#!/bin/python3


import subprocess

name = "Unknown/Error"
battery = 0
charging = False
dpiLevel = 0
brightness = 0
try:
    res = str(subprocess.check_output(["/home/adonis/.local/share/devbox/global/default/.devbox/nix/profile/default/bin/razer-cli", "-ls"]))
    parts = res.split("\\n")
    name = parts[1].replace(":", "")
    battery = 0
    dpiLevel = (
        parts[3].split(":")[1].replace("(", "").replace(")", "").strip().split(", ")[0]
    )
    for i, part in enumerate(parts):
        part = part.strip()
        # print(part)
        if "battery" in part:
            battery = parts[i + 1].split(":")[1].strip()
        if "charging: True" in part:
            charging = True
        if "logo zone" in part:
            brightness = parts[i + 1].split(":")[1].strip()

    name = name.replace(" (Wireless)", "").replace(" (Wired)", "")

except Exception as e:
    pass
print(f"{name}\n{battery}\n{charging}\n{dpiLevel}\n{brightness}")
