<img width="960" height="600" alt="Screenshot 2026-04-29 190841" src="https://github.com/user-attachments/assets/2993071c-8c30-487d-a0d5-993446babae1" />
<img width="6000" height="3375" alt="HiNan" src="https://github.com/user-attachments/assets/efd7c351-b562-4b87-9e95-9283f7970231" />

# Windows Cleanup Script

A powerful and lightweight Windows batch script designed to automate essential system cleanup tasks. This tool is built for users who want a fast, no-install solution to remove unnecessary files, reduce system clutter, and maintain optimal performance.

## Description

Over time, Windows accumulates temporary files, cache data, and system leftovers that can consume disk space and impact performance. Manually cleaning these files can be repetitive and time-consuming.

This script simplifies the process by combining multiple cleanup operations into a single execution. With one run, it performs a structured cleanup across several system locations safely and efficiently.

## What This Script Does

The script executes the following steps:

1. Cleans user temporary files (`%TEMP%`)
2. Clears Windows temporary directory (`C:\Windows\Temp`)
3. Removes Windows Update cache (SoftwareDistribution)
4. Deletes thumbnail cache
5. Flushes DNS cache
6. Clears Prefetch data
7. Removes recent file history
8. Cleans DirectX shader cache
9. Empties Recycle Bin

Each step is executed sequentially and displayed with progress indicators.

## Expected Results

After running this script, you may notice:

* Increased available disk space
* Reduced system clutter
* Improved responsiveness in some cases
* Reset of certain caches (e.g. thumbnails, DNS, update cache)

Note: Some performance improvements may not be immediately noticeable depending on system usage.

## Requirements

* Windows operating system
* Administrator privileges (required)
* No external dependencies

## How to Use

1. Download the `.bat` file from this repository
2. Right-click on the file
3. Select **"Run as administrator"**
4. Wait for the cleaning process to complete
5. Review the summary shown at the end
6. Press any key to exit

## Important Notes

* The script will permanently delete temporary and cached files
* Some files may not be removed if they are currently in use
* It is recommended to close all applications before running
* Windows may rebuild certain caches after cleanup

## Safety & Transparency

All commands used in this script are visible and can be reviewed directly. No hidden operations or external downloads are performed.

Users are encouraged to inspect the script before executing it.

## Limitations

* This is a basic cleanup tool, not a full system optimizer
* Does not modify registry or system configurations
* Does not replace professional maintenance software

## Disclaimer

This tool is provided as-is without any warranty. The author is not responsible for any potential data loss or system issues resulting from its use.

Use responsibly and at your own risk.

## Author

HiNan Tools by Fernando
