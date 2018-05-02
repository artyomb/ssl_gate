require 'thin'
require 'em-http'
require 'json'

require_relative '../lib/ssl_gate'

config = {
  bind_port: 9001,
  target: 'http://localhost:9000',
  private_key_file: File.dirname(__FILE__) + '/ssl/server.key',
  cert_chain_file: File.dirname(__FILE__) + '/ssl/server.crt'
}

EventMachine.run do
  Signal.trap('INT')  { EM.stop if EM.reactor_running? }
  Signal.trap('TERM') { EM.stop if EM.reactor_running? }

  Thin::Server.start('0.0.0.0', 9000, signals: false) do
    run lambda { |env| [200, { 'Content-Type' => 'application/javascript' }, [env.to_json]] }
  end

  SSLGate::HTTPServerAll.start config

  EM.add_timer(3) { EM.stop }

  EM.add_timer(1) do
    10.times do
      http = EM::HttpRequest.new('https://localhost:9001/path1?p1=v1&p2=v2').get
      http.callback {
        puts "#{http.response_header.status} - #{http.response.length} bytes\n"
        puts http.response
      }
      http.errback { puts http.error }
    end
  end
end