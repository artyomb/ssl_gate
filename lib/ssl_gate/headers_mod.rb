module SSLGate

  module HeadersModAddOn

    def call(env)
      prev = env['async.callback']
      env['async.callback'] = lambda { |*args|
        # puts 'I see you'
        prev.call *args
      }
      headers = env.select { |k, _v| k.start_with? 'HTTP_' }
                   .collect { |key, val| [key.sub(/^HTTP_/, '').gsub('_', '-'), val] }
                   .to_h
      headers.delete 'HOST'
      headers.delete 'USER-AGENT'
      headers['REFERER'].sub! %r{^https?://[^/]+(:\d+)?}, @config[:target] if headers['REFERER']
      super env
    end

    def initialize(config)
      super
      # subst_host: 'name'
    end
  end

  add_ons << HeadersModAddOn
end
