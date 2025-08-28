Comes installed with

- [x] Hadoop v3.6.6
- [x] Hive v3.1.3
- [ ] Spark
- [ ] Kafka

> [!NOTE]
> The mentioned tools/applications may or may not be used in the course.
> These are what I assume will be used.
> The list will be updated accordingly as more lab sessions are conducted

## Build

Required to run only once unless changes made to `config/` or the Dockerfile

```bash
docker build --build-arg username=<your srn in lowercase> --build-arg password=<your password> -t bdlab .
```

## To start

```bash
docker run -it --rm -h <your srn as given in usernme> -v bdata:/home -p 9870:9870 -p 8088:8088 -p 9864:9864 bdlab:latest
```

Follow Step 4 onwards from [Hadoop installation guide](https://pesubigdata2025.super.site/hadoop-installation-guide)

> [!NOTE]
> If rebuilding, (due to updates to the Dockerfile)
> you may have to remove the volume(`docker volume rm bdata`) and create a new one as the changes will be overwritten by the volume.
>
> Thus, it is recommended to temporarily create a copy of what you want to keep using `docker cp <Container ID>:/path/to/files /path/in/host/machine`
> and then copy it back to the container.
>
> You can find the container ID using `docker ps`
