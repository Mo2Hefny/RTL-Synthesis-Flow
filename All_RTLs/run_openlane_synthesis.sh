#!/bin/bash

DESIGN_NAMES=("carry_select_adder" "ripple_carry_adder" "carry_lookahead_adder" "carry_bypass_adder" "booth_multiplier" "sequential_multiplier" "tree_multiplier" "verilog_multiplier")

BASE_DIR="openlane/designs"
RUN_DIR="saved_runs"  

echo "Current directory: $(pwd)"

echo "Base directory: $BASE_DIR"

for DESIGN_NAME in "${DESIGN_NAMES[@]}"; do
    DESIGN_DIR="$BASE_DIR/src"
    CONFIG_FILE="$BASE_DIR/config.json"
    DESIGN_RUN_DIR="$BASE_DIR/${RUN_DIR}/RUN_${DESIGN_NAME}"

    echo "Design directory: $DESIGN_DIR"
    echo "Config file: $CONFIG_FILE"

    if [ ! -d "$DESIGN_DIR" ]; then
        echo "Error: Design directory '$DESIGN_DIR' does not exist!"
        continue
    fi

    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Error: Config file '$CONFIG_FILE' does not exist!"
        continue
    fi

    VERILOG_FILE="dir::src/${DESIGN_NAME}.v"
    echo "Updating DESIGN_NAME and VERILOG_FILES in $CONFIG_FILE to $DESIGN_NAME and $VERILOG_FILE"
    awk -v name="$DESIGN_NAME" -v verilog="$VERILOG_FILE" '
        /"DESIGN_NAME"/ { 
            $0 = "  \"DESIGN_NAME\": \"" name "\","; 
        }
        /"VERILOG_FILES"/ { 
            $0 = "  \"VERILOG_FILES\": \"" verilog "\","; 
        } 
        { print }
    ' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

    mkdir -p "$DESIGN_RUN_DIR"

    echo "Running synthesis for design: $DESIGN_NAME"
    nix-shell --pure ~/openlane2/shell.nix --run "
        openlane --design-dir \"$BASE_DIR\" \"$CONFIG_FILE\"
    "

    if [ $? -ne 0 ]; then
        echo "Error: Synthesis step failed for design: $DESIGN_NAME"
        continue
    fi


    echo "Synthesis for $DESIGN_NAME completed successfully!"
    # echo "Check the $DESIGN_RUN_DIR directory for outputs."
    echo "--------------------------------------"
done

echo "All designs processed!"
