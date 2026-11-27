# ha-certbot-scaleway

Home Assistant apps repository providing an app that generates and automatically renews Let's Encrypt TLS certificates using the [Scaleway DNS API](https://www.scaleway.com/en/developers/api/domains/) through the [`certbot-dns-scaleway`](https://pypi.org/project/certbot-dns-scaleway/) plugin (dns-01 challenge).

## Apps

| App | Description |
| --- | --- |
| [certbot_scaleway](certbot_scaleway/) | Generate and auto-renew Let's Encrypt certificates for domains hosted on Scaleway DNS |

## Installation

1. In Home Assistant, go to **Settings > Apps > App Store**.
2. Open the top-right menu and select **Repositories**.
3. Add the URL of this repository:

   ```text
   https://github.com/MrWazaby/ha-certbot-scaleway
   ```

   Or click the badge to pre-fill the dialog:

   [![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-added.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https://github.com/MrWazaby/ha-certbot-scaleway)

4. Select **Add**, then install the **Certbot Scaleway** app from the store and follow the [app documentation](certbot_scaleway/DOCS.md).

## Development

Each app lives in its own folder (named after its `slug`) and is built for all supported architectures by the GitHub Actions workflows in `.github/workflows/`. To build an app locally instead:

```shell
docker buildx build --platform linux/amd64 -t local/certbot_scaleway ./certbot_scaleway
```
