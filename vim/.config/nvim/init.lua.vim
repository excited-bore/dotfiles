lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local M = {
  root = vim.g.pluginInstallPath,  -- share plugin folder with Plug  
  "neoclide/coc.nvim",
  branch = "master",
  build = "yarn install --frozen-lockfile",
}

M.config = function()
 -- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- 
-- -- Use Tab for trigger completion with characters ahead and navigate
-- -- NOTE: There's always a completion item selected by default, you may want to enable
-- -- no select by setting `"suggest.noselect": true` in your configuration file
-- -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- -- other plugins before putting this into your config
-- local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
-- keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
-- keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
-- 
-- -- Make <CR> to accept selected completion item or notify coc.nvim to format
-- -- <C-g>u breaks current undo, please make your own choice
-- keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
--                                                         
-- -- Use <c-j> to trigger snippets
-- keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- -- Use <c-space> to trigger completion
-- keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
-- 
-- -- Use `[g` and `]g` to navigate diagnostics
-- -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
-- keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
-- keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
-- 
-- -- GoTo code navigation
-- keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
-- keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
-- keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
-- keyset("n", "gr", "<Plug>(coc-references)", {silent = true})
-- 
-- 
-- -- Use K to show documentation in preview window
-- function _G.show_docs()
--     local cw = vim.fn.expand('<cword>')
--     if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
--         vim.api.nvim_command('h ' .. cw)
--     elseif vim.api.nvim_eval('coc#rpc#ready()') then
--         vim.fn.CocActionAsync('doHover')
--     else
--         vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
--     end
-- end
-- keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})
-- 
-- 
-- -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
-- vim.api.nvim_create_augroup("CocGroup", {})
-- vim.api.nvim_create_autocmd("CursorHold", {
--     group = "CocGroup",
--     command = "silent call CocActionAsync('highlight')",
--     desc = "Highlight symbol under cursor on CursorHold"
-- })
-- 
-- 
-- -- Symbol renaming
-- keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})
-- 
-- 
-- -- Formatting selected code
-- keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
-- keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
-- 
-- 
-- -- Setup formatexpr specified filetype(s)
-- vim.api.nvim_create_autocmd("FileType", {
--     group = "CocGroup",
--     pattern = "typescript,json",
--     command = "setl formatexpr=CocAction('formatSelected')",
--     desc = "Setup formatexpr specified filetype(s)."
-- })
-- 
-- -- Update signature help on jump placeholder
-- vim.api.nvim_create_autocmd("User", {
--     group = "CocGroup",
--     pattern = "CocJumpPlaceholder",
--     command = "call CocActionAsync('showSignatureHelp')",
--     desc = "Update signature help on jump placeholder"
-- })
-- 
-- -- Apply codeAction to the selected region
-- -- Example: `<leader>aap` for current paragraph
-- local opts = {silent = true, nowait = true}
-- keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
-- keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
-- 
-- -- Remap keys for apply code actions at the cursor position.
-- keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- -- Remap keys for apply code actions affect whole buffer.
-- keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
-- -- Remap keys for applying codeActions to the current buffer
-- keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
-- -- Apply the most preferred quickfix action on the current line.
-- keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)
-- 
-- -- Remap keys for apply refactor code actions.
-- keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
-- keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
-- keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
-- 
-- -- Run the Code Lens actions on the current line
-- keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)
-- 
-- 
-- -- Map function and class text objects
-- -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
-- keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
-- keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
-- keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
-- keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
-- keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
-- keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
-- keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
-- keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)
-- 
-- 
-- -- Remap <C-f> and <C-b> to scroll float windows/popups
-- ---@diagnostic disable-next-line: redefined-local
-- local opts = {silent = true, nowait = true, expr = true}
-- keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
-- keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
-- keyset("i", "<C-f>",
--        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
-- keyset("i", "<C-b>",
--        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
-- keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
-- keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
-- 
-- 
-- -- Use CTRL-S for selections ranges
-- -- Requires 'textDocument/selectionRange' support of language server
-- keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
-- keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
-- 
-- 
-- -- Add `:Format` command to format current buffer
-- vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
-- 
-- -- " Add `:Fold` command to fold current buffer
-- vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})
-- 
-- -- Add `:OR` command for organize imports of the current buffer
-- vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
-- 
-- -- Add (Neo)Vim's native statusline support
-- -- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- -- provide custom statusline: lightline.vim, vim-airline
-- vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")
-- 
-- -- Mappings for CoCList
-- -- code actions and coc stuff
-- ---@diagnostic disable-next-line: redefined-local
-- local opts = {silent = true, nowait = true}
-- -- Show all diagnostics
-- keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- -- Manage extensions
-- keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- -- Show commands
-- keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- -- Find symbol of current document
-- keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
-- -- Search workspace symbols
-- keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
-- -- Do default action for next item
-- keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- -- Do default action for previous item
-- keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- -- Resume latest coc list
-- keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
end


  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

 
require("lazy").setup({
      root = vim.g.pluginInstallPath,  -- share plugin folder with Plug
      spec = {
        LazyPlugSpecs,
       { 
            'mikesmithgh/kitty-scrollback.nvim',
            enabled = true,
            lazy = true,
            cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
            event = { 'User KittyScrollbackLaunch' },
            -- version = '*', -- latest stable version, may have breaking changes if major version changed
            -- version = '^3.0.0', -- pin major version, include fixes and features that do not have breaking changes
            config = function()
              require('kitty-scrollback').setup()
            end
        --{
        --  "kelly-lin/ranger.nvim",
        --  config = function()
        --    require("ranger-nvim").setup({ replace_netrw = true })
        --    vim.api.nvim_set_keymap("n", "<leader>ef", "", {
        --      noremap = true,
        --      callback = function()
        --        require("ranger-nvim").open(true)
        --      end,
        --    })
        --  end,
        --},
        -- https://www.playfulpython.com/configuring-neovim-as-a-python-ide/
        },{

            "hrsh7th/nvim-cmp",
              dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip"
              },
              config = function()
                local has_words_before = function()
                  unpack = unpack or table.unpack
                  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                end

                local cmp = require('cmp')
                local luasnip = require('luasnip')

                cmp.setup({
                  snippet = {
                    expand = function(args)
                      luasnip.lsp_expand(args.body)
                    end
                },
                    completion = {
                    autocomplete = false
                    },
                    mapping = cmp.mapping.preset.insert ({
                        ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                        ["<s-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                           cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<c-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select=true }),
                  }),
                  sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                  }
                })
            end
        },{
            "williamboman/mason.nvim",
            dependencies = {
                "williamboman/mason-lspconfig.nvim",
                "WhoIsSethDaniel/mason-tool-installer.nvim",
            },
            config = function()
                require("mason").setup()

                require("mason-lspconfig").setup({
                    automatic_installation = true,
                    ensure_installed = {
                        "html",
                        "cssls",
                        "jsonls",
                        "pyright",
                        "bashls",
                       -- "tailwindcss",
                       -- "tsserver",
                       -- "eslint",

                    },
                })

                require("mason-tool-installer").setup({
                    ensure_installed = {
                        "prettier",
                        "stylua", -- lua formatter
                        "isort", -- python formatter
                        "black", -- python formatter
                        "pylint",
                        -- "eslint_d",
                        "shellcheck",
                        "glow",
                        "markdownlint",
                        "shfmt",
                        "powershell_es",
                    },
                })
            end, 
        },{
       
        -- https://dev.to/slydragonn/ultimate-neovim-setup-guide-lazynvim-plugin-manager-23b7
       
        "neovim/nvim-lspconfig",
        
          dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim"
          },
          config = function()
            local nvim_lsp = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")

            local protocol = require("vim.lsp.protocol")

            local on_attach = function(client, bufnr)
                -- format on save
                if client.server_capabilities.documentFormattingProvider then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("Format", { clear = true }),
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format()
                        end,
                    })
                end
            end
      
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            local mason_lspconfig = require 'mason-lspconfig'
            mason_lspconfig.setup_handlers( {
                function(server)
                    nvim_lsp[server].setup({
                        capabilities = capabilities,
                   })
                end,
                ["html"] = function()
                    nvim_lsp["html"].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                ["cssls"] = function()
                    nvim_lsp["cssls"].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                ["jsonls"] = function()
                    nvim_lsp["jsonls"].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                ["bashls"] = function()
                    nvim_lsp["bashls"].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                ["pyright"] = function()
                    nvim_lsp["pyright"].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            })
            end
        },{
            
            "nvim-treesitter/nvim-treesitter", version = false,
            
            build = function()
                require("nvim-treesitter.install").update({ with_sync = true })
            end,
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "javascript", "powershell", "bash" },
                    auto_install = false,
                    highlight = { enable = true, additional_vim_regex_highlighting = false },
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "<C-n>",
                            node_incremental = "<C-n>",
                            scope_incremental = "<C-s>",
                            node_decremental = "<C-m>",
                        }
                    }
                })
           end
        },{
            "echasnovski/mini.icons",
            
            config = function()
                require("mini.icons").setup() 
            end
        },{
        
        "echasnovski/mini.files", 
         
        config = function()
            require("mini.files").setup {
            mappings = {
                close       = '<C-Q>',
                go_in       = '<C-Right>',
                go_in_plus  = '<C-Up>',
                go_out      = '<C-Left>',
                go_out_plus = '<C-Down>',
                mark_goto   = "'",
                mark_set    = 'm',
                reset       = '<BS>',
                reveal_cwd  = '@',
                show_help   = 'g?',
                synchronize = '<C-S>',
                trim_left   = '<',
                trim_right  = '>'
                }
            }
            end
        }
    }
})



local MiniFiles = require('mini.files')
vim.api.nvim_create_autocmd('user', {
  pattern = 'minifilesbuffercreate',
  callback = function(args)
    vim.keymap.set('i', '<c-q>', function() MiniFiles.close() end, { buffer = args.data.buf_id })
    vim.keymap.set('i', '<c-right>', function() MiniFiles.go_in() end, { buffer = args.data.buf_id })
    vim.keymap.set('i', '<c-up>', function() MiniFiles.go_in_plus() end, { buffer = args.data.buf_id })
    vim.keymap.set('i', '<c-left>', function() MiniFiles.go_out() end, { buffer = args.data.buf_id })
    vim.keymap.set('i', '<c-down>', function() MiniFiles.go_out_plus() end, { buffer = args.data.buf_id })
    vim.keymap.set('i', '<c-r>', function() MiniFiles.reset() end, { buffer = args.data.buf_id })
    vim.keymap.set('i', '<c-s>', function() MiniFiles.synchronize() end, { buffer = args.data.buf_id })
    vim.keymap.set('n', '<a-e>', function() MiniFiles.open() end, {  buffer = args.data.buf_id })
    vim.keymap.set('i', '<a-e>', function() MiniFiles.open() end, {  buffer = args.data.buf_id })
    end,
})

-- n = {
--     ["-"] = { function()
--         MiniFiles.open(vim.api.nvim_buf_get_name(0))
--     end, "Open MiniFiles"}
-- }



-- files.setup({
--   mappings = {
--     go_out = '-',
--   },
-- })
-- vim.keymap.set('n', '-', files.open)
-- vim.api.nvim_echo({{'first chunk and ', 'None'}, {'second chunk to echo', 'None'}}, false, {})

-- local ranger_nvim = require("ranger-nvim")
-- ranger_nvim.setup({
--   enable_cmds = true,
--   replace_netrw = false,
--   keybinds = {
--     ["ov"] = ranger_nvim.OPEN_MODE.vsplit,
--     ["oh"] = ranger_nvim.OPEN_MODE.split,
--     ["ot"] = ranger_nvim.OPEN_MODE.tabedit,
--     ["or"] = ranger_nvim.OPEN_MODE.rifle,
--   },
--   ui = {
--     border = "none",
--     height = 1,
--     width = 1,
--     x = 0.5,
--     y = 0.5,
--   }
-- })

 require("oil").setup({
   -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
   -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
     default_file_explorer = false,   
     view_options = {
         -- Show files and directories that start with "."
         show_hidden = true
     }
 })
 
-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })


require("telescope")

-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require('telescope').load_extension('media_files')
-- require('telescope').load_extension("whaler")

require('telescope').setup({
    layout_strategy='vertical',
    layout_config={width=0.5},
    pickers = {
      find_files = {
       -- theme = "dropdown", 
        follow = true,
        ignore = true,
        hidden = true
      }
    }
})

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

require("telescope").setup({
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}) 
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"


require('glow').setup()


require("toggleterm").setup()

-- save in minifiles 
-- https://github.com/echasnovski/mini.nvim/discussions/1532






-- local find_files_hijack_netrw = vim.api.nvim_create_augroup("find_files_hijack_netrw", { clear = true })
-- -- clear FileExplorer appropriately to prevent netrw from launching on folders
-- -- netrw may or may not be loaded before telescope-find-files
-- -- conceptual credits to nvim-tree and telescope-file-browser
-- vim.api.nvim_create_autocmd("VimEnter", {
--     pattern = "*",
--     once = true,
--     callback = function()
--         pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
--     end,
-- })
-- vim.api.nvim_create_autocmd("BufEnter", {
--     group = find_files_hijack_netrw,
--     pattern = "*",
--     callback = function()
--         vim.schedule(function()
--             -- Early return if netrw or not a directory
--             if vim.bo[0].filetype == "netrw" or vim.fn.isdirectory(vim.fn.expand("%:p")) == 0 then
--                 return
--             end
-- 
--             vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")
-- 
--             require("telescope.builtin").find_files({
--                 cwd = vim.fn.expand("%:p:h"),
--             })
--         end)
--     end,
-- })


-- lga_actions = require("telescope-live-grep-args.actions")

-- telescope.setup {
--   extensions = {
--        }
--     live_grep_args = {
--       auto_quoting = true, -- enable/disable auto-quoting
--       -- define mappings, e.g.
--       mappings = { -- extend mappings
--         i = {
--           ["<C-k>"] = lga_actions.quote_prompt(),
--           ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
--           -- freeze the current list and start a fuzzy search in the frozen list
--           ["<C-space>"] = actions.to_fuzzy_refine,
--         },
--       },
--       -- ... also accepts theme settings, for example:
--       -- theme = "dropdown", -- use dropdown theme
--       -- theme = { }, -- use own theme spec
--       -- layout_config = { mirror=true }, -- mirror preview pane
--     }
--   }
-- }

-- telescope.load_extension("live_grep_args")
EOF
