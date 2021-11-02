# workspace

1. Specify work_base_dir with is path to the sources at Makefile
2. make build
3. make run
4. run ssh agent inside the container
```
eval `ssh-agent -s`
ssh-add -k ~/developer/.ssh/id_rsa
```
You can use prebuild docker image with crystal 1.1.1 https://hub.docker.com/repository/docker/pavelzh/neuralegion_workspace

Note! If you have built binaries (e.g shards) on the host OS, don't forget to rebuild it when you will be inside the container.
