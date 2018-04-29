module SSLGate

  module ClientCertAddOn
    def initialize(config)
      super config.merge verify_peer: true, fail_if_no_peer_cert: true
      # ca:'ca.crt'
      # add_cn_header: 'SSL_CLIENT_CN'
    end
  end

  add_ons << ClientCertAddOn
end