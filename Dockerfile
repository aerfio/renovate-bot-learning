# old go version
FROM golang:1.24.2 as builder

WORKDIR /workspace

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY main.go main.go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o app .

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/app .

EXPOSE 8080
ENTRYPOINT ["/app"]
