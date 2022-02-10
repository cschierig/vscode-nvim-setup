-- global settings

-- packer.nvim config

-- ensure that packer is installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- configure plugins
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    
    -- for adding mappings
    use 'b0o/mapx.nvim'

    -- surround text objects
    use 'machakann/vim-sandwich'

    -- comment/uncomment
    use {
        'numToStr/Comment.nvim',
        config = function()
            require'Comment'.setup()
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end
)

-- setup mapx
require'mapx'.setup{ global = true }

-- set clipboard to global clipboard
vim.opt.clipboard:append("unnamedplus")

-- keybindings

-- map jk to escape
inoremap('jk', '<ESC>')
inoremap('JK', '<ESC>')
inoremap('jK', '<ESC>')

-- vscode and nvim only settings
if (vim.g.vscode) then
    -- VSCode extension

    -- map keyboard quickfix
    nnoremap('z=', "<Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<Cr>")
else
    -- ordinary neovim
end