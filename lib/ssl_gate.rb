require_relative 'base_gate'
require_relative 'base_ssl_gate'
require_relative 'headers_mod'
#require_relative 'client_cert'
require_relative 'runner'

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

