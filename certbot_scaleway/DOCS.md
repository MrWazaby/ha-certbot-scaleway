# Certbot Scaleway

Generate and automatically renew [Let's Encrypt](https://letsencrypt.org/) certificates for domains hosted on [Scaleway DNS](https://www.scaleway.com/en/domains-and-dns/), using [certbot](https://certbot.eff.org/) with the [`certbot-dns-scaleway`](https://pypi.org/project/certbot-dns-scaleway/) plugin.

The dns-01 challenge only creates a temporary TXT record through the Scaleway API, so **no inbound ports need to be open** on your network.

## Installation

1. Add this repository to Home Assistant: **Settings > Apps > App Store > ⋮ > Repositories**, then enter `https://github.com/MrWazaby/ha-certbot-scaleway`.
2. Install the **Certbot Scaleway** app and open its configuration tab.

## Configuration

| Option | Required | Default | Description |
| --- | --- | --- | --- |
| `domains` | yes | `[]` | List of domains for the certificate (e.g. `home.example.com`, `*.example.com`). The first entry is used as the certificate name. Each domain must belong to a DNS zone managed by your Scaleway account. |
| `email` | yes | – | Email address registered with Let's Encrypt (used for expiry notices). |
| `scaleway_api_token` | yes | – | Scaleway API token **secret key**. See below. |
| `staging` | no | `false` | Use the Let's Encrypt **staging** environment (for testing; certificates are not trusted by browsers and avoid production rate limits). |
| `dns_propagation_seconds` | no | `60` | Seconds to wait for the `_acme-challenge` TXT record to propagate before validation. Increase this if validation fails with propagation errors. |
| `renew_interval_hours` | no | `12` | How often to check whether the certificate must be renewed. Certbot only renews certificates that expire within 30 days. |
| `renew_retry_interval_hours` | no | `2` | Sleep between renewal attempts after a failed `certbot renew` (e.g. transient DNS or API error), instead of waiting the full `renew_interval_hours`. |

Example:

```yaml
domains:
  - home.example.com
  - "*.example.com"
email: admin@example.com
scaleway_api_token: 11111111-2222-3333-4444-555555555555
staging: false
dns_propagation_seconds: 60
renew_interval_hours: 12
renew_retry_interval_hours: 2
```

### Getting a Scaleway API token

1. Open the [Scaleway console](https://console.scaleway.com/) and go to **Profile > API keys** (or **Credentials**).
2. Click **Generate new API key**, give it a name and restrict it to the **Domains** product if possible.
3. Copy the **secret key** (a UUID) — this is the value for the `scaleway_api_token` option. The plugin sends it as the `X-Auth-Token` header of the Scaleway Domains API.

The token is stored with `0600` permissions in `/data/scaleway-credentials.ini` inside the app container. Treat it like a password: it can modify every DNS zone of your Scaleway project.

## How it works

- On start, the app writes the Scaleway credentials file, then runs `certbot certonly --authenticator dns-scaleway` with `--keep-until-expiring` (so restarts do not trigger new issuances).
- A deploy hook copies `fullchain.pem` / `privkey.pem` to the `ssl` share (`/ssl`) after every issuance and renewal.
- The app then loops: every `renew_interval_hours` it runs `certbot renew`, which renews the certificate only when it is due (within 30 days of expiry) and re-runs the deploy hook. If a renewal attempt fails, the next attempt happens after `renew_retry_interval_hours` (default `2`) instead of the full check interval.
- Certbot state is kept in `/data/letsencrypt`, so certificates survive app restarts and updates.

## Using the certificate

The certificate is available in the `ssl` share of your Home Assistant host. To serve Home Assistant itself over HTTPS, add to `configuration.yaml`:

```yaml
http:
  ssl_certificate: /ssl/fullchain.pem
  ssl_key: /ssl/privkey.pem
```

Then restart Home Assistant. Other apps that map the `ssl` share can use `/ssl/fullchain.pem` and `/ssl/privkey.pem` as well.

## Troubleshooting

- **App stops immediately with a log error**: check that `email`, `scaleway_api_token` and at least one entry in `domains` are set. The full certbot output is in the app log.
- **"Can't find domain to use with the Scaleway API"**: the domain is not a DNS zone (or subdomain of a zone) in the Scaleway project of the token. Add the domain in **Scaleway console > Domains and DNS**.
- **Validation fails / timeouts**: increase `dns_propagation_seconds` (Scaleway DNS can be slow to propagate).
- **Rate limits**: Let's Encrypt limits production certificate issuances per domain. Use `staging: true` while testing, and avoid deleting `/data/letsencrypt` repeatedly.
- **Changing the domain list**: if you add or remove domains, delete the app data (or `/data/letsencrypt`) once so certbot issues a fresh certificate for the new set.

## Support

- [App repository](https://github.com/MrWazaby/ha-certbot-scaleway)
- [certbot-dns-scaleway plugin](https://github.com/vanonox/certbot-dns-scaleway)
