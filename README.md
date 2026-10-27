# Mapacy

Aplicación web de mapas dinámicos para la Gestión Hidrosocial en el embalse Acaray y el Censo Hidrosocial Acaray–Yguazú. La interfaz parte del HTML entregado; las fichas y el historial se guardan en PostgreSQL fuera del repositorio.

## Despliegue en Hydra

El despliegue usa `deploy/hydra-compose.yaml`. PostgreSQL 16 guarda sus datos en el volumen Docker `mapacy-postgres-data`, fuera del repositorio. La carga inicial, las credenciales y la copia del HTML original se guardan con permisos restringidos en `/home/rodrigo/.local/share/mapacy/`.

La aplicación responde en `https://mapacy.romagal.com`. El hostname público del túnel dirige a `http://nginx:80` en la red `docker_network`.

## Evaluación inicial

El HTML original guardaba fichas e historial en `localStorage`, sin autenticación ni sincronización entre dispositivos. El servidor ahora requiere login, valida los códigos de ficha, escribe en una transacción PostgreSQL y compara revisiones para detectar cambios concurrentes. La base actual contiene 295 fichas de ejemplo, 73 sitios de interés y 77 encuestas de depleción sin nombres ni teléfonos.

La arquitectura todavía usa una sola cuenta compartida, reemplaza la lista completa de fichas en cada guardado y mantiene escenarios y capas personalizadas en `localStorage`. Tampoco hay copias automáticas ni restauraciones ensayadas. Antes de incorporar relevamientos reales conviene agregar cuentas y permisos por rol, escrituras por ficha con auditoría inmutable, sincronización de escenarios, migraciones de esquema y backups automáticos verificados. Los límites de intentos de login se aplican en Nginx.
