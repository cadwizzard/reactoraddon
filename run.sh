#!/usr/bin/env bashio

HASS_CONFIG_PATH="/data/options.json"
CONFIG_DIR="/config/reactor"
CONFIG_SRC="/opt/reactor/dist-config"
DATA_DIR="/data/reactor"

# Setup the config
if [ ! -d "$CONFIG_DIR" ]; then
  echo "New setup, copy dist-config files to /config/reactor"
  cp -vaR $CONFIG_SRC $CONFIG_DIR
  
  echo "Configure hass"
  yq eval -i '(.controllers[] | select(.id=="hass").config.source) |= "ws://homeassistant.local:8123"' $CONFIG_DIR/reactor.yaml
  yq eval -i '(.controllers[] | select(.id=="hass").enabled) |= true' $CONFIG_DIR/reactor.yaml
else
  echo "Using existing set-up"
fi

if [ -f "$HASS_CONFIG_PATH" ]; then
  REACTOR_HASS_TOKEN=$(jq --raw-output '.long_lived_token // empty' $HASS_CONFIG_PATH)
  if [ -n "$REACTOR_HASS_TOKEN" ]; then
    echo "Reactor Token is set, updating config"
    yq eval -i "(.controllers[] | select(.id==\"hass\").config.access_token) |= \"$REACTOR_HASS_TOKEN\"" $CONFIG_DIR/reactor.yaml
  fi
fi

#Setup data directory
if [ ! -d "$DATA_DIR" ]; then
  mkdir -p $DATA_DIR
fi

if [ ! -L "/var/reactor" ]; then
  echo "symlink does not exist, create it"
  rm -rf /var/reactor
  ln -s $DATA_DIR /var/reactor 
fi


# Run the app
node app.js -c $CONFIG_DIR
