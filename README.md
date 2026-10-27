# Mapacy

Aplicación web de mapas dinámicos para la Gestión Hidrosocial en el embalse Acaray y el Censo Hidrosocial Acaray–Yguazú. La interfaz nueva adapta el prototipo de [Camilo Caballero Ocariz](https://github.com/camilojco/hidosocioacy).

## Aplicación y datos

- `app.py` ofrece login, API y persistencia central en PostgreSQL.
- `fuente/app_template.html` contiene la interfaz, incluidos escenarios de agua e hidrología.
- `datos/` contiene cartografía y series hidrometeorológicas de demostración. Las series hidrológicas de ejemplo son simuladas.
- `static/index.html` es la página generada que sirve Flask. Generala con `python3 scripts/build-mapacy-web.py`.

Las fichas y el historial se consultan por API solo después de iniciar sesión. Los arrays `SAMPLE`, `SITES` y `SURVEYS` se dejan vacíos en el HTML generado. Los datos de fichas, sitios y encuestas iniciales permanecen en la base PostgreSQL y en los archivos privados fuera del repo bajo `/home/rodrigo/.local/share/mapacy/`; no copies esos archivos ni los datos personales al repositorio público. La base inicial contiene 295 fichas de ejemplo, 73 sitios de interés y 77 encuestas de depleción, sin nombres ni teléfonos.

Los escenarios personalizados y las series cargadas desde la interfaz siguen guardándose en `localStorage` de cada navegador. Los sitios y encuestas se comparten mediante PostgreSQL.

## Actualizar Hydra

Los cambios se revisan y se fusionan manualmente en GitHub. En Hydra, tras hacer pull, reconstruye y recrea solamente la web:

```bash
cd ~/projects/mapacy
git pull --ff-only origin main
python3 scripts/build-mapacy-web.py
./scripts/rebuild-hydra-web.sh
```

El script de reconstrucción espera el healthcheck de `web` y no recrea ni modifica el servicio de base de datos. La aplicación responde en `https://mapacy.romagal.com`.

`.github/CODEOWNERS` solicita una revisión de `@romagal13` en cada pull request. Para recibir avisos, activa **Watch → Custom → Pull requests** en GitHub y exige pull requests antes de permitir cambios a `main`.
