import { getActiveClient } from "./hyprland";
import { $ } from "bun";
const c = await getActiveClient();
const at = c.at;
console.log(c.at);
const dir = process.argv[2];
await $`hyprctl dispatch movewindow ${dir}`;
await new Promise((r) => setTimeout(r, 500));
const nc = await getActiveClient();
const newat = nc.at;
// await $`notify-send ${at.join(",")} "${newat.join(",")} ${c.address}"`;

if (at[0] == newat[0] && at[1] == newat[1] && dir == "u") {
  await $`hyprctl dispatch movewindow mon:DP-2`;
}
