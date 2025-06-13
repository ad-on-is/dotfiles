import { getMonitors, socketAddr } from "./hyprland";
import monitorSetup from "../monitors.json";

let urgents: string[] = [];

type MonitorSetup = {
  config: string;
  workspaces: number[];
};

function replaceBetween(
  text: string,
  start: string,
  end: string,
  replacement: string,
): string {
  const startIndex = text.indexOf(start);
  const endIndex = text.indexOf(end, startIndex + start.length);

  if (startIndex === -1 || endIndex === -1) {
    return text; // Return original if delimiters not found
  }

  return (
    text.substring(0, startIndex + start.length) +
    replacement +
    text.substring(endIndex)
  );
}

async function handleMonitors() {
  const monitors = await getMonitors();
  let config = "";

  monitors.forEach((monitor) => {
    const m = monitorSetup[monitor.description] as MonitorSetup | undefined;

    if (m) {
      config += `\nmonitor=${monitor.name},${m.config}`;
      m.workspaces.forEach((w: number, i: number) => {
        config += `\nworkspace=${w}, monitor:${monitor.name}, persistent:true${i === 0 ? ", default:true" : ""}`;
      });
      config += `\n\n`;
    }
  });
  const MONITOR_FILE = "../config/monitors.conf.bak";

  const mc = await Bun.file(MONITOR_FILE).text();
  const nc = replaceBetween(
    mc,
    "#HYPRGOODIES-MONITORS-START",
    "#HYPRGOODIES-MONITORS-END",
    config,
  );

  console.log(nc);
  await Bun.write(MONITOR_FILE, nc);
}
await Bun.connect({
  unix: socketAddr,
  socket: {
    data(socket, data) {
      const d = new TextDecoder().decode(data);
      const msgs = d
        .split("\n")
        .map((m) => m.trim())
        .filter((m) => m !== "");
      msgs.forEach((msg) => {
        const sp = msg.split(">>");
        const dispatcher = sp[0].trim();
        if (["monitoradded", "monitorremoved"].includes(dispatcher)) {
          handleMonitors();
        }
      });
    },
    open(socket) {
      console.log("Connected to socket");
    },
    close(socket) {
      console.log("Socket closed");
    },
    error(socket, error) {
      console.error("Socket error:", error);
    },
  },
});
