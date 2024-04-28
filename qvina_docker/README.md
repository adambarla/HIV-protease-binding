# Problem

Unfortunately, `qvina` is not currently supported for macOS with `arm64` architecture (M chips).

If you are also using macOS with `arm64` architecture this code is for you.

Before starting, you can check if the issue has been fixed
 [here](https://github.com/ccsb-scripps/AutoDock-Vina/issues/84) or [here](https://github.com/dmlc/dgl/issues/3915). Or you can try compiling it yourself from source [here](https://github.com/QVina/qvina) by following their instructions. I had no luck with this.

# Workaround

The workaround is to use `docker`.
The speed of the calculations will be much slower, but at least it will work.

Run the following commands in this directory.

```bash
docker compose up -d
docker compose exec qvina bash
```
