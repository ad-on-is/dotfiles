import { $ } from "bun";
export const socketAddr = `${process.env.XDG_RUNTIME_DIR}/hypr/${process.env.HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock`;

export type Workspace = {
  id: number;
  name: string;
};

export type Client = {
  address: string;
  timestamp: number;
  title: string;
  initialTitle: string;
  focusHistoryID: number;
  class: string;
  initialClass: string;
  floating: boolean;
  pinned: boolean;
  fullscreen: number;
  fullscreenClient: number;
  at: [number, number];
  size: [number, number];
  workspace: {
    id: number;
    name: string;
  };
  monitor: number;
};

export const getClients = async (): Promise<Client[]> => {
  const ctl = await $`hyprctl clients -j`.text();
  return JSON.parse(ctl) as Client[];
};

export const getActiveClient = async (): Promise<Client> => {
  const ctl = await $`hyprctl activewindow -j`.text();
  return JSON.parse(ctl) as Client;
};

export async function getClient(address: string): Promise<Client | undefined> {
  const clients = await getClients();
  return clients.find((c) => c.address === `${address}`);
}

export async function getActiveWorkspace(): Promise<Workspace> {
  const ctl = await $`hyprctl activeworkspace -j`.text();
  return JSON.parse(ctl) as Workspace;
}

export async function getWorkspaces(): Promise<Workspace[]> {
  const ctl = await $`hyprctl workspaces -j`.text();
  return JSON.parse(ctl) as Workspace[];
}
