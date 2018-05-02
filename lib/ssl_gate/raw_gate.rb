require 'eventmachine'

module SSLGate

  class RawClient < EM::Connection
    attr_reader :queue

    def initialize(q, parent)
      set_sock_opt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1) # Nagle off

      @parent = parent
      @queue = q

      cb = proc do |msg|
        msg ? send_data(msg) : close_connection
        q.pop &cb
      end
      q.pop &cb
    end

    def receive_data(data)
      @parent.send_data data
    end

    def unbind
      @parent.close_connection
    end
  end

  class RawServer < EM::Connection
    class << self; attr_accessor :add_ons end
    @add_ons = []

    def self.start(config)
      EventMachine.start_server (config[:bind_interface] || '0.0.0.0'), config[:bind_port], self, config
    end

    def initialize(config)
      @config = config
    end

    def post_init
      @queue = EM::Queue.new
      uri = URI.parse @config[:target]
      EM.connect uri.host, uri.port, RawClient, @queue, self
    end

    def receive_data(data)
      @queue.push data
    end

    def unbind
      @queue.push nil
    end
  end
end