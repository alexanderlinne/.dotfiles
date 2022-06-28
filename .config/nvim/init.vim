set number
set relativenumber
set wildignore+=build/*
set wildignore+=**/build/*
set wildignore+=install/*
set wildignore+=**/install/*
set wildignore+=git/*
set wildignore+=**/.git/*
set wildignore+=node_modules/*
set wildignore+=**/node_modules/*
set wildignore+=.ccls-cache/*

call plug#begin()

" NERDtree
Plug 'preservim/nerdtree'

" for better responsiveness
Plug 'antoinemadec/FixCursorHold.nvim'

" colorscheme
Plug 'altercation/vim-colors-solarized'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-telescope/telescope-ui-select.nvim'

" git worktree
Plug 'ThePrimeagen/git-worktree.nvim'

" telescope.nvim
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'fcying/telescope-ctags-outline.nvim'

" lsp
Plug 'neovim/nvim-lspconfig'

" utils
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'justinmk/vim-sneak'

" formatter
Plug 'rhysd/vim-clang-format'

" ctags
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'

" autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

let mapleader = ","

let g:clang_format#command = "/usr/bin/clang-format-12"
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format_on_insert_leave = 1
autocmd FileType c,cpp ClangFormatAutoEnable

let g:cursorhold_updatetime = 100

autocmd VimEnter * nested :NERDTree

autocmd VimEnter * nested :TagbarOpen
let g:tagbar_autoclose = 0

let g:sneak#label = 1

set background=light
colorscheme solarized

let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1

let g:gutentags_exclude_wildignore=1
let g:gutentags_ctags_extra_args=["--kinds-c++=+pf", "--fields=+imaSft", "--extras=+q"]

lua require'lspconfig'.ccls.setup{}

lua require'nvim-treesitter.configs'.setup { ensure_installed = { "c", "cpp", "lua", "python", "rust", "bibtex", "cmake", "java", "javascript", "json", "kotlin", "latex", "llvm", "make", "ninja", "perl", "scala", "scss", "svelte", "toml", "tsx", "typescript", "vim" }, highlight = { enable = true}, incremental_selection = { enable = true}, textobjects = { enable = true} }

lua require("git-worktree").setup({})

lua <<EOF
  local actions = require("telescope.actions")
  require("telescope").setup({
   defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close,
        },
      },
    },
  })
EOF

lua require("telescope").load_extension("ui-select")
lua require("telescope").load_extension("fzy_native")
lua require("telescope").load_extension("ctags_outline")
lua require("telescope").load_extension("git_worktree")

nnoremap <leader><leader> :w<cr>
nnoremap <C-f> :Telescope find_files hidden=true<cr>
nnoremap <leader>fg :Telescope tags only_sort_tags=true<cr>
nnoremap <leader>fl :Telescope current_buffer_tags<cr>
nnoremap <leader>fs :Telescope live_grep<cr>
nnoremap <leader>gww :lua require("telescope").extensions.git_worktree.git_worktrees()<cr>
nnoremap <leader>gwc :lua require("telescope").extensions.git_worktree.create_git_worktree()<cr>
nnoremap <C-e> :lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <leader>e :lua require("harpoon.mark").add_file()<cr>
nnoremap <leader>n :NERDTreeFocus<cr>

" vim sneak
let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['ccls'].setup {
    capabilities = capabilities
  }
EOF

