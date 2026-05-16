local M = {

  dbg = function(self, data)
    local f = io.open("/tmp/hypr-debug.log", "a")
    if f then
      f:write(self:dump(data) .. "\n")
      f:close()
    end
  end,

  dump = function(self, val)
    local indent = 0
    local pad = string.rep("  ", indent)
    local t = type(val)

    if t == "table" then
      local lines = { "{\n" }
      for k, v in pairs(val) do
        local key = type(k) == "string" and k or "[" .. tostring(k) .. "]"
        table.insert(lines, pad .. "  " .. key .. " = " .. self:dump(v, indent + 1) .. ",\n")
      end
      table.insert(lines, pad .. "}")
      return table.concat(lines)
    elseif t == "string" then
      return string.format("%q", val)
    else
      return tostring(val)
    end
  end

}

return M
