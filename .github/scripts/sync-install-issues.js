// Opens one issue per failing OS (listing the packages that failed) and closes it
// again once that OS passes on a later run.
//
// Called from .github/workflows/software-install-test.yml via actions/github-script.
// Expects the per-OS JSON reports to be downloaded into ./report.

module.exports = async ({ github, context, core }) => {
  const fs = require("fs");
  const path = require("path");

  const dir = "report";
  if (!fs.existsSync(dir)) {
    core.info("No reports found, nothing to do.");
    return;
  }
  const reports = fs
    .readdirSync(dir)
    .filter((f) => f.endsWith(".json"))
    .map((f) => JSON.parse(fs.readFileSync(path.join(dir, f), "utf8")));

  const { owner, repo } = context.repo;
  const runUrl = `${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId}`;
  const LABEL = "software-install-failure";

  try {
    await github.rest.issues.getLabel({ owner, repo, name: LABEL });
  } catch {
    try {
      await github.rest.issues.createLabel({
        owner,
        repo,
        name: LABEL,
        color: "d73a4a",
        description: "Software install CI is failing on an OS",
      });
    } catch (e) {
      core.warning(`Could not create label: ${e.message}`);
    }
  }

  const openIssues = await github.paginate(github.rest.issues.listForRepo, {
    owner,
    repo,
    state: "open",
    labels: LABEL,
    per_page: 100,
  });

  for (const r of reports) {
    const title = `Software install failing on ${r.name}`;
    const existing = openIssues.find((i) => i.title === title && !i.pull_request);

    if (r.outcome === "success") {
      if (!existing) continue;
      await github.rest.issues.createComment({
        owner,
        repo,
        issue_number: existing.number,
        body: `Fixed: all packages installed on **${r.name}** in ${runUrl} (commit ${context.sha}). Closing.`,
      });
      await github.rest.issues.update({
        owner,
        repo,
        issue_number: existing.number,
        state: "closed",
        state_reason: "completed",
      });
      core.info(`Closed #${existing.number} (${r.name})`);
      continue;
    }

    if (r.outcome !== "failure") {
      core.info(`${r.name}: outcome '${r.outcome}', skipping.`);
      continue;
    }

    const missing = r.missing || [];
    const log = (r.log || "").slice(-15000);
    let body =
      `The **Software Install Test** failed on **${r.name}**.\n\n` +
      `- Run: ${runUrl}\n- Commit: ${context.sha}\n\n`;

    if (missing.length) {
      body +=
        `### Packages that failed to install (${missing.length})\n\n` +
        missing.map((m) => `- \`${m.replace(/\|/g, " | ")}\``).join("\n") +
        `\n\n> An entry like \`a | b\` means none of the listed alternatives could be installed.\n\n`;
    } else {
      body +=
        "No individual package was reported missing. The install script or the verification step itself failed, see the log below.\n\n";
    }

    body +=
      `<details><summary>Last log lines</summary>\n\n\`\`\`\n${log}\n\`\`\`\n\n</details>\n\n` +
      "_This issue is closed automatically once the workflow passes on this OS._";

    if (existing) {
      await github.rest.issues.update({ owner, repo, issue_number: existing.number, body });
      await github.rest.issues.createComment({
        owner,
        repo,
        issue_number: existing.number,
        body: `Still failing on **${r.name}**: ${runUrl} (commit ${context.sha}).`,
      });
      core.info(`Updated #${existing.number} (${r.name})`);
    } else {
      const created = await github.rest.issues.create({
        owner,
        repo,
        title,
        body,
        labels: [LABEL],
      });
      core.info(`Opened #${created.data.number} (${r.name})`);
    }
  }
};
