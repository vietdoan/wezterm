local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Leader key: CTRL-a (replaces tmux prefix C-a)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- General settings
config.color_scheme = "Catppuccin Mocha"
config.scrollback_lines = 50000
config.term = "xterm-256color"

-- Use PowerShell on Windows
if wezterm.target_triple:find("windows") then
  config.default_prog = { "powershell.exe" }
end

-- URL detection
config.hyperlink_rules = wezterm.default_hyperlink_rules()


-- Key bindings
config.keys = {
  -- Send CTRL-a to the terminal when pressing CTRL-a twice
  { key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },

  -- Reload config (leader + r)
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },

  -- Split panes (leader + | horizontal, leader + - vertical), preserving cwd
  {
    key = "|",
    mods = "LEADER|SHIFT",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "-",
    mods = "LEADER",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  -- New tab preserving cwd (leader + c)
  {
    key = "c",
    mods = "LEADER",
    action = act.SpawnTab("CurrentPaneDomain"),
  },

  -- Smart pane navigation (Ctrl+h/j/k/l without leader)
  -- Works seamlessly with Neovim when using smart-splits.nvim
  {
    key = "h",
    mods = "CTRL",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "CTRL",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "CTRL",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = "CTRL",
    action = act.ActivatePaneDirection("Right"),
  },

  -- Pane navigation with leader (fallback)
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- Pane resize (Alt + h/j/k/l) — matches smart-splits.nvim resize keys
  { key = "h", mods = "ALT", action = act.AdjustPaneSize({ "Left", 3 }) },
  { key = "j", mods = "ALT", action = act.AdjustPaneSize({ "Down", 3 }) },
  { key = "k", mods = "ALT", action = act.AdjustPaneSize({ "Up", 3 }) },
  { key = "l", mods = "ALT", action = act.AdjustPaneSize({ "Right", 3 }) },

  -- Copy mode with vi keybindings (leader + [)
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },

  -- Quick select mode (leader + space) - highlight URLs, paths, hashes for quick copy
  { key = " ", mods = "LEADER", action = act.QuickSelect },

  -- Search mode (leader + /)
  { key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },

  -- Command palette (leader + :)
  { key = ":", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },

  -- Workspace switching (leader + s to show launcher, leader + w to switch)
  {
    key = "s",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
  },
  {
    key = "w",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Enter name for new workspace",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
        end
      end),
    }),
  },

  -- Quick tab switching (leader + number)
  { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9", mods = "LEADER", action = act.ActivateTab(8) },

  -- Close pane (leader + x)
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

  -- Zoom/toggle pane (leader + z)
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
}

return config
