module SSLGate
  module SSLRawAddOn
    def post_init
      super
      start_tls private_key_file: @config[:private_key_file],
                cert_chain_file: @config[:cert_chain_file]
      # verify_peer: true,
      # fail_if_no_peer_cert: true
    end

#    def ssl_verify_peer(cert)
#      true
#    end

    def ssl_handshake_completed
      $server_handshake_completed = true
    end
  end

  RawServer.add_ons << SSLRawAddOn
end