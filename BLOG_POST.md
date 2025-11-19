# Building Custom macOS Dotfiles: From Zero to Automated Development Environment

*A journey through creating personalized dotfiles for multi-user Laravel development on macOS*

## The Problem

Setting up a new Mac is tedious. Installing apps, configuring settings, setting up databases, cloning repositories - it's hours of repetitive work. And when you have multiple macOS user accounts on the same machine, each needing different projects? That's a recipe for human error.

I needed a solution that could:
- Set up a fresh Mac in minutes, not hours
- Support multiple user accounts with different project repositories
- Handle Laravel development with Herd's multi-environment setup
- Be maintainable and well-documented for future updates

## The Solution: Smart Dotfiles

Dotfiles are configuration files (usually starting with a dot, like `.bashrc` or `.gitconfig`) that customize your development environment. But we took it further - building an intelligent system that adapts to each user.

## What We Built

### 1. **The Foundation: Core Dotfiles**

Started with the essentials:
- **`.zshrc`** - Minimal shell configuration with useful aliases
- **`.gitconfig`** - Pre-configured with my name and email, plus helpful git aliases
- **`.gitignore_global`** - Never commit `.DS_Store` files again
- **`Brewfile`** - Package manager definitions for all tools

```bash
# Simple, clean aliases
alias ll="ls -lah"
alias gs="git status"
alias reload="source ~/.zshrc"
```

### 2. **Automated Installation Script**

The `install.sh` script orchestrates everything:

```bash
git clone https://github.com/nathaniel-m/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

That's it. One command to:
- Install Homebrew (if needed)
- Install all packages: PHP, Node.js, MySQL, Redis, Herd, VS Code, etc.
- Create symlinks for dotfiles
- Set zsh as default shell
- Configure macOS system preferences
- Generate SSH keys for GitHub
- Clone project repositories
- Set up MySQL databases

### 3. **Multi-User Support**

Here's where it gets interesting. I have four different user accounts on my Mac:
- `fuze` - Fuze projects
- `rerank` - ReRank projects
- `rapidhover` - RapidHover projects
- `detectivefaq` - DetectiveFAQ projects

Each user needs different GitHub repositories. The solution? User detection:

```bash
case $(whoami) in
    "fuze")
        clone_project "FuzeUpsell/fuze" "fuze"
        clone_project "FuzeUpsell/fuze-post-purchase" "fuze-post-purchase"
        ;;
    "rerank")
        clone_project "RerankSEO/rerank" "rerank"
        ;;
    # ... and so on
esac
```

### 4. **Herd Multi-Environment Setup**

Laravel Herd is fantastic for local development, but we took it further. Each project gets cloned **three times**:

```
~/Herd/
├── Development/
│   ├── fuze/
│   ├── fuze-post-purchase/
│   └── fullfuze.com/
├── Staging/
│   ├── fuze/
│   ├── fuze-post-purchase/
│   └── fullfuze.com/
└── Production/
    ├── fuze/
    ├── fuze-post-purchase/
    └── fullfuze.com/
```

Why? Because sometimes you need to:
- Test a bug on production branch while developing a fix
- Compare staging and production side-by-side
- Run multiple versions simultaneously

### 5. **Automated MySQL Database Setup**

Every project needs databases. The `setup-mysql.sh` script creates:
- Database for each project and environment
- MySQL users with appropriate permissions
- Ready-to-use credentials

For the Fuze user:
```bash
# Databases created:
fuze_dev, fuze_staging, fuze_prod
fuze_post_purchase_dev, fuze_post_purchase_staging, fuze_post_purchase_prod
fullfuze_dev, fullfuze_staging, fullfuze_prod

# Credentials ready to paste into .env:
DB_USERNAME=fuze
DB_PASSWORD=fuze_password
```

### 6. **SSH Key Automation**

No more Googling "how to generate SSH key":

```bash
./scripts/setup-ssh.sh
```

It:
1. Generates an ed25519 SSH key
2. Adds it to macOS keychain (no more passphrase prompts)
3. Copies public key to clipboard
4. Tells you exactly what to do next (paste into GitHub)

### 7. **Dock Perfection**

Using `dockutil`, we automatically configure the Dock:

```bash
# Remove ALL default apps
dockutil --remove all

# Add only what we want
dockutil --add "/Applications/Google Chrome.app"
dockutil --add "/Applications/Visual Studio Code.app"
dockutil --add "/Applications/Notion.app"
```

Clean. Minimal. Perfect.

### 8. **macOS System Preferences**

The `.macos` script applies sensible defaults:
- Show file extensions in Finder
- Fast keyboard repeat rate
- Tap to click on trackpad
- Disable auto-correct (because we're writing code)
- Hide Dock automatically
- Screenshot settings

```bash
# Fast keyboard repeat (essential for vim users)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```

## The Challenges We Solved

### Challenge 1: Username Case Sensitivity
**Problem**: macOS usernames are lowercase, but we initially used capitalized names in the script.
**Solution**: Changed all case statements to lowercase: `"Fuze"` → `"fuze"`

### Challenge 2: Script Permissions
**Problem**: "Permission denied" errors when running scripts.
**Solution**: `chmod +x` all scripts and commit the executable permissions to git.

### Challenge 3: Deprecated Homebrew Tap
**Problem**: `homebrew/bundle` tap is deprecated.
**Solution**: Removed it - bundle functionality is now built into Homebrew.

### Challenge 4: Fresh Install Chicken-and-Egg
**Problem**: Need SSH key to clone repos, but SSH key is generated during install.
**Solution**: Clone with HTTPS first, then generate SSH key during installation.

## The Technology Stack

**Tools Used:**
- **Homebrew** - macOS package manager
- **GitHub CLI (`gh`)** - Repository management and authentication
- **Dockutil** - Dock customization
- **Laravel Herd** - PHP development environment
- **MySQL** - Database
- **Zsh** - Modern shell

**Languages:**
- PHP/Laravel
- Node.js
- Bash scripting

## Key Design Decisions

### 1. **Minimal Over Maximal**
We resisted adding Oh-My-Zsh and kept `.zshrc` simple. Why?
- Faster shell startup
- Easier to understand and modify
- Can always add more later

### 2. **Modular Scripts**
Three separate scripts instead of one monolith:
- `setup-ssh.sh` - Run independently anytime
- `clone-projects.sh` - Run independently anytime
- `setup-mysql.sh` - Run independently anytime

### 3. **Documentation First**
Created two documentation files:
- `README.md` - User-facing instructions
- `DEVELOPMENT.md` - Developer notes for future updates

### 4. **Smart Defaults, Easy Overrides**
Everything has sensible defaults, but users can:
- Create `~/.zshrc.local` for custom aliases
- Skip any optional step during install
- Run individual scripts later

## The Results

**Before dotfiles:**
- 2-3 hours to set up a new Mac
- Inconsistent configurations across machines
- Forgotten steps and missing tools
- Manual database creation for every project

**After dotfiles:**
- 15-20 minutes automated setup (mostly waiting for downloads)
- Identical configuration across all machines
- Nothing forgotten - it's all in the script
- All databases created automatically

## Real-World Usage

Setting up a new Mac user is now:

```bash
# 1. Clone the repo
git clone https://github.com/nathaniel-m/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Run installer
./install.sh

# Answer a few prompts:
# - Apply macOS preferences? y
# - Generate SSH key? y
# - Clone projects? y
# - Set up MySQL? y

# 3. Done!
```

15 minutes later, you have:
- ✅ All development tools installed
- ✅ All projects cloned (Dev/Staging/Prod)
- ✅ All databases created
- ✅ SSH keys configured
- ✅ Dock customized
- ✅ macOS preferences applied

## Lessons Learned

### 1. **Test on a Fresh Install**
We hit several issues that only appeared on fresh macOS installs. Lesson: Test in a clean environment (new user account or VM).

### 2. **Document As You Go**
Writing `DEVELOPMENT.md` at the end was challenging. Better to document decisions as you make them.

### 3. **Executable Permissions Matter**
Git tracks executable permissions. Always `chmod +x` your scripts before committing.

### 4. **User Feedback is Gold**
Running the installer on actual machines revealed:
- Case sensitivity issues
- PATH problems
- Missing dependencies

### 5. **Keep It Simple**
We almost added complex branch management (dev/staging/prod branches). Instead, we clone the default branch three times. Simple works.

## Code Highlights

### Smart Project Cloning

```bash
clone_project() {
    local repo=$1
    local project_name=$2

    # Clone to all three environments
    for env in Development Staging Production; do
        if [ -d "$HERD_DIR/$env/$project_name" ]; then
            echo "⊘ $env/$project_name (already exists)"
        else
            echo "↓ Cloning into $env/$project_name..."
            gh repo clone "$repo" "$HERD_DIR/$env/$project_name"
            echo "✓ $env/$project_name"
        fi
    done
}
```

### MySQL Database Creation

```bash
create_database() {
    local db_name=$1

    if mysql -uroot -e "USE $db_name" 2>/dev/null; then
        echo "⊘ Database '$db_name' already exists"
    else
        mysql -uroot -e "CREATE DATABASE $db_name
            CHARACTER SET utf8mb4
            COLLATE utf8mb4_unicode_ci;"
        echo "✓ Created database: $db_name"
    fi
}
```

### SSH Key with Clipboard Copy

```bash
# Generate key
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519

# Add to keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copy to clipboard
pbcopy < ~/.ssh/id_ed25519.pub

echo "✓ Public key copied to clipboard!"
echo "Paste it into GitHub → Settings → SSH Keys"
```

## Future Enhancements

Ideas we discussed but haven't implemented yet:

1. **Database Seeding**
   - Auto-seed databases after creation
   - Different seeds per environment

2. **VS Code Settings Sync**
   - Extensions auto-install
   - Settings and keybindings sync

3. **Environment File Templates**
   - Pre-configured `.env` files
   - Database credentials auto-filled

4. **Backup Scripts**
   - Database backup automation
   - Dotfiles backup to GitHub

5. **PHP Version Management**
   - Multiple PHP versions via Herd
   - Project-specific PHP versions

## The Impact

This project transformed my development workflow. But more importantly, it's a **living system**. As needs change, the dotfiles evolve:

```bash
cd ~/.dotfiles
# Make changes
git commit -m "Add new tool"
git push

# On other machines
git pull
./install.sh  # Re-run to apply updates
```

## Try It Yourself

The dotfiles are open source and well-documented:

**Repository**: https://github.com/nathaniel-m/dotfiles

**Quick Start**:
```bash
git clone https://github.com/nathaniel-m/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

**Customize It**:
1. Fork the repository
2. Edit `Brewfile` with your tools
3. Update `scripts/clone-projects.sh` with your repos
4. Modify `.zshrc` with your aliases
5. Commit and push
6. Use on all your machines!

## Key Takeaways

1. **Automate Everything** - If you do it more than once, automate it
2. **Document Thoroughly** - Future you will thank present you
3. **Test in Reality** - Clean installs reveal issues development doesn't
4. **Keep It Modular** - Small, focused scripts beat monolithic ones
5. **Make It Yours** - Dotfiles should reflect YOUR workflow

## Conclusion

Building these dotfiles was more than just automating setup - it was about **understanding** my development workflow well enough to codify it. Every script, every alias, every configuration represents a decision about how I work.

The result? A system that:
- Saves hours on every new setup
- Ensures consistency across machines
- Documents my entire development environment
- Evolves with my needs

If you're still setting up Macs manually, you're doing it the hard way. Build your dotfiles. Future you will thank you.

---

## About the Build

**Built with**: Claude Code
**Time invested**: ~4 hours of conversation and refinement
**Lines of code**: ~1,500
**Time saved per setup**: ~2.5 hours
**Break-even point**: After 2 setups (already there!)

**The Best Part**: This entire system was built through conversation with an AI coding assistant. No switching between documentation, Stack Overflow, and trial-and-error. Just describe what you need, refine as you go, and end up with production-ready code.

That's the future of development.

---

*Want to see the full conversation that built this? Check out the commit history: https://github.com/nathaniel-m/dotfiles/commits/main*

*Questions or suggestions? Open an issue on GitHub!*
