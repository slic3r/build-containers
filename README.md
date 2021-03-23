# Slic3r Container Images

This repository contains a submodule and the relevant Dockerfile container images to pre-build a functioning compilation environment on Linux with [Docker](https://www.docker.com/) or [podman](podman.io).

These images are available on [Docker Hub](https://hub.docker.com/repository/docker/slic3r/appimage-build).
 
## Usage

Note: these commands run the same with podman 3.0.1 or newer; just replace `docker` for `podman`

1. Clone this repository with submodules.
```bash
git clone --recurse-submodules git@github.com:slic3r/build-containers.git
```
2. Copy slic3r/deps to the directory of the container you want to build.
```bash
cp -R slic3r/deps appimage-base/slic3r/deps
```
3. Build the container. 
```bash
docker build -t slic3r-appimage-base appimage-base
```
4. Start the container in interactive mode, mounting the /build directory and /source to a suitable output directory and where the [Slic3r source code](https://github.com/slic3r/Slic3r) is checked out. 
```bash
docker run --rm -it -v /build:/path/to/build/output -v /source:/path/to/Slic3r/source slic3r-appimage-base
```
5. In the container, run `cmake` to configure the build directory and start the build. You can pass higher numbers to `-j` to build in more parallel workers.
```bash
cmake -DCMAKE_PREFIX_PATH=${1}/usr/local -DSLIC3R_STATIC=1 /source
make -j4 Slic3r
``` 

## Images

* `docker.io/slic3r/slic3r-appimage-build`
    * Prebuilt dependencies on Ubuntu Bionic (18.04 LTS)
    * Suitable for static linking for Slic3r builds.
    * Dependencies are located in `/opt/dependencies/usr/local` prefix for CMake.
* `docker.io/slic3r/ubuntu-build`
    * Suitable for building dynamically-linked dependencies for Slic3r on Debian (stable/testing/sid)
* `docker.io/slic3r/debian-build`
    * Suitable for building dynamically-linked dependencies for Slic3r on Debian (stable/testing/sid)
* `docker.io/slic3r/fedora-build`
    * Fedora-based container with Slic3r dependencies installed from pacakge manager. 
    * Suitable for building dynamically-linked dependencies for Slic3r on Fedora. 
