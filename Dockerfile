FROM golang:1.12 AS builder
ENV GO111MODULE on
WORKDIR /go/src/app
COPY . .
RUN go get -d -v ./... && \
  CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -o caddy

FROM alpine:3.7 as alpine
RUN apk add -U --no-cache ca-certificates

# Image starts here
FROM scratch
LABEL maintainer "Lucas Lorentz <lucaslorentzlara@hotmail.com>"

EXPOSE 80 443 2015
ENV HOME /root

WORKDIR /
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /go/src/app/caddy /bin/

ENTRYPOINT ["/bin/caddy"]
