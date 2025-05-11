import {
  getActiveClient,
  getActiveWorkspace,
  getWorkspaces,
  getMonitors,
  getClients,
  monitors,
} from "./hyprland";
import { $ } from "bun";

const toggleFloating = async () => {
  // CONFIG
  const [width, height] = [80, 80]; // width and height in percent
  const CENTER = true; // center window when floating
  // CONFIG
  //
  //
  const c = await getActiveClient();

  if (!c.floating) {
    await $`hyprctl dispatch setfloating`;
    await $`hyprctl dispatch resizeactive exact ${width}% ${height}%`;
    if (CENTER) {
      await $`hyprctl dispatch centerwindow`;
    }
  } else {
    await $`hyprctl dispatch settiled`;
  }
};

// WIP
const getArrangement = async () => {
  const workspace = await getActiveWorkspace();
  const monitor = (await getMonitors()).find(
    (m) => m.id == workspace.monitorID,
  );
  let clients = (await getClients()).filter(
    (c) => c.workspace.id == workspace.id,
  );

  let swallowed = clients
    .filter((c) => c.swallowing !== "0x0")
    .map((c) => c.swallowing);

  clients = clients.filter((c) => !swallowed.includes(c.address));
  console.log(swallowed);
  const w = monitor.width;
  const h = monitor.height;
  console.log(clients);
  const matrix = [];
  // for (const c of clients) {
  //
  // }
};

const moveWindow = async () => {
  // await getArrangement();
  const c = await getActiveClient();
  const at = c.at;
  const dir = process.argv[4];

  await $`hyprctl dispatch movewindow ${dir}`;

  const nc = await getActiveClient();
  const newat = nc.at;
  const w = await getActiveWorkspace();

  const clients = await getClients();
  const wHasClients = clients.filter((c) => c.workspace.id == w.id).length > 1;

  if (
    ((at[0] == newat[0] && at[1] == newat[1]) || !wHasClients) &&
    ["u", "t"].includes(dir)
  ) {
    await $`hyprctl dispatch movewindow mon:${monitors.top}`;
  }
  if (
    ((at[0] == newat[0] && at[1] == newat[1]) || !wHasClients) &&
    ["d", "b"].includes(dir)
  ) {
    await $`hyprctl dispatch movewindow mon:${monitors.bottom}`;
  }
};

const focusWindow = async () => {
  const dir = process.argv[4];
  const aws = await getActiveWorkspace();
  const clients = await getClients();
  const wHasClients =
    clients.filter((c) => c.workspace.id == aws.id).length > 1;

  if (!wHasClients) {
    switch (dir) {
      case "t":
        await $`hyprctl dispatch focusmonitor DP-2`;
        break;
      case "b":
        await $`hyprctl dispatch focusmonitor DP-1`;
        break;
      case "l":
        await $`hyprctl dispatch focusmonitor DP-3`;
        break;
      case "r":
        await $`hyprctl dispatch focusmonitor HDMI-A-1`;
        break;
    }
  } else {
    await $`hyprctl dispatch movefocus ${dir}`;
  }
};

const workspace = async () => {
  // CONFIG
  const CYCLE = false; // cycle through workspaces when reaching first or last
  //CONFIG

  const aws = await getActiveWorkspace();
  const wss = await getWorkspaces();
  const id = aws.id;
  const what = process.argv[3];
  const where = process.argv[4];

  const [group] = `${id / 10}`.split(".").map((x) => parseInt(x));
  let to = id;
  const mws = wss
    .filter((x) => `${x.id}`.startsWith(`${group}`))
    .map((ws) => ws.id)
    .sort();
  if (where === "next") {
    to++;
  } else if (where === "prev") {
    to--;
  }

  if (to > mws[mws.length - 1]) {
    to = CYCLE ? mws[0] : mws[mws.length - 1];
  }

  if (to < mws[0]) {
    to = CYCLE ? mws[mws.length - 1] : mws[0];
  }

  switch (what) {
    case "switch":
      await $`hyprctl dispatch workspace ${to}`;
      break;
    case "movewindow":
      await $`hyprctl dispatch movetoworkspace ${to}`;
      break;
  }
};

const action = process.argv[2];

switch (action) {
  case "toggleFloating":
    toggleFloating();
    break;
  case "window":
    switch (process.argv[3]) {
      case "move":
        moveWindow();
        break;
      case "focus":
        focusWindow();
        break;
    }
    break;
  case "workspace":
    workspace();
}
