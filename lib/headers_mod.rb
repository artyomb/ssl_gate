module SSLGate

  module HeadersModAddOn

    def call(env)
      prev = env['async.callback']
      env['async.callback'] = lambda { |*args|
        puts 'I see you'
        prev.call *args
      }
      env[:target_get_options] = { head: { 'host' => 'val1' } }
      super env
    end

    def initialize(config)
      super
      # subst_host: 'name'
    end
  end

  add_ons << HeadersModAddOn
end
