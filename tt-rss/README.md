# Docker image for tt-rss

This packages [tt-rss](https://tt-rss.org/) and required auxiliary services
(such as nginx) into a single, easy-to-use Docker image.

## Prerequisites

A working PostgreSQL installation is needed for tt-rss. A user and database for
tt-rss must already exist and **are not created automatically**.

## Usage

Prebuilt Docker images can be found on [ghcr.io](https://github.com/christoph-heiss/docker-images/pkgs/container/tt-rss).

Since tt-rss does not adhere to proper release{s,-cycles}, the images are tagged by
builddate and git-commit-hash of tt-rss (and both). Thus, the same image is available as e.g.
`ghcr.io/christoph-heiss/tt-rss:2022-10-31`, `ghcr.io/christoph-heiss/tt-rss:602e86842`
and `ghcr.io/christoph-heiss/tt-rss:2022-10-31-602e86842`.

Additionally, a `ghcr.io/christoph-heiss/tt-rss:latest` image tag is available,
which always points to the most recently-built image.

### Configuring using environment variables

Following environment variables must be correctly set up for the container:

- `TTRSS_DB_HOST`: Hostname/address under which the PostgreSQL server can be reached
- `TTRSS_DB_PORT`: Port on which PostgreSQL is running, defaults to `5432`
- `TTRSS_DB_USER`: Username of the databaso user to use
- `TTRSS_DB_PASS`: Authentication password for the database user
- `TTRSS_DB_NAME`: Database name to use, defaults to `TTRSS_DB_USER`
- `TTRSS_SELF_URL_PATH`: Full URL through which tt-rss gets accessed (i.e. `ttrss.example.com`)
