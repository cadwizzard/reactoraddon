# hassio-reactor-addon
All CREDITS to mrw298 for initial write. I've cloned this add-on to pull newer versions that I can maintain/update myself.
See: https://github.com/mrw298/hassio-reactor-addon for original work
## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.][addon-repo-badge]][addon-reactor-repo]
[![Open your Home Assistant instance and show the dashboard of a Supervisor add-on.][addon-badge]][addon-reactor]

## Configuration

The addon should attempt a basic configuration of reactor when it first
starts and connect it to the home assistant instance.

1. Create a long lived access token in Config > Users
2. Add the long lived access token to the Reactor Addon configuration
3. Start the addon

## Advanced Configuration

The reactor configuration files are copied to the `/config/reactor` directory on first start.

1. Edit with your prefered editor:
   * [Studio Code Server][addon-code]
2. Add the homeassistant configuration to `/config/reactor/reactor.yaml` file
   * [Reactor Home Assistant Install Manual][reactor-docs-hass-install]

[addon-repo-badge]: https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg
[addon-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[addon-reactor-repo]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fcadwizzard%2Freactoraddon
[addon-reactor]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=0521a35e_reactor&repository_url=https%3A%2F%2Fgithub.com%2Fcadwizzard%2Freactoraddon
[addon-code]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_vscode&repository_url=https%3A%2F%2Fgithub.com%2Fhassio-addons%2Frepository
[reactor-docs-hass-install]: https://reactor.toggledbits.com/docs/HassController/