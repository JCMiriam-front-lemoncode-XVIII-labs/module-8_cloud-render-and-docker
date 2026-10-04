# Lemon Orbit: despliegue automático en Render con Docker

## Objetivo de la práctica

Preparar Lemon Orbit para su despliegue automático en Render mediante Docker al actualizar la rama `main`. La aplicación es una web estática en HTML, CSS y JavaScript sin dependencias.

## Pasos seguidos

1. Se revisó la estructura de la aplicación y se identificaron sus tres archivos públicos: `index.html`, `styles.css` y `script.js`.
2. Se creó un `Dockerfile` basado en `nginx:stable-alpine` y se copiaron los archivos de la web al directorio público de Nginx. El contenedor arranca con `nginx -g 'daemon off;'`.
3. Se añadió `nginx/default.conf.template` para escuchar en `0.0.0.0` y utilizar la variable `PORT`. El entrypoint de la imagen sustituye esta variable al arrancar; se estableció `10000` como valor por defecto.
4. Se incorporó el endpoint `/healthz`, que devuelve `ok`, para la comprobación de salud del servicio.
5. Se creó `.dockerignore` para limitar el contexto de construcción a los archivos necesarios.
6. Se preparó `render.yaml` con la definición del Web Service y el despliegue automático por commit.
7. Se sustituyó el workflow de GitHub Pages por `.github/workflows/ci.yml`. Este workflow comprueba la sintaxis JavaScript, construye la imagen y verifica el endpoint de salud y el contenido de los tres archivos utilizando un puerto personalizado.
8. Se comprobó localmente la sintaxis JavaScript mediante `node --check`, pasando el contenido de `script.js` por la entrada estándar. La comprobación terminó correctamente.

Node.js se utiliza para la validación, pero no es necesario en el contenedor que sirve la web.

## Configuración realizada en Render

9. Se subieron a GitHub los archivos de la aplicación, Docker, la configuración de Render y el workflow de CI. El README se dejó pendiente de actualizar con la configuración y el resultado del despliegue antes de subirlo.
10. En el panel de Render se eligió **New → Web Service** y se seleccionó el repositorio `module-8_cloud-render-and-docker`.
11. Se configuró el servicio con los siguientes valores, manteniendo Virginia como región:

| Campo | Valor configurado |
| --- | --- |
| Name | `module-8_cloud-render-and-docker` |
| Branch | `main` |
| Language | Docker |
| Region | Virginia |
| Root Directory | Vacío: el proyecto está en la raíz del repositorio |
| Dockerfile Path | `./Dockerfile` |
| Docker Build Context Directory | `.` |
| Docker Command | Vacío: se utiliza el CMD del Dockerfile |
| Instance Type | Free |
| Health Check Path | `/healthz` |
| Auto-Deploy | On Commit |

12. No se añadieron variables de entorno propias. Nginx utiliza la variable `PORT` al arrancar, con `10000` como valor por defecto en la imagen.

El servicio se configuró desde el panel de Render. El archivo `render.yaml` se dejó en el repositorio como alternativa para crear el servicio mediante Blueprint; no se utilizó para esta configuración. Su nombre de servicio es `lemon-orbit-docker` y no representa el nombre elegido en el panel.

Con **On Commit**, cada push o merge en `main` activa la construcción y el despliegue de la imagen. GitHub Actions realiza la validación por separado; esta configuración no espera al resultado de CI.

## URL del sitio

[Abrir Lemon Orbit en Render](https://module-8-cloud-render-and-docker.onrender.com)
