# Certbot Scaleway

Home Assistant app that generates and automatically renews [Let's Encrypt](https://letsencrypt.org/) TLS certificates for your domains using the [Scaleway DNS API](https://www.scaleway.com/en/developers/api/domains/) via the [`certbot-dns-scaleway`](https://pypi.org/project/certbot-dns-scaleway/) plugin (dns-01 challenge, no open ports required).

The issued certificate is published to the `ssl` share as `fullchain.pem` and `privkey.pem`, so Home Assistant itself (or any other app mapping the `ssl` share) can use it.

## Using the certificate in Home Assistant (network settings)

Once the app has issued a certificate, serve Home Assistant itself over HTTPS:

1. In Home Assistant, go to **Settings > System > Network**.
2. In the **HTTP server** section, set **SSL certificate path** to `/ssl/fullchain.pem` and **SSL key path** to `/ssl/privkey.pem`.
3. On the same page, set the **Home Assistant URL** to `https://<your-domain>` so browsers and companion apps connect over HTTPS.
4. Save. Home Assistant restarts and asks an administrator to confirm the new settings — confirm within 5 minutes, otherwise it falls back to the previous settings.

On older Home Assistant versions where the HTTP server is still configured in YAML, add to `configuration.yaml` instead and restart Home Assistant:

```yaml
http:
  ssl_certificate: /ssl/fullchain.pem
  ssl_key: /ssl/privkey.pem
```

Home Assistant reads the certificate files when the HTTP server starts, so restart Home Assistant after a renewal to serve the renewed certificate.

See [DOCS.md](DOCS.md) for installation and configuration details.
