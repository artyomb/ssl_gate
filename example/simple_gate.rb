require 'ssl_gate'

config = {
  bind_port: 9001,
  target: 'https://www.google.com',
  private_key_file: File.dirname(__FILE__) + '/../test/ssl/server.key',
  cert_chain_file: File.dirname(__FILE__) + '/../test/ssl/server.crt'
}

EventMachine.run do
  Signal.trap('INT')  { EM.stop if EM.reactor_running? }
  Signal.trap('TERM') { EM.stop if EM.reactor_running? }

  SSLGate::HTTPServerAll.start config
end
