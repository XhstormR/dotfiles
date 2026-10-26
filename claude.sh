#!/usr/bin/env bash

# Hooks
sh <(curl https://raw.githubusercontent.com/PeonPing/peon-ping/main/install.sh)

# MCP
claude mcp add --scope user --transport stdio sequential-thinking -- bun x @modelcontextprotocol/server-sequential-thinking@latest
claude mcp add --scope user --transport stdio context7 -- bun x @upstash/context7-mcp@latest
claude mcp add --scope user --transport stdio playwright-mcp -- bun x @playwright/mcp@latest
claude mcp add --scope user --transport stdio markitdown-mcp -- uvx markitdown-mcp@latest
# claude mcp add --scope user --transport stdio chrome-devtools-mcp -- bun x chrome-devtools-mcp@latest
claude mcp add --scope user --transport stdio code-review-graph -- uvx code-review-graph@latest serve
claude mcp add --scope user --transport stdio fff -- fff-mcp
claude mcp add --scope user --transport http  grep -- https://mcp.grep.app

claude mcp add --scope user --transport stdio svelte -- bun x @sveltejs/mcp@latest
claude mcp add --scope user --transport stdio angular-cli -- bun x @angular/cli@latest mcp
claude mcp add --scope user --transport stdio daisyui-doc -- bun x mcp-remote@latest https://gitmcp.io/saadeghi/daisyui
claude mcp add --scope user --transport http  astro-docs -- https://mcp.docs.astro.build/mcp
claude mcp add --scope user --transport http  atlassian-mcp-server -- https://mcp.atlassian.com/v1/mcp
claude mcp add --scope user --transport http  gitlab-cmc -H "X-Gitlab-Mcp-Server-Tool-Name-Prefix: cmc_" -- https://git.coinmarketcap.supply/api/v4/mcp

# Skills
bun x skills add --agent claude-code --global --yes https://github.com/anthropics/skills --skill webapp-testing frontend-design
bun x skills add --agent claude-code --global --yes https://github.com/sveltejs/ai-tools --skill svelte-code-writer svelte-core-bestpractices
bun x skills add --agent claude-code --global --yes https://github.com/redis/agent-skills --skill '*'
bun x skills add --agent claude-code --global --yes https://github.com/duckdb/duckdb-skills --skill '*'
bun x skills add --agent claude-code --global --yes https://github.com/tt-a1i/archify --skill archify
bun x skills add --agent claude-code --global --yes https://github.com/vercel-labs/skills --skill find-skills
bun x skills add --agent claude-code --global --yes https://github.com/vercel-labs/agent-skills --skill web-design-guidelines writing-guidelines
bun x skills add --agent claude-code --global --yes https://github.com/ast-grep/agent-skill --skill ast-grep
bun x skills add --agent claude-code --global --yes https://github.com/dietrichgebert/ponytail --skill ponytail
bun x skills add --agent claude-code --global --yes https://github.com/microsoft/playwright-cli --skill playwright-cli
bun x skills add --agent claude-code --global --yes https://github.com/nextlevelbuilder/ui-ux-pro-max-skill --skill ui-ux-pro-max
bun x skills add --agent claude-code --global --yes https://github.com/humanlayer/skills --skill show-me

bun x skills add --agent claude-code --global --yes https://github.com/3stoneBrother/code-audit --skill code-audit
bun x skills add --agent claude-code --global --yes https://github.com/alibaba/open-code-review --skill open-code-review open-code-review-delegate
bun x skills add --agent claude-code --global --yes https://github.com/cloudflare/security-audit-skill --skill security-audit
