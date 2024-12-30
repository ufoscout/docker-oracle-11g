# Oracle 11g Enterprise Edition Database Docker Image
A Docker image for **Oracle Database 11g Enterprise Edition Release 11.2.0.1.0** based on an Oracle Linux 7.1 image.

## Build Image
Due to legal restrictions, this image is not available on the Docker Hub. However, with some time and patience you may build it yourself.

### Build
Download the following zip files from [Oracle Tech Net](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/112010-linx8664soft-100572.html) and put them in the 'oracle-11g/installation_files/' folder:
 * `linux.x64_11gR2_database_1of2.zip`
 * `linux.x64_11gR2_database_2of2.zip`

Finally, from the 'oracle-11g' folder simply run:
```
$ docker build -t ufoscout/oracle-11g .
```
The build process could take long time to run; so, it is now the moment to have break and drink some good coffee...

## Run
Due to Docker limitations, this image must be run with the "privileged" flag. This is due to the amount of available memory on */dev/shm* which is limited to 64MB (see [#2606](https://github.com/docker/docker/issues/2606)). This is not sufficient to meet Oracle's *MEMORY_TARGET* minimum requirements.

**Please note that this limitation has been removed in Docker 1.10.**

Create a new container running an Oracle 12c database:
```
$ docker run --privileged -d ufoscout/oracle-11g
```

## Inspect
You can connect as SYSDBA with the following statement:
```
$ docker exec -ti containerName sudo -u oracle -i bash -c "sqlplus / AS SYSDBA"
```
This is particularly useful, if you don't want to expose any ports and solely rely on linking containers with each other directly.

## Acknowledgements
This image is largely based on the work of [Remo Arpagaus](https://github.com/arpagaus/docker-oracle-12c) for Oracle 12c.
