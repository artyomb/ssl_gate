#!/usr/bin/ruby
require 'thin'

OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::OP_NO_COMPRESSION
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers] = 'TLSv1.2:!aNULL:!eNULL'
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'TLSv1_2'

module SSLGate

  class SSLBackend < ::Thin::Backends::TcpServer
    def initialize(host, port, options)
      super(host, port)
      @ssl = true
      @ssl_options = options
    end
  end

  module SSLBackendAddOn
    def initialize(config)
      super config.merge backend: SSLBackend
      # private_key_file: File.dirname(__FILE__) + "/server.key",
      # cert_chain_file: File.dirname(__FILE__) + "/server.crt",
    end
  end

  add_ons << SSLBackendAddOn
end
