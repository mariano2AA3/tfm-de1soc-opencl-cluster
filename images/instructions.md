
# Instalation

## Author

Mariano Hernández García

Creation date: 29/03/2017

### 1) Download and extract

Download all parts.

To extract them, you should first collect the files together:
``` 
 cat Linux_debian8_3.13_OpenCLRTE16_marianoh_v2._split.gz* | zcat > Linux_debian8_3.13_OpenCLRTE16_marianoh_v2.zip
```

And then, you can simply unzip:
```
 unzip Linux_debian8_3.13_OpenCLRTE16_marianoh_v2.zip
```


### 2) copy img file to microSD

**Linux**: Use dd command
```
sudo dd if=Linux_debian8_3.13_OpenCL_RTE_16_marianoh_v2.img of=/dev/sdX bs=1M status=progress

where sdX is the path to microSD (use lsblk command)
```

**Windows**: Use Disk Imager Utility


### 3) Config DE1-SOC switches

Set MSEL[5:0]=101010


### 4) Connect DE1-SOC and PC with UART-TO-USB adapter

**Linux:**

```
sudo screen /dev/ttyUSB0 115200
```

**Windows**:

Install the  _uart-to-usb device driver_ showed in the  _DE1-SOC Getting Started Guide_, available on Internet.

Launch Putty, with a  _baud rate_ of 115200.

### 5) Power ON the DE1-SOC

* user:  root
* password: debiandebian


The network is auto configured by DHCP protocol. To show the IP address, execute:
```
ifconfig
```


### 6) Launch OpenCL programs

Follow the steps content in /root/README file:

```
cat README
```
