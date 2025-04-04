import { $ } from "bun";
import {
  getActiveWorkspace,
  getClient,
  getClients,
  socketAddr,
  type Client,
} from "./hyprland";

const openClients: Client[] = [];
const maybeRestoreClients: Client[] = [];

export function removeClient(address: string): Client | undefined {
  if (typeof address === "undefined") return;
  const index = openClients.findIndex((c) => c.address === address);
  if (index !== -1) {
    const c = openClients[index];
    openClients.splice(index, 1);
    return c;
  }
}

export async function saveForMaybeRestore(c: Client | undefined) {
  if (!c) return;
  c.timestamp = performance.now();
  maybeRestoreClients.push(c);
}

export async function maybeRestoreClient(c: Client | undefined) {
  const rcs = maybeRestoreClients.filter(
    (r) => r.initialTitle === c?.initialTitle
  );
  const timestamps = rcs.map((r) => r.timestamp).sort();
  const avg = timestamps[timestamps.length - 1] - timestamps[0];

  // a multi-window app was probably closed at once
  if (
    timestamps.length > 1 &&
    avg < 100 &&
    avg > 0 &&
    typeof c !== "undefined"
  ) {
    await new Promise((r) => setTimeout(r, 300));
    restoreClient(c.address);
  }
}

export async function restoreClient(address: string) {
  if (typeof address === "undefined") return;
  let c = openClients.find((c) => c.address === address);
  const rcs = maybeRestoreClients.filter(
    (r) => r.initialClass === c!.initialClass
  );
  if (rcs.length > 0 && typeof c !== "undefined") {
    let i = 0;
    let toggle = false;
    // temporarely hide the window
    await $`hyprctl dispatch movetoworkspacesilent special:tryrestore,address:${c.address}`;
    while (c.title == c.initialTitle && i < 10) {
      toggle = !toggle;
      i++;
      await new Promise((r) => setTimeout(r, 300));
      c = (await getClient(address)) as Client;
    }
    changeClient(address);
    const rc = maybeRestoreClients.find((r) => r.title === c!.title);
    if (typeof rc !== "undefined") {
      let cmd = `dispatch movetoworkspacesilent ${rc.workspace.id},address:${c.address}`;
      if (rc.floating) {
        cmd += ` ; dispatch setfloating address:${c.address}`;
      }
      if (rc.pinned) {
        cmd += ` ; dispatch pin address:${c.address}`;
      }
      // TODO: handle fullscreen
      // if (rc.fullscreen) {
      //   cmd += ` ; dispatch pin address:${c.address}`;
      // }
      await $`hyprctl --batch "${cmd}"`;
      const rcidx = maybeRestoreClients.indexOf(rc);
      maybeRestoreClients.splice(rcidx, 1);
    } else {
      const aw = await getActiveWorkspace();
      await $`hyprctl dispatch movetoworkspacesilent ${aw.id},address:${c.address}`;
    }
  }
}

export async function addClient(address: string): Promise<Client | undefined> {
  if (typeof address === "undefined") return;
  const c = await getClient(address);
  if (c) {
    openClients.push(c);
  }
  return c;
}

export async function changeClient(address: string) {
  if (typeof address === "undefined") return;
  removeClient(address);
  await addClient(address);
}

export async function maybeFocusUrgent(
  c: Client | undefined,
  urgents: string[]
) {
  if (!c) return;
  let isNemoPreview = false;
  const clients = await getClients();
  let parent = undefined;
  if (c.class === "Nemo-preview-start") {
    const nemos = clients.filter((c) => c.class === "nemo");
    nemos.sort((a, b) => a.focusHistoryID - b.focusHistoryID);
    parent = nemos[0];
    isNemoPreview = true;
  }

  if (urgents.includes(c.address)) {
    parent = clients.find((p) => p.focusHistoryID === c.focusHistoryID + 1);
  }

  if (!parent) {
    return;
  }

  console.log(parent?.title);

  await new Promise((r) => setTimeout(r, 50));
  const newc = await getClient(c!.address);
  let [w, h] = newc!.size;
  console.log(newc!.size);

  if (!isNemoPreview) {
    if (w > parent!.size[0] / 1.3) w = Math.round(parent!.size[0] / 1.3);
    if (h > parent!.size[1] / 1.3) h = Math.round(parent!.size[1] / 1.3);
    await $`hyprctl dispatch resizewindowpixel exact ${w} ${h},address:${
      c!.address
    }`;
  }

  console.log("WH", w, h);
  //
  const lCenter = Math.round(parent!.at[0] + parent!.size[0] / 2 - w / 2);
  const tCenter = Math.round(parent!.at[1] + parent!.size[1] / 2 - h / 2);

  await $`hyprctl dispatch movewindowpixel exact ${lCenter} ${tCenter},address:${
    c!.address
  }`;

  await $`hyprctl dispatch focuswindow address:${c!.address}`;
}
