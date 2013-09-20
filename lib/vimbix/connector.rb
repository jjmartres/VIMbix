class Connector < RbVmomi::VIM
  def initialize(host, user, pass, logger)
    @host = host
    @user = user
    @pass = pass
    @logger = logger
  end

  def collect

    beginning_time = Time.now

    container = Hash.new
    [ "viserver", "hosts", "datastores", "virtualmachines"].each do |a|
      container[a] = {}
    end

    # by default, we consider that check has failed
    container["viserver"]["status"] = "FAILED"
    container["viserver"]["timestampcheck"] = "#{Time.now.utc.to_i}"
    container["viserver"]["collectionduration"] = "#{(Time.now - beginning_time).to_i}"

    # check if vCenter port (TCP 443) is reachable
    begin
      Timeout::timeout(30) do
        begin
          TCPSocket.new(@host, 443).close
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::TIMEOUT => fault
          return container
          @logger.error("#{@host}: #{fault.message}")
          #exit
        end
      end
    rescue
      message = "#{@host}: connection timeout"
      return container
      @logger.error(message)
    end

    # initiate conection to the vCenter
    begin
      @vim = RbVmomi::VIM.connect :host => @host, :user => @user, :password => @pass, :insecure => true
      @logger.info("#{@host}: connected")
    rescue RbVmomi::Fault => fault
      @logger.error("#{@host}: unable to connect. #{fault.message}")
    end

    # log that data collection is started
    @logger.info("#{@host}: data collection started")

    # get the vCenter rootFolder
    begin
      @rootFolder = @vim.serviceInstance.content.rootFolder
    rescue RbVmomi::Fault => fault
      @logger.error("#{@host}: unable to get the vCenter root folder. #{fault.message}")
    end

    # get all datacenters
    begin
      @datacenters = @rootFolder.childEntity.grep(RbVmomi::VIM::Datacenter)
    rescue RbVmomi::Fault => fault
      @logger.error("#{@host}: unable to get all Datacenters. #{fault.message}")
    end

    # get serviceContent view
    begin
      @serviceContent = @vim.serviceContent.viewManager
    rescue RbVmomi::Fault => fault
      @logger.error("#{@host}: unable to get Service Content View. #{fault.message}")
    end

    # collect hosts informations
    @datacenters.each do |datacenter|
      # get all computerRessources on all datacenters
      begin
        @computerRessources = datacenter.hostFolder.childEntity
      rescue RbVmomi::Fault => fault
        @logger.error("#{@host}: unable to get all Computer Ressources. #{fault.message}")
      end
      pathStateActive = 0
      pathStateDead = 0
      pathStateDisabled = 0
      pathStateStandby = 0
      pathStateUnknown = 0
      if @computerRessources.size > 1
        i = 0
        while i < (@computerRessources.size) do
         datacenter.hostFolder.childEntity[i].host.grep(RbVmomi::VIM::HostSystem).each do |host|
          name = host.name.gsub(/:/,"-")
          host.config.multipathState.path.each do |path|
            case path[:pathState]

            when "active"
              pathStateActive += 1
            when "dead"
              pathStateDead += 1
            when "disabled"
              pathStateDisabled += 1
            when "standby"
              pathStateStandby += 1
            when "unknown"
              pathStateUnknown += 1
            end
          end

          data = {
            "hostname"         => host.name,
            "product"          => host.summary.config.product.fullName,
            "hardwaremodel"    => host.summary.hardware.model,
            "cpumodel"         => host.summary.hardware.cpuModel,
            "cpumhz"           => host.summary.hardware.cpuMhz.to_i*1000000,
            "cpucore"          => host.summary.hardware.numCpuCores,
            "cpuusage"         => host.summary.quickStats.overallCpuUsage.to_i*1000000,
            "cpuusagepercent"  => host.summary.quickStats.overallCpuUsage.to_i.percent_of(host.summary.hardware.cpuMhz.to_i*host.summary.hardware.numCpuCores.to_i),
            "totalcpusize"     => host.summary.hardware.numCpuCores*host.summary.hardware.cpuMhz.to_i*1000000,
            "totalmemorysize"  => host.summary.hardware.memorySize,
            "memoryusage"      => host.summary.quickStats.overallMemoryUsage.to_i*1024*1024,
            "memoryusagepercent" => (host.summary.quickStats.overallMemoryUsage.to_i*1024*1024).percent_of(host.summary.hardware.memorySize.to_i),
            "powerstate"       => host.summary.runtime.powerState,
            "maintenancemode"  => host.summary.runtime.inMaintenanceMode,
            "uptime"           => host.summary.quickStats.uptime,
            "overallstatus"    => host.summary.overallStatus,
            "pathstateactive"  => pathStateActive,
            "pathstatedead"    => pathStateDead,
            "pathstatedisabled" => pathStateDisabled,
            "pathstatestandby" => pathStateStandby,
            "pathstateunknown" => pathStateUnknown
          }
          container["hosts"][name]=data
         end
         i += 1
        end
      else
        datacenter.hostFolder.childEntity[0].host.grep(RbVmomi::VIM::HostSystem).each do |host|
          name = host.name.gsub(/:/,"-")
          host.config.multipathState.path.each do |path|
            case path[:pathState]

            when "active"
              pathStateActive += 1
            when "dead"
              pathStateDead += 1
            when "disabled"
              pathStateDisabled += 1
            when "standby"
              pathStateStandby += 1
            when "unknown"
              pathStateUnknown += 1
            end
          end

          data = {
            "hostname"         => host.name,
            "product"          => host.summary.config.product.fullName,
            "hardwaremodel"    => host.summary.hardware.model,
            "cpumodel"         => host.summary.hardware.cpuModel,
            "cpumhz"           => host.summary.hardware.cpuMhz.to_i*1000000,
            "cpucore"          => host.summary.hardware.numCpuCores,
            "cpuusage"         => host.summary.quickStats.overallCpuUsage.to_i*1000000,
            "cpuusagepercent"  => host.summary.quickStats.overallCpuUsage.to_i.percent_of(host.summary.hardware.cpuMhz.to_i*host.summary.hardware.numCpuCores.to_i),
            "totalcpusize"     => host.summary.hardware.numCpuCores*host.summary.hardware.cpuMhz.to_i*1000000,
            "totalmemorysize"  => host.summary.hardware.memorySize,
            "memoryusage"      => host.summary.quickStats.overallMemoryUsage.to_i*1024*1024,
            "memoryusagepercent" => (host.summary.quickStats.overallMemoryUsage.to_i*1024*1024).percent_of(host.summary.hardware.memorySize.to_i),
            "powerstate"       => host.summary.runtime.powerState,
            "maintenancemode"  => host.summary.runtime.inMaintenanceMode,
            "uptime"           => host.summary.quickStats.uptime,
            "overallstatus"    => host.summary.overallStatus,
            "pathstateactive"  => pathStateActive,
            "pathstatedead"    => pathStateDead,
            "pathstatedisabled" => pathStateDisabled,
            "pathstatestandby" => pathStateStandby,
            "pathstateunknown" => pathStateUnknown
          }
          container["hosts"][name]=data
        end
      end
    end

    # collect datastores informations
    @datacenters.each do |datacenter|
      datacenter.datastore.grep(RbVmomi::VIM::Datastore).each do |datastore|
       name = datastore.name.gsub(/:/,"-")
       vmlist =[]
       datastore.vm.grep(RbVmomi::VIM::VirtualMachine).each {|v| vmlist << v.name }
       data = {
          "name"                  => datastore.name,
          "capacity"              => datastore.summary.capacity,
          "capacityfree"          => datastore.summary.freeSpace,
          "capacityused"          => datastore.summary.capacity - datastore.summary.freeSpace,
          "capacityusedpercent"   => 1 - (datastore.summary.freeSpace.to_i.percent_of(datastore.summary.capacity.to_i)),
          "accessible"            => datastore.summary.accessible,
          "maintenancemode"       => datastore.summary.maintenanceMode,
          "type"                  => datastore.summary.type,
          "vmcount"               => ((vmlist.join(', ')).split(",")).count,
          "vmlist"                => vmlist.join(', ')
       }
       container["datastores"][name]=data
      end
    end

    # collect virtualmachines informations
    @serviceContent.CreateContainerView({:container => @rootFolder ,:type => ['VirtualMachine'], :recursive => true}).view.each do |vm|
      name = vm.name.gsub(/:/,"-")
      maxcpuusage = vm.summary.runtime.maxCpuUsage.to_i*1000000 unless vm.summary.runtime.maxCpuUsage.nil?

      data = {
        "name"                  => vm.name,
        "runninghost"           => vm.runtime.host.name,
        "powerstate"            => vm.summary.runtime.powerState,
        "toolsinstallermounted" => vm.summary.runtime.toolsInstallerMounted,
        "consolidationeeded"    => vm.summary.runtime.consolidationNeeded,
        "cleanpoweroff"         => vm.summary.runtime.cleanPowerOff,
        "boottime"              => vm.summary.runtime.bootTime,
        "guestfullname"         => vm.summary.guest.guestFullName,
        "hostname"              => vm.summary.guest.hostName,
        "ipaddress"             => vm.summary.guest.ipAddress,
        "vmwaretools"           => vm.summary.guest.toolsVersionStatus2,
        "maxcpuusage"           => maxcpuusage,
        "overallcpuusage"       => vm.summary.quickStats.overallCpuUsage.to_i*1000000,
        "percentcpuusage"       => vm.summary.quickStats.overallCpuUsage.to_i.percent_of(vm.summary.runtime.maxCpuUsage.to_i),
        "numcpu"                => vm.summary.config.numCpu,
        "memorysize"            => vm.summary.config.memorySizeMB.to_i*1024*1024,
        "hostmemoryusage"       => vm.summary.quickStats.hostMemoryUsage.to_i*1024*1024,
        "guestmemoryusage"      => vm.summary.quickStats.guestMemoryUsage.to_i*1024*1024,
        "balloonedmemory"       => vm.summary.quickStats.balloonedMemory.to_i*1024*1024,
        "percentmemoryusage"    => vm.summary.quickStats.hostMemoryUsage.to_i.percent_of(vm.summary.config.memorySizeMB.to_i),
        "uncommittedstorage"    => vm.summary.storage.uncommitted,
        "usedstorage"           => vm.summary.storage.committed,
        "provisionedstorage"    => vm.summary.storage.uncommitted + vm.summary.storage.committed,
        "percentusedstorage"    => vm.summary.storage.committed.to_i.percent_of(vm.summary.storage.uncommitted.to_i + vm.summary.storage.committed.to_i),
        "unsharedstorage"       => vm.summary.storage.unshared,
        "storagelocation"       => vm.summary.config.vmPathName,
        "uptime"                => vm.summary.quickStats.uptimeSeconds,
        "overallstatus"         => vm.summary.overallStatus
      }
      container["virtualmachines"][name]=data
    end

    # log that data collection is terminated
    @logger.info("#{@host}: data collection ended (#{(Time.now - beginning_time).to_i} seconds)")

    @vim.serviceContent.about.props.each do |key,value|
      container["viserver"]["#{key.to_s.downcase}"] = value
    end
    # set api serial number
    container["viserver"]["timestampcheck"] = "#{Time.now.utc.to_i}"

    # set api collection duration
    container["viserver"]["collectionduration"] = "#{(Time.now - beginning_time).to_i}"

    # set api status
    container["viserver"]["status"] = "OK"

    # return data
    return container
  end

end
