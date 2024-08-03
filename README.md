# Image Compressor Script

This script compresses `.png`, `.jpeg`, `.jpg`, and `.webp` files in the specified directories. It calculates and reports the size before and after compression, the total number of files, and the percentage of savings. It is designed to work on both macOS and Linux systems.

## Features

- Compresses image files in the specified directories.
- Calculates the size of each file before and after compression.
- Computes and displays the percentage of savings.
- Reports the size of the directory before and after processing.

## Requirements

This script requires the following tools to be installed on your system:

- **ImageMagick**: Used for compressing image files. [Download ImageMagick](https://imagemagick.org/script/download.php)
- **bc**: Used for mathematical calculations. (Usually pre-installed on Linux and macOS systems.)

Installation:
- macOS: `brew install imagemagick bc`
- Linux: `sudo apt-get install imagemagick bc` or `sudo yum install imagemagick bc` (depending on your distribution)

## Usage

To run the script, follow these steps:

1. Download or copy the script.
2. Navigate to the directory where the script is located in your terminal or command line.
3. Make the script executable:
    ```bash
    chmod +x compressor.sh
    ```
4. Run the script and specify the directories to compress:
    ```bash
    ./compressor.sh <directory1> [<directory2> ... <directoryN>]
    ```

Example:
```bash
./compressor.sh folder1 folder2 folder3

## Sample Output
<img width="694" alt="image" src="https://github.com/user-attachments/assets/4d05813b-c093-4d1b-9da4-d6167c191a54">

## Known Issues
- There may be some incompatibilities due to ImageMagick's change from convert to magick. Ensure that the magick command is correctly configured on your system.

## Contributing
Sefa Öğük - Developer and maintainer of the script

