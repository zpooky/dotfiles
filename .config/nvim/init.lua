-- - sh
--   - npm install bash-language-server
-- - js
--   - npm install -g neovim
--   - yay -S nodejs-neovim
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

-- AI {
local core_parser_path = vim.fn.expand('~/lib/nvim')
if vim.fn.isdirectory(core_parser_path) == 1 then
  vim.opt.runtimepath:remove(core_parser_path)
  vim.opt.runtimepath:prepend(core_parser_path)
end
-- }

vim.cmd([[
  source $HOME/.standardvimrc

  call plug#begin('~/.config/nvim/plugged')
  source ~/.config/nvim/plug.vim
  " {{{
  " example configs: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
  " https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file
  Plug 'neovim/nvim-lspconfig'
  " }}}

  " nvim tree-sitter {{{
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'zpooky/cglobal'
  " NOTE: while hang if we insert allot of
  " Plug 'p00f/nvim-ts-rainbow'
  " }}}

  " {{{
  Plug 'MeanderingProgrammer/render-markdown.nvim'
  " }}}
  call plug#end()


  " {{{
  colorscheme codedark
  set background=dark
  " }}}
]])

-- TODO
require('nvim-treesitter').install { 'rust', 'javascript', 'zig', 'html', 'bash', 'c', 'cpp', 'scala', 'make', 'python', 'zsh', 'yaml', 'xml', 'vim', 'lua', 'cmake', 'diff', 'dockerfile', 'java', 'json', 'markdown', 'markdown_inline'}

-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = "all",
--   sync_install = true,
--   -- cglobal = {
--   --   enable = true
--   -- }
-- }

-- vim.api.nvim_create_autocmd('TabEnter', {
--   callback = function()
--     if vim.v.vim_did_enter == 0 then return end
--     vim.api.nvim_echo({{ vim.fn.expand('%:p:h'), '' }}, false, {})
--   end,
-- })

require('render-markdown').setup({
  enabled = true,
  render_modes = { 'n', 'c', 't' },
  anti_conceal = {
    enabled = false,
  },
  heading = {
    enabled = false,
  },
  bullet = {
    enabled = false,
  },
  checkbox = {
    enabled = false,
  },
  quote = {
    enabled = false,
  },
  dash = {
    enabled = false,
    -- icon = '─',
    -- width = 'full',
    -- left_margin = 0,
  },
  pipe_table = {
    enabled = false,
  },
  callout = {},
  link = {
    enabled = false,
  },
  sign = {
    enabled = false,
  },
  code = {
    enabled = true,
    sign = false,
    language = false,
    inline = true,
    border = 'none',
    width = 'block',
    disable_background = true,
    conceal_delimiters = false,
    highlight_inline = 'markdownCode',
  },
  win_options = {
    conceallevel = {
      default = vim.o.conceallevel,
      rendered = vim.o.conceallevel,
    },
    concealcursor = {
      default = vim.o.concealcursor,
      rendered = vim.o.concealcursor,
    },
  },
})

-- https://github.com/LuaLS/lua-language-server.git
-- ./make.sh
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})
vim.lsp.enable('lua_ls')

-- apt-get install python3-pylsp
-- apt-get install python3-pylsp-rope
vim.lsp.config('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
})
vim.lsp.enable('pylsp')

-- yay -S rust-analyzer
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
})
vim.lsp.enable('rust_analyzer')

-- npm i -g bash-language-server
vim.lsp.enable('bashls')

-- print current file when I switch tab
vim.api.nvim_create_autocmd('TabEnter', {
  callback = function()
    local file = vim.fn.expand('%')
    vim.notify(file, vim.log.levels.INFO)
  end,
})
