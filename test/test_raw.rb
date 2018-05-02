require_relative '../lib/ssl_gate'

config = {
  bind_port: 9001,
  target: 'tcp://localhost:9000',
  private_key_file: File.dirname(__FILE__) + '/ssl/server.key',
  cert_chain_file: File.dirname(__FILE__) + '/ssl/server.crt'
}

EventMachine.run do
  Signal.trap('INT')  { EM.stop if EM.reactor_running? }
  Signal.trap('TERM') { EM.stop if EM.reactor_running? }

  EM.start_server '0.0.0.0', 9000 do |srv|
    def srv.receive_data(data)
      send_data ">>> you sent: #{data}"
    end
  end

  SSLGate::RawServerAll.start config

  EM.add_timer(1) do
    10.times do
      EventMachine.connect '127.0.0.1', 9001 do |c|
        c.start_tls
        def c.ssl_handshake_completed
          send_data 'Hello'
        end
        def c.receive_data(data)
          p data
        end
      end
    end
  end
end