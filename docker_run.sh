IMAGE_NAME=$1; shift
WORK_BASE_DIR=$1; shift

FULL_IMAGE_NAME=neuralegion_workspace

GIT_UNAME=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)

CONTAINER_ID=$(docker run -dt --rm \
  -e IMAGE_NAME=$IMAGE_NAME \
  -e GIT_AUTHOR_NAME="$GIT_UNAME" \
  -e GIT_COMMITTER_NAME="$GIT_UNAME" \
  -e GIT_AUTHOR_EMAIL="$GIT_EMAIL" \
  -e GIT_COMMITTER_EMAIL="$GIT_EMAIL" \
  --network host \
  --security-opt seccomp=unconfined \
  --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp:/tmp \
  -v $WORK_BASE_DIR:/root/developer/neuralegion \
  -v ~/.ssh:/root/developer/.ssh \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/localtime:/etc/localtime:ro \
  $FULL_IMAGE_NAME)

docker exec -it $CONTAINER_ID /bin/bash