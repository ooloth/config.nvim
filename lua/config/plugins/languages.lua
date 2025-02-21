-- TODO: enable inlay hints and code lenses for each LSP server

local util = require('config.util')

return util.require_all_files_in_config_directory('plugins/lang')
