import { getClients } from "./hyprland";

const clients = await getClients();

const list = clients
  .map((client) => `${client.address}\t${client.title}`)
  .join("\n");

console.log(list);
