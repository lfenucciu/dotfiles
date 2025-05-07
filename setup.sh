#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting dotfiles setup...${NC}"

# Check if script is run from dotfiles directory
if [ ! -d "./hypr" ] && [ ! -d "./rofi" ]; then
  echo -e "${RED}Error: Script must be run from dotfiles directory${NC}"
  exit 1
fi

# Create backup directory
backup_dir=~/.config-backup-$(date +%Y%m%d-%H%M%S)
mkdir -p "$backup_dir"
echo -e "${YELLOW}Created backup directory: $backup_dir${NC}"

# Get all directories in current folder
configs=()
for d in */ ; do
  configs+=("${d%/}")
done

# Process each config
for config in "${configs[@]}"; do
  # Backup existing config
  if [ -d ~/.config/$config ] || [ -L ~/.config/$config ]; then
    echo -e "${YELLOW}Backing up ~/.config/$config${NC}"
    mv ~/.config/$config "$backup_dir/"
  fi
  
  # Create symlink
  echo -e "${GREEN}Creating symlink for $config${NC}"
  ln -sf "$PWD/$config" ~/.config/
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully created symlink for $config${NC}"
  else
    echo -e "${RED}Failed to create symlink for $config${NC}"
  fi
done

echo -e "${GREEN}Dotfiles setup complete!${NC}"
