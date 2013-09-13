class VIMbix < Sinatra::Base

  # [GET] /:viserver/api/:word
  get '/:viserver/api/:word' do
    content_type :json
    viserver = params[:viserver]
    word = params[:word]

    if settings.api_words.include? word
      begin
        viserver.exist_dump?
        data = get_dump(viserver)
        { :error => nil, :result => data["viserver"]["#{word}"] }.to_json
      rescue Exception => fault
        not_found
      end
    else
      not_found
    end
  end

  # [GET] /:viserver/host/:id/:word
  get '/:viserver/host/:id/:word' do
    content_type :json
    viserver = params[:viserver]
    word = params[:word]
    id = params[:id]

    if settings.host_words.include? word
      begin
        viserver.exist_dump?
        data = get_dump(viserver)
        { :error => nil, :result => data["hosts"]["#{id}"]["#{word}"] }.to_json
      rescue Exception => fault
        not_found
      end
    else
      not_found
    end
  end

  # [GET] /:viserver/datastore/:id/:word
  get '/:viserver/datastore/:id/:word' do
    content_type :json
    viserver = params[:viserver]
    word = params[:word]
    id = params[:id]

    if settings.datastore_words.include? word
      begin
        viserver.exist_dump?
        data = get_dump(viserver)
        { :error => nil, :result => data["datastores"]["#{id}"]["#{word}"] }.to_json
      rescue Exception => fault
        not_found
      end
    else
      not_found
    end
  end

  # [GET] /:viserver/virtualmachine/:id/:word
  get '/:viserver/virtualmachine/:id/:word' do
    content_type :json
    viserver = params[:viserver]
    word = params[:word]
    id = params[:id]

    if settings.virtualmachine_words.include? word
      begin
        viserver.exist_dump?
        data = get_dump(viserver)
        { :error => nil, :result => data["virtualmachines"]["#{id}"]["#{word}"] }.to_json
      rescue Exception => fault
        not_found
      end
    else
      not_found
    end
  end

  # [GET] /:viserver/hosts
  get '/:viserver/hosts' do
    content_type :json
    viserver = params[:viserver]

    if exist_dump(viserver)
      data = get_dump(viserver)
      value = "{  \"data\":["
      x = 0
      data["hosts"].each do |host|
        x += 1
        if x < data["hosts"].size
          value += "{ \"{#HOST}\":\"#{host[0]}\"},"
        else
          value += "{ \"{#HOST}\":\"#{host[0]}\"}"
        end
      end
      value += "] }"
      { :error => nil, :result => value }.to_json
    else
      not_found
    end

  end

  # [GET] /:viserver/datastores
  get '/:viserver/datastores' do
    content_type :json
    viserver = params[:viserver]

    begin
      viserver.exist_dump?
      data = get_dump(viserver)
      value = "{  \"data\":["
      x = 0
      data["datastores"].each do |datastore|
        x += 1
        if x < data["datastores"].size
          value += "{ \"{#DATASTORE}\":\"#{datastore[0]}\"},"
        else
          value += "{ \"{#DATASTORE}\":\"#{datastore[0]}\"}"
        end
      end
      value += "] }"
      { :error => nil, :result => value }.to_json
    rescue Exception => fault
      not_found
    end

  end

  # [GET] /:viserver/virtualmachines
  get '/:viserver/virtualmachines' do
    content_type :json
    viserver = params[:viserver]

    begin
      viserver.exist_dump?
      data = get_dump(viserver)
      value = "{  \"data\":["
      x = 0
      data["virtualmachines"].each do |virtualmachine|
        x += 1
        if x < data["virtualmachines"].size
          value += "{ \"{#VIRTUALMACHINE}\":\"#{virtualmachine[0]}\"},"
        else
          value += "{ \"{#VIRTUALMACHINE}\":\"#{virtualmachine[0]}\"}"
        end
      end
      value += "] }"
      { :error => nil, :result => value }.to_json
    rescue Exception => fault
      not_found
    end

  end

  # return http status code 404
  not_found do
    content_type :json
    halt 404, { :error => "The resource you were looking for does not exist", :result => nil }.to_json
    logger.error("HTTP 404 ERROR on #{request.url}")
  end

  # return http status code 500
  error do
    content_type :json
    halt 500, { :error => "We're sorry, but something went wrong. We've been notified about this issue and we'll take a look at it shortly", :result => nil }.to_json
    logger.error("HTTP 500 ERROR on #{request.url}")
  end

end
