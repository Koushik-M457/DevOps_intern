
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (e.g. sudo ./disk_manager.sh)"
  exit 1
fi


echo " Simple Disk Management Tool"
echo ""
echo "Please choose an option:"
echo "1) List disks and partitions"
echo "2) Show free space on disks"
echo "3) Create a new partition"
echo "4) Resize a partition"
echo "5) Delete a partition"
echo "6) Exit"
echo ""

read -p "Enter your choice [1-6]: " choice

case $choice in

    1)
        echo ""
        echo "Listing disks and partitions..."
        lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
        ;;

    2)
        echo ""
        echo "Showing free space on disks..."
        df -h
        ;;

    3)
        echo ""
        echo "Creating a new partition..."
        echo "Available disks:"
        lsblk -d -o NAME,SIZE,MODEL
        read -p "Enter the disk device name : " diskname
        disk="/dev/$diskname"

        if [ ! -b "$disk" ]; then
          echo "Error: $disk does not exist!"
          exit 1
        fi

        read -p "Enter partition size (M or G): " size

        echo "Creating partition on $disk with size $size..."

        
        parted -s $disk mkpart primary ext4 0% $size

        echo "Partition created. Run lsblk to check."
        ;;

    4)
        echo ""
        echo "Resizing a partition..."
        lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
        read -p "Enter the partition device name : " partname
        part="/dev/$partname"

        if [ ! -b "$part" ]; then
          echo "Error: $part does not exist!"
          exit 1
        fi

        read -p "Enter new end size (G or M): " newsize

        
        partnum=$(echo $partname | grep -o '[0-9]*$')

        disk="/dev/$(echo $partname | sed 's/[0-9]*$//')"

        parted -s $disk resizepart $partnum $newsize

        echo "Partition resized. Run lsblk to check."
        ;;

    5)
        echo ""
        echo "Deleting a partition..."
        echo "Available disks:"
        lsblk -d -o NAME,SIZE,MODEL
        read -p "Enter the disk device name (e.g. sdb): " diskname
        disk="/dev/$diskname"

        if [ ! -b "$disk" ]; then
          echo "Error: $disk does not exist!"
          exit 1
        fi

        parted -s $disk print

        read -p "Enter the partition number to delete (e.g. 1): " partnum

        parted -s $disk rm $partnum

        echo "Partition deleted. Run lsblk to check."
        ;;

    6)
        echo "Thank you  see you again!"
        exit 0
        ;;

    *)
        echo "Invalid choice."
        ;;
esac

