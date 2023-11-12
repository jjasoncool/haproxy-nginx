## Configs
- create your config
`cp /haproxy/cert-list.cfg.template /haproxy/cert-list.cfg`
`cp .env.template .env`

- edit your config
`/haproxy/haproxy.cfg`

## test sed build
`docker build -t test -f ./haproxy/test_sed ./haproxy && docker run --rm test`
