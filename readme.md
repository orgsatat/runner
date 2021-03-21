# vps

This repository contains script to configure and setup a ubuntu 20.04 vps for
variety of purposes related to software development processes.

## Installation

```
./bin/install $INSTALL_PREFIX
```

## Steps to Setup a VPS

1. Build a VPS with one of the following instances:
    a. DISTRIBUTION=Ubuntu RELASE=20.04
2. Set a root password in web interface.
3. Set SSH Key in the web interface.
4. Run

```
satat.setup.vps $DISTRIBUTION $RELEASE $TARGET_HOSTNAME $PORT $USERNAME
```

