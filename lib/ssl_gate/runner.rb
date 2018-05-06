require 'yaml'

module SSLGate
  # CLI runner.
  # Parse options and send command to the correct Controller.
  class Runner

    def self.start
      config = YAML.load_file 'SSLGate'

      EventMachine.run do
        Signal.trap('INT')  { EM.stop if EM.reactor_running? }
        Signal.trap('TERM') { EM.stop if EM.reactor_running? }

        SSLGate.factory config
      end
    rescue =>e
      STDERR.puts e.message

    end
  end
end
