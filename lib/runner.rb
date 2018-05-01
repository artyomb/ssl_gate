require_relative '../lib/ssl_gate'

module SSLGate
  # CLI runner.
  # Parse options and send command to the correct Controller.
  class Runner

    def initialize(config)
      @config = config
    end

    def start
      EventMachine.run do
        Signal.trap('INT')  { EM.stop if EM.reactor_running? }
        Signal.trap('TERM') { EM.stop if EM.reactor_running? }

        SSLGate.start @config
      end
    end
  end
end
