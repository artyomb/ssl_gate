#!/bin/bash
cd "$(dirname "$0")"
#ALTNAME="DNS:<host1>,DNS:<host2>"

#Generate certificate
openssl genrsa -out server.key 2048


openssl req -new -key server.key -out server.csr -subj "/O=Group/OU=Youtest/CN=localhost"

openssl x509 -req -extfile v3.ext -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 3650\
    -extfile <(cat ./v3.ext <(printf "\nsubjectAltName=IP:localhost,DNS:localhost"))

#Debug dump
openssl req -in server.csr -text -noout >server.csr.txt
openssl x509 -in server.crt -noout -text >server.crt.txt
openssl verify -verbose -CAfile ca.crt server.crt
