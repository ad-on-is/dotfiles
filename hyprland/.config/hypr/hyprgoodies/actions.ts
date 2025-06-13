import {
  getActiveClient,
  getActiveWorkspace,
  getWorkspaces,
  getMonitors,
  getClients,
  monitors,
  type Monitor,
} from "./hyprland";
import { $ } from "bun";
import { JSONFilePreset } from "lowdb/node";

const toggleFloating = async () => {
  // CONFIG
  const [width, height] = [80, 80]; // width and height in percent
  const CENTER = true; // center window when floating
  const PIN = process.argv[4] || false;
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
    if (PIN) {
      await $`hyprctl dispatch pin`;
    }
  } else {
    await $`hyprctl dispatch settiled`;
  }
};

// WIP

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

type FixedWindowsData = {
  fixedWindows: string[];
};
const fixWindowToMonitor = async () => {
  const db = await JSONFilePreset<FixedWindowsData>(
    ".hyprgoodies-fixed-windows.json",
    {
      fixedWindows: [],
    },
  );

  await db.read();

  const c = await getActiveClient();
  if (!db.data.fixedWindows.includes(c.class)) {
    await $`hyprctl keyword windowrule "monitor ${c.monitor},class:^(${c.class})$"`;
    await $`hyprctl dispatch tagwindow +fixedToMonitor`;
    db.data.fixedWindows.push(c.class);
  } else {
    db.data.fixedWindows = db.data.fixedWindows.filter((x) => x !== c.class);
    await $`hyprctl keyword windowrule unset, "class:^(${c.class})$"`;
    await $`hyprctl dispatch tagwindow -- -fixedToMonitor`;
  }
  await db.write();
  console.log(db.data.fixedWindows);
  // if (!c.floating) {
  //   await $`hyprctl dispatch setfloating`;
  //   await $`hyprctl dispatch pin`;
  //   await $`hyprctl dispatch resizeactive exact ${nw} ${nh}`;
  //   await $`hyprctl dispatch centerwindow`;
  // } else {
  //   await $`hyprctl dispatch settiled`;
  // }
};

const getMontiorLayout = async () => {
  const monitors = await getMonitors();
  const am = (await getActiveWorkspace()).monitorID;
  const active = monitors.find((m) => m.id == am);
  if (!active) {
    return;
  }
  const left = monitors.find((m) => m.x < active.x);
  const right = monitors.find((m) => m.x > active.x);
  const top = monitors.find((m) => m.y < active.y);
  const bottom = monitors.find((m) => m.y > active.y);

  return [top, bottom, left, right];
};

const focusWindow = async () => {
  const dir = process.argv[4];
  const aws = await getActiveWorkspace();
  const clients = await getClients();
  const [top, bottom, left, right] = await getMontiorLayout();
  const wHasClients =
    clients.filter((c) => c.workspace.id == aws.id).length > 1;

  if (!wHasClients) {
    switch (dir) {
      case "t":
        await $`hyprctl dispatch focusmonitor ${top.name}`;
        break;
      case "b":
        await $`hyprctl dispatch focusmonitor ${bottom.name}`;
        break;
      case "l":
        await $`hyprctl dispatch focusmonitor ${left.name}`;
        break;
      case "r":
        await $`hyprctl dispatch focusmonitor ${right.name}`;
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
  case "window":
    switch (process.argv[3]) {
      case "toggleFloating":
        toggleFloating();
      case "move":
        moveWindow();
        break;
      case "focus":
        focusWindow();
        break;
      case "fixToMonitor":
        fixWindowToMonitor();
        break;
    }
    break;
  case "workspace":
    workspace();
}
