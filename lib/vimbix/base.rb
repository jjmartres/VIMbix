class VIMbix < Sinatra::Base
  register Sinatra::Partial

  #set :root, Dir[File.dirname(__FILE__) + "/../.."]
  #set :root, APP_ROOT

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
