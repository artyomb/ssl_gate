require_relative 'ssl_gate/base_gate'
require_relative 'ssl_gate/base_ssl_gate'
require_relative 'ssl_gate/headers_mod'
#require_relative 'ssl_gate/client_cert'
require_relative 'ssl_gate/runner'

module SSLGate
  class ServerAll < Server
    SSLGate.add_ons.each { |add_on|
      puts "Include server add-on: #{add_on}"
      prepend add_on
    }
  end

  def self.start(config)
    ServerAll.new(config).start
  end
end

