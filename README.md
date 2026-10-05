# PapaProxy.net MCP Server

Manage your [PapaProxy.net](https://papaproxy.net) proxies from an AI agent. Connect Cursor, Claude Code, or any MCP client that supports remote servers, and your agent gets 50 tools for your proxy account: stock and pricing, orders and renewals, IP whitelisting, credentials, IP refreshes, usage analytics, billing, and support tickets.

- **Remote server**, nothing to install
- **Free** on every PapaProxy.net account
- **Scoped API keys**: an agent without `wallet:spend` can't pay for anything

| | |
|---|---|
| Endpoint | `https://papaproxy.net/account_new/api/v1/mcp` |
| Transport | Streamable HTTP |
| Auth | `Authorization: Bearer <API_KEY>` |

## Quick start

### 1. Create an API key

In the Dashboard, open [Settings → API keys](https://papaproxy.net/account_new/settings#api-keys), name the key, and select only the scopes it needs (see [Scopes](#scopes)). The full key is shown once, right after creation.

### 2. Connect your client

**Cursor**

Add this to `.cursor/mcp.json` in your project or `~/.cursor/mcp.json` for all projects:

```json
{
  "mcpServers": {
    "papaproxy": {
      "url": "https://papaproxy.net/account_new/api/v1/mcp",
      "headers": {
        "Authorization": "Bearer fb_YOUR_API_KEY"
      }
    }
  }
}
```

You can also install it in one click from the [developer page](https://papaproxy.net/developers.php#mcp).

**Claude Code**

```bash
claude mcp add --transport http papaproxy \
  https://papaproxy.net/account_new/api/v1/mcp \
  --header "Authorization: Bearer fb_YOUR_API_KEY"
```

**Other clients**

Any MCP client that supports remote servers with custom headers works with the same URL and `Authorization` header.

Ready-to-use files are in the [`examples`](examples) folder.

### Try it without a key

Country stock and price quotes are public. Paste this into any agent that can open web pages and send HTTP requests:

```
Read https://papaproxy.net/developers.md. Using the public endpoints described there (no API key needed), show which countries have datacenter proxies in stock right now and quote 100 US IPs for 1 month. Then tell me what you could do with my PapaProxy.net account once I connect the MCP server with an API key.
```

## What your agent can do

| Area | Examples |
|---|---|
| Stock and pricing | Check IP stock by country (`list_countries`), price a country mix and term (`quote_composite`) |
| Orders | Buy from your balance (`order_composite`), add IPs to a service, renew, cancel with a prorated refund, toggle auto-renewal |
| Proxy settings | IP whitelisting (`add_whitelist_ip`), per-IP connection limits, credential rotation, rotating-proxy connection details |
| IP refresh | Replace specific IPs or the whole list |
| Analytics | Usage time series (`get_usage_timeseries`), errors by category (`get_diagnostics`), top destinations, recommendations (`get_recommendations`) |
| Add-ons | List, buy, and cancel add-ons such as UDP |
| Billing | Balance, ledger, invoices with PDF download, top-ups |
| Support | Open, read, reply to, and close tickets |
| Rotating plans | Sticky sessions: list, rotate, reset, adjust TTL |

The full list is on the [developer page](https://papaproxy.net/developers.php#mcp).

### Prompts that work well

- *"What would 1,000 ISP proxies across the US and Spain cost for 3 months? Don't buy anything yet."*
- *"Our office IP changed to 198.51.100.24 — update IP whitelisting on all active services."*
- *"Why did errors increase on my datacenter plan yesterday? Break them down by category."*
- *"Which services expire this month, and which of them have auto-renewal turned off?"*

Each of these is walked through step by step in [How to Manage Proxies with an AI Agent: 4 Real Workflows](https://papaproxy.net/blog/manage-proxies-with-ai-agent.php).

## Scopes

Scopes apply the same way to MCP tools and REST calls.

| Scope | What it allows |
|---|---|
| `catalog:read` | Products, countries, and prices |
| `services:read` | Services, proxy lists, credentials, whitelist entries, refresh status |
| `services:write` | Change credentials and IP whitelisting, refresh IPs, manage sticky sessions, cancel services |
| `usage:read` | Usage statistics |
| `wallet:read` | Balance, ledger, and invoice PDFs |
| `wallet:deposit` | Start a balance top-up and get a checkout URL |
| `wallet:spend` | Pay from your balance: purchases, renewals, add-ons, extra IPs, paid IP refreshes |
| `tickets:read` | Read support tickets |
| `tickets:write` | Open tickets and reply |
| `customer:read` | Profile details |
| `customer:write` | Update profile details |
| `webhooks` | Manage webhook endpoints and deliveries |

**Typical setups**

- **Monitoring:** `services:read`, `usage:read`. Sees everything about your services, changes nothing.
- **Provisioning:** `catalog:read`, `services:read`, `services:write`, `wallet:read`, `wallet:spend`. Orders and configures proxies. Keep your balance at the level you're comfortable letting automation spend.

## Safeguards

- **Spending is a separate scope.** Without `wallet:spend`, a key can read, quote, and configure, but can't pay for anything.
- **Only your balance.** Agent purchases are paid from your account balance. Card details stay with the payment processor.
- **Safe retries.** Orders, paid IP refreshes, and top-ups accept an idempotency key, so a repeated request returns the original result.
- **Revocable keys.** Each key shows when and from which IP it was last used. Revoke it in the Dashboard at any time.

Use a separate key for each integration and environment. Don't paste keys into prompts or commit them to a repository.

## FAQ

**Does it cost extra?**
No. The MCP server and REST API are free on every account. You pay only for the proxies and add-ons you order.

**Does it work with rotating proxies?**
Yes. For rotating plans, the agent works with gateway connection details and sticky sessions. For datacenter, ISP, and dedicated proxies, it works with IP lists, credentials, and IP whitelisting.

**Do I need programming experience?**
No. Paste one configuration block with your key, then describe what you need in plain English.

## REST API

Everything the MCP server does is also available through the REST API with the same keys, plus webhooks for account events.

- [API reference](https://papaproxy.net/developers/reference/)
- [OpenAPI 3.1 specification](https://papaproxy.net/openapi.json)
- [Developer guide](https://papaproxy.net/developers.php)

## Links

- Website: [papaproxy.net](https://papaproxy.net)
- Developer guide: [papaproxy.net/developers.php](https://papaproxy.net/developers.php)
- Markdown brief for agents: [papaproxy.net/developers.md](https://papaproxy.net/developers.md)
- Blog: [4 real workflows with an AI agent](https://papaproxy.net/blog/manage-proxies-with-ai-agent.php)
- 48-hour trial: [papaproxy.net/free-test.php](https://papaproxy.net/free-test.php)
- Support: [open a ticket](https://papaproxy.net/account_new/tickets/new) · [Telegram](https://t.me/papaproxy)
- X: [@papaproxy_net](https://x.com/papaproxy_net) · [LinkedIn](https://www.linkedin.com/company/papaproxynet)

## License

Configuration examples in this repository are released under the [MIT License](LICENSE). The MCP server itself is a hosted service operated by PapaProxy.net.
