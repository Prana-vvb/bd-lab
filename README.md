```bash
docker build --build-arg username=<your srn in lowercase> --build-arg password=<your password> -t bdlab .
```

```bash
docker run -it --rm -v bdata:/home -p 9870:9870 -p 8088:8088 -p 9864:9864 bdlab:latest
```
