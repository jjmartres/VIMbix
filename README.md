VIMbix
======

###### [Introduction](https://github.com/jjmartres/VIMbix/blob/master/README.md#introduction)
###### [How it works](https://github.com/jjmartres/VIMbix/blob/master/README.md#how-it-works)
###### [Installation and configuration](https://github.com/jjmartres/VIMbix/blob/master/README.md#iInstallation-and-configuration)
###### [How to use it](https://github.com/jjmartres/VIMbix/blob/master/README.md#how-to-use-it)
###### [Zabbix template](https://github.com/jjmartres/VIMbix/blob/master/README.md#zabbix-template)
###### [Requirements](https://github.com/jjmartres/VIMbix/blob/master/README.md#requirements)
###### [Support](https://github.com/jjmartres/VIMbix/blob/master/README.md#support)
###### [Development](https://github.com/jjmartres/VIMbix/blob/master/README.md#development)
###### [Version](https://github.com/jjmartres/VIMbix/blob/master/README.md#version)
###### [Licence](https://github.com/jjmartres/VIMbix/blob/master/README.md#licence)

Introduction
------------
**VIMbix** is a **VMware** Virtual Infrastructure Methodology RESTfull proxy for [Zabbix](http://www.zabbix.com). Build on top of [Sinatra](http://www.sinatrarb.com), it accepts connection from Zabbix server and/or proxy and translates them to **VMware** API calls.
It can helps to manage large **VMware** infrastructure, with many ESX(i) and/or vCenter. The current release supports the [vSphere 5.0 API](http://pubs.vmware.com/vsphere-50/index.jsp#com.vmware.sdk.doc_50/GUID-19793BCA-9EAB-42E2-8B9F-F9F2129E7741.html).

How it works
------------
On a configured frequency, VIMbix query multiple VIServers (vCenter and/or ESX(i)) discover all virtual machines, datastores and hosts and build a dump file of all collected informations for each VIServers. This method prevent high load on large **VMware**  Virtual Infrastructure. Collected data are accessible through the **VMbix** RESTfull API. Collected informations and supported method are :

|  | Method                               | Description                           |
|:--:|:------------------------------------ |:------------------------------------- |
|[GET]|/:viserver/api/status          | VIMbix API VIServer last check status |
|[GET]|/:viserver/api/timestampcheck  | VIMbix API VIServer last check date   |
|[GET]|/:viserver/api/apitype         | VIServer api type                     |
|[GET]|/:viserver/api/apiversion      | VIServer api version                  |
|[GET]|/:viserver/api/build           | VIServer build version                |
|[GET]|/:viserver/api/fullname        | VIServer full name                    |
|[GET]|/:viserver/api/name            | VIServer name                         |
|[GET]|/:viserver/api/version         | VIServer version                      |
|[GET]|/:viserver/hosts               | Hosts discovery on VIServer           |
|[GET]|/:viserver/datastores          | Datastores discovery on VIServer      |
|[GET]|/:viserver/virtualmachines     | VirtualMachines discovery on VIServer |
|[GET]|/:viserver/host/:id/hostname | Host name                             |
|[GET]|/:viserver/host/:id/product | Information about the software running |
|[GET]|/:viserver/host/:id/hardwaremodel | The system model identification |
|[GET]|/:viserver/host/:id/cpumodel | CPU model |
|[GET]|/:viserver/host/:id/cpumhz | The speed of the CPU cores in Hz|
|[GET]|/:viserver/host/:id/cpucore | Number of physical CPU cores on the host |
|[GET]|/:viserver/host/:id/cpuusage | Aggregated CPU usage across all cores on the host in Hz |
|[GET]|/:viserver/host/:id/cpuusagepercent | Aggregated CPU usage across all cores on the host in % |
|[GET]|/:viserver/host/:id/totalmemorysize | The physical memory size in bytes |
|[GET]|/:viserver/host/:id/memoryusage | Physical memory usage on the host in bytes |
|[GET]|/:viserver/host/:id/memoryusagepercent | Physical memory usage on the host in % |
|[GET]|/:viserver/host/:id/powerstate | The host power state |
|[GET]|/:viserver/host/:id/maintenancemode | The host maintenance status |
|[GET]|/:viserver/host/:id/uptime | The system uptime of the host in seconds |
|[GET]|/:viserver/host/:id/pathstateactive | Number of active storage paths |
|[GET]|/:viserver/host/:id/pathstatedead | Number of dead storage paths |
|[GET]|/:viserver/host/:id/pathstatestandby | Number of standby storage paths |
|[GET]|/:viserver/host/:id/pathstatedisabled | Number of disabled storage paths |
|[GET]|/:viserver/host/:id/pathstateunknown | Number of unknown storage paths |
|[GET]|/:viserver/host/:id/overallstatus | The overall alarm status of the host |
|[GET]|/:viserver/datastore/:id/name | The name of the datastore |
|[GET]|/:viserver/datastore/:id/capacity | Maximum capacity of this datastore, in bytes |
|[GET]|/:viserver/datastore/:id/capacityfree | Available space of this datastore, in bytes |
|[GET]|/:viserver/datastore/:id/capacityused | Used space of this datastore, in bytes |
[GET]|/:viserver/datastore/:id/capacityusedpercent | Used space of this datastore, in % |
[GET]|/:viserver/datastore/:id/accessible | The connectivity status of this datastore |
[GET]|/:viserver/datastore/:id/type | Type of file system volume, such as VMFS or NFS of this datastore |
[GET]|/:viserver/datastore/:id/maintenancemode | The current maintenance mode state of this datastore |
|[GET]|/:viserver/datastore/:id/vmcount | Number of VirtualMachines stored on the datastore |
|[GET]|/:viserver/datastore/:id/vmlist | List of VirtualMachines stored on the datastore |
|[GET]|/:viserver/virtualmachine/:id/name | Name of the VirtualMachine |
|[GET]|/:viserver/virtualmachine/:id/vmwaretools | Current version status of VMware Tools in the guest operating system |
|[GET]|/:viserver/virtualmachine/:id/runninghost | The host that is responsible for running a virtual machine |
|[GET]|/:viserver/virtualmachine/:id/powerstate | The current power state of the virtual machine |
|[GET]|/:viserver/virtualmachine/:id/toolsinstallermounte | Indicate whether or not the VMware Tools installer is mounted as a CD-ROM on virtual machine |
|[GET]|/:viserver/virtualmachine/:id/consolidationneeded | Whether any disk of the virtual machine requires consolidation |
|[GET]|/:viserver/virtualmachine/:id/cleanpoweroff | For a powered off virtual machine, indicates whether the virtual machine's last shutdown was an orderly power off or not |
|[GET]|/:viserver/virtualmachine/:id/boottime | The timestamp when the virtual machine was most recently powered on |
|[GET]|/:viserver/virtualmachine/:id/guestfullname | Guest operating system name configured on the virtual machine |
|[GET]|/:viserver/virtualmachine/:id/hostname | Hostname of the guest operating system, if known |
|[GET]|/:viserver/virtualmachine/:id/ipaddress | Primary IP address assigned to the guest operating system, if known |
|[GET]|/:viserver/virtualmachine/:id/maxcpuusage | Current upper-bound on CPU usage in Hz|
|[GET]|/:viserver/virtualmachine/:id/overallcpuusage | Basic CPU performance statistics, in Hz |
|[GET]|/:viserver/virtualmachine/:id/percentcpuusage | CPU usage, in % |
|[GET]|/:viserver/virtualmachine/:id/numcpu |Number of processors in the virtual machine |
|[GET]|/:viserver/virtualmachine/:id/memorysize |Memory size of the virtual machine, in bytes |
|[GET]|/:viserver/virtualmachine/:id/hostmemoryusage |Host memory utilization statistics, in bytes |
|[GET]|/:viserver/virtualmachine/:id/guestmemoryusage | Guest memory utilization statistics, in bytes |
|[GET]|/:viserver/virtualmachine/:id/balloonedmemory | The size of the balloon driver in a virtual machine, in bytes |
|[GET]|/:viserver/virtualmachine/:id/percentmemoryusage | Guest memory utilization statistics, in % |
|[GET]|/:viserver/virtualmachine/:id/usedstorage | Total storage space, in bytes, committed to this virtual machine across all datastores |
|[GET]|/:viserver/virtualmachine/:id/percentusedstorage | Total storage space, in %, committed to this virtual machine across all datastores |
|[GET]|/:viserver/virtualmachine/:id/uncommittedstorage | Additional storage space, in bytes, potentially used by this virtual machine on all datastores |
|[GET]|/:viserver/virtualmachine/:id/provisionedstorage | Total storage space, in bytes, provisioned to the virtual machine on all datastores |
|[GET]|/:viserver/virtualmachine/:id/unsharedstorage | Total storage space, in bytes, occupied by the virtual machine across all datastores, that is not shared with any other virtual machine |
|[GET]|/:viserver/virtualmachine/:id/storagelocation | Path name to the configuration file for the virtual machine | 
|[GET]|/:viserver/virtualmachine/:id/uptime | The system uptime of the VitualMachine in seconds |
|[GET]|/:viserver/virtualmachine/:id/overallstatus | Overall alarm status on this VirtualMachine |

Installation and configuration
------------------------------

1. Make sure that your system meets recommended system [requirements](https://github.com/jjmartres/VIMbix/blob/master/README.md#requirements)
2. Install **VIMbix** in the **ExternalScripts** directory of your Zabbix server and/or proxy. Check your `zabbix_server.conf` and/or `zabbix_proxy.conf` if in doubt

  ```
  git clone https://github.com/jjmartres/VIMbix.git
  ```
3. Install dependencies

  ```
  cd VIMbix
  bundle install
  ```
4. Deploy VIMbix client

  ```
  rake install:client <your-zabbix-externalscripts-path-here>
  ```
5. (Optional) Install init script (Debian or Ubuntu)

  ```
  rake install:initscript
  ```

6. Edit `config/vimbix.yml` configuration file to change bind address and/or listen port.

  ```YAML
  ---
      environment: production
      rackup: config.ru
      address: 0.0.0.0
      port: 9090
      pid: var/run/vimbix.pid
      log: var/log/vimbix.log
      max_conns: 1024
      timeout: 30
      server: 1
      max_persistent_conns: 512
      daemonize: true
  ```

7. Edit `config/viservers.yml` configuration file to add your VIServers

  ```YAML
  # list all your VIServer (vCenter and/or ESX(i) hosts)
  1:
      hostname: 10.0.1.1                              # VIServer IP address or fqdn
      username: username                              # VIServer username
      password: 'password'                            # VIServer password
      frequency: 300s                                 # VIServer check frequency. Supported format: 300s, 5m
      timeout: 280s                                   # VIServer check frequency. Supported format: 280s, 4m
  2:
      hostname: 172.254.3.24                          # VIServer IP address or fqdn
      username: username                              # VIServer username
      password: 'password'                            # VIServer password
      frequency: 300s                                 # VIServer check frequency. Supported format: 300s, 5m
      timeout: 280s                                   # VIServer check frequency. Supported format: 280s, 4m
  ```

8. Import **zbx-vimbix.xml** file into Zabbix
9. Add to your host the followed macro with value **{$VIMBIX\_ADDRESS}** and **{$VIMBIX\_PORT}** (default value is 9090)
10. Associate **ZBX-VIMBIX** template to your VIServer on Zabbix


How to use it
-------------

###### VIMbix server

```
rake clean               # Remove any temporary products
rake clobber             # Remove any generated file
rake daemon:restart      # Restart VIMbix daemon
rake daemon:start        # Start VIMbix daemon
rake daemon:status       # Status of VIMbix daemon
rake daemon:stop         # Stop VIMbix daemon
rake install:client      # Install VIMbix client into Zabbix external script directory
rake install:initscript  # Deploy init script (Debian or Ubuntu)
rake version             # Show VIMbix version
````

###### VIMbix client

```
vimbix-client -u <vimbix-restfull-uri>
```

Zabbix template
---------------
###### Items

  * VIMbix last check status
  * VIMbick last check
  * VIServer product
  * VIServer API version
  * VIServer API type
  * Discovery : Memory usage (%) on each host
  * Discovery : Memory usage (B) on each host
  * Discovery : CPU usage (%) on each host
  * Discovery : CPU usage (Hz) on each host
  * Discovery : Number of active storage paths on each host
  * Discovery : Number of unknown storage paths on each host
  * Discovery : Number of disabled storage paths on each host
  * Discovery : Number of standby storage paths on each host
  * Discovery : Total memory size on each host
  * Discovery : Total CPU size on each host
  * Discovery : Overall status on each host
  * Discovery : Uptime on each host
  * Discovery : Hardware model for host
  * Discovery : CPU cores speed on each host
  * Discovery : Number of physical CPU cores on each host
  * Discovery : Maintenance status on each host
  * Discovery : Power state on each host
  * Discovery : Software version on each host
  * Discovery: Capacity (B) for each datastore
  * Discovery: Free capacity (B) for each datastore
  * Discovery: Number of virtual machines on each datastore
  * Discovery: Used capacity (%) for each datastore
  * Discovery: Used capacity (B) for each datastore
  * Discovery: Accessibility for each datatstore
  * Discovery: maintenance mode for each datastore
  * Discovery: filesystem type for each datastore
  * Discovery: Ballooned memory (B) on each virtual machine
  * Discovery: Last boot time for on each virtual machine
  * Discovery: Last shutdown orderly power off status for on each virtual machine
  * Discovery: Disk(s) consolidation needed on each virtual machine
  * Discovery: Memory usage (B) on guest for on each virtual machine
  * Discovery: Memory usage (B) on host for on each virtual machine
  * Discovery: Primary IP address for on each virtual machine
  * Discovery: Total CPU size (Hz) on each virtual machine
  * Discovery: Total memory size (B) for on each virtual machine
  * Discovery: Number of vCPU on each virtual machine
  * Discovery: CPU usage (Hz) on each virtual machine
  * Discovery: Overall alarm status on each virtual machine
  * Discovery: CPU usage (%) on each virtual machine
  * Discovery: Memory usage (%) on guest for on each virtual machine
  * Discovery: Used storage (%) on each virtual machine
  * Discovery: Power state for each virtual machine
  * Discovery: Provisioned storage (B) on each virtual machine
  * Discovery: Host responsible for running each virtual machine
  * Discovery: Storage location for each virtual machine
  * Discovery: Tools installer CD mounted status on each virtual machine
  * Discovery: Uncommited storage (B) on each virtual machine
  * Discovery: Unshared storage (B) on each virtual machine
  * Discovery: Uptime for each virtual machine
  * Discovery: Used storage (B) on each virtual machine
  * Discovery: VMware tools version on each virtual machine

###### Triggers

  * **[DISASTER]** Discovery: host power state is not ON
  * **[DISASTER]** Discovery: host is DOWN or UNREACHABLE
  * **[DISASTER]** Discovery: datastore is not accessible
  * **[HIGH]** VIMbix check has failed
  * **[HIGH]** Discovery: memory usage exceed 95% on host
  * **[HIGH]** Discovery: CPU usage exceed 90% on host
  * **[HIGH]** Discovery: host has a problem (overall status)
  * **[HIGH]** Discovery: storage paths into DEAD state on host
  * **[HIGH]** Discovery: used capacity exceed 85% on datastore
  * **[HIGH]** Discovery: ballooned memory on each virtual machine
  * **[HIGH]** Discovery: CPU usage exceed 90% on each virtual machine
  * **[HIGH]** Discovery: memory usage exceed 95% on each virtual machine
  * **[AVERAGE]** Discovery: maintenance mode is enabled on host
  * **[AVERAGE]** Discovery: host might have a problem
  * **[AVERAGE]** Discovery: disk(s) consolitdation needed on each virtual machine
  * **[AVERAGE]** Discovery: virtual machine might have a problem
  * **[WARNING]** Discovery: memory usage exceed 90% on host
  * **[WARNING]** Discovery: CPU usage exceed 75% on host
  * **[WARNING]** Discovery: storage paths into UNKNOWN state on host
  * **[WARNING]** Discovery: used capacity exceed 75% on datastore
  * **[WARNING]** Discovery: memory usage exceed 75% on virtual machine
  * **[WARNING]** Discovery: VMware Tools CD is mounted on virtual machine
  * **[WARNING]** Discovery: VMware tools is outdated on virtual machine
  * **[INFORMATION]** Discovery: host has just been restarted

###### Graphs

  * Discovery : Memory usage on host
  * Discovery : CPU usage on host
  * Discovery : Capacity usage on datastore
  * Discovery : CPU usage on virtual machine
  * Discovery : memory usage on virtual machine
  * Discovery : storage usage on virtual machine

Requirements
------------
This script was tested for :

- Zabbix 2.0.0 or higher.
- **VMware** vSphere 5.x
- **VMware** ESX(i) 5.x


###### [Ruby](http://www.ruby-lang.org/en/downloads/) 1.8.7

This script require Ruby 1.8.7 or higher.

###### [RubyGems](http://rubygems.org) 1.8

This script require RubyGems 1.8 or higher.

###### [Bundler](http://bundler.io) 1.3

This script require Bundler 1.3 or higher.

Support
-------
Please do not send me an email for support on **VIMbix**. Open an [issue](https://github.com/jjmartres/VIMbix/issues/new) on Github.

Development
-----------
Fork the project on Github and send me a merge request, or send a patch to jjmartres@gmail.com.

Version
-------
Version 1.0.5

License
-------
This script is distributed under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

### Copyright

  Copyright (c) Jean-Jacques Martrès

### Authors

  Jean-Jacques Martrès
  (jjmartres |at| gmail |dot| com)
