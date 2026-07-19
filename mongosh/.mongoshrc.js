// ~/.mongoshrc.js

(function () {
  const RESET = "\x1b[0m";
  const col = (n) => `\x1b[38;5;${n}m`;

  // Dracula palette mapped to the nearest xterm-256 codes
  const dracula = {
    comment: col(61), // #6272a4 - brackets / separators
    purple: col(141), // #bd93f9
    pink: col(212), // #ff79c6
    cyan: col(117), // #8be9fd
    green: col(84), // #50fa7b
    yellow: col(228), // #f1fa8c
    orange: col(215), // #ffb86c
    red: col(203), // #ff5555
  };

  // Runs fn() and returns its result, or fallback if it throws / returns nullish
  function safe(fn, fallback) {
    try {
      const v = fn();
      return v === undefined || v === null ? fallback : v;
    } catch (e) {
      return fallback;
    }
  }

  safe(() => config.set("disableGreetingMessage", true), null);

  // Custom welcome banner, printed once when the shell starts
  const user = safe(() => process.env.USER || process.env.USERNAME, "user");
  const now = safe(() => new Date().toString(), "");

  console.log(
    `${dracula.pink}Welcome,${RESET} ${dracula.yellow}${user}${RESET} ` +
      `${dracula.comment}--${RESET} ${dracula.cyan}${now}${RESET}`,
  );
  console.log(
    `${dracula.comment}Type ${dracula.purple}help${dracula.comment} for help, ` +
      `${dracula.purple}exit${dracula.comment} to quit.${RESET}`,
  );
  console.log("");

  // Prompt: [host db]❯  — no boxes, arrows, or extra labels
  globalThis.prompt = function () {
    const dbName = safe(() => db.getName(), "test");
    const host = safe(() => db.getMongo().host, "localhost:27017");

    const isConnected = safe(() => {
      db.getMongo().getDB("admin").runCommand({ ping: 1 });
      return true;
    }, false);

    const promptChar = isConnected ? "❯" : "✗";
    const charColor = isConnected ? dracula.green : dracula.red;

    return (
      `${dracula.comment}[${RESET}` +
      `${dracula.purple}${host}${RESET}` +
      `${dracula.comment} ${RESET}` +
      `${dracula.cyan}${dbName}${RESET}` +
      `${dracula.comment}]${RESET}` +
      `${charColor}${promptChar}${RESET} `
    );
  };
})();
