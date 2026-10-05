#!/usr/bin/env bash
# Add the PapaProxy.net MCP server to Claude Code.
# Set your API key first: export PAPA_API_KEY="fb_..."
set -euo pipefail

if [ -z "${PAPA_API_KEY:-}" ]; then
  echo "PAPA_API_KEY is not set. Run: export PAPA_API_KEY=\"fb_...\"" >&2
  exit 1
fi

claude mcp add --transport http papaproxy \
  https://papaproxy.net/account_new/api/v1/mcp \
  --header "Authorization: Bearer ${PAPA_API_KEY}"
