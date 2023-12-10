-- Plugin configuration
--
-- I don't know enough about lua to say that the order in which they appear
-- below is relevant. Though that is the assumption i've made. i.e. The plugin
-- which is configured later is using the plugin which was configured earlier
-- in some fashion. It does so by doing a `require` within its config.

require("plugin_configs.impatient")
require("plugin_configs.lualine")
require("plugin_configs.colourscheme")
require("plugin_configs.dressing")
require("plugin_configs.nvim-web-devicons")
require("plugin_configs.nvim-treesitter")
require("plugin_configs.telescope")
require("plugin_configs.luasnip")
require("plugin_configs.jump-lightspeed-leap")
require("plugin_configs.nvim-autopairs")
require("plugin_configs.indent-blankline")
require("plugin_configs.virt-column")
require("plugin_configs.comment")
-- require("plugin_configs.neoclip")
require("plugin_configs.gitsigns")
require("plugin_configs.diffview")
require("plugin_configs.trouble")
require("plugin_configs.todo-comments")
require("plugin_configs.which-key")
require("plugin_configs.zen-mode")
require("plugin_configs.twilight")
require("plugin_configs.neorg")
require("plugin_configs.eyeliner")
require("plugin_configs.surround")
require("plugin_configs.oil")
-- require("plugin_configs.nvim-tree")

-- TODO
require("plugin_configs.toggleterm")
require("plugin_configs.alpha-nvim")
