

manage_process() {
    read -p "Enter the process name: " process_name

    
    pgrep "$process_name" > /dev/null
    if [ $? -ne 0 ]; then
        echo "No such process: $process_name"
        return 1
    fi

    echo "Choose an option:"
    echo "1) View process and subprocesses"
    echo "2) Kill the process and its subprocesses"
    read -p "Enter 1 or 2: " choice

    case $choice in
        1)
            # Show process tree
            pid=$(pgrep -o "$process_name")  # Get the oldest matching PID
            echo "Process tree for $process_name (PID: $pid):"
            pstree -p $pid
            ;;
        2)
            echo "Killing $process_name and its subprocesses..."
            pkill -TERM -P $(pgrep -o "$process_name") 2>/dev/null
            pkill "$process_name"
            echo "Process killed."
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}


