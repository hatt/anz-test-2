# Build stage
FROM golang:alpine AS build

ENV GO111MODULE=on

WORKDIR /app

ADD ./ /app

RUN apk update --no-cache && \
    apk add git make && \
    rm -rf /var/cache/apk/*

RUN make all

# Runtime stage
FROM alpine:latest

COPY --from=build /app/anz-test-2 /app/

EXPOSE 8000

ENTRYPOINT ["/app/anz-test-2"]
