# VSCode & Neovim Setup Guide

This guide is intended to provide an easy-to-understand installation and configuration help for setting up VSCode with the vscode-neovim extension.

## Introduction

For a long time I have been wanting to switch to a modal editor like [vim](https://www.vim.org/) or it's fork [neovim](https://neovim.io) and especially in the last months, I have found it to be more and more annoying to have to reach for the mouse when trying to navigate through a project.
On the other hand, I fell in love with Visual Studio Code on the day I started using it because of it's customisability (which vim obviously has too) and the general feel when coding.
I had already tried out projects like [VSCodeVim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) and [VSCode Neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim), but I always had some problems with them.
With the former I've had severe performance problems while working on larger projects and both of them seemed like they didn't perfectly integrate with the existing shortcuts and extensions I had without requiring a lot of research and manual adjustments to be made.

The reason I created this guide is because I want to spare others the hassle of having to test and tweak everything until it is a, in my opinion, perfect mix between neovim and VSCode.

## Structure

The guide is divided into several modules. The *core* modules are required to set up VSCode and the neovim extension and I'll assume you have worked through them in linear order, but the *optional* modules are what set this document apart. They provide further customization and options to integrate extensions into the experience and to add more navigation shortcuts so that you'll never ever have to touch your mouse again. 

## Requirements

[VSCode](https://code.microsoft.com) and [neovim](https://github.com/neovim/neovim) v0.5.0 or greater have to be installed. If neovim is in your system path, you can check your neovim version with the `nvim --version` command.

## 0) Setting up a custom VSCode configuration \[*Optional*\]

In this module, we set up a clean VSCode configuration so that you can experiment with your extensions and configuration without messing up your current setup.

To do so, all that is required is that you have added VSCode to your path.
You then have to create a folder where your extensions and configurations are going to be stored. In that folder you need to create two subdirectories, `extensions` and `data`, and then create a batch file with the following contents:

```sh
code -n --extensions-dir "path/to/extensions/folder" --user-data-dir "path/to/data/folder"
```

Whenever you want to launch your custom VSCode & neovim setup, just execute this script.

## 1) Installation \[*Core*\]

This module covers the basic installation and setup necessary to integrate neovim into VSCode.
Most if not all of this can also be found in the [vscode-neovim extension readme](https://github.com/asvetliakov/vscode-neovim#readme), but we are going to be using lua instead of vimscript for writing the configuration.

First of all you have to open VSCode and install the [vscode-neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) extension by [Alexey Svetliakov](https://github.com/asvetliakov).
To tell the extension where the neovim executable is located, we need to open the settings. Throughout this guide, we will be using the settings.json file instead of the gui settings.
Feel free to use whatever you're comfortable with, but the `settings.json` file works regardless of the language you're using and, with some comments, it is a lot cleaner to look at and work with.

To open the `settings.json`, open the command picker with `F1` or `Ctrl+Shift+P` and pick *Preferences: Open Settings (JSON)*. I'm going to be assuming that the file is currently empty, but you can also append the settings to your existing ones.

To add the neovim executable path to your configuration, set the `vscode-neovim.neovimExecutablePaths.win32/linux/darwin` setting, with the last part depending on your OS, to the path of your neovim executable.
Let's also add a comment to clarify that we'll put all settings related to the neovim extension here.
Our example configuration now looks like this:

```json5
{
    // neovim
    "vscode-neovim.neovimExecutablePaths.win32": "C:\\Neovim\\bin\\nvim.exe",
}
```

If you did everything correctly, you have now completed the basic setup and are ready to use neovim in VSCode. If you've got any issues, be sure to check out the [vscode-neovim extension readme](https://github.com/asvetliakov/vscode-neovim#readme) which has further information on the topic of setting up the extension.

## 2) init.lua - neovim configuration \[*Core*\]

One of the advantages neovim has over vim is it's possibility to be configured with lua, a proper programming language.
To find out where to the configuration should be saved, type `:echo stdpath("config")` while in normal mode. This will print out the folder where the configuration should be saved into the lower left corner.
In this folder, create a file named `init.lua` with the following contents:

```lua
-- global settings

-- vscode and nvim only settings
if (vim.g.vscode) then
    -- VSCode extension
else
    -- ordinary neovim
end
```
In the top we are going to put the settings applied to neovim both while running VSCode and while in the command line.
The *if/else* statement is used for configuration specific to VSCode or standalone neovim.

For now, we are going to leave the `init.lua` file empty, but some of the optional modules require this structure to work.

## 3) settings.json - VSCode configuration \[*Core*\]

We already have a `settings.json` file so let's populate it with some settings to make our life easier.
In the [vscode-neovim extension readme](https://github.com/asvetliakov/vscode-neovim#readme) it is recommended to set `"editor.scrollBeyondLastLine"` to `false`, so add
```json5
    "editor.scrollBeyondLastLine": false, // recommended by neovim
```
to your `settings.json`.
This setting prevents the editor from creating an empty space below the last line of a file, which can result in some funky behaviour when scrolling or navigating through your code.

If you want to, you can also enable relative line numbers like this:
```json5
    "editor.lineNumbers": "relative",
```
If enabled, the relative distance of your cursor to the corresponding line will be shown instead of the absolute line number.

## 4) Entering normal mode \[*Optional*\]

> This section is pretty much copied over from the [vscode-neovim extension readme](https://github.com/asvetliakov/vscode-neovim#custom-escape-keys), but included for the sake of completeness.

I like to enter normal mode by pressing `jk` instead of `Ctrl+C` or `Esc`. While it doesn't work perfectly, both using `jj` and `jk` is supported by the vscode-neovim extension. To use them, open your `keybindings.json` similarly to how you opened the settings.json and add the following keybindings: 

```json5
// enter normal mode with jk
{
    "command": "vscode-neovim.compositeEscape1",
    "key": "j",
    "when": "neovim.mode == insert && editorTextFocus",
    "args": "j"
},
{
    "command": "vscode-neovim.compositeEscape2",
    "key": "k",
    "when": "neovim.mode == insert && editorTextFocus",
    "args": "k"
},
```

Unfortunately, it is not possible to enable `jk` without enabling `jj`. More information on that can be found in the [vscode-neovim extension readme](https://github.com/asvetliakov/vscode-neovim#custom-escape-keys).

Additionally, you can add the following code in you init.lua to enable `jk` even if you're using neovim from the terminal:

```lua
-- key mappings

-- map jk to escape
inoremap('jk', '<ESC>')
inoremap('JK', '<ESC>')
inoremap('jK', '<ESC>')
```
For this to work, you need to have configured mapx.nvim [](https://link)

> For this to work, you need to have mapx.nvim installed ([see 5.2) mapx.nvim](#52-mapxnvim-optional)).

## 5) Neovim plugins \[*Optional*\]

In this module, we are going to be taking a look at how to set up some neovim plugins.
These are not necessary for the core experience, but can improve the editing experience and/or provide similar features to the ones VSCode provides by default in a more vim-like fashion.

### 5.1) packer.nvim \[*Required*\]

| Name        | packer.nvim                                 |
| ----------- | ------------------------------------------- |
| Author      | [wbthomason](https://github.com/wbthomason) |
| Source      | <https://github.com/wbthomason/packer.nvim> |
| Description | plugin manager                              |

packer.nvim is a plugin manager allowing you to install and use plugins similarly to how the extensions marketplace works in VSCode (it works differently, but it's the same concept: download and install something that modifies your editing experience).

> **!! You need to have [git](https://git-scm.com) installed for this to work !!**

Instead of installing it packer.nvim manually, we are going to do something they also suggest in their [readme](https://github.com/wbthomason/packer.nvim#bootstrapping). Into the global section of the `init.lua` file we created earlier, paste the following code *(We're going to go over it right after, but copying it in one go usually results in less errors from selecting to little or to much)*.

```lua
-- packer.nvim config

-- ensure that packer is installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
```

This piece of code will check if packer.nvim is installed by checking if the folder where `packer.nvim` should be stored is empty (the condition of the if statement). If it is, the plugin will be cloned from its GitHub repository.
**While it should be safe to do so as packer.nvim is a well-known open source plugin, cloning unknown code can be a security risk.**

After this add the the following lines to your neovim configuration. They will properly initialize `packer.nvim` and are where we are going to specify which plugins we want to use later on.
```lua
-- configure plugins
require('packer').startup(function(use)

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end
)
```

The first plugin we want `packer.nvim` to manage is itself. This is done by adding the following line in the startup function:

```lua
...
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
...
```

Each time you add or remove a plugin, use the command `:PackerSync` to update and install your plugins.
You might have to restart VSCode before that so that the configuration updates.

### 5.2) mapx.nvim \[*Optional*\]

| Name        | mapx.nvim                            |
| ----------- | ------------------------------------ |
| Author      | [b0o](https://github.com/b0o)        |
| Source      | <https://github.com/b0o/mapx.nvim>   |
| Description | easier key (re)mapping in lua config |

This plugin adds functions to simplify the configuration of key mappings and commands in a lua config. You should definitely use it if you are planning on customizing your mappings.

To use it, add
```lua
-- for adding mappings
use 'b0o/mapx.nvim'
```
inside of the `packer.nvim` startup function and 
```lua
-- setup mapx
require('mapx').setup{ global = true }
```
after it. The second option is needed to include the functions in the global scope.

### 5.3) sandwich.vim \[*Optional*\]

| Name        | sandwich.vim                                |
| ----------- | ------------------------------------------- |
| Author      | [machakann](https://github.com/machakann)   |
| Source      | <https://github.com/machakann/vim-sandwich> |
| Description | surround text objects with things           |

`sandwich.vim` is a plugin which makes it very easy to surround text with parentheses, quotes, etc..
If you want to use it, add

```lua
-- surround text objects
use 'machakann/vim-sandwich'
```
inside of the `packer.nvim` startup function.

### 5.3) Comment.nvim

| Name        | Comment.nvim                               |
| ----------- | ------------------------------------------ |
| Author      | [numToStr](https://github.com/numToStr)    |
| Source      | <https://github.com/numToStr/Comment.nvim> |
| Description | comment and uncomment text                 |

`Comment.nvim` adds motions for commenting out or uncommenting lines, blocks and other text objects similarly to some builtin VSCode shortcuts.
The most basic motion is `gcc`, which comments out the line your cursor is on.
This code will add `Comment.nvim` to your plugins and configure it:

```lua
    -- comment/uncomment
    use {
        'numToStr/Comment.nvim',
        config = function()
            require'Comment'.setup()
        end
    }
```
It has to be put into the `packer.nvim` startup function.

## 6) VSCode Extensions

This module covers various VSCode extensions which need extra configuration to work well with neovim or which improve keyboard navigation in VSCode.

### 6.1) Keyboard QuickFix \[*Optional*\]

| Name        | Keyboard QuickFix                                                                  |
| ----------- | ---------------------------------------------------------------------------------- |
| Author      | [PascalSenn](https://github.com/PascalSenn)                                        |
| Marketplace | <https://marketplace.visualstudio.com/items?itemName=pascalsenn.keyboard-quickfix> |
| Source      | <https://github.com/PascalSenn/keyboard-quickfix>                                  |
| Description | navigate quick fix menu with keyboard                                              |

This one, once again, is suggested on the [vscode-neovim extension readme](https://github.com/asvetliakov/vscode-neovim#custom-escape-keys).
It changes the quick fix menu to a quick open menu which can be navigated with the keyboard.

To make it work with `Ctrl+.` and `z=` (normal mode) you have to configure the keyboard shortcuts in the VSCode `keybindings.json` and the `init.lua` respectively

`keybindings.json`:
```json5
// keyboard quickfix
{
    "key": "ctrl+.",
    "command": "keyboard-quickfix.openQuickFix",
    "when": "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly"
},
```
`init.lua` in the VSCode section:
```lua
if (vim.g.vscode) then
    -- VSCode extension
    ...
    -- map keyboard quickfix;
    
    nnoremap('z=', "<Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<Cr>")
    
```

> For the lua code to work, you need to have mapx.nvim installed ([see 5.2) mapx.nvim](#52-mapxnvim-optional)).

### 6.2) Colonize \[*Optional*\]

| Name        | Colonize                                                                |
| ----------- | ----------------------------------------------------------------------- |
| Author      | [vmsynkov-zz](https://github.com/vmsynkov-zz)                           |
| Marketplace | <https://marketplace.visualstudio.com/items?itemName=vmsynkov.colonize> |
| Source      | <https://github.com/vmsynkov-zz/colonize>                               |
| Description | add semicolons to the end of lines                                      |

I use this extension to easily append semicolons to the end of a line. It isn't perfect and unfortunately not being updated anymore, so I might replace it with another extension in the near future, but it works well and isn't disruptive.

The keyboard shortcuts for this extension need to be configured so that it doesn't trigger in normal mode.
Append this to your `keybindings.json`:
```json5
// colonize
{
    "key": "shift+enter",
    "command": "colonize.endline",
    "when": "neovim.mode == insert && editorTextFocus"
},
{
    "key": "shift+enter",
    "command": "-colonize.endline",
    "when": "editorTextFocus"
},
{
    "key": "ctrl+alt+enter",
    "command": "colonize.hold",
    "when": "neovim.mode == insert && editorTextFocus"
},
{
    "key": "ctrl+alt+enter",
    "command": "-colonize.hold",
    "when": "editorTextFocus"
},
{
    "key": "alt+enter",
    "command": "colonize.newline",
    "when": "neovim.mode == insert && editorTextFocus"
},
{
    "key": "alt+enter",
    "command": "-colonize.newline",
    "when": "editorTextFocus"
},
```
The keybindings have simply been modified to include `neovim.mode == insert`, which restricts keybindings to insert mode.

## 7) System-wide clipboard

By default, neovim uses another clipboard which makes it very hard to copy and paste stuff over from other programs.
To change that, append
```lua
-- set clipboard to global clipboard
vim.opt.clipboard:append("unnamedplus")
```
to the global section of your `init.lua`. This is equivalent to `set clipboard+=unnamedplus` in vimscript.

## 8) Better support for Neovim Commands in VSCode

With the default setup, you can't access the command dropdown with `:` unless you are in normal mode in active editor. This prevents you from using commands to e.g. open files while inside the markdown preview or the settings tab.

To bypass this, add the following keyboard shortcut (It may not work on all keyboards, please open an issue if this doesn't work for you):

```json5
// use ':' key for commands even if no editor tab is opened
{
    "key": "Shift+.",
    "command": "vscode-neovim.send",
    "when": "!inputFocus && !editorTextFocus",
    "args": ":"
}
```

This will send the colon `:` to the neovim backend when `Shift+.` (colon) is pressed while you aren't focussing on an editor or input.

## Appendix

### A) Links & Resources

- neovim: <https://github.com/neovim/neovim>
- vscode-neovim extension: <https://github.com/asvetliakov/vscode-neovim>
- neovim lua guide: <https://github.com/nanotee/nvim-lua-guide>
