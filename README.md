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
