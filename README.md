# Traefik

Reverse proxy to manager microservices requests

## Test local

Run: `docker-compose -f docker-compose.yml up --build`

Its open 80, 443 and 8080 ports in your host:

- Open <http://127.0.0.1/> for requests;
- Or <https://127.0.0.1/> for https requests;
- Or <http://127.0.0.1:8080/> for Traefik dashboard.

Copy all self signed certificates to /usr/local/share/ca-certificates/: `cp conf/certs/wildcard*crt /usr/local/share/ca-certificates/`  
and update: `sudo update-ca-certificates`

Now you can do send requests without certificates errors. Examples:

Add these lines in your /etc/hosts:

```bash
127.0.0.1 <domain>.com.br
127.0.0.1 <domain>.com.br
```

Now send requests:

```bash
curl -vv -I https://<domain>.com.br/
curl -vv -I https://<domain>.com.br/
```

Awesome!

## To add a service in Traefik manager

Create:

```bash
docker service create \
    --name <service name> \
    --constraint=node.role==worker \
    --network traefik \
    --mount type=bind,source=/var/run/nscd,target=/var/run/nscd,readonly \
    --update-failure-action rollback \
    --label traefik.enable=true \
    --label traefik.port=<container port> \
    --label traefik.docker.network=traefik \
    --label "traefik.frontend.rule=PathPrefix:<path>" \
    <image base>
```

Update:

```bash
docker service update \
    --update-failure-action rollback \
    --update-parallelism 1 \
    --label-add traefik.enable=true \
    --label-add traefik.port=<container port> \
    --label-add traefik.docker.network=traefik \
    --label-add "traefik.frontend.rule=PathPrefix:<path>" \
    <service name>
```

Per path:

```bash
docker service update --label-add "traefik.frontend.rule=PathPrefixStrip:/pathhere" <service name>
```

Per host: `--label-add "traefik.frontend.rule=Host:somedomain.com.br"`

To join both, just separate with ";": `--label-add "traefik.frontend.rule=Host:domain.com.br;PathPrefixStrip:/pathhere"`

To add more one value, just insert comma: `Host:domain1.com.br,domain2.com.br`

Weighted Round Robin: `--label-add "traefik.backend.loadbalancer.method=wrr"`

Dynamic Round Robin: `--label-add "traefik.backend.loadbalancer.method=drr"`

Force Traefik do view specific network in container: `--label-add "traefik.docker.network=traefik"`

References:

- <https://docs.traefik.io/user-guide/examples/>
- <https://docs.traefik.io/configuration/backends/docker/>
