#!/bin/bash

# Function to display the current MAC and IP addresses
show_current_info() {
    echo "Current MAC Address: $(ifconfig | grep -o -E '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}' | head -n 1)"
    echo "Current IP Address: $(hostname -I | awk '{print $1}')"
}

# Function to generate a random MAC address
generate_random_mac() {
    # Use the first three octets of the OUI (Organizationally Unique Identifier) for a random MAC
    random_mac="00:16:3e"
    
    # Generate the last three octets randomly
    for i in {1..3}; do
        random_mac+=":$(openssl rand -hex 1 | tr '[:lower:]' '[:upper:]')"
    done
    
    echo "$random_mac"
}

# Function to change the MAC address
change_mac() {
    interface="eth0"  # Change this to your network interface (e.g., wlan0 for Wi-Fi)

    # Show the current MAC address
    show_current_info

    # Generate a random MAC address
    new_mac=$(generate_random_mac)

    # Disable the network interface
    sudo ifconfig $interface down

    # Change the MAC address
    sudo ifconfig $interface hw ether $new_mac

    # Enable the network interface
    sudo ifconfig $interface up

    echo "Changed MAC Address to: $new_mac"
}

# Function to change the IP address
change_ip() {
    interface="eth0"  # Change this to your network interface (e.g., wlan0 for Wi-Fi)

    # Show the current IP address
    show_current_info

    # Prompt the user for the new IP address
    read -p "Enter the new IP Address: " new_ip

    # Change the IP address
    sudo ifconfig $interface $new_ip

    echo "Changed IP Address to: $new_ip"
}

# Main function
main() {
    clear
    echo "=== MAC and IP Changer Tool By Akash Motkar ==="
    echo "1. Change MAC Address"
    echo "2. Change IP Address"
    echo "3. Change Both MAC and IP Address"
    echo "4. Exit"
    echo "==============================="

    read -p "Enter your choice (1-4): " choice

    case $choice in
        1) change_mac ;;
        2) change_ip ;;
        3) change_mac && change_ip ;;
        4) echo "Exiting. Goodbye!"; exit ;;
        *) echo "Invalid choice. Please enter a number between 1 and 4."
    esac

    read -p "Press Enter to continue..."
}

main
