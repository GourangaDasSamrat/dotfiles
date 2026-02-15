#!/bin/bash

echo "================================"
echo "  Setup Script Selector"
echo "================================"
echo ""

# Find all .sh files in current directory (excluding setup.sh itself)
mapfile -t SCRIPTS < <(find . -maxdepth 1 -name "*.sh" ! -name "setup.sh" -type f | sort)

# Check if any scripts found
if [ ${#SCRIPTS[@]} -eq 0 ]; then
    echo "No .sh files found in the current directory."
    exit 1
fi

# Display available scripts
echo "Available scripts:"
echo ""
for i in "${!SCRIPTS[@]}"; do
    script_name=$(basename "${SCRIPTS[$i]}")
    echo "  $((i+1)). $script_name"
done

echo ""
echo "================================"
echo ""

# Get user selection
read -p "Enter script numbers to run (space-separated, e.g., 1 3 4) or type 'all' to run all: " INPUT

# Check if user wants to run all scripts
if [[ "$INPUT" =~ ^[Aa][Ll][Ll]$ ]]; then
    echo "Selected: All scripts"
    SELECTED_SCRIPTS=("${SCRIPTS[@]}")
else
    # Parse individual selections
    read -a SELECTIONS <<< "$INPUT"
    
    # Validate and collect selected scripts
    SELECTED_SCRIPTS=()
    for selection in "${SELECTIONS[@]}"; do
        # Check if input is a number
        if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
            echo "Error: '$selection' is not a valid number. Skipping."
            continue
        fi
        
        # Convert to array index (subtract 1)
        index=$((selection - 1))
        
        # Check if index is valid
        if [ $index -lt 0 ] || [ $index -ge ${#SCRIPTS[@]} ]; then
            echo "Error: Number $selection is out of range. Skipping."
            continue
        fi
        
        SELECTED_SCRIPTS+=("${SCRIPTS[$index]}")
    done
fi

# Check if any valid scripts were selected
if [ ${#SELECTED_SCRIPTS[@]} -eq 0 ]; then
    echo "No valid scripts selected. Exiting."
    exit 1
fi

echo ""
echo "================================"
echo "Selected scripts:"
for script in "${SELECTED_SCRIPTS[@]}"; do
    echo "  - $(basename "$script")"
done
echo "================================"
echo ""

# Ask for confirmation
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

# Execute selected scripts
FAILED_SCRIPTS=0
SUCCESS_SCRIPTS=0

for script in "${SELECTED_SCRIPTS[@]}"; do
    script_name=$(basename "$script")
    echo "----------------------------------------"
    echo "Processing: $script_name"
    echo "----------------------------------------"
    
    # Give execute permission
    chmod +x "$script"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to set execute permission for $script_name"
        ((FAILED_SCRIPTS++))
        continue
    fi
    
    echo "Running $script_name..."
    echo ""
    
    # Execute the script
    bash "$script"
    
    if [ $? -ne 0 ]; then
        echo ""
        echo "Error: $script_name failed to execute"
        ((FAILED_SCRIPTS++))
    else
        echo ""
        echo "Success: $script_name completed successfully"
        ((SUCCESS_SCRIPTS++))
    fi
    
    echo ""
done

echo "========================================"
echo "Execution Summary:"
echo "  Total scripts run: $((SUCCESS_SCRIPTS + FAILED_SCRIPTS))"
echo "  Successful: $SUCCESS_SCRIPTS"
echo "  Failed: $FAILED_SCRIPTS"
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
