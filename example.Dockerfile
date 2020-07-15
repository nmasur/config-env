FROM alpine:latest

COPY config-env ./

CMD eval $(./config-env) && printenv
