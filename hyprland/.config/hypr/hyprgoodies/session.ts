import {
  addClient,
  changeClient,
  maybeFocusUrgent,
  maybeRestoreClient,
  removeClient,
  saveForMaybeRestore,
} from "./handler";
import { getClient, socketAddr } from "./hyprland";

let urgents: string[] = [];

async function handleClient(dispatcher: string, address: string) {
  switch (dispatcher) {
    case "urgent":
      urgents.push(address);
      break;
    case "openwindow":
      const c = await addClient(address);
      await maybeFocusUrgent(c, urgents);
      await maybeRestoreClient(c);
      break;
    case "activewindow":
      await maybeFocusUrgent(await getClient(address), urgents);
      break;
    case "closewindow":
      saveForMaybeRestore(removeClient(address));
      urgents = urgents.filter((u) => u !== address);
      break;
    case "movewindow":
    case "changefloatingmode":
    case "windowtitle":
    case "fullscreen":
      await changeClient(address);
      break;
    default:
      break;
  }
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
        const address = `0x${sp[1].split(",")[0].trim()}`;
        if (
          [
            "urgent",
            "activewindow",
            "openwindow",
            "closewindow",
            "movewindow",
            "windowtitle",
            "changefloatingmode",
          ].includes(dispatcher)
        ) {
          handleClient(dispatcher, address);
        } else {
          // console.log(dispatcher);
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
