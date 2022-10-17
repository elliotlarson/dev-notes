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

You can list available local hard drives to mount with:

```bash
$ lsblk
```

You need to make sure you have mount directories for the drives:

```bash
$ mkdir /mnt/hdd
$ mkdir /mnt/hdd2
$ mkdir /mnt/ssd
$ mkdir /mnt/ssd2
$ mkdir /mnt/chchchia-volume1
$ mkdir /mnt/chchchia-volume2
$ mkdir /mnt/chchchia-volume3
$ mkdir /mnt/chchchia-volume4
$ mkdir /mnt/chchchia-volume5
```

Then you can mount the drives:

```bash
# Internal drives
$ sudo mount /dev/sdb /mnt/hdd
$ sudo mount /dev/sdd /mnt/hdd2

# SSDs for plotting
$ sudo mount -t xfs -o discard /dev/sda /mnt/ssd
$ sudo mount -t xfs -o discard /dev/sdc /mnt/ssd2

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
* `chia show -c` – Show connections
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

## Plotting

You can figure out how many cores your machine has with:

```bash
$ lscpu
```

Getting info about the madmax plotter:

```bash
$ chia plotters madmax -h
```

Get the farmer key with:

```bash
$ chia keys show
# Farmer: b4037a7138d5757e62c4494bce69199faf7a9cd79aa71c+++++++++++++++++++++++++++
```

Get the pool contract address:

```bash
$ chia plotnft show
# Pool contract: xch1sff6x4292lh6l4mxx7s4egz7vt8++++++++++++++++++++
```

You can get information about the hard drives on your machine:

```bash
$ sudo lshw -class disk -class storage
# tmpdir = /mnt/ssd
# final dir = /mnt/hdd
```

Plotting with madmax:

* -k = size
* -r = threads (1 per core)
* -n = number of plots
* -t = tmp directory
* -d = final directory
* -f = farmer key
* -c = contract address

```bash
$ chia plotters madmax -k 32 -r 24 -n 1 -t /mnt/ssd -d /mnt/hdd -f <farmer-key> -c <contract-address>
```
