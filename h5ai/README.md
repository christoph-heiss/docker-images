# Docker image for h5ai

This packages [h5ai](https://larsjung.de/h5ai/) and required auxiliary services
(such as nginx) into a single, easy-to-use Docker image.

## Usage

Prebuilt Docker images can be found on [ghcr.io](https://github.com/christoph-heiss/docker-images/pkgs/container/h5ai).

Latest available version of h5ai is `0.30.0`.

Additionally, a `ghcr.io/christoph-heiss/h5ai:latest` image tag is available,
which always points to the most recently-built image

All files and folders under `/data` inside the container are displayed. Simply mount a
(read-only) volume into the container at `/data`.

### Security

There are no user accounts or similarly, meaning everyone who can access h5ai also
has access to all files.

Thus it should be put behind a authenticating reverse proxy, VPN access etc.
