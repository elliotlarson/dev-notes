# Chia Notes

## Open port

On your farmer, get your IP address:

```bash
$ ip a
```

On your internet router, setup port forwarding for 8444 -> <farmer-IP>

On your farmer, open the port in your firewall:

```bash
$ sudo ufw allow 8444/tcp
```

Use an online port checking website to verify that your `8444` port is open.

## Mounting Hard Drives

```bash
# Internal drives
$ sudo mount /dev/sdc /mnt/hdd

# SSDs for plotting
$ sudo mount -t xfs -o discard /dev/sdb /mnt/ssd
$ sudo mount -t xfs -o discard /dev/sda /mnt/ssd2

# External drives
$ sudo mount -t nfs 169.254.250.65:/volume1/volume1shared /mnt/chchchchia-volume1
$ sudo mount -t nfs 169.254.250.65:/volume2/volume2shared /mnt/chchchchia-volume2
$ sudo mount -t nfs 169.254.250.65:/volume3/volume3shared /mnt/chchchchia-volume3
$ sudo mount -t nfs 169.254.250.65:/volume4/volume4shared /mnt/chchchchia-volume4
$ sudo mount -t nfs 169.254.250.65:/volume5/volume5shared /mnt/chchchchia-volume5
```

## Commands

* `chia init` – Migrates files from an old version to the latest version after an update
* `chia start node` – Starts node only
* `chia start node -r` – Restarts the node
* `chia start farmer` – Starts the farmer, harvester, bode, and wallet
* `chia start farmer -r` – Restarts everything
* `chia plots check` – Checks all plot files
* `chia show -s` – Show status of node
* `chia farm summary` – Show summary of the farmer
* `chia wallet show` – Show wallet data
* `chia keys generate` – Generate keys
* `chia keys add` – Add keys / seed
* `chia stop -d all` – Turn off all Chia services
* `chia netspace` – Show the current size of the network
* `chia version` – Shows the current chia version
* `chia configure --set-log-level INFO` - Setting the log level to info

## Read Logs

```bash
$ tail -f -n 5000 ~/.chia/mainnet/log/debug.log
```
