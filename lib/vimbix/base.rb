class VIMbix < Sinatra::Base
  register Sinatra::Partial

  # check if datadump file exists
  def exist_dump(viserver)
    File.file?("#{settings.root}/data/datadump_#{viserver}")
  end

  # read datadump file
  def get_dump(viserver)
    @logger = settings.logger

    begin
      f = File.open(File.join("#{settings.root}/data/datadump_#{viserver}"), "r")
      data = f.readlines
      return JSON.parse(data[0])
    rescue Exception => fault
      @logger.error(fault.message)
    ensure
      f.close unless f.nil?
    end

  end

end
