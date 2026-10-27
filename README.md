# Mapacy

Aplicación web para el Censo Hidrosocial Acaray–Yguazú. La interfaz de mapas parte del HTML entregado; las fichas y el historial se guardan en PostgreSQL fuera del repositorio.

## Despliegue en Hydra

El Compose de Hydra incluye `deploy/hydra-compose.yaml`; PostgreSQL 16 queda en el volumen Docker `mapacy-postgres-data`, fuera del repositorio. La carga inicial, las credenciales y la copia del HTML original viven con permisos restringidos en `/home/rodrigo/.local/share/mapacy/`.

La app responde detrás de Nginx en `https://mapacy.romagal.com`; el hostname público del túnel dirige a `http://nginx:80` en la red `docker_network`. Algunos DNS de la red local pueden conservar una respuesta `NXDOMAIN` antigua.

El usuario y la contraseña iniciales están en `credentials.txt` dentro del directorio de datos local, con modo `0600`.

## Evaluación inicial

El HTML recibido guardaba fichas e historial en `localStorage`, sin acceso autenticado ni sincronización entre dispositivos. El servidor ahora exige login, valida los códigos de ficha, escribe en una transacción PostgreSQL y compara revisiones para detectar cambios concurrentes. La base de datos contiene 295 fichas ficticias de ejemplo, 73 sitios de interés y 77 encuestas de depleción sin nombres ni teléfonos.

La arquitectura sigue siendo un primer corte: el login usa una sola cuenta compartida; cada guardado reemplaza la lista completa de fichas; escenarios y capas personalizadas siguen en `localStorage`; no hay copias automáticas ni restauraciones ensayadas. Antes de incorporar relevamientos reales recomiendo cuentas y permisos por rol, escrituras por ficha con auditoría inmutable, sincronización de escenarios, migraciones de esquema y backups automáticos verificados. Los límites de intentos de login están aplicados en Nginx.
