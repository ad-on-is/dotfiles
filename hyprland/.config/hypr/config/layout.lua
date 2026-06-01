hl.config({
  general = {

    layout = "dwindle",
  },

  dwindle = {
    preserve_split = true,
    force_split = 0,
    smart_resizing = true,
    smart_split = false,
    precise_mouse_move = true,
  },

  master = {
    allow_small_split = true,
    mfact = 0.50,
    orientation = "center",
    drop_at_cursor = true,
    new_status = "master"
  },
  scrolling = {
    fullscreen_on_one_column = false,
  },

})
