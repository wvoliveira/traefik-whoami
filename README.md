# betraefik

Reverse proxy to manager requests

## How

Use [mkcert](https://github.com/FiloSottile/mkcert/releases) for generate local certs and install in your system.

Run following command to start traefik and 1 container for test:

```bash
# start traefik with configurations in the conf/ path
make run

# start whoami container
make run_whoami
```

Go to <http://localhost:8080/dashboard/> to access traefik dashboard.  
Go to <http://localhost:8082/metrics> to access metrics with prometheus format.  
Go to <http://whoami.localhost/> to access whoami container response.  

References:

- <https://docs.traefik.io/user-guides/docker-compose/basic-example/>
- <https://docs.traefik.io/observability/logs/>
- <https://docs.traefik.io/migration/v1-to-v2/>
