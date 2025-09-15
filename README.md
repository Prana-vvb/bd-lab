Comes installed with

- [x] Hadoop v3.6.6
- [x] Hive v3.1.3
- [x] Flume v1.11.0
- [x] Pig v0.17.0
- [ ] Sqoop v1.4.7

> [!NOTE]
> The list will be updated accordingly as more lab sessions are conducted

# Linux

```bash
chmod +x setup.sh
./setup.sh
```

```bash
docker run -it --rm -h <srn> -v bdata:/home/<srn>/Desktop -p 9870:9870 -p 8088:8088 -p 9864:9864 -p 8032:8032 bdlab:latest
```

Make sure to store any files you want saved in `Desktop`

# Windows

## Prerequisites

Download the following into the `installers` directory
 - [Hadoop](https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz) 
 - [Hive](https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz) 
 - [Flume](https://downloads.apache.org/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz) 
 - [Pig](https://dlcdn.apache.org/pig/pig-0.17.0/pig-0.17.0.tar.gz) 
 - [Sqoop](https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz ) 
 - [JDBC](https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-9.4.0.tar.gz ) 
 - [Commons-lang](https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar)

## Build

Required to run only once unless changes made to `config/` or the Dockerfile

```bash
docker build --no-cache --build-arg username=<your srn in lowercase> -t bdlab .
```

## To start

```bash
docker run -it --rm -h <srn> -v bdata:/home/<srn>/Desktop -p 9870:9870 -p 8088:8088 -p 9864:9864 -p 8032:8032 bdlab:latest
```

> [!NOTE]
> If rebuilding, (due to updates to the Dockerfile)
> you may have to remove the volume(`docker volume rm bdata`) and create a new one as the changes will be overwritten by the volume.
>
> Thus, it is recommended to temporarily create a copy of what you want to keep using `docker cp <Container ID>:/path/to/files /path/in/host/machine`
> and then copy it back to the container.
>
> You ccan find the container ID using `docker ps`
