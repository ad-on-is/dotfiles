import { getActiveClient, getActiveWorkspace, getWorkspaces } from "./hyprland";
import { $ } from "bun";


const toggleFloating = async () => {
  // CONFIG
  const [width, height] = [80, 80] // width and height in percent
  const CENTER = true // center window when floating
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

}

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
  const mws = wss.filter((x) => `${x.id}`.startsWith(`${group}`)).map((ws) => ws.id).sort();
  if (where === "next") {
    to++
  } else if (where === "prev") {
    to--
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
}


const action = process.argv[2];



switch (action) {
  case "toggleFloating":
    toggleFloating();
    break;
  case "workspace":
    workspace();

}

