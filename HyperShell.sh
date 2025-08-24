#!/bin/bash  

# Terminal colors
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color


# History array
declare -a history
declare -A aliases

# Default prompt
PROMPT="HyperShell"

# Welcome banner
echo -e "Welcome to ${GREEN}HyperShell v1.0${NC}"
echo "All rights reserved."
echo "Type 'help' or '--h' to see available commands."
echo

while true; do
    echo -ne "${GREEN}HyperShell> ${NC}"
    read -ra args
    user_input="${args[*]}"
    cmd="${args[0]}"

    # Skip empty input
    [[ -z "$cmd" ]] && continue

    # Add to history
    history+=("$user_input")
    echo "$user_input" >> ~/.hypershell_history

    # Aliases
    [[ ${aliases[$cmd]} ]] && user_input="${aliases[$cmd]}" && eval "$user_input" && continue

    if [[ "$cmd" == "help" ]]; then
        echo -e "${GREEN}Available commands:${NC}"
        echo "  help             - Show this help message"
        echo "  clear / cls      - Clear the screen"
        echo "  cd <dir>         - Change directory"
        echo "  pwd              - Show current directory"
        echo "  date / --d       - Show current date and time"
        echo "  version / --v    - Show shell version"
        echo "  history / --h    - Show command history"
        echo "  alias name='cmd' - Create a command alias"
        echo "  setprompt <txt>  - Change prompt text"
        echo "  banner <text>    - Show ASCII banner (requires figlet)"
        echo "  weather          - Show weather info (requires curl)"
        echo "  exit             - Exit the shell"

    elif [[ "$cmd" == "clear" || "$cmd" == "cls" ]]; then
        clear

    elif [[ "$cmd" == "cd" ]]; then
        if [[ -n "${args[1]}" ]]; then
            cd "${args[1]}" 2>/tmp/hyper_shell_error || echo -e "${RED}Error:${NC} $(cat /tmp/hyper_shell_error)"
        else
            echo -e "${RED}Error:${NC} No directory specified."
        fi

    elif [[ "$cmd" == "pwd" ]]; then
        echo "$(pwd)"

    elif [[ "$cmd" == "date" || "$cmd" == "--d" ]]; then
        echo -e "${CYAN}Current date and time: $(date)${NC}"

    elif [[ "$cmd" == "version" || "$cmd" == "--v" ]]; then
        echo -e "${CYAN}HyperShell v1.0${NC}"

    elif [[ "$cmd" == "history" || "$cmd" == "--h" ]]; then
        echo -e "${CYAN}Command History:${NC}"
        for i in "${!history[@]}"; do
            echo "$((i + 1)): ${history[i]}"
        done

    elif [[ "$cmd" == "alias" ]]; then
        # Example: alias ll='ls -l'
        alias_def=$(echo "$user_input" | cut -d' ' -f2-)
        name=$(echo "$alias_def" | cut -d'=' -f1)
        value=$(echo "$alias_def" | cut -d'=' -f2- | sed "s/^['\"]//;s/['\"]$//")
        aliases["$name"]="$value"
        echo "Alias '$name' created."

    elif [[ "$cmd" == "setprompt" ]]; then
        if [[ -n "${args[1]}" ]]; then
            PROMPT="${args[1]}"
        else
            echo -e "${RED}Error:${NC} No prompt text provided."
        fi

    elif [[ "$cmd" == "banner" ]]; then
        if command -v figlet >/dev/null 2>&1; then
            figlet "${args[1]}"
        else
            echo -e "${RED}Error:${NC} 'figlet' not installed. Run: sudo apt install figlet"
        fi

    elif [[ "$cmd" == "weather" ]]; then
        if command -v curl >/dev/null 2>&1; then
            curl -s wttr.in
        else
            echo -e "${RED}Error:${NC} 'curl' not installed. Run: sudo apt install curl"
        fi

    elif [[ "$cmd" == "exit" ]]; then
        echo -e "${CYAN}Exiting HyperShell. Bye!${NC}"
        exit 0

    # === Background Job Support ===
    else
        if [[ "$user_input" == *"&" ]]; then
            eval "${user_input%&}" &
        else
            eval "$user_input" 2>/tmp/hyper_shell_error
            if [[ $? -ne 0 ]]; then
                echo -e "${RED}Error:${NC} $(cat /tmp/hyper_shell_error)"
            fi
        fi
    fi
done 