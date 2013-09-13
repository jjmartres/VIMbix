class VIMbix < Sinatra::Base

  configure do

    # init directory if not exists
    ["/var", "/var/log", "/var/run", "/data"].each do |subdir|
      Dir.mkdir(File.join(settings.root, subdir)) unless File.exists?(File.join(settings.root, subdir))
    end

    # init logger
    @logger = Logger.new(File.join("#{settings.root}/var/log/vimbix.log"), shift_age = 'daily', shitf_size = 1048576 )
    set :logger, @logger

    # load viservers configuration file
    begin
      viservers_yml = File.join("#{settings.root}/config/viservers.yml")
    rescue Exception => fault
      @logger.error(fault.message)
      exit(-1)
    end

    @viservers = YAML::load(File.open(viservers_yml))

    # init scheduler
    scheduler = Rufus::Scheduler.start_new
    set :scheduler, scheduler

    @viservers.each do |key,value|
      scheduler.every value["frequency"], :timeout => value["timeout"], :first_at => Time.now do

        beginning_time = Time.now
        begin
          viserver = Connector.new(value["hostname"], value["username"], value["password"], @logger)
          data = viserver.collect
          begin
            filename = "datadump_#{value["hostname"]}"
            f = File.open(File.join("#{settings.root}/data/#{filename}"), "w")
            f << data.to_json
          rescue Exception => fault
            @logger.error(fault.message)
          ensure
            f.close unless f.nil?
          end
          @logger.info("File #{filename} saved")
        rescue
          @logger.error("Execution timed out (#{(Time.now - beginning_time).to_i} seconds)")
        end

      end

    end

  end

end
