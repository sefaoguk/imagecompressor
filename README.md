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
    chmod +x imagecompressor.sh
    ```
4. Run the script and specify the directories to compress, and optionally set the quality using the `-q` parameter:
    ```bash
    ./imagecompressor.sh [-q quality] <directory1> [<directory2> ... <directoryN>]
    ```

   - `-q quality`: Optional parameter to specify the compression quality. The default value is 65 if not provided.
   
Example:
```bash
./imagecompressor.sh -q 75 folder1 folder2 folder3
```
<img width="694" alt="image" src="https://github.com/user-attachments/assets/4d05813b-c093-4d1b-9da4-d6167c191a54">

If you do not specify the -q parameter, the default quality "-q 65" is used.

## Script Details
- **-q quality:** Set the compression quality. The default value is 65. If not provided, the script uses 65 as the default quality setting.
- **File Size Calculation:** Sizes are displayed in bytes, kilobytes, megabytes, or gigabytes.
- **Savings Calculation:** The script calculates and displays the percentage of savings based on the file size before and after compression.

## Contributing
**Sefa Öğük** - Developer and maintainer of the script



