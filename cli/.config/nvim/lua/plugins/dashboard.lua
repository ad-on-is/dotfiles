return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          preset = {
            header = [[
	                                              
	       ████ ██████           █████      ██
	      ███████████             █████ 
	      █████████ ███████████████████ ███   ███████████
	     █████████  ███    █████████████ █████ ██████████████
	    █████████ ██████████ █████████ █████ █████ ████ █████
	  ███████████ ███    ███ █████████ █████ █████ ████ █████
	 ██████  █████████████████████ ████ █████ █████ ████ ██████
 ]],
          },

          { section = "header" },
          {
            title = [[


          ]],
            pane = 2,
          },
          {
            pane = 2,
            section = "terminal",
            cmd = "colorscript -e square",
            padding = 1,
            height = 7,
          },
          { section = "keys", pane = 2, padding = 1, indent = 2 },
          { icon = " ", title = "Recent Files", section = "recent_files", padding = 1 },
          { icon = " ", title = "Projects", section = "projects", padding = 1 },
          {

            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git l -n 5",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
    },
  },
}
