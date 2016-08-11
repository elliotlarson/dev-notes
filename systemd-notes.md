# Systemd Notes

## Location of a unit file

Unit files are the configuration file for services, sockets, etc.

The primary location is `/lib/systemd/sytem`.  Files in this directory are overloaded by files located in `/etc/systemd/system`.

## Commands

#### Enabling a service

This does not start the service. This just makes it possible to manage a service.

```bash
$ sudo systemctl enable puma.service
```

#### Starting a service

```bash
$ sudo systemctl start puma.service
```

#### Getting the status of a service

```bash
$ sudo systemctl status puma.service
```

#### Stopping a service

```bash
$ sudo systemctl stop puma.service
```

#### Reload after updating a configuration file

If you update a configuration file, you will need to reload the systemd daemon:

```bash
$ sudo systemctl daemon-reload
```

#### Getting log output for a service

```bash
$ sudo journalctl -u puma
```
