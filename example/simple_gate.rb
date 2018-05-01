require 'ssl_gate'

config = {
  bind_port: 9001,
  target: 'http://localhost:9000',
  private_key_file: File.dirname(__FILE__) + '../test//server.key',
  cert_chain_file: File.dirname(__FILE__) + '../test//server.crt'
}

EventMachine.run do
  Signal.trap('INT')  { EM.stop if EM.reactor_running? }
  Signal.trap('TERM') { EM.stop if EM.reactor_running? }

  SSLGate.start config
end