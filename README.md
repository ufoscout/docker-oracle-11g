# Oracle 12c Database Docker Image
A Docker image for [Oracle Database 12c Enterprise Edition Release 12.1.0.2.0](http://www.oracle.com/technetwork/database/enterprise-edition/overview/index.html) based on an Oracle Linux 7.1 image.

## Build Image
Due to legal restrictions this image is not available on the Docker Hub. However, with some time and patience you may build it yourself. 

### Build
Be sure you've read the [prerequisites](#prerequisites), then download the following zip files from [Oracle Tech Net](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-2240591.html) and put them in the build's root folder:
 * `linuxamd64_12102_database_1of2.zip`
 * `linuxamd64_12102_database_2of2.zip` 

Finally, simply run:
```
$ docker build -t arpagaus/oracle-12c .
```

### Prerequisites
Due to Docker limitations this image cannot be built using the stock binary. Within containers the amount of available memory on */dev/shm* is limited to 64MB (see [#2606](https://github.com/docker/docker/issues/2606)). This is not sufficient to meet Oracle's *MEMORY_TARGET* minimum requirements.
If you are not comfortable building and using a modified docker binary let me assure you that the steps are well [documented](https://docs.docker.com/project/set-up-dev-env/) and straight-forward.
If you're still not convinced I'd recommend https://github.com/wscherphof/oracle-12c instead which relies on some manual steps and the use of *--privileged* as a workaround.

You may refer to https://github.com/arpagaus/docker for a modified Docker v1.5.0 repository which increases /dev/shm to 2GB

## Run
Create a new container running an Oracle 12c database:
```
$ docker run -dP arpagaus/oracle-12c
```

## Inspect
You can connect as SYSDBA with the following statement:
```
$ docker exec -ti evil_blackwell sudo -u oracle -i bash -c "sqlplus / AS SYSDBA"
```
This is particularly useful, if you don't want to expose any ports and solely rely on linking containers with each other directly. 

## Acknowledgements
This image is largely based on the work of [Wouter Scherphof](https://github.com/wscherphof)

## Known issues
### Updating Oracle Linux
When installing packages on the Oracle Linux container using *yum* an error might occur. As a workaround I've published an updated version of the Oracle Linux 7.1 image arpagaus/oraclelinux.

## License
[GNU General Public License (GPL)](https://www.gnu.org/licenses/gpl-2.0.txt) for the contents of this GitHub repo; for Oracle's database software, see their [Licensing Information](http://docs.oracle.com/database/121/DBLIC/toc.htm)

