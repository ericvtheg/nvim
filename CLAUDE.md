# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personalized Neovim configuration based on kickstart.nvim, structured as a modular Lua-based setup. The configuration uses Lazy.nvim as the plugin manager and focuses on modern development workflows with LSP, formatting, linting, and AI assistance.

## Key Architecture

### Plugin Structure
- **Core**: `init.lua` contains base configuration and loads the Lazy plugin manager
- **Kickstart plugins**: Located in `lua/kickstart/plugins/` (debug, autopairs, neo-tree, gitsigns)
- **Custom plugins**: Located in `lua/custom/plugins/` for personalized extensions
- **Plugin loading**: Uses `{ import = 'custom.plugins' }` pattern for automatic module discovery

### Configuration Approach
- Uses 2-space indentation consistently
- Leader key is `<space>`
- Global statusline enabled (required for some plugins like avante nvim)
- Auto-formatting on save via conform.nvim
- Real-time linting via nvim-lint

## Important Tools & Commands

### Dependencies
```bash
# Required external tools (from README.md)
pip3 install neovim-remote
brew install pngpaste
ulimit -n 4096  # Increase file descriptor limit for neo-tree
```

### Neovim Commands
- `:Lazy` - Manage plugins (install, update, view status)
- `:Lazy update` - Update all plugins
- `:ConformInfo` - View formatter configuration and status
- `:LazyGit` - Open LazyGit interface
- `:1ToggleTerm direction=float` - Open floating terminal

### Key Development Workflows

#### Formatting & Linting
- **Auto-formatting**: Configured via `lua/custom/plugins/conform.lua`
  - Runs on save with 500ms timeout
  - Supports: Lua (stylua), JS/TS/React (prettier/eslint_d), YAML/JSON (prettier)
- **Linting**: Configured via `lua/custom/plugins/nvim_lint.lua` 
  - Uses eslint_d for JavaScript/TypeScript files
  - Triggers on save, buffer read, and insert leave

#### Git Integration
- **LazyGit**: Accessed via `<leader>gi` or `:LazyGit`
- **Git blame**: `<leader>gb`
- **Browse remote**: `<leader>go` (requires fugitive.vim)
- **Git editor integration**: Uses neovim-remote (nvr) when available

#### AI Code Assistance
- **CodeCompanion**: Configured in `lua/custom/plugins/code_companion.lua`
  - Toggle chat: `<leader>a`
  - Actions palette: `<C-a>`
  - Add code to chat: `<LocalLeader>a` (visual mode)
  - Adapts between Anthropic (personal) and Copilot (work) based on `PERSONAL_COMPUTER` env var

## Plugin Configuration Patterns

### Custom Plugin Structure
Each plugin in `lua/custom/plugins/` should return a table with:
- Plugin specification (string or table)
- Optional: `opts`, `config`, `keys`, `cmd`, `event` properties
- Follow existing patterns for consistency

### Environment-Aware Configuration
The setup detects personal vs work environments using `PERSONAL_COMPUTER` environment variable and adapts AI provider accordingly.

## Terminal & Navigation

### Terminal Management
- Floating terminal: `<leader>tf` (ID 1, persistent)
- Horizontal terminal: `<leader>th` (incremental IDs)
- Toggle all terminals: `<leader>tt`
- Send visual selection to terminal: `<leader>tt` (visual mode)

### Key Bindings
- Window navigation: `<C-hjkl>`
- Save: `<C-s>` (all modes)
- Find/replace current word: `<leader>h`
- Buffer management: `<leader>bX` (close all buffers)