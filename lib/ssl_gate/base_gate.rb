require 'thin'
require 'em-http'

module SSLGate
  class << self; attr_accessor :add_ons end
  @add_ons = []

  class Server
    def initialize(config)
      @config = {  signals: false,
                   bind_interface: '0.0.0.0',
                   # bind_port: 5050,
                   # target: 'http://localhost:9000'
      }.merge config
    end

    def call(env)
      r_method = env['REQUEST_METHOD'].downcase.to_sym
      r_query = env['QUERY_STRING']
      r_path = env['REQUEST_PATH']
      input = env['rack.input'] #StringIO
      env[:target_request_options] ||= { connect_timeout: 20, inactivity_timeout: 20 }

      puts "head: #{env[:target_get_options][:head] rescue ''}"
      request = EM::HttpRequest.new @config[:target], env[:target_request_options]
      http = request.send r_method, (env[:target_get_options] || {}).merge( path: r_path, query: r_query) # body: input
      puts "#{r_method}: #{r_path} #{r_query}"

      ready = lambda {
        headers = http.response_header.map{ |key, val| [key.tr('_', '-'), val] }.to_h
        headers.delete 'TRANSFER-ENCODING'
        headers.delete 'CONTENT-ENCODING'
        headers.delete 'CONTENT-LENGTH'
        puts "OK: #{headers}"
        env['async.callback'].call [http.response_header.status, headers, [http.response]]
      }
      http.callback { ready.call }
      http.errback { ready.call }
      throw :async
    end

    def start
      Thin::Server.start @config[:bind_interface], @config[:bind_port], @config, self
    end
  end
end
