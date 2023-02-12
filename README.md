# Wordpress La Colifata

Repositorio para el proyecto de La Colifata, sitio Wordpress, scripts para backups, etc.

## Backup script

A partir de esta [guía](https://theme.fm/a-shell-script-for-a-complete-wordpress-backup/) y aportes de openai, agregué un script de bash para copiar, comprimir y backupear tanto la base MySQL como los archivos de Wordpress. Está configurado para que sólo mantenga los últimos 5 backups. Ver [script](backup.sh).

## Dropbox upload

Con ayuda de openai y la documentación de Dropbox, [configuré una app](https://www.dropbox.com/developers/apps) y un script para subir estos backups a la nube. En este caso el script mantiene los últimos 20 archivos. Ver [script](backup_upload_dropbox.py).  
Además del script, corresponde configurar las credenciales de la API y demás cuestiones de Dropbox:

- En un navegador, abrir esta [URL](https://www.dropbox.com/oauth2/authorize?token_access_type=offline&response_type=code&client_id={app_key}), reemplazando el valor que corresponda para app_key.

- Ejecutar el siguiente comando para obtener access_token y refresh_token, reemplazando insert_code, app_key y app_secret por los valores que correspondan:

```bash
# to get tokens
$ curl https://api.dropbox.com/oauth2/token -d code={insert_code} -d grant_type=authorization_code -u {app_key}:{app_secret}
```

Este comando devuelve algo similar a:

```bash
{"access_token": "sl.xxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxx-xxxxxxxxxxxxx", "token_type": "bearer", "expires_in": 14400, "refresh_token": "xxxxxxxxx-xxxxxxxxxxxx-xxxxxxxxxxxxxxx", "scope": "account_info.read files.content.write files.metadata.read", "uid": "12345678", "account_id": "dbid:xxxxxxxxxxxxxx"}
```

En principio estos comandos permiten obtener las distintas credenciales para el script de upload, pero con openai lo agregamos para que refresque el token al momento de subir los archivos (en realidad verificar que faltan por subir y que existen 20 en la carpeta en la nube).

### cron

```bash
# Editamos el archivo para que ejecute los scripts todos los días a las 03:00 am
$ crontab -e
```

```cron
0 3 * * * bash /home/diego/backup_wp_sql.sh
0 3 * * * python3 /home/diego/backup_upload_dropbox.py
```
