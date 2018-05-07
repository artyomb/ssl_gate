# SSL_Gate

This gems allows to start TCP(HTTP) server that serves SSL(TLS) connections and forwards them further.  
HTTP requests are recreated and responses are send back 
while TCP connections are coupled and each data packets are forwarded both directions asynchronously.  

## Installation
To install the gem run

    $ gem install ssl_gate

## Usage
Create the file `SSLGate` which describes the gates
```yaml
google:
  bind_port: 9001
  target: https://www.google.com
  private_key_file: "../test/ssl/server.key"
  cert_chain_file: "../test/ssl/server.crt"
```
Then run in the current directory

    $ ssl_gate

This will start the HTTPS server on the 0.0.0.0:9001 with the SSL Certificate specified.
Each request will spawn the corresponding one to the target server and response will be send back.

## Local Gate
More practical example is to setup server gates to secure access local services. 
Suppose you have Wiki server, RestAPI server and Jabber server running locally. 
Then you can setup three gates to provide SSL access these services from outside. 
The `SSLGate` file may looks as follows  
```yaml
wiki:
  bind_port: 80
  target: http://127.0.0.1:8080
  private_key_file: "server.key"
  cert_chain_file: "server.crt"
rest_api:
  bind_port: 90
  target: http://127.0.0.1:9090
  private_key_file: "rest_server.key"
  cert_chain_file: "rest_server.crt"
jabber:
  bind_port: 6222
  target: tcp://127.0.0.1:5222
  private_key_file: "xmpp_server.key"
  cert_chain_file: "xmpp_server.crt"
```
Simple run `ssl_gate` to start 