version = "0.21.0"

local home = os.getenv("HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path
  .. ";"
  .. xpm_path
  .. "/?.lua;"
  .. xpm_path
  .. "/?/init.lua"

os.execute(
  string.format(
    "[ -e '%s' ] || git clone '%s' '%s'",
    xpm_path,
    xpm_url,
    xpm_path
  )
)

require("xpm").setup({
  plugins = {
    -- Let xpm manage itself
    'dtomvan/xpm.xplr',
    'sayanarijit/fzf.xplr',
    'sayanarijit/command-mode.xplr',
    'sayanarijit/dua-cli.xplr',
    'dtomvan/ouch.xplr',
    {
      name = 'sayanarijit/trash-cli.xplr',
      setup = function()
          require("trash-cli").setup({
            trash_bin = "/opt/homebrew/bin/trash",
          })
      end,
    },
    'sayanarijit/zoxide.xplr',
    -- 'sayanarijit/material-landscape2.xplr',
    'sayanarijit/zentable.xplr',
    -- 'prncss-xyz/icons.xplr',
    'gitlab:hartan/web-devicons.xplr',
    {
      'dtomvan/extra-icons.xplr',
      after = function()
        xplr.config.general.table.row.cols[2] = { format = "custom.icons_dtomvan_col_1" }
      end
    },
  },
  auto_install = true,
  auto_cleanup = true,
})

xplr.config.modes.builtin.default.key_bindings.on_key.x = {
  help = "xpm",
  messages = {
    "PopMode",
    { SwitchModeCustom = "xpm" },
  },
}

xplr.config.modes.builtin.action.key_bindings.on_key["!"] = {
  help = "shell",
  messages = {
    { Call = { command = "zsh", args = { "-i" } } },
    "ExplorePwdAsync",
    "PopMode",
  },
}

xplr.config.modes.builtin.default.key_bindings.on_key.S = {
  help = "serve $PWD",
  messages = {
    {
      BashExec0 = [===[
        dufs --render-index &
        sleep 1 && read -p '[press enter to exit]'
        kill -9 %1
      ]===],
    },
  },
}

xplr.config.modes.builtin.default.key_bindings.on_key.R = {
  help = "batch rename",
  messages = {
    {
      BashExec = [===[
       SELECTION=$(cat "${XPLR_PIPE_SELECTION_OUT:?}")
       NODES=${SELECTION:-$(cat "${XPLR_PIPE_DIRECTORY_NODES_OUT:?}")}
       if [ "$NODES" ]; then
         echo -e "$NODES" | renamer
         "$XPLR" -m ExplorePwdAsync
       fi
     ]===],
    },
  },
}

xplr.config.modes.builtin.default.key_bindings.on_key.T = {
  help = "tere nav",
  messages = {
    { BashExec0 = [[xplr -m 'ChangeDirectory: %q' "$(tere)"]] },
  },
}
