version = "0.19.0"

local home = os.getenv("HOME")
package.path = home
.. "/.config/xplr/plugins/?/init.lua;"
.. home
.. "/.config/xplr/plugins/?/src/init.lua;"
.. home
.. "/.config/xplr/plugins/?.lua;"
.. package.path

require("fzf").setup()
require("trash-cli").setup()
require("zoxide").setup()
require("ouch").setup()
require("material-landscape2").setup()
require("icons").setup()
require("dua-cli").setup()
require("dragon").setup()
require("preview-tabbed").setup()
require("map").setup()
