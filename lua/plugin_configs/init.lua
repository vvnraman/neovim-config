-- Plugin configuration
--
-- I'm not sure enough about lua to say that the order in which they appear
-- below is relevant. Though that is the assumption i've made. i.e. The plugin
-- which is configured later is using the plugin which was configured earlier
-- in some fashion. It does so by doing a `require` within its config.

require 'plugin_configs.impatient'
require 'plugin_configs.colourscheme'
require 'plugin_configs.dressing'
require 'plugin_configs.nvim-web-devicons'
require 'plugin_configs.nvim-autopairs'
require 'plugin_configs.indent-blankline'
require 'plugin_configs.comment'
require 'plugin_configs.lualine'
require 'plugin_configs.bufferline'
require 'plugin_configs.gitsigns'


require 'plugin_configs.trouble'
require 'plugin_configs.telescope'
require 'plugin_configs.todo-comments'
require 'plugin_configs.nvim-treesitter'
require 'plugin_configs.which-key'

-- TODO
require 'plugin_configs.null-ls'
require 'plugin_configs.toggleterm'
require 'plugin_configs.project'
require 'plugin_configs.alpha-nvim'

-- This will take some time getting used to. I'm already quite proficient with
-- netrw, so will keep using that for now
-- require 'plugin_configs.nvim-tree'

--[[
require 'plugin_configs.legendary'
require 'plugin_configs.navigator'
--]]

