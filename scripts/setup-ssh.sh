#!/usr/bin/env bash

# SSH Key Setup for GitHub
# Generates a new SSH key and configures it for use with GitHub

set -e

echo "Setting up SSH key for GitHub..."
echo ""

# Use the email from the first argument, or default to the git email
EMAIL="${1:-nathanielssoftware@gmail.com}"

echo "Generating SSH key with email: $EMAIL"
echo ""

# Check if SSH key already exists
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "⚠️  SSH key already exists at ~/.ssh/id_ed25519"
    read -p "Do you want to overwrite it? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping SSH key generation."
        exit 0
    fi
fi

# Generate new SSH key
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519

echo ""
echo "✓ SSH key generated"

# Start the ssh-agent
echo ""
echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"

# Create SSH config if it doesn't exist
mkdir -p ~/.ssh
touch ~/.ssh/config

# Add SSH config for macOS keychain
if ! grep -q "Host \*" ~/.ssh/config; then
    echo ""
    echo "Configuring SSH agent..."
    cat >> ~/.ssh/config << EOF

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
    echo "✓ SSH config updated"
else
    echo "✓ SSH config already exists"
fi

# Add SSH key to the ssh-agent and store passphrase in keychain
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copy public key to clipboard
pbcopy < ~/.ssh/id_ed25519.pub

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✓ SSH Key Setup Complete!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Your public SSH key has been copied to your clipboard."
echo ""
echo "Next steps:"
echo "  1. Go to GitHub → Settings → SSH and GPG keys"
echo "  2. Click 'New SSH key'"
echo "  3. Paste your key (Cmd+V) and give it a title"
echo "  4. Click 'Add SSH key'"
echo ""
echo "GitHub SSH Settings: https://github.com/settings/keys"
echo ""
echo "To manually copy your key again, run:"
echo "  pbcopy < ~/.ssh/id_ed25519.pub"
echo ""
