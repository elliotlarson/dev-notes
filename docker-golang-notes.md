# Docker Golang Notes

## Build a Golang app image

Say you have an Echo app

`server.go`

```go
package main

import (
	"net/http"

	"github.com/labstack/echo"
)

func main() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, from Echo!")
	})
	e.Logger.Fatal(e.Start(":1323"))
}
```

And you have a Dockerfile:

`Dockerfile`

```dockerfile
FROM golang:1.11.4-alpine
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    bash \
    git \
    openssh
WORKDIR /go/src/golang-hello-world
COPY . .
RUN go get -u github.com/labstack/echo/...
RUN go install -v ./...
EXPOSE 1323
CMD ["golang-hello-world"]
```

You can build the image with:

```bash
$ docker image build -t nginx-with-html .
```

And, you can run the container from the image with:

```bash
$ docker run -it --rm -p 80:1323 --name my-running-app golang-hello-world
```

Add to Docker Hub.

You may need to login first:

```bash
$ docker login
```

Tag the image:

```bash
$ docker tag golang-hello-world elliotlarson/golang-hello-world
```

Push the repository to Docker Hub:

```bash
$ docker push elliotlarson/golang-hello-world
```
