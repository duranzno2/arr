#!/usr/bin/env bash
# One-time migration: move the jellyfin container from the media-stack
# compose project to its own project and systemd unit.
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

if docker ps -a --format '{{.Names}}' | grep -qx sb-jellyfin-media; then
  echo "Removing old sb-jellyfin-media container..."
  docker stop sb-jellyfin-media
  docker rm sb-jellyfin-media
fi

echo "Installing jellyfin.service..."
sudo cp jellyfin.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now jellyfin.service

systemctl --no-pager status jellyfin.service
docker compose -f jellyfin.compose.yml ps
