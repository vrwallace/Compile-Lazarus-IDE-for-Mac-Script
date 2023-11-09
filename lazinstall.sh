 #!/bin/bash

# Define the desired download directory and Lazarus version details
DOWNLOAD_DIR="$HOME/downloads"
LAZARUS_VERSION="fixes_3_0"
LAZARUS_ZIP="lazarus-${LAZARUS_VERSION}.zip"
LAZARUS_URL="https://gitlab.com/freepascal.org/lazarus/lazarus/-/archive/${LAZARUS_VERSION}/${LAZARUS_ZIP}"
UNZIP_DIR="lazarus-${LAZARUS_VERSION}"

# Navigate to the desired download directory
cd "${DOWNLOAD_DIR}" || { echo "Failed to navigate to ${DOWNLOAD_DIR}. Exiting."; exit 1; }

# Remove the previous zip file if it exists
if [ -f "${LAZARUS_ZIP}" ]; then
    rm "${LAZARUS_ZIP}" || { echo "Failed to remove existing ${LAZARUS_ZIP}. Exiting."; exit 1; }
fi

# Remove the previous Lazarus directory if it exists
if [ -d "${UNZIP_DIR}" ]; then
    rm -rf "${UNZIP_DIR}" || { echo "Failed to remove existing ${UNZIP_DIR} directory. Exiting."; exit 1; }
fi

# Download the zip file using wget with a progress bar and retries on failure
wget --progress=bar:force --tries=3 "${LAZARUS_URL}" || { echo "Download failed. Exiting."; exit 1; }

# Unzip the downloaded file
unzip "${LAZARUS_ZIP}" || { echo "Unzipping failed. Exiting."; exit 1; }

# Enter the unzipped Lazarus directory
cd "${UNZIP_DIR}" || { echo "Failed to navigate to ${UNZIP_DIR} directory. Exiting."; exit 1; }

# Clean and build Lazarus with the specified parameters
make clean all LCL_PLATFORM=cocoa CPU_TARGET=x86_64 bigide || { echo "Make command failed. Exiting."; exit 1; }

# Remove the 'com.apple.quarantine' attribute from the files
xattr -d -r -v com.apple.quarantine ./* || { echo "Failed to remove quarantine attributes. Exiting."; exit 1; }

echo "Lazarus ${LAZARUS_VERSION} has been successfully installed."

# End of the script
