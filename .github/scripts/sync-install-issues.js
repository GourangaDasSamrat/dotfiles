// Opens one issue per failing OS (listing the packages that failed) and closes it
// again once that OS passes on a later run.
//
// Called from .github/workflows/software-install-test.yml via actions/github-script.
// Expects the per-OS JSON reports to be downloaded into ./report.

const {
  workflowRunUrl,
  listOpenIssues,
  upsertIssue,
  closeIssue,
} = require("./issue-sync.js");

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
  const runUrl = workflowRunUrl(context);
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

  const openIssues = await listOpenIssues({ github, context, label: LABEL });

  for (const r of reports) {
    const title = `Software install failing on ${r.name}`;
    const existing = openIssues.find((i) => i.title === title && !i.pull_request);

    if (r.outcome === "success") {
      if (!existing) continue;
      await closeIssue({
        github,
        context,
        issue: existing,
        comment: `Fixed: all packages installed on **${r.name}** in ${runUrl} (commit ${context.sha}). Closing.`,
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

    const { issue, created } = await upsertIssue({
      github,
      context,
      label: LABEL,
      title,
      body,
      matchTitle: true,
      openIssues,
      updateComment: `Still failing on **${r.name}**: ${runUrl} (commit ${context.sha}).`,
    });
    core.info(`${created ? "Opened" : "Updated"} #${issue.number} (${r.name})`);
  }
};
