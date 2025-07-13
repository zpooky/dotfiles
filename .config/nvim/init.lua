-- - sh
--   - npm install bash-language-server
-- - js
--   - npm install -g neovim
--   - yay -S nodejs-neovim
-- - python2
--   - pip2 install --user --upgrade jedi
--   - yay -S python2-neovim python2-jedi
-- - python3
--   - pip3 install --user --upgrade jedi
--   - yay -S python-neovim python-jedi
--   - pip3 install pynvim --upgrade
-- - ruby
--   - yay -S ruby-neovim
--   - gem install neovim
-- - docker
--   - npm install -g dockerfile-language-server-nodejs
-- - scala
--   - yay -S metals
-- - markdown
--   - yay -S redpen languagetool
-- 
-- pip3 install --upgrade neovim
-- 
-- :checkhealth
vim.cmd([[
  source $HOME/.standardvimrc

  call plug#begin('~/.config/nvim/plugged')
  source ~/.config/nvim/plug.vim
  " {{{
  Plug 'neovim/nvim-lspconfig'
  " }}}

  " nvim tree-sitter {{{
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'zpooky/cglobal'
  " NOTE: while hang if we insert allot of
  " Plug 'p00f/nvim-ts-rainbow'
  " }}}

  call plug#end()


  " {{{
  colorscheme codedark
  set background=dark
  " }}}
]])

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  sync_install = true,
  cglobal = {
    enable = true
  }
}

vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}
