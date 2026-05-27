hl.config({
  general = {
    resize_on_border  = true,
    no_focus_fallback = true,

    snap              = {
      enabled = true,
      window_gap = 30
    },
    allow_tearing     = true,

    layout            = "dwindle",
  },
  gestures = {
    -- workspace_swipe = off

    -- workspace_swipe_fingers = 4
    workspace_swipe_cancel_ratio = 0.2,
    workspace_swipe_min_speed_to_force = 5,
    workspace_swipe_direction_lock = true,
    workspace_swipe_direction_lock_threshold = 10,
    workspace_swipe_create_new = true

  },
  misc = {
    force_default_wallpaper      = false,
    disable_hyprland_logo        = true,
    font_family                  = "Maple Mono NF",
    -- new_window_takes_over_fullscreen = 2
    middle_click_paste           = false,
    animate_manual_resizes       = true,
    animate_mouse_windowdragging = true,
    focus_on_activate            = false,
    enable_swallow               = false,
    swallow_regex                = "^(com.mitchellh.ghostty|kitty)$",
    layers_hog_keyboard_focus    = true,
    allow_session_lock_restore   = true,

  },
  binds = {
    -- workspace_back_and_forth = false,
    -- allow_workspace_cycles = false,
    scroll_event_delay = 0,
    workspace_center_on = 1,

  },
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },
})
