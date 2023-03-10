#Build stage
FROM golang:1.16.3-alpine3.13 as builder
LABEL maintainer="Son Huynh <son@huynh.dev>"

ENV GO111MODULE=on

WORKDIR /build

RUN apk update && apk upgrade && apk add --no-cache ca-certificates

COPY go.mod .
COPY go.sum .

#RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main

#Final stage
FROM scratch
LABEL maintainer="Son Huynh <son@huynh.dev>"

COPY --from=builder /build/main /src/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
WORKDIR /src/credentials
WORKDIR /src/migrations
WORKDIR /src

ENTRYPOINT ["./main"]