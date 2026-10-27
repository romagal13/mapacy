#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(git -C "$(dirname "${BASH_SOURCE[0]}")/.." rev-parse --show-toplevel)"
hydra_dir="${MAPACY_HYDRA_DIR:-/home/rodrigo/projects/servers-setup/servers/hydra}"
compose_file="${MAPACY_COMPOSE_FILE:-$hydra_dir/compose.yaml}"
compose_project_dir="${MAPACY_COMPOSE_PROJECT_DIR:-$hydra_dir}"

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

[[ "$(git -C "$repo_dir" branch --show-current)" == "main" ]] \
  || fail "El checkout debe estar en la rama main."
[[ -z "$(git -C "$repo_dir" status --porcelain)" ]] \
  || fail "Hay cambios locales sin guardar. Haz commit y push, o resuélvelos antes de desplegar."
[[ -f "$compose_file" ]] \
  || fail "No encuentro el archivo Compose en: $compose_file"

printf 'Actualizando main desde GitHub...\n'
git -C "$repo_dir" pull --ff-only origin main

printf 'Construyendo y recreando solo el servicio web de Mapacy...\n'
docker compose \
  --project-name hydra \
  --project-directory "$compose_project_dir" \
  --file "$compose_file" \
  up --detach --build --force-recreate --no-deps --wait --wait-timeout 120 web

printf '\nMapacy quedó actualizado y saludable. Estado del servicio:\n'
docker compose \
  --project-name hydra \
  --project-directory "$compose_project_dir" \
  --file "$compose_file" \
  ps web
