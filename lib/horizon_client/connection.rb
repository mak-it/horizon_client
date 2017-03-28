module HorizonClient
  class Connection
    attr_accessor :logger

    def initialize(url = nil)
      url ||=  ENV['HORIZON_REST_URL']

      @connection = Faraday.new url do |conn|
        conn.response :raise_error
        conn.use HorizonClient::Response::ParseXml
        conn.use HorizonClient::Request::EncodeXml

        conn.adapter Faraday.default_adapter
      end
    end

    def url_prefix
      @connection.url_prefix
    end

    def get(path = '', params = {})
      log "GET #{path}", params do
        response = @connection.get path, params
        response.body
      end
    end

    def post(path = '', body)
      log "GET #{path}", {body: body} do
        response = @connection.post do |req|
          req.url path
          req.headers['Content-Type'] = 'application/xml;charset=UTF-8'
          req.body = body
        end

        response.body
      end
    end

    def log(message, params = {})
      t1 = Time.now
      yield
    ensure
      t2 = Time.now
      duration = (t2 - t1) / 1000
      logger.info "Horizon (#{duration}ms) #{message} #{params.inspect}" if logger
    end
  end
end
