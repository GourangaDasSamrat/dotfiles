#!/bin/bash

echo "================================"
echo "  Setup Script Selector"
echo "================================"
echo ""

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find all .sh files — current dir + subdirs, excluding setup.sh and utils/
mapfile -t SCRIPTS < <(
    find "$SETUP_DIR" \
        -name "*.sh" \
        ! -name "setup.sh" \
        ! -path "*/utils/*" \
        -type f | sort
)

if [ ${#SCRIPTS[@]} -eq 0 ]; then
    echo "No .sh files found."
    exit 1
fi

# Display with relative paths for clarity
echo "Available scripts:"
echo ""
for i in "${!SCRIPTS[@]}"; do
    rel_path="${SCRIPTS[$i]#$SETUP_DIR/}"
    echo "  $((i + 1)). $rel_path"
done

echo ""
echo "================================"
echo ""

read -p "Enter script numbers to run (space-separated, e.g., 1 3 4) or type 'all' to run all: " INPUT

if [[ "$INPUT" =~ ^[Aa][Ll][Ll]$ ]]; then
    echo "Selected: All scripts"
    SELECTED_SCRIPTS=("${SCRIPTS[@]}")
else
    read -a SELECTIONS <<<"$INPUT"
    SELECTED_SCRIPTS=()
    for selection in "${SELECTIONS[@]}"; do
        if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
            echo "Error: '$selection' is not a valid number. Skipping."
            continue
        fi
        index=$((selection - 1))
        if [ $index -lt 0 ] || [ $index -ge ${#SCRIPTS[@]} ]; then
            echo "Error: Number $selection is out of range. Skipping."
            continue
        fi
        SELECTED_SCRIPTS+=("${SCRIPTS[$index]}")
    done
fi

if [ ${#SELECTED_SCRIPTS[@]} -eq 0 ]; then
    echo "No valid scripts selected. Exiting."
    exit 1
fi

echo ""
echo "================================"
echo "Selected scripts:"
for script in "${SELECTED_SCRIPTS[@]}"; do
    echo "  - ${script#$SETUP_DIR/}"
done
echo "================================"
echo ""

read -p "Do you want to proceed? (y/n): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
echo "================================"
echo "Starting execution..."
echo "================================"
echo ""

FAILED_SCRIPTS=0
SUCCESS_SCRIPTS=0

for script in "${SELECTED_SCRIPTS[@]}"; do
    script_label="${script#$SETUP_DIR/}"
    echo "----------------------------------------"
    echo "Processing: $script_label"
    echo "----------------------------------------"

    chmod +x "$script"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to set execute permission for $script_label"
        ((FAILED_SCRIPTS++))
        continue
    fi

    echo "Running $script_label..."
    echo ""

    bash "$script"
    if [ $? -ne 0 ]; then
        echo ""
        echo "Error: $script_label failed"
        ((FAILED_SCRIPTS++))
    else
        echo ""
        echo "Success: $script_label completed"
        ((SUCCESS_SCRIPTS++))
    fi
    echo ""
done

echo "========================================"
echo "Execution Summary:"
echo "  Total scripts run : $((SUCCESS_SCRIPTS + FAILED_SCRIPTS))"
echo "  Successful        : $SUCCESS_SCRIPTS"
echo "  Failed            : $FAILED_SCRIPTS"
echo "========================================"

if [ $FAILED_SCRIPTS -eq 0 ]; then
    echo ""
    echo "All selected scripts completed successfully!"
    exit 0
else
    echo ""
    echo "Some scripts failed. Please check the errors above."
    exit 1
fi
