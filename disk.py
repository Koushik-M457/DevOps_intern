import subprocess
import sys

def run_command(command):
    

    try:
        result = subprocess.run(command, check=True, text=True, capture_output=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error: {e.stderr}")
        sys.exit(1)

def list_disks():
    print("\nListing disks and partitions...\n")
    run_command(["lsblk", "-o", "NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT"])

def show_free_space():
    print("\nShowing free space on disks...\n")
    run_command(["df", "-h"])

def create_partition():
    print("\nCreating a new partition...\n")
    run_command(["lsblk", "-d", "-o", "NAME,SIZE,MODEL"])

    diskname = input("Enter the disk device name (e.g. sdb): ").strip()
    disk = f"/dev/{diskname}"

    
    if not subprocess.call(["test", "-b", disk]) == 0:
        print(f"Error: {disk} does not exist!")
        sys.exit(1)

    size = input("Enter partition size (e.g. 1G): ").strip()

    print(f"Creating partition on {disk} with size {size}...")
    run_command(["parted", "-s", disk, "mkpart", "primary", "ext4", "0%", size])

    print("Partition created. Run lsblk to check.")

def resize_partition():
    print("\nResizing a partition...\n")
    run_command(["lsblk", "-o", "NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT"])

    partname = input("Enter the partition device name (e.g. sdb1): ").strip()
    part = f"/dev/{partname}"

    
    if not subprocess.call(["test", "-b", part]) == 0:
        print(f"Error: {part} does not exist!")
        sys.exit(1)

    newsize = input("Enter new end size (e.g. 2G): ").strip()

    
    partnum = ''.join(filter(str.isdigit, partname))
    diskname = partname.rstrip(partnum)
    disk = f"/dev/{diskname}"

    run_command(["parted", "-s", disk, "resizepart", partnum, newsize])

    print("Partition resized. Run lsblk to check.")

def delete_partition():
    print("\nDeleting a partition...\n")
    run_command(["lsblk", "-d", "-o", "NAME,SIZE,MODEL"])

    diskname = input("Enter the disk device name (e.g. sdb): ").strip()
    disk = f"/dev/{diskname}"

    if not subprocess.call(["test", "-b", disk]) == 0:
        print(f"Error: {disk} does not exist!")
        sys.exit(1)

    print("\nPartitions on this disk:")
    run_command(["parted", "-s", disk, "print"])

    partnum = input("Enter the partition number to delete (e.g. 1): ").strip()

    run_command(["parted", "-s", disk, "rm", partnum])

    print("Partition deleted. Run lsblk to check.")

def main():
    if not (subprocess.getoutput("whoami") == "root"):
        print("Please run this script as root (e.g. sudo python3 disk_manager.py)")
        sys.exit(1)

    while True:
        
        print(" Simple Disk Management Tool")
    
        print("Please choose an option:")
        print("1) List disks and partitions")
        print("2) Show free space on disks")
        print("3) Create a new partition")
        print("4) Resize a partition")
        print("5) Delete a partition")
        print("6) Exit\n")

        choice = input("Enter your choice [1-6]: ").strip()

        if choice == "1":
            list_disks()
        elif choice == "2":
            show_free_space()
        elif choice == "3":
            create_partition()
        elif choice == "4":
            resize_partition()
        elif choice == "5":
            delete_partition()
        elif choice == "6":
            print("see you again!")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()

