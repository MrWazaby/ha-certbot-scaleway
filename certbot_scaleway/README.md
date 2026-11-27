# Certbot Scaleway

Home Assistant app that generates and automatically renews [Let's Encrypt](https://letsencrypt.org/) TLS certificates for your domains using the [Scaleway DNS API](https://www.scaleway.com/en/developers/api/domains/) via the [`certbot-dns-scaleway`](https://pypi.org/project/certbot-dns-scaleway/) plugin (dns-01 challenge, no open ports required).

The issued certificate is published to the `ssl` share as `fullchain.pem` and `privkey.pem`, so Home Assistant itself (or any other app mapping the `ssl` share) can use it.

See [DOCS.md](DOCS.md) for installation and configuration details.
