# Dotfiles Development Documentation

This document outlines the structure, decisions, and implementation details of Nathaniel's dotfiles project.

## Project Overview

Personal macOS dotfiles for automated setup of development environments focused on PHP/Laravel and Node.js development. Designed to support multiple user accounts on the same machine, each with different project repositories.

## Key Features

### 1. Automated Installation
- **Script**: `install.sh`
- Installs Homebrew
- Installs all packages from Brewfile
- Creates symlinks for dotfiles
- Sets zsh as default shell
- Optional SSH key generation
- Optional macOS system preferences
- Optional project cloning

### 2. Multi-User Support
Users supported: `fuze`, `rerank`, `rapidhover`, `detectivefaq`

Each user gets:
- Custom project repositories cloned into Herd environments
- Same dotfiles and tools (shared Homebrew installation)
- Individual shell configurations

### 3. Herd Environment Structure
Projects are cloned into three environments for each user:
```
~/Herd/
├── Development/  (default branch)
├── Staging/      (default branch)
└── Production/   (default branch)
```

### 4. SSH Key Management
- Automated SSH key generation (ed25519)
- Auto-configured for macOS keychain
- Public key copied to clipboard for GitHub

### 5. Dock Customization
- Automated Dock configuration using `dockutil`
- Removes all default apps
- Adds only: Finder, Terminal, Chrome, Safari, Screenshot, VS Code, Notion

### 6. MySQL Database Setup
- Automated MySQL database creation for each project
- Creates databases for Dev, Staging, and Production environments
- Creates MySQL users with appropriate permissions
- Pre-configured credentials ready for `.env` files

## File Structure

```
dotfiles/
├── .gitconfig              # Git configuration (pre-configured for Nathaniel)
├── .gitignore_global       # Global gitignore patterns
├── .macos                  # macOS system preferences
├── .zshrc                  # Minimal zsh configuration
├── Brewfile                # Homebrew package definitions
├── install.sh              # Main installation script
├── README.md               # User-facing documentation
├── DEVELOPMENT.md          # This file - developer documentation
├── bin/                    # Custom scripts (added to PATH)
└── scripts/
    ├── setup-ssh.sh        # SSH key generation
    ├── clone-projects.sh   # User-specific project cloning
    └── setup-mysql.sh      # MySQL database setup
```

## Brewfile Contents

### Development Tools
- **PHP/Laravel**: `php`, `composer`, Herd
- **Node.js**: `node`, `yarn`
- **Git**: `git`, `gh` (GitHub CLI)
- **Databases**: `mysql`, `redis`
- **Editor**: VS Code, Claude Code CLI

### Applications
- **Browsers**: Chrome, Firefox (optional)
- **Development**: TablePlus, Postman
- **Productivity**: Notion, Bitwarden, Rectangle (optional)

### Utilities
- `fzf` - Fuzzy finder
- `ripgrep` - Fast search
- `tree` - Directory visualization
- `mas` - Mac App Store CLI
- `dockutil` - Dock management

## User-Specific Projects

### Fuze
```bash
FuzeUpsell/fuze
FuzeUpsell/fuze-post-purchase
TrinityRiverSoftware/fullfuze.com
```

### ReRank
```bash
RerankSEO/rerank
TrinityRiverSoftware/rerankseo.com
```

### RapidHover
```bash
RapidHover/images-cdn
RapidHover/images-backend
TrinityRiverSoftware/rapidhover.com
```

### DetectiveFAQ
```bash
DetectiveHQ/faq-admin
DetectiveHQ/faq-backend
DetectiveHQ/faq-api
DetectiveHQ/faq-widget
DetectiveHQ/faq-client
DetectiveHQ/detectivehq.com
```

## MySQL Databases

Each user gets MySQL databases for each project and environment:

### Fuze
- **User**: `fuze` / **Password**: `fuze_password`
- **Databases**:
  - `fuze_dev`, `fuze_staging`, `fuze_prod`
  - `fuze_post_purchase_dev`, `fuze_post_purchase_staging`, `fuze_post_purchase_prod`
  - `fullfuze_dev`, `fullfuze_staging`, `fullfuze_prod`

### ReRank
- **User**: `rerank` / **Password**: `rerank_password`
- **Databases**:
  - `rerank_dev`, `rerank_staging`, `rerank_prod`
  - `rerankseo_dev`, `rerankseo_staging`, `rerankseo_prod`

### RapidHover
- **User**: `rapidhover` / **Password**: `rapidhover_password`
- **Databases**:
  - `rapidhover_cdn_dev`, `rapidhover_cdn_staging`, `rapidhover_cdn_prod`
  - `rapidhover_backend_dev`, `rapidhover_backend_staging`, `rapidhover_backend_prod`
  - `rapidhover_com_dev`, `rapidhover_com_staging`, `rapidhover_com_prod`

### DetectiveFAQ
- **User**: `detectivefaq` / **Password**: `detective_password`
- **Databases**:
  - `faq_admin_dev`, `faq_admin_staging`, `faq_admin_prod`
  - `faq_backend_dev`, `faq_backend_staging`, `faq_backend_prod`
  - `faq_api_dev`, `faq_api_staging`, `faq_api_prod`
  - `faq_widget_dev`, `faq_widget_staging`, `faq_widget_prod`
  - `faq_client_dev`, `faq_client_staging`, `faq_client_prod`
  - `detectivehq_dev`, `detectivehq_staging`, `detectivehq_prod`

## Technical Decisions

### Why Lowercase Usernames?
macOS user accounts are lowercase. The `clone-projects.sh` script uses `$(whoami)` which returns lowercase.

### Why Three Environment Copies?
Herd allows running multiple sites simultaneously. Having Dev/Staging/Prod copies allows:
- Testing on different branches
- Comparing environments side-by-side
- Safe production debugging

### Why Minimal .zshrc?
Keeps configuration simple and fast. Users can extend with `~/.zshrc.local` for machine-specific customizations.

### Why Separate Scripts?
- `setup-ssh.sh` - Can be run independently
- `clone-projects.sh` - Can be run independently
- `setup-mysql.sh` - Can be run independently
- Modular = easier to maintain and test

### Why Not Oh-My-Zsh by Default?
- Adds complexity
- Slower shell startup
- Most features unused
- Can be added optionally during install

## macOS Preferences Applied

### Finder
- Show all file extensions
- Show path bar and status bar
- List view by default
- Search current folder
- No .DS_Store on network/USB
- Show ~/Library folder

### Dock
- Auto-hide enabled
- No recent apps
- Custom app list (via dockutil)

### Keyboard/Trackpad
- Tap to click enabled
- Fast key repeat
- Auto-correct disabled

### Screenshots
- Save to Desktop
- PNG format

## Customization Points

### Adding New Users
Edit `scripts/clone-projects.sh`:
```bash
"newuser")
    clone_project "org/repo" "folder-name"
    ;;
```

### Adding Packages
Edit `Brewfile`:
```ruby
brew "package-name"
cask "app-name"
mas "App Name", id: 123456
```

### Modifying Dock
Edit `.macos` around line 77:
```bash
dockutil --add "/Applications/YourApp.app" --no-restart
```

### Adding Aliases
Edit `.zshrc` or create `~/.zshrc.local`:
```bash
alias myalias="command"
```

## Installation Flow

1. Clone repo with HTTPS (no SSH key yet)
2. Run `./install.sh`
3. Installer checks/installs Homebrew
4. Runs `brew bundle` to install all packages
5. Creates symlinks: `.zshrc`, `.gitconfig`, `.gitignore_global`
6. Sets zsh as default shell
7. Asks: Apply macOS preferences? (optional)
8. Asks: Generate SSH key? (optional)
9. Asks: Clone projects? (optional, user-specific)
10. Asks: Set up MySQL databases? (optional, user-specific)

## Common Issues & Solutions

### "Permission Denied" on Install
**Cause**: Scripts not executable
**Fix**: `chmod +x install.sh .macos scripts/*.sh`

### "homebrew/bundle deprecated"
**Cause**: Old tap in Brewfile
**Fix**: Remove `tap "homebrew/bundle"` (now built-in)

### "gh: command not found"
**Cause**: Shell hasn't reloaded PATH
**Fix**: `source ~/.zshrc` or restart terminal

### Projects Not Cloning
**Cause**: Username capitalization mismatch
**Fix**: Usernames must be lowercase in `clone-projects.sh`

### Homebrew Not Found (New User)
**Cause**: PATH not set
**Fix**: Run dotfiles installer for that user (sets PATH)

## Future Improvements

### Potential Additions
- [ ] Database seeding scripts per project
- [ ] IDE settings sync (VS Code settings)
- [ ] Git commit template
- [ ] Custom Laravel aliases/functions
- [ ] Automated composer global packages
- [ ] Node.js version management (nvm)
- [ ] PHP version management (phpbrew)
- [ ] Automated .env file templates
- [ ] Backup script for databases
- [ ] Project-specific post-clone setup

### Nice-to-Haves
- [ ] iTerm2 theme/profile
- [ ] VS Code extensions auto-install
- [ ] Mackup integration for app settings
- [ ] Automated GitHub CLI configuration
- [ ] Custom Herd PHP configurations

## Maintenance Notes

### Updating Dotfiles
```bash
cd ~/.dotfiles
git pull
./install.sh  # Re-run to update symlinks
```

### Adding New Repositories
1. Edit `scripts/clone-projects.sh`
2. Add `clone_project "org/repo" "name"`
3. Commit and push
4. On target machine: `git pull && ./scripts/clone-projects.sh`

### Testing Changes
- Test on fresh macOS install (VM or new account)
- Verify all scripts are executable before commit
- Check that usernames are lowercase
- Ensure paths work on both Intel and Apple Silicon

## Git Workflow

### Repository
- **URL**: https://github.com/nathaniel-m/dotfiles
- **Branch**: `main`
- **Access**: Public

### Making Changes
```bash
# Make changes
git add .
git commit -m "Description of changes"
git push

# On other machines
cd ~/.dotfiles
git pull
```

### Commit Message Style
- Concise, descriptive
- Examples:
  - "Add dockutil for Dock management"
  - "Fix usernames to lowercase for macOS compatibility"
  - "Update README with HTTPS clone instructions"

## Credits

Built with assistance from Claude Code.

**Key Technologies:**
- Homebrew - Package management
- Zsh - Shell
- GitHub CLI - Repository management
- Dockutil - Dock customization
- Laravel Herd - PHP development environment

## Support

For issues or questions:
- Check this document
- Review README.md
- Check GitHub issues
- Refer to individual script comments
