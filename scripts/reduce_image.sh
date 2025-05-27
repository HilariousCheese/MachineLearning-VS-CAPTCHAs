#!/bin/bash

# Set the path to your dataset directory
DATASET_DIR="reCAPTCHA"  # e.g., "recaptcha-images"
IMAGES_TO_KEEP=1000

# Loop through each class folder
for CLASS_DIR in "$DATASET_DIR"/*; do
    if [ -d "$CLASS_DIR" ]; then
        echo "Processing class: $(basename "$CLASS_DIR")"
        
        TOTAL_IMAGES=$(find "$CLASS_DIR" -type f | wc -l)

        if [ "$TOTAL_IMAGES" -le "$IMAGES_TO_KEEP" ]; then
            echo "  Skipping, only $TOTAL_IMAGES images found."
            continue
        fi

        # Find images to delete
        find "$CLASS_DIR" -type f | sort -R | tail -n +$((IMAGES_TO_KEEP + 1)) > delete_list.txt

        # Delete them
        while read -r file; do
            rm "$file"
        done < delete_list.txt

        echo "  Kept $IMAGES_TO_KEEP images. Deleted $((TOTAL_IMAGES - IMAGES_TO_KEEP))."
    fi
done

# Cleanup
rm -f delete_list.txt

echo "✅ Done reducing all classes to $IMAGES_TO_KEEP images each."

