
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 inputfile.csv /path/to/download/folder"
    exit 1
fi

INPUT_FILE="$1"
DOWNLOAD_DIR="$2"


if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' does not exist."
    exit 2
fi


mkdir -p "$DOWNLOAD_DIR"


tail -n +2 "$INPUT_FILE" | while IFS= read -r url; do
    if [ -n "$url" ]; then
        echo "Downloading $url ..."
        wget -q --show-progress -P "$DOWNLOAD_DIR" "$url"
    fi
done

echo "Download completed to: $DOWNLOAD_DIR"

