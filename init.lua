--[[
Neovim automatically adds a 'lua' folder, if present here, to be available to
vim's runtimepath. This allows us to just refer the lua modules as we're doing
below.

We also don't need to refer to them by their full path which includes '.lua',
we can omit the extension. This is standard lua setup.

On top of this, we can also `require` a folder as long as it has an 'init.lua'
inside the folder. Its the job of that 'init.lua' file to 'require' any other
sub-modules inside the folder. I'm still unclear of what path we'll use inside
of the 'foldder/init.lua' to include those sub-modules.
]]
--
require("globals")
require("options")
require("mappings")
require("autocommands")
require("plugins")
require("plugin_configs")
require("lsp_configs")
