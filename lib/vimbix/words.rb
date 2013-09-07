class VIMbix < Sinatra::Base

  configure do
    set :api_words, %w(
      apitype
      apiversion
      build
      fullname
      name
      version
      timestampcheck
      status
    )

    set :host_words, %w(
      hostname
      product
      hardwaremodel
      cpumodel
      cpumhz
      cpucore
      cpuusage
      totalcpusize
      cpuusagepercent
      totalmemorysize
      memoryusage
      memoryusagepercent
      powerstate
      maintenancemode
      uptime
      overallstatus
      pathstateactive
      pathstatedead
      pathstatedisabled
      pathstatestandby
      pathstateunknown
    )

    set :datastore_words, %w(
      name
      capacity
      capacityfree
      capacityused
      capacityusedpercent
      accessible
      maintenancemode
      type
      vmcount
      vmlist
    )

    set :virtualmachine_words, %w(
      name
      runninghost
      powerstate
      guestfullname
      hostname
      ipaddress
      vmwaretools
      maxcpuusage
      numcpu
      overallcpuusage
      memorysize
      hostmemoryusage
      guestmemoryusage
      uncommittedstorage
      provisionedstorage
      usedstorage
      unsharedstorage
      storagelocation
      percentusedstorage
      uptime
      overallstatus
      percentcpuusage
      balloonedmemory
      percentmemoryusage
      toolsinstallermounted
      consolidationeeded
      cleanpoweroff
      boottime
    )
  end

end
