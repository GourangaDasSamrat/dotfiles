// Shared issue helpers for the workflows' actions/github-script steps.
//
// Every workflow that opens / updates / closes tracking issues goes through
// this one module instead of re-implementing the list -> create-or-update ->
// close dance inline:
//
//   const { upsertIssue, workflowRunLink } = require("./.github/scripts/issue-sync.js");
//
// The calling job needs `permissions: issues: write` and must have checked out
// this directory first (a sparse checkout of `.github/scripts` is enough).

/** URL of the current workflow run, e.g. "https://github.com/o/r/actions/runs/123". */
function workflowRunUrl(context) {
  const { owner, repo } = context.repo;
  return `${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId}`;
}

/** Markdown link to the current workflow run, e.g. "[#42](https://github.com/o/r/actions/runs/123)". */
function workflowRunLink(context) {
  return `[#${context.runNumber}](${workflowRunUrl(context)})`;
}

/** All open issues (not PRs) carrying `label`. */
async function listOpenIssues({ github, context, label }) {
  const { owner, repo } = context.repo;
  const issues = await github.paginate(github.rest.issues.listForRepo, {
    owner,
    repo,
    state: "open",
    labels: label,
    per_page: 100,
  });
  return issues.filter((i) => !i.pull_request);
}

/**
 * Creates the issue, or refreshes the existing open one.
 *
 * An existing issue is the first open issue with `label` (and, when
 * `matchTitle` is set, the same title). Its body is replaced by `body`; if
 * `updateComment` is given a comment is added as well.
 *
 * @param {string}   label          label used to find an existing issue
 * @param {string[]} [labels]       labels for a NEW issue (defaults to [label])
 * @param {boolean}  [matchTitle]   also require an identical title when searching
 * @param {string}   [updateComment] comment to post when an existing issue is updated
 * @param {object[]} [openIssues]   already-fetched result of listOpenIssues (saves an API call)
 * @returns {Promise<{issue: object, created: boolean}>}
 */
async function upsertIssue({
  github,
  context,
  label,
  labels = [label],
  title,
  body,
  matchTitle = false,
  updateComment,
  openIssues,
}) {
  const { owner, repo } = context.repo;
  const open = openIssues ?? (await listOpenIssues({ github, context, label }));
  const existing = open.find((i) => !matchTitle || i.title === title);

  if (existing) {
    await github.rest.issues.update({
      owner,
      repo,
      issue_number: existing.number,
      body,
    });
    if (updateComment) {
      await github.rest.issues.createComment({
        owner,
        repo,
        issue_number: existing.number,
        body: updateComment,
      });
    }
    return { issue: existing, created: false };
  }

  const created = await github.rest.issues.create({
    owner,
    repo,
    title,
    body,
    labels,
  });
  return { issue: created.data, created: true };
}

/** Comments on a single issue and closes it. */
async function closeIssue({
  github,
  context,
  issue,
  comment,
  reason = "completed",
}) {
  const { owner, repo } = context.repo;
  if (comment) {
    await github.rest.issues.createComment({
      owner,
      repo,
      issue_number: issue.number,
      body: comment,
    });
  }
  await github.rest.issues.update({
    owner,
    repo,
    issue_number: issue.number,
    state: "closed",
    state_reason: reason,
  });
}

/** Closes every open issue carrying `label`, leaving `comment` on each. Returns the closed issues. */
async function closeIssues({ github, context, label, comment }) {
  const issues = await listOpenIssues({ github, context, label });
  for (const issue of issues) {
    await closeIssue({ github, context, issue, comment });
  }
  return issues;
}

module.exports = {
  workflowRunUrl,
  workflowRunLink,
  listOpenIssues,
  upsertIssue,
  closeIssue,
  closeIssues,
};
