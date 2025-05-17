import { $ } from "bun";
const NUMWORKSPACES = 3;


const action = process.argv[2]

await new Promise((res) => setTimeout(res, 5000))

if (typeof action === "undefined") {
  console.log("Missing action")
  process.exit()
}

if (action === "init") {
  const monitors = JSON.parse(await $`hyprctl monitors -j`.text())

  const workspaceCMDs = []
  for (const m of monitors) {
    for (let i = 1; i <= NUMWORKSPACES; i++) {
      const id = m["id"] + 1
      const wsId = `${id}${i}`
      // if (i == 1) {
      //   ws += `, default:true`
      // }
      workspaceCMDs.push(`dispatch workspace name:${wsId}`)
      workspaceCMDs.push(`dispatch moveworkspacetomonitor name:${wsId} ${m["id"]}`)
      // await $`hyprctl dispatch ${ws}`
      // console.log(`hyprctl dispatch moveworkspacetomonitor ${wsId} ${m["id"]}`)
      // await $`hyprctl dispatch moveworkspacetomonitor ${wsId} ${m["id"]}`
      // workspaceCMDs.push(`dispatch moveworkspacetomonitor ${wsId} ${m["id"]}`)
    }
  }
  // await $`hyprctl dispatch forcerendererreload`


  const batch = workspaceCMDs.join(" ; ")
  const h = await $`hyprctl -r --batch ${batch}`.text()
  console.log(h)
  // console.log(`Created ${NUMWORKSPACES} for each monitor`)
  // await $`notify-send "Initialized workspaces"`
}


if (action == "workspace") {

  const dir = process.argv[3]

}

