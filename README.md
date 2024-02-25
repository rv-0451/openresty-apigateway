# Description

An example of usage OpenResty as an Api Gateway. Openresty is responsible for the rate-limiting and authentication before passing request to the backend server.

# Usage

Docker with compose plugin should be installed:

```bash
make up
```

Try curl the application:

```bash
curl http://127.0.0.1:8080
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
curl -s http://127.0.0.1:8080 > /dev/null  && curl http://127.0.0.1:8080
# output:
# <html>
# <head><title>503 Service Temporarily Unavailable</title></head>
# <body>
# <center><h1>503 Service Temporarily Unavailable</h1></center>
# <hr><center>openresty/1.21.4.1</center>
# </body>
# </html>
```

Try curl with token (auth test):

```bash
# Get token and run curl
TOKEN=$(./scripts/jwt-gen.sh)
curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8080/
# output:
# X-Real-Ip: 172.21.0.1
# X-Forwarded-For: 172.21.0.1
# Connection: close
# User-Agent: curl/7.29.0
# Accept: */*
# Authorization: Bearer <token>
```

Stop and remove containers:

```bash
make rm
```

# Internals

`docker-compose.yaml` spins up the following containers:

- `processing-service`: simple Go server (port 8090) returning request headers on `/headers` endpoint
- `api-gateway`: OpenResty-based api gateway which does the following:
- - listens 8080 port and serving only `/` path
- - rate-limits requests
- - authenticates jwt tokens in requests (symmetric key is specified in the env variable)
- - passes request to backend `processing-service`
