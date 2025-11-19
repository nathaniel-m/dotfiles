# Nathaniel's Dotfiles

Personal dotfiles for setting up a new Mac for PHP/Laravel and Node.js development.

## What's Included

### Configuration Files
- `.zshrc` - Minimal zsh configuration with useful aliases
- `.gitconfig` - Git configuration with helpful aliases
- `.gitignore_global` - Global gitignore patterns
- `.macos` - macOS system preferences

### Installation Scripts
- `install.sh` - Main installation script
- `Brewfile` - Package and application definitions

## Quick Start

### Fresh Mac Setup (No SSH Key Yet)

```bash
# Clone using HTTPS (no SSH key needed)
git clone https://github.com/nathaniel-m/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installer
./install.sh
```

During installation, say **yes** when asked to generate an SSH key. The script will:
- Generate your SSH key
- Copy it to your clipboard
- Give you instructions to paste it into GitHub

After that, you'll be set up with SSH for all future git operations!

### What the Installer Does

1. Install Homebrew (if needed)
2. Install packages from Brewfile
3. Create symlinks for dotfiles
4. Set zsh as default shell
5. Optionally apply macOS preferences
6. Optionally generate SSH key for GitHub
7. Optionally clone your projects into Herd environments
8. Optionally set up MySQL databases for your projects

### What Gets Installed

**Development Tools:**
- PHP & Composer (for Laravel)
- Node.js & Yarn
- Git
- Visual Studio Code
- TablePlus (database GUI)
- Postman (API testing)

**Browsers:**
- Google Chrome
- Firefox

**Utilities:**
- Rectangle (window management)
- fzf (fuzzy finder)
- ripgrep (fast search)

## Customization

### Adding More Packages

Edit `Brewfile` and run:
```bash
brew bundle --file=~/.dotfiles/Brewfile
```

### Personalizing Aliases

Edit `~/.zshrc` or create `~/.zshrc.local` for local-only customizations:
```bash
# Example ~/.zshrc.local
alias myproject="cd ~/Projects/myproject"
```

### Updating macOS Settings

Edit `.macos` and run:
```bash
~/.dotfiles/.macos
```

### Installing Mac App Store Apps

The Brewfile includes `mas` (Mac App Store CLI). To find and install apps:

```bash
# Search for an app
mas search "1Password"

# Install by ID
mas install 1333542190

# List installed apps
mas list

# Upgrade all apps
mas upgrade
```

Uncomment the apps you want in the `Brewfile` under the "Mac App Store Apps" section, then run `brew bundle`.

## Useful Aliases

```bash
# Navigation
..          # cd ..
...         # cd ../..

# List files
ll          # ls -lah
la          # ls -A

# Git shortcuts
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gl          # git log --oneline --graph

# Utilities
reload      # source ~/.zshrc
brewup      # Update Homebrew and packages
```

## Git Configuration

Your git is configured with:
- Name: Nathaniel Magaw
- Email: nathanielssoftware@gmail.com

To change this, edit `~/.gitconfig` or run:
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

## SSH Key Setup

Generate an SSH key for GitHub (if you skipped it during installation):

```bash
~/.dotfiles/scripts/setup-ssh.sh
```

This will:
1. Generate an ed25519 SSH key
2. Add it to your SSH agent
3. Configure it to use macOS keychain
4. Copy the public key to your clipboard

Then just paste it into GitHub Settings → SSH Keys: https://github.com/settings/keys

## Cloning Your Projects (Herd Setup)

The dotfiles include a user-specific project cloning script that sets up your Laravel Herd environment. Each project is cloned **three times** into separate environment folders:

```
~/Herd/
├── Development/  (develop branch)
├── Staging/      (staging branch)
└── Production/   (main branch)
```

**Setup:**
```bash
# Edit the script
vim ~/.dotfiles/scripts/clone-projects.sh

# Add your repos like this:
clone_project "your-org/your-repo" "project-name" "develop" "staging" "main"

# Or use defaults (develop, staging, main):
clone_project "your-org/your-repo" "project-name"

# Then run it
~/.dotfiles/scripts/clone-projects.sh
```

**How it works:**
- Detects which user is running it (Fuze, ReRank, RapidHover, or DetectiveFAQ)
- Creates Development, Staging, and Production folders in ~/Herd
- Clones each project 3 times with the appropriate branch
- Skips projects that already exist

**Prerequisites:**
- Authenticate with GitHub CLI: `gh auth login`
- Herd will create the ~/Herd directory when installed

## MySQL Database Setup

Automatically create MySQL databases for each project and environment:

```bash
# Run during installation (it will ask)
./install.sh

# Or run manually anytime
./scripts/setup-mysql.sh
```

**What it creates:**
- Database for each project (e.g., `fuze_dev`, `fuze_staging`, `fuze_prod`)
- MySQL user with appropriate permissions
- Ready-to-use credentials for your `.env` files

**Example credentials (Fuze user):**
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=fuze_dev
DB_USERNAME=fuze
DB_PASSWORD=fuze_password
```

## Directory Structure

```
~/.dotfiles/
├── .gitconfig
├── .gitignore_global
├── .macos
├── .zshrc
├── Brewfile
├── install.sh
├── README.md
├── DEVELOPMENT.md          # Developer documentation
├── bin/                    # Custom scripts (add to PATH)
└── scripts/
    ├── setup-ssh.sh        # SSH key generator for GitHub
    ├── clone-projects.sh   # Clone repos based on username
    └── setup-mysql.sh      # MySQL database setup
```

## Keeping Your Dotfiles Updated

```bash
cd ~/.dotfiles
git pull
./install.sh  # Re-run installer to update symlinks
```

## Backing Up to GitHub

```bash
cd ~/.dotfiles
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git
git push -u origin main
```

## Tips

- Add custom scripts to `bin/` directory (automatically in PATH)
- Use `.zshrc.local` for machine-specific settings
- Run `brewup` regularly to keep packages updated
- Commit and push changes to keep dotfiles synced across machines

## Resources

- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [Laravel Documentation](https://laravel.com/docs)
- [Homebrew Documentation](https://docs.brew.sh)
