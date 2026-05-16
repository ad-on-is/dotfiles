hl.config({
  input = {
    kb_layout           = "de",
    kb_options          = "compose:caps",
    -- kb_variant   = "",
    -- kb_model     = "",
    -- kb_rules     = "",
    repeat_rate         = 100,
    repeat_delay        = 200,

    follow_mouse        = 1,
    sensitivity         = 0,
    special_fallthrough = true,

    touchpad            = {
      natural_scroll = false,
      clickfinger_behavior = true,
      scroll_factor = 0.5
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({
--   name        = "epic-mouse-v1",
--   sensitivity = -0.5,
-- })
