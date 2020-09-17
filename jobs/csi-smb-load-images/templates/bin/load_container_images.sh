#!/usr/bin/env bash
set -eux
set -o pipefail


load_one_container() {
  image=$1

  local job_dir=${BOSH_JOB_DIR:-/var/vcap/jobs}
  local docker="${packages_dir}/docker/bin/docker"
  local DOCKER_SOCKET=unix:///var/vcap/sys/run/docker/docker.sock

  echo "loading cached container: ${image}"
  if sudo ${docker} -H ${DOCKER_SOCKET} load < "${image}"; then
    echo "successfully loaded container: ${image}"
  else
    echo "failed to load container: ${image}"
    exit 1
  fi
}

load_containers() {
  local packages_dir=${BOSH_PACKAGES_DIR:-/var/vcap/packages}
  local CONTAINER_IMAGE_DIR=${packages_dir}/csi-smb/container-images

  for img in ${CONTAINER_IMAGE_DIR}/*.{tgz,tar.gz,tar}; do
    # make sure that the file exists and is readable
    [[ -f "${img}" && -r "${img}" ]] || { echo "skiping $img because it does not exist"; continue; }
    load_one_container ${img}
  done
}

