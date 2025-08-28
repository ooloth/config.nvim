-- TODO: enable inlay hints and code lenses for each LSP server

local util = require('config.util')

-- custom filename -> filetype associations
vim.filetype.add({
  extension = {
    mdx = 'markdown.mdx',
    tf = 'terraform', -- see: https://sbulav.github.io/vim/neovim-improving-work-with-terraform/#correctly-detecting-tf-filetype
    tfvars = 'terraform',
    tfstate = 'json',
  },
  filename = {
    ['Brewfile'] = 'ruby',
    ['tsconfig.json'] = 'jsonc',
    -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#docker_compose_language_service
    ['docker-compose.yaml'] = 'yaml.docker-compose',
  },
  pattern = {
    ['docker-compose.*%.yaml'] = 'yaml.docker-compose',
    ['.*/kitty/.*%.conf'] = 'conf',
    ['.*/kitty/.*/.*%.conf'] = 'conf',
    ['.*/.vscode/.*%.json'] = 'jsonc',
    ['.*/vscode/.*%.json'] = 'jsonc',
  },
})

return {
  require('config.plugins.specs.nvim-treesitter'),
  util.require_all_files_in_config_directory('plugins/lang'),
}
