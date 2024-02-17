# Description

An example of usage OpenResty as an Api Gateway. Openresty is responsible for the rate-limiting and authentication before passing request to the backend server.

# Usage

Docker with compose plugin should be installed:

```bash
make up
```

Try curl the application:

```bash
curl http://127.0.0.1:8080/headers
# output:
# <html>
# <head><title>401 Authorization Required</title></head>
# <body>
# <center><h1>401 Authorization Required</h1></center>
# <hr><center>openresty/1.21.4.1</center>
# </body>
# </html>
```

Try curl the application repetitively (rate-limiter test):

```bash
curl -s http://127.0.0.1:8080/headers > /dev/null  && curl http://127.0.0.1:8080/headers
# output:
# <html>
# <head><title>503 Service Temporarily Unavailable</title></head>
# <body>
# <center><h1>503 Service Temporarily Unavailable</h1></center>
# <hr><center>openresty/1.21.4.1</center>
# </body>
# </html>
```

Try curl with key parameter (auth test):

```bash
curl http://127.0.0.1:8080/headers\?key=mysecurekey
# output:
# Connection: close
# User-Agent: curl/7.29.0
# Accept: */*
```

Stop and remove containers:

```bash
make rm
```

# Internals

`docker-compose.yaml` spins up the following containers:

- `processing-service`: simple Go server (port 8090) returning request headers on `/headers` endpoint
- `api-gateway`: OpenResty-based api gateway which does the following:
- - listens 8080 port and serving only `/headers` path
- - rate-limits requests
- - authenticates requests with `key` query param stored in redis
- - passes request to backend `processing-service`
- `redis-cache`: stores keys for authentication
- `redis-cache-setup`:  helper container, adds authentication key after `redis-cache` is up
