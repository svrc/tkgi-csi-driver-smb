# Tanzu Kubernetes Grid Integrated (TKGI) / PKS Addon for [SMB](https://wiki.wireshark.org/SMB) file sharing

## What does this do?

This will ensure that TKGI/PKS clusters can use SMB file shares via StorageClass or PeristentVolume *without enabling privileged mode*.   It runs the CSI controller as a Deployment, but runs the node agent as a BOSH job directly on the Docker runtime (which is always privileged-capable).


## How do I install it?

1. Open a shell prompt on a BOSH CLI with access to your PKS bosh director, such as Ops Manager.
2. Export your BOSH credentials to the enviornment.  These can be accessed via the Ops Manager GUI -> BOSH Director Tile -> Credentials Tab -> Bosh Commandline Credentials.

e.g.
```
export BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET=fakesecret BOSH_CA_CERT=/var/tempest/workspaces/default/root_ca_certificate  BOSH_ENVIRONMENT=10.0.0.10
```
3. Copy or clone this repository onto this BOSH CLI workstation and create+upload the BOSH release to the director

```
git clone https://github.com/svrc/tkgi-csi-driver-smb && cd tkgi-csi-driver-smb
git submodule init ; git submodule update
cd docker-boshrelease
bosh create-release --force
bosh upload-release ./dev_releases/docker-boshrelease/docker-boshrelease.0.0+dev.1.yml
cd ../kubo-release
bosh create-release --force
bosh upload-release ./dev_releases/kubo-release/kubo-release.0.0+dev.1.yml

```
4. Configure the addon from this repo
```
cd ..
bosh -n update-config --name=tkgi-csi-driver-smb --type=runtime ./addon.yml
```
5. Update your PKS clusters via the PKS CLI and/or Ops Manager "Apply Pending Changes" button with the PKS upgrade errand enabled.  This addon will automatically be installed on all master and worker nodes with the default manifest `addon.yml`

