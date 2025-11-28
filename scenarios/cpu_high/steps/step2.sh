#!/bin/bash
echo "Step 2: Simulating high CPU usage..."
# Run multiple background loops to generate CPU load
yes > /dev/null &
yes > /dev/null &
yes > /dev/null &
echo "High CPU load started. Observe the system. Press Ctrl+C to stop."
