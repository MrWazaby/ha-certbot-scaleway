## 1.1.0

- Add `renew_retry_interval_hours` option (default `2`): configurable sleep between renewal attempts after a failed `certbot renew`, instead of waiting the full `renew_interval_hours`.
- Document how to use the generated certificate in Home Assistant via **Settings > System > Network > HTTP server** (SSL certificate/key paths).

## 1.0.0

- Initial release: issue and auto-renew Let's Encrypt certificates with the Scaleway DNS API (certbot-dns-scaleway, dns-01), published to the `ssl` share as `fullchain.pem` / `privkey.pem`.
