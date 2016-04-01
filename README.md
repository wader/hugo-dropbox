### hugo-dropbox

Docker image that serves a hugo site from dropbox

### Setup

Environment variable `DROPBOX_FOLDER` sets which dropbox folder to use for
hugo files.

First start a container:
```
docker run --rm -e DROPBOX_FOLDER="hugo test" -p 8080:8080 test
```
After a while you will see log messages from dropboxd:  
 ```
This computer isn't linked to any Dropbox account...
Please visit https://www.dropbox.com/cli_link_nonce?nonce=.... to link this device.
 ```
Visit the link in a browser logged in with the dropbox account you want to
link. Once linked files will start to be synced and hugo will start running.

Now your site should be available at `http://docker-host:8080`

### docker-compose

```
site:
  image: mwader/hugo-dropbox
  restart: always
  environment:
    - DROPBOX_FOLDER=Homepage
```

Run `docker-compose up -d` and check logs `docker-compose logs`

### Tips

You most probably want to create a dedicated dropbox account for hugo-dropbox
and share a collaborative folder with it. That way it does not sync and have
access to your other files.

To preserve dropbox configuration and data i suggest letting docker-compose
take care of it or create a data only container and use `-volumes-from`.  
