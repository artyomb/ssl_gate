#!/bin/bash
cd "$(dirname "$0")"

#Generage CA (self-signed)
openssl req -x509 -nodes -days 5000 -newkey rsa:2048 -keyout ca.key -out ca.crt -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"


#Debug dump
openssl x509 -in ca.crt -noout -text >ca.txt
openssl x509 -noout -fingerprint -in ca.crt >> ca.txt

openssl verify -verbose -CAfile ca.crt ca.crt


#Calculate SKI (Subject Key Identifier)
openssl x509  -noout -in ca.crt -pubkey  | openssl asn1parse  -strparse 19 -out ca.pub.tmp 1>/dev/null
openssl dgst -c -sha1 ca.pub.tmp
rm *.tmp