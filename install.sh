#!/usr/bin/env bash

# Dotfiles Installation Script
# Sets up a new Mac with development tools and configurations

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}"
echo "════════════════════════════════════════"
echo "  Nathaniel's Dotfiles Installation"
echo "════════════════════════════════════════"
echo -e "${NC}"

# Helper functions
print_section() {
    echo -e "\n${BLUE}▸${NC} ${1}..."
}

print_success() {
    echo -e "${GREEN}✓${NC} ${1}"
}

print_warning() {
    echo -e "${YELLOW}!${NC} ${1}"
}

# Request sudo upfront
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Homebrew
###############################################################################

print_section "Checking Homebrew"

if ! command -v brew &> /dev/null; then
    print_warning "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"

    # Check if current user can write to Homebrew directories (multi-user support)
    BREW_PREFIX="$(brew --prefix)"
    if [ -d "$BREW_PREFIX" ] && [ ! -w "$BREW_PREFIX" ]; then
        print_warning "Fixing Homebrew permissions for user $(whoami)..."
        sudo chown -R $(whoami) "$BREW_PREFIX"
        print_success "Homebrew permissions fixed"
    fi
fi

###############################################################################
# Install Packages
###############################################################################

print_section "Installing packages from Brewfile"

if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    print_success "Packages installed"
else
    print_warning "Brewfile not found"
fi

###############################################################################
# Symlink Dotfiles
###############################################################################

print_section "Linking dotfiles"

# Backup existing files
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

link_file() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -d "$backup_dir" ]; then
            mkdir -p "$backup_dir"
        fi
        mv "$dest" "$backup_dir/"
    fi

    ln -sf "$src" "$dest"
    print_success "Linked $(basename $src)"
}

# Link each dotfile
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"

# Create .dotfiles symlink
ln -sf "$DOTFILES_DIR" "$HOME/.dotfiles"
print_success "Created ~/.dotfiles symlink"

###############################################################################
# Set Zsh as Default Shell
###############################################################################

print_section "Setting zsh as default shell"

if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    print_success "Default shell set to zsh"
else
    print_success "Zsh already default"
fi

###############################################################################
# macOS Settings
###############################################################################

print_section "Apply macOS settings"

echo ""
read -p "Apply macOS system preferences? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$DOTFILES_DIR/.macos" ]; then
        chmod +x "$DOTFILES_DIR/.macos"
        "$DOTFILES_DIR/.macos"
    else
        print_warning ".macos script not found"
    fi
else
    print_warning "Skipping macOS preferences"
fi

###############################################################################
# Create Project Directories
###############################################################################

print_section "Creating project directories"

#mkdir -p "$HOME/Projects"
#mkdir -p "$HOME/.config"

print_success "Directories created"

###############################################################################
# SSH Key Setup
###############################################################################

print_section "Set up SSH key for GitHub"

echo ""
read -p "Generate SSH key for GitHub? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$DOTFILES_DIR/scripts/setup-ssh.sh" ]; then
        chmod +x "$DOTFILES_DIR/scripts/setup-ssh.sh"
        "$DOTFILES_DIR/scripts/setup-ssh.sh"
    else
        print_warning "SSH setup script not found"
    fi
else
    print_warning "Skipping SSH key setup (you can run scripts/setup-ssh.sh later)"
fi

###############################################################################
# Clone GitHub Projects
###############################################################################

print_section "Clone GitHub projects for $(whoami)"

echo ""
read -p "Clone your GitHub projects? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$DOTFILES_DIR/scripts/clone-projects.sh" ]; then
        chmod +x "$DOTFILES_DIR/scripts/clone-projects.sh"
        "$DOTFILES_DIR/scripts/clone-projects.sh"
    else
        print_warning "Clone projects script not found"
    fi
else
    print_warning "Skipping project cloning (you can run scripts/clone-projects.sh later)"
fi

###############################################################################
# MySQL Database Setup
###############################################################################

print_section "Set up MySQL databases for $(whoami)"

echo ""
read -p "Create MySQL databases for your projects? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$DOTFILES_DIR/scripts/setup-mysql.sh" ]; then
        chmod +x "$DOTFILES_DIR/scripts/setup-mysql.sh"
        "$DOTFILES_DIR/scripts/setup-mysql.sh"
    else
        print_warning "MySQL setup script not found"
    fi
else
    print_warning "Skipping MySQL setup (you can run scripts/setup-mysql.sh later)"
fi

###############################################################################
# Done
###############################################################################

echo ""
echo -e "${GREEN}"
echo "════════════════════════════════════════"
echo "  ✓ Installation Complete!"
echo "════════════════════════════════════════"
echo -e "${NC}"

if [ -d "$backup_dir" ]; then
    echo "Old dotfiles backed up to: $backup_dir"
fi

echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Customize dotfiles in: $DOTFILES_DIR"
echo ""
