# openbb-workspace

Self-hosted [OpenBB Workspace](https://github.com/OpenBB-finance/workspace) (Apache-2.0,
released after OpenBB wound down), built from the upstream "Lite" Docker packaging and
published as `ghcr.io/michaexel-copilot/openbb-workspace`, deployed behind Traefik on a
Hostinger VPS.

- `.github/workflows/docker-image.yml` fetches the pinned upstream commit
  (`UPSTREAM_SHA`), assembles the build context (`scripts/assemble-context.sh`) and
  pushes the image to GHCR.
- `docker-compose.yml` adds Traefik routing and Let's Encrypt. Data (SQLite, secrets,
  uploads) lives in the `openbb-workspace-data` volume.
- The admin password is generated on first start: `docker exec openbb-workspace credentials`.
- The TradingView Advanced Charts library is proprietary and not included; charts that
  depend on it are unavailable.
- Connect the ODP backend (`https://odp.michaexel.de`) in Workspace as a custom backend
  with the header `X-API-Key`.
