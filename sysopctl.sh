#!/bin/bash

# Define the command version
VERSION="v0.1.0"

# Function to display help
show_help() {
    cat << EOF
sysopctl - System Operations Control Tool

Usage:
  sysopctl [command] [options]

Commands:
  --help                     Show this help message
  --version                  Show the version of sysopctl

  service list               List all active services
  service start <name>        Start a system service
  service stop <name>         Stop a system service

  system load                Show system load averages
  disk usage                 Show disk usage by partition
  process monitor            Monitor system processes in real time
  logs analyze               Summarize critical log entries
  backup <path>              Backup system files to a specified location

EOF
}

# Function to show version information
show_version() {
    echo "sysopctl version $VERSION"
}

# Function to list running services
list_services() {
    echo "Listing active services:"
    systemctl list-units --type=service
}

# Function to start a service
start_service() {
    local service_name=$1
    if [ -z "$service_name" ]; then
        echo "Error: Service name is required"
        exit 1
    fi

    sudo systemctl start "$service_name" 2>&1
    if [ $? -eq 0 ]; then
        echo "Service '$service_name' started successfully."
    else
        echo "Failed to start service '$service_name'."
    fi
}

# Function to stop a service
stop_service() {
    local service_name=$1
    if [ -z "$service_name" ]; then
        echo "Error: Service name is required"
        exit 1
    fi

    sudo systemctl stop "$service_name" 2>&1
    if [ $? -eq 0 ]; then
        echo "Service '$service_name' stopped successfully."
    else
        echo "Failed to stop service '$service_name'."
    fi
}

# Function to show system load
show_system_load() {
    echo "System load averages:"
    uptime
}

# Function to show disk usage
show_disk_usage() {
    echo "Disk usage by partition:"
    df -h
}

# Function to monitor system processes
monitor_processes() {
    echo "Monitoring system processes:"
    top
}

# Function to analyze system logs
analyze_logs() {
    echo "Analyzing system logs:"
    sudo journalctl -p 3 -xb
}

# Function to backup system files
backup_files() {
    local backup_path=$1
    if [ -z "$backup_path" ]; then
        echo "Error: Backup path is required"
        exit 1
    fi
    echo "Starting backup to $backup_path..."
    rsync -avh --progress / "$backup_path"
    echo "Backup completed."
}

# Main command parsing
case "$1" in
    --help)
        show_help
        ;;
    --version)
        show_version
        ;;
    service)
        case "$2" in
            list)
                list_services
                ;;
            start)
                start_service "$3"
                ;;
            stop)
                stop_service "$3"
                ;;
            *)
                echo "Error: Unknown service command."
                show_help
                ;;
        esac
        ;;
    system)
        case "$2" in
            load)
                show_system_load
                ;;
            *)
                echo "Error: Unknown system command."
                show_help
                ;;
        esac
        ;;
    disk)
        case "$2" in
            usage)
                show_disk_usage
                ;;
            *)
                echo "Error: Unknown disk command."
                show_help
                ;;
        esac
        ;;
    process)
        case "$2" in
            monitor)
                monitor_processes
                ;;
            *)
                echo "Error: Unknown process command."
                show_help
                ;;
        esac
        ;;
    logs)
        case "$2" in
            analyze)
                analyze_logs
                ;;
            *)
                echo "Error: Unknown logs command."
                show_help
                ;;
        esac
        ;;
    backup)
        backup_files "$2"
        ;;
    *)
        echo "Error: Unknown command."
        show_help
        ;;
esac
