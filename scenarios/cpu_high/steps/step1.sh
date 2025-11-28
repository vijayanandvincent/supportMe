#!/bin/bash
echo "Step 1: Checking current CPU usage..."
top -b -n1 | head -10
echo "Record the CPU usage for analysis."
