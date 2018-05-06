require 'yaml'

module SSLGate
  # CLI runner.
  class Runner

    def self.symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), result|
        new_key = key.is_a?(String) ? key.to_sym : key
        new_value = value.is_a?(Hash) ? symbolize_keys(value) : value
        result[new_key] = new_value
        result
      end
    end

    def self.start
      config = symbolize_keys YAML.load_file('SSLGate')

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
