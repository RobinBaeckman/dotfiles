local wezterm = require 'wezterm'
return {
   term = "wezterm",
   color_scheme = 'Catppuccin Mocha',
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = true,
   font_size = 14.0,
   font = wezterm.font_with_fallback {
      'JetBrains Mono',
      'Fira Code',
      'Cascadia Code'
   },
   colors = {
      background = "#141423",
   },

   -- Add padding for better readability
   window_padding = {
      left = 10,
      right = 10,
      top = 10,
      bottom = 10,
   },

   -- Scrollback lines for better history navigation
   scrollback_lines = 5000,

   -- Key bindings
   keys = {
      -- Remap the `¥` key to backslash
      { key = "¥", mods = "NONE", action = wezterm.action { SendString = "\\" } },
      {
         key = ',',
         mods = 'CTRL',
         action = wezterm.action.SendString('\x1b[44;5u'), -- Send a custom escape sequence
      },
      {
         key = 'H',
         mods = 'CTRL|SHIFT',
         action = wezterm.action.SendKey { key = 'LeftArrow', mods = 'CTRL|SHIFT' },
      },
      {
         key = 'J',
         mods = 'CTRL|SHIFT',
         action = wezterm.action.SendKey { key = 'DownArrow', mods = 'CTRL|SHIFT' },
      },
      {
         key = 'K',
         mods = 'CTRL|SHIFT',
         action = wezterm.action.SendKey { key = 'UpArrow', mods = 'CTRL|SHIFT' },
      },
      {
         key = 'L',
         mods = 'CTRL|SHIFT',
         action = wezterm.action.SendKey { key = 'RightArrow', mods = 'CTRL|SHIFT' },
      },
   },

   -- Mouse bindings
   mouse_bindings = {
      {
         event = { Up = { streak = 1, button = 'Left' } },
         mods = 'CTRL',
         action = wezterm.action.OpenLinkAtMouseCursor,
      },
   },

   -- Hyperlink settings
   hyperlink_rules = {
      {
         regex = [[\b\w+://(?:[^\s/$.?#].[^\s]*)\b]],
         format = '$0',
      },
      {
         regex = [[\b\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6}\b]],
         format = 'mailto:$0',
      },
      {
         regex = [[\bfile://[^\s]*\b]],
         format = 'file:$0',
      },
   },

   -- Set default shell to Homebrew Zsh and source .zshrc
   default_prog = { '/Users/robin/.nix-profile/bin/zsh', '-l' },

   -- Window decorations
   window_decorations = "TITLE|RESIZE",
}
