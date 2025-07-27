#!/bin/bash 

# Terminal colors
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Welcome banner
echo -e "Welcome to ${GREEN}HyperShell v1.0${NC}"
echo "All rights reserved."
echo "Type 'help' to see available commands."
echo

# History array
history=()

while true; do
    echo -ne "${GREEN}HyperShell> ${NC}"
    read user_input

    # Add to history
    history+=("$user_input")

    # Help menu
    if [[ "$user_input" == "help" ]]; then
        echo -e "${GREEN}Available commands:${NC}"
        echo "  help      - Show this help message"
        echo "  clear     - Clear the screen"
        echo "  date      - Show current date and time"
        echo "  history   - Show command history"
        echo "  version   - Show shell version"
        echo "  exit      - Exit the shell"

    # Clear screen
    elif [[ "$user_input" == "clear" || "$user_input" == "cls" ]]; then
        clear

    # Show date
    elif [[ "$user_input" == "date" || "$user_input" == "--d" ]]; then
        echo -e "${CYAN}Current date and time: $(date)${NC}"

    # Show version
    elif [[ "$user_input" == "version" || "$user_input" == "--v" ]]; then
        echo -e "${CYAN}HyperShell v1.0${NC}"

    # Show history
    elif [[ "$user_input" == "history" || "$user_input" == "--h" ]]; then
        echo -e "${CYAN}Command History:${NC}"
        for i in "${!history[@]}"; do
            echo "$((i + 1)): ${history[i]}"
        done

    else
        eval "$user_input" 2>/tmp/hyper_shell_error
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Error:${NC} $(cat /tmp/hyper_shell_error)"
        fi
    fi
done 