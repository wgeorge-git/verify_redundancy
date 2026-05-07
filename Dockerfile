# VIOLATION: Policy ID: ckv-docker-2
# VIOLATION: Title: Ensure that HEALTHCHECK instructions have been added to container images
# VIOLATION: Severity: Low
# VIOLATION: Compliance: None

# VIOLATION: Policy ID: ckv-docker-3
# VIOLATION: Title: Ensure that a user for the container has been created
# VIOLATION: Severity: Low
# VIOLATION: Compliance: None
FROM alpine:3.20

RUN apk update && \
    apk add --no-cache \
        ca-certificates \
        curl \
        nginx && \
    chmod u+s /bin/busybox

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/http.d/default.conf

EXPOSE 80

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
