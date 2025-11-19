#!/usr/bin/env bash

# Setup MySQL databases for user projects
# Creates databases for Development, Staging, and Production environments

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Setting up MySQL databases for user: $(whoami)${NC}\n"

# Check if MySQL is installed and running
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}Error: MySQL is not installed${NC}"
    echo "Install it with: brew install mysql"
    exit 1
fi

# Check if MySQL is running
if ! pgrep -x mysqld > /dev/null; then
    echo -e "${YELLOW}MySQL is not running. Starting MySQL...${NC}"
    brew services start mysql
    sleep 3
fi

# MySQL root password (empty by default on Homebrew install)
MYSQL_ROOT=""

# Function to create database if it doesn't exist
create_database() {
    local db_name=$1

    if mysql -uroot -p"${MYSQL_ROOT}" -e "USE $db_name" 2>/dev/null; then
        echo -e "${YELLOW}⊘${NC} Database '$db_name' already exists"
    else
        mysql -uroot -p"${MYSQL_ROOT}" -e "CREATE DATABASE $db_name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
        echo -e "${GREEN}✓${NC} Created database: $db_name"
    fi
}

# Function to create MySQL user if it doesn't exist
create_user() {
    local username=$1
    local password=$2

    if mysql -uroot -p"${MYSQL_ROOT}" -e "SELECT User FROM mysql.user WHERE User='$username';" | grep -q "$username"; then
        echo -e "${YELLOW}⊘${NC} User '$username' already exists"
    else
        mysql -uroot -p"${MYSQL_ROOT}" -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';"
        echo -e "${GREEN}✓${NC} Created user: $username"
    fi
}

# Function to grant privileges
grant_privileges() {
    local username=$1
    local db_pattern=$2

    mysql -uroot -p"${MYSQL_ROOT}" -e "GRANT ALL PRIVILEGES ON ${db_pattern}.* TO '$username'@'localhost';"
    mysql -uroot -p"${MYSQL_ROOT}" -e "FLUSH PRIVILEGES;"
    echo -e "${GREEN}✓${NC} Granted privileges to $username on $db_pattern"
}

# Create databases based on username
case $(whoami) in
    "fuze")
        echo -e "${BLUE}Setting up Fuze databases...${NC}\n"

        # Create user
        create_user "fuze" "fuze_password"

        # Create databases for each project and environment
        create_database "fuze_dev"
        create_database "fuze_staging"
        create_database "fuze_prod"

        create_database "fuze_post_purchase_dev"
        create_database "fuze_post_purchase_staging"
        create_database "fuze_post_purchase_prod"

        create_database "fullfuze_dev"
        create_database "fullfuze_staging"
        create_database "fullfuze_prod"

        # Grant privileges
        grant_privileges "fuze" "fuze_%"
        grant_privileges "fuze" "fullfuze_%"

        echo ""
        echo -e "${GREEN}✓ Fuze databases created!${NC}"
        echo -e "Username: ${BLUE}fuze${NC}"
        echo -e "Password: ${BLUE}fuze_password${NC}"
        echo ""
        echo "Databases:"
        echo "  - fuze_dev, fuze_staging, fuze_prod"
        echo "  - fuze_post_purchase_dev, fuze_post_purchase_staging, fuze_post_purchase_prod"
        echo "  - fullfuze_dev, fullfuze_staging, fullfuze_prod"
        ;;

    "rerank")
        echo -e "${BLUE}Setting up ReRank databases...${NC}\n"

        # Create user
        create_user "rerank" "rerank_password"

        # Create databases for each project and environment
        create_database "rerank_dev"
        create_database "rerank_staging"
        create_database "rerank_prod"

        create_database "rerankseo_dev"
        create_database "rerankseo_staging"
        create_database "rerankseo_prod"

        # Grant privileges
        grant_privileges "rerank" "rerank%"

        echo ""
        echo -e "${GREEN}✓ ReRank databases created!${NC}"
        echo -e "Username: ${BLUE}rerank${NC}"
        echo -e "Password: ${BLUE}rerank_password${NC}"
        echo ""
        echo "Databases:"
        echo "  - rerank_dev, rerank_staging, rerank_prod"
        echo "  - rerankseo_dev, rerankseo_staging, rerankseo_prod"
        ;;

    "rapidhover")
        echo -e "${BLUE}Setting up RapidHover databases...${NC}\n"

        create_user "rapidhover" "rapidhover_password"

        create_database "rapidhover_cdn_dev"
        create_database "rapidhover_cdn_staging"
        create_database "rapidhover_cdn_prod"

        create_database "rapidhover_backend_dev"
        create_database "rapidhover_backend_staging"
        create_database "rapidhover_backend_prod"

        create_database "rapidhover_com_dev"
        create_database "rapidhover_com_staging"
        create_database "rapidhover_com_prod"

        grant_privileges "rapidhover" "rapidhover%"

        echo ""
        echo -e "${GREEN}✓ RapidHover databases created!${NC}"
        echo -e "Username: ${BLUE}rapidhover${NC}"
        echo -e "Password: ${BLUE}rapidhover_password${NC}"
        ;;

    "detectivefaq")
        echo -e "${BLUE}Setting up DetectiveFAQ databases...${NC}\n"

        create_user "detectivefaq" "detective_password"

        create_database "faq_admin_dev"
        create_database "faq_admin_staging"
        create_database "faq_admin_prod"

        create_database "faq_backend_dev"
        create_database "faq_backend_staging"
        create_database "faq_backend_prod"

        create_database "faq_api_dev"
        create_database "faq_api_staging"
        create_database "faq_api_prod"

        create_database "faq_widget_dev"
        create_database "faq_widget_staging"
        create_database "faq_widget_prod"

        create_database "faq_client_dev"
        create_database "faq_client_staging"
        create_database "faq_client_prod"

        create_database "detectivehq_dev"
        create_database "detectivehq_staging"
        create_database "detectivehq_prod"

        grant_privileges "detectivefaq" "faq_%"
        grant_privileges "detectivefaq" "detectivehq%"

        echo ""
        echo -e "${GREEN}✓ DetectiveFAQ databases created!${NC}"
        echo -e "Username: ${BLUE}detectivefaq${NC}"
        echo -e "Password: ${BLUE}detective_password${NC}"
        ;;

    *)
        echo -e "${YELLOW}No MySQL configuration for user: $(whoami)${NC}"
        exit 0
        ;;
esac

echo ""
echo -e "${BLUE}Update your .env files with these credentials:${NC}"
echo "DB_CONNECTION=mysql"
echo "DB_HOST=127.0.0.1"
echo "DB_PORT=3306"
echo "DB_DATABASE=<database_name>"
echo "DB_USERNAME=<username>"
echo "DB_PASSWORD=<password>"
