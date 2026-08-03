# Alog GitHub CI environment

The GitHub-only `abuild-gh` branch extends the Abuild integration branch with
CI and Pages configuration. The three long-lived branches have distinct
roles:

- `master` mirrors the Codelabs upstream repository.
- `abuild` mirrors the branch consumed by Abuild.
- `abuild-gh` adds only files below `.github/` to `abuild`.

The `run` helper builds a minimal Debian Trixie image and starts it as the
invoking host user. Its root filesystem is read-only, its network is disabled
after the image build, and the repository is mounted read-write at `/work`.
GitHub Actions and local development use the same entry point.

Run the complete build and test sequence from the Alog repository root:

```sh
.github/ci/run /bin/sh -c '
  set -eu
  make clean
  make -j8 NUM_CPUS=8
  make -j8 NUM_CPUS=8 LIBRARY_KIND=static
  make -j8 NUM_CPUS=8 tests
'
```

Build the HTML documentation with:

```sh
.github/ci/run /bin/sh -c 'set -eu; make doc'
```

With no command, `run` opens an interactive shell in `/work`:

```sh
.github/ci/run
```

Set `ALOG_CI_IMAGE` to override the local image name and `DOCKER_PLATFORM` to
override the default `linux/amd64` platform.

The weekly upstream monitor compares both `master` and every Codelabs `v*`
release-tag ref with this GitHub mirror. Missing, additional or moved release
tags fail the workflow for manual review; the workflow never updates tags.
