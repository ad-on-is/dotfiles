require "config.envs"
require "config.general"
require "config.decorations"
require "config.monitors"
require "config.input"
require "config.keybinds"
require "config.rules"

local ok, err = pcall(require, "config.overrides")
if not ok and not err:find("module 'config.overrides' not found") then
  error(err)
end
