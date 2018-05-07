require_relative 'ssl_gate/raw_gate'
require_relative 'ssl_gate/raw_ssl'

require_relative 'ssl_gate/base_gate'
require_relative 'ssl_gate/base_ssl_gate'
require_relative 'ssl_gate/headers_mod'
#require_relative 'ssl_gate/client_cert'
require_relative 'ssl_gate/runner'

module SSLGate
  class RawServerAll < RawServer
    RawServer.add_ons.each { |add_on|
      puts "Include server add-on: #{add_on}"
      prepend add_on
    }
  end

  class HTTPServerAll < HTTPServer
    HTTPServer.add_ons.each { |add_on|
      puts "Include server add-on: #{add_on}"
      prepend add_on
    }
  end

  def self.factory(config)
    config.each do |key, conf|
      case conf[:target]
      when /http/ then HTTPServerAll.start conf
      else RawServerAll.start conf
      end
    end
  end
end

