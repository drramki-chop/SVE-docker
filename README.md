# Docker for SVE/ FusorSV

Dockerfile for building SVE

The Dockerfile provided in the original FusorSV fails during the build. Here's the one tested with Docker v18.03.1

## Some notes

* This image requires >10GB image size (ROOT + all the tools in the SVE)

* Docker memory requirements to be increased. The basic setting of 2Gb throws an `error code 137` while building. This is essentially an `out of memory` error while compiling ROOT.

* The Docker image size is ~12GB now. This could be reduced by removing some source files or try docker-slim.
