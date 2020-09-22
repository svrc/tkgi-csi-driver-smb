# Tanzu Kubernetes Grid Integrated (TKGI) / PKS Addon for [SMB](https://wiki.wireshark.org/SMB) file sharing

## What does this do?

This will ensure that TKGI/PKS clusters can use **SMB file shares via StorageClass or PeristentVolume** with two benefits over the usual DaemonSet-based CSI deployment
* **No requirement to enable privileged mode**.   It runs the CSI controller as a Kubernetes Deployment, but runs the node agent as a BOSH job directly on the Docker runtime (which is always privileged-capable).
* **No requirement for container registry or internet access**.  It includes the images in this BOSH release, for airgapped environments.

That said, **you probably should use the DaemonSet-based drivers** and enable privileged access + Pod Security Policies (and/or OpenPolicyAgent) on your Kubernetes cluster, and if you're airgapped, copy the images and retag them.   It's the more standardized way to installing CSI, and easier to understand than the nuances of BOSH.   

This version exists mostly for those who aren't ready to do that and are willing to deal with the update lag and/or potential quirks.  I will make reasonable efforts to keep this up to date with the [upstream](https://github.com/kubernetes-csi/csi-driver-smb) but I don't have a formal SLO.

## How do I install it?

1. Open a shell prompt on a BOSH CLI with access to your PKS bosh director, such as Ops Manager.
2. Export your BOSH credentials to the enviornment.  These can be accessed via the Ops Manager GUI -> BOSH Director Tile -> Credentials Tab -> Bosh Commandline Credentials.

e.g.
```
export BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET=fakesecret BOSH_CA_CERT=/var/tempest/workspaces/default/root_ca_certificate  BOSH_ENVIRONMENT=10.0.0.10
```
3. Download the BOSH release from this GitHub releases page, and copy to your BOSH CLI enviornment, uploading it.

```
bosh upload-release https://github.com/svrc/tkgi-csi-driver-smb/releases/download/0.3.0/tkgi-csi-driver-smb-0.3.1.tgz # IF you have internet acccess
```
or if airgapped
```
wget https://github.com/svrc/tkgi-csi-driver-smb/releases/download/0.3.1/tkgi-csi-driver-smb-0.3.1.tgz 
# copy it this file to your BOSH CLI workstation and then run:
bosh upload-release tkgi-csi-driver-smb-0.3.1.tgz
```
4. Configure the addon from this repo
```
cd ..
bosh -n update-config --name=tkgi-csi-driver-smb --type=runtime ./addon.yml
```
5. Update your PKS clusters via the PKS CLI and/or Ops Manager "Apply Pending Changes" button with the PKS upgrade errand enabled.  This addon will automatically be installed on all master and worker nodes with the default manifest `addon.yml`

