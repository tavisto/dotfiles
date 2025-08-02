#!/bin/bash

# FastGPT Kagi API Shell Script

# Check if API key is provided
if [ -z "$KAGI_API_KEY" ]; then
    echo "Error: KAGI_API_KEY environment variable is not set"
    echo "Please set it with: export KAGI_API_KEY=your_api_key"
    exit 1
fi

# Check if query is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 \"your query here\""
    exit 1
fi

# Get terminal width
TERM_WIDTH=$(tput cols)

# Prepare the query
QUERY="$*"

# Call the FastGPT API and pipe through glow
curl -vv -s "https://kagi.com/api/v0/fastgpt" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bot $KAGI_API_KEY" \
  -d "{\"query\": \"$QUERY\"}" | \
  jq -r '.data.output' | \
  glow -w $TERM_WIDTH

# Exit with the status of the last command
exit ${PIPESTATUS[0]}

