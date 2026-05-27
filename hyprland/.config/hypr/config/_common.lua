local log = require("config._log")

M = {

  ntfy = function(title, text)
    hl.exec_cmd("notify-send " .. title .. " " .. text)
  end,

  colors = {
    primary = "#f54900",
    primarygradient = "#f56600",
    secondary = "#18191ef5",
    primary2 = "#40191ef5",
    outline = "#18191ef5",
    error = "#f38ba8",
    group = {
      active = "#f54900",
      inactive = "#18191ef5",
      locked_active = "#f54900",
      locked_inactive = "#18191ef5",
      bar = {
        active = "#40191ef5",
        inactive = "#18191ef5",
        locked_active = "#f54900",
        locked_inactive = "#18191ef5",
        text = "#ffffffaa"
      },
    },
  },

  workspaces = {
    count = 3,
    w = function()
      local w = hl.get_active_workspace()
      local n = w.name:sub(2)
      return n
    end,
    focusNext = function(self)
      if self.w() ~= tostring(self.count) then
        hl.dispatch(hl.dsp.focus({ workspace = "m+1" }))
      end
    end,
    focusPrev = function(self)
      if self.w() ~= "1" then
        hl.dispatch(hl.dsp.focus({ workspace = "m-1" }))
      end
    end,
    moveNext = function(self)
      if self.w() ~= tostring(self.count) then
        hl.dispatch(hl.dsp.window.move({ workspace = "m+1" }))
      end
    end,
    movePrev = function(self)
      if self.w() ~= "1" then
        hl.dispatch(hl.dsp.window.move({ workspace = "m-1" }))
      end
    end
  },

  float = function(pin)
    if pin == nil then
      pin = false
    end
    local a = hl.get_active_window()
    local m = hl.get_active_monitor()
    local isFloating = a.floating
    if isFloating then
      hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
      -- hl.dispatch(hl.dsp.window.pin({ toggle = pin }))
      return
    end
    local w, h = m.width * 0.8, m.height * 0.8
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.center())
    hl.dispatch(hl.dsp.window.resize({ x = w, y = h, relative = false }))
  end,

  group = function()
    local function contains(t, x, y)
      for _, v in ipairs(t) do
        if v.x == x and v.y == y then
          return true
        end
      end
      return false
    end


    local a = hl.get_active_window()
    if a.group ~= nil then
      hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
      return
    end

    local dir = ""
    local ax = a.at.x
    local ay = a.at.y
    local gapout = hl.get_config('general.gaps_out')
    gapout = gapout['left']
    local groups = {}
    local dirs = { l = {}, r = {}, t = {}, b = {} }
    local wins = hl.get_workspace_windows(a.workspace.id)
    local hasgroups = false
    for _, w in ipairs(wins) do
      local wx = w.at.x
      local wy = w.at.y
      if w.group ~= nil and not contains(groups, wx, wy) then
        hasgroups = true
        table.insert(groups, { x = wx, y = wy })
      end
    end

    if not hasgroups then
      hl.dispatch(hl.dsp.group.toggle())
      return
    end

    for _, g in ipairs(groups) do
      local gx = g.x
      local gy = g.y
      local barheight = hl.get_config('group.groupbar.height')
      gy = gy - barheight

      if gy < ay then
        table.insert(dirs.t, g)
      end
      if gx < ax then
        table.insert(dirs.l, g)
      end

      if gx > ax then
        table.insert(dirs.r, g)
      end

      if gy > ay then
        log:dbg({ gy, ay })

        table.insert(dirs.b, g)
      end

      if gy == ay then
        if gx < ax then
          table.insert(dirs.l, g)
        elseif gx > ax then
          table.insert(dirs.r, g)
        end
      end
    end

    local function findNearestDir(dirs, x, y)
      local nearestKey = nil
      local minDist = math.huge

      for key, group in pairs(dirs) do
        for _, v in ipairs(group) do
          local dist = (v.x - x) ^ 2 + (v.y - y) ^ 2
          log:dbg({ key = key, dist = dist, v = v })
          if dist < minDist then
            minDist = dist
            nearestKey = key
          end
        end
      end

      return nearestKey, math.sqrt(minDist)
    end

    local nearest = findNearestDir(dirs, ax, ay)
    log:dbg(nearest)
    hl.dispatch(hl.dsp.window.move({ into_group = nearest }))
  end

}
return M
