-- TODO: formatting?
-- TODO: linting?
-- TODO: nvim-lint: consider the default linter: dockerfile = { "hadolint" },
-- TODO: https://www.lazyvim.org/extras/lang/docker

-- Requires https://github.com/rcjsuen/dockerfile-language-server-nodejs
-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#dockerls
vim.lsp.enable('dockerls')

return {}
