## Configs
- create your config
`cp /haproxy/cert-list.cfg.template /haproxy/cert-list.cfg`
`cp .env.template .env`

- edit your configs, the configs below will be copied to container when executed for the first time
`/haproxy/haproxy.cfg`

- Using `docker-compose up -d --build`

## test sed build
`docker build -t test -f ./haproxy/test_sed ./haproxy && docker run --rm test`
