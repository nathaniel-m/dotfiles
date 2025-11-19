#!/usr/bin/env bash

# Clone GitHub projects into Herd environments
# Each project is cloned into Development, Staging, and Production folders

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Cloning projects for user: $(whoami)${NC}\n"

# Herd directory structure
HERD_DIR="$HOME/Herd"
DEV_DIR="$HERD_DIR/Development"
STAGING_DIR="$HERD_DIR/Staging"
PROD_DIR="$HERD_DIR/Production"

# Create environment directories
mkdir -p "$DEV_DIR" "$STAGING_DIR" "$PROD_DIR"

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    echo "Install it with: brew install gh"
    echo "Then authenticate with: gh auth login"
    exit 1
fi

# Check if authenticated with GitHub
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}You need to authenticate with GitHub first${NC}"
    echo "Run: gh auth login"
    exit 1
fi

# Function to clone a repo into all three environments
clone_project() {
    local repo=$1
    local project_name=$2

    echo -e "${BLUE}━━━ $project_name ━━━${NC}"

    # Development
    if [ -d "$DEV_DIR/$project_name" ]; then
        echo -e "${YELLOW}⊘${NC} Development/$project_name (already exists)"
    else
        echo -e "${BLUE}↓${NC} Cloning into Development/$project_name..."
        gh repo clone "$repo" "$DEV_DIR/$project_name"
        echo -e "${GREEN}✓${NC} Development/$project_name"
    fi

    # Staging
    if [ -d "$STAGING_DIR/$project_name" ]; then
        echo -e "${YELLOW}⊘${NC} Staging/$project_name (already exists)"
    else
        echo -e "${BLUE}↓${NC} Cloning into Staging/$project_name..."
        gh repo clone "$repo" "$STAGING_DIR/$project_name"
        echo -e "${GREEN}✓${NC} Staging/$project_name"
    fi

    # Production
    if [ -d "$PROD_DIR/$project_name" ]; then
        echo -e "${YELLOW}⊘${NC} Production/$project_name (already exists)"
    else
        echo -e "${BLUE}↓${NC} Cloning into Production/$project_name..."
        gh repo clone "$repo" "$PROD_DIR/$project_name"
        echo -e "${GREEN}✓${NC} Production/$project_name"
    fi

    echo ""
}

# Clone projects based on username
case $(whoami) in
    "fuze")
        echo -e "${BLUE}Setting up Fuze projects in Herd...${NC}\n"

        clone_project "FuzeUpsell/fuze" "fuze"
        clone_project "FuzeUpsell/fuze-post-purchase" "fuze-post-purchase"
        clone_project "TrinityRiverSoftware/fullfuze.com" "fullfuze.com"
        ;;

    "rerank")
        echo -e "${BLUE}Setting up ReRank projects in Herd...${NC}\n"

        clone_project "RerankSEO/rerank" "rerank"
        clone_project "TrinityRiverSoftware/rerankseo.com" "rerankseo.com"
        ;;

    "rapidhover")
        echo -e "${BLUE}Setting up RapidHover projects in Herd...${NC}\n"

        clone_project "RapidHover/images-cdn" "images-cdn"
        clone_project "RapidHover/images-backend" "images-backend"
        clone_project "TrinityRiverSoftware/rapidhover.com" "rapidhover.com"
        ;;

    "detectivefaq")
        echo -e "${BLUE}Setting up DetectiveFAQ projects in Herd...${NC}\n"

        clone_project "DetectiveHQ/faq-admin" "faq-admin"
        clone_project "DetectiveHQ/faq-backend" "faq-backend"
        clone_project "DetectiveHQ/faq-api" "faq-api"
        clone_project "DetectiveHQ/faq-widget" "faq-widget"
        clone_project "DetectiveHQ/faq-client" "faq-client"
        clone_project "DetectiveHQ/detectivehq.com" "detectivehq.com"
        ;;

    *)
        echo -e "${YELLOW}No projects configured for user: $(whoami)${NC}"
        echo "Edit scripts/clone-projects.sh to add your repositories"
        exit 0
        ;;
esac

echo -e "${GREEN}✓ All projects cloned!${NC}\n"
echo -e "Project structure:"
echo -e "  ${BLUE}$HERD_DIR${NC}"
echo -e "  ├── Development/"
echo -e "  ├── Staging/"
echo -e "  └── Production/"
echo ""
echo -e "${YELLOW}Note:${NC} All environments use the default branch."
echo -e "You can switch branches manually in each folder as needed."
