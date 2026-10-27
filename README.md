# Mapacy

Aplicación web de mapas dinámicos para la Gestión Hidrosocial en el embalse Acaray y el Censo Hidrosocial Acaray–Yguazú. La interfaz parte del HTML entregado; las fichas y el historial se guardan en PostgreSQL fuera del repositorio.

## Despliegue en Hydra

La aplicación responde en `https://mapacy.romagal.com`.

Después de subir cambios a `main`, en Hydra se puede actualizar y recrear solo el servicio web con:

```bash
./scripts/deploy-hydra.sh
```

El script requiere un checkout limpio en `main`, descarga únicamente avances fast-forward y espera que el healthcheck del servicio `web` esté saludable. No recrea ni modifica PostgreSQL. Si el Compose de Hydra está en otra ubicación, se puede indicar con `MAPACY_HYDRA_DIR=/ruta/a/hydra`.

### Despliegue automático con GitHub Actions

El workflow `.github/workflows/deploy-mapacy.yml` despliega al hacer push a `main`. Usa un runner propio de Hydra con la etiqueta `mapacy-deploy`, el checkout con el `GITHUB_TOKEN` de solo lectura y el mismo script. Para registrarlo, en GitHub abre **Settings → Actions → Runners → New self-hosted runner**, elige Linux y x64, sigue las instrucciones para descargar y extraer el runner, y desde ese directorio configura el token temporal que GitHub muestra:

```bash
read -r -s -p 'Token temporal de registro: ' RUNNER_TOKEN; echo
./config.sh --url https://github.com/romagal13/mapacy --token "$RUNNER_TOKEN" --name hydra-mapacy --labels mapacy-deploy --unattended
unset RUNNER_TOKEN
sudo ./svc.sh install rodrigo
sudo ./svc.sh start
```

El runner debe quedar en estado **Idle** en la página de Actions → Runners. El token de registro vence rápidamente y sirve solo para registrar el runner; no lo guardes en el repo. La cuenta `rodrigo` debe tener acceso a Docker. Quien pueda cambiar y ejecutar workflows sobre este runner puede ejecutar código en Hydra, así que concede escritura solo a personas de confianza y protege `main` con revisión antes de fusionar cambios.

## Evaluación inicial

El HTML original guardaba fichas e historial en `localStorage`, sin autenticación ni sincronización entre dispositivos. El servidor ahora requiere login, valida los códigos de ficha, escribe en una transacción PostgreSQL y compara revisiones para detectar cambios concurrentes. La base actual contiene 295 fichas de ejemplo, 73 sitios de interés y 77 encuestas de depleción sin nombres ni teléfonos.

La arquitectura todavía usa una sola cuenta compartida, reemplaza la lista completa de fichas en cada guardado y mantiene escenarios y capas personalizadas en `localStorage`. Tampoco hay copias automáticas ni restauraciones ensayadas. Antes de incorporar relevamientos reales conviene agregar cuentas y permisos por rol, escrituras por ficha con auditoría inmutable, sincronización de escenarios, migraciones de esquema y backups automáticos verificados. Los límites de intentos de login se aplican en Nginx.
