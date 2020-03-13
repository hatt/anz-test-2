# ANZx Technical Test 2

A microservice to expose an API built with httprouter to show the version of the project on port 8000.


## API Responses

The API will return the release version, git commit hash, and description of the app when a GET request
is made to the `/version` endpoint. The schema looks like the following:

```
"myapplication": [{
  "version": "dev",
  "lastcommitsha": "1234abc",
  "description" : "pre-interview technical test"
}]
```


## Versioning

Versioning is managed by git tags. On an untagged build, the version `dev` is used. Tagged builds
push a Docker image and versioned release to the GitHub image and source respositories.

The version is dynamically hard set at build time so that a misconfigured deployment won't show a different
version to what is actually released. This ensures the version running definitely points to the commit
that it was compiled from.


## CI Builds

Continuous Integration is managed by GitHub Actions, configured in the `.github/workflows/` directory.

GHA will test on push, and additionally release on new tags along with building the Docker image before
deploying to the GitHub Docker registry. Part of the CI process applies `go fmt` and `go vet` to ensure
good code style and make any apparent issues in code quality clearer.


## Dependencies

While the code itself has no user-installed dependencies, the build environment requires the following:

- Docker
- Git
- GNU Make

A development environment additionally needs Go 1.13 or later.


## Developing

To build, `make build` will suffice. There is also `make test` to run just the tests.

To release a new version, git tags are used, for example:

```
git tag v1.0 && git push --tags
```


## Productionisation and Risks

The app as currently built has no graceful error handling or even shutdown. Terminating the app will
simply drop any ongoing connections. A proper cancel context would solve this. Additionally, some
signal handling to instruct the app to shutdown would be advisable.

As far as application error handling goes, there is no proper catch or recovery. If the JSON encoder
errors, the user would currently receive an HTTP 200 status and unexpected output. Proper error catching
should be added, for both logging and presenting the API consumer with information they can use to debug.

The built Docker image is also running as privileged user, however if it isn't, then it wouldn't be able
to receive signals on PID 0. For this reason, the Distroless base image is used rather than Scratch.


## Deployments

The app is simply a Docker image and can be run in any Docker-capable environment. To start a container,
run the following:

```
docker run -p 8000:8000 docker.pkg.github.com/hatt/anz-test-2/anz-test-2:latest
```
