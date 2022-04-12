#!/bin/sh

openssl req -nodes -x509 -newkey rsa:2048 -keyout ca.key -out ca.crt -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=root/CN=`hostname -f`/emailAddress=kevinadi@mongodb.com"

openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=server/CN=`hostname -f`/emailAddress=kevinadi@mongodb.com"

openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt

cat server.key server.crt > server.pem

openssl req -nodes -newkey rsa:2048 -keyout client.key -out client.csr -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=client/CN=`hostname -f`/emailAddress=kevinadi@mongodb.com"

openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAserial ca.srl -out client.crt

cat client.key client.crt > client.pem

# openssl pkcs12 -inkey client.key -in client.crt -export -out client.pfx


# Start mongod with SSL
# mkdir -p data/db
# mongod --sslMode requireSSL --sslPEMKeyFile server.pem --sslCAFile ca.crt --dbpath data/db --logpath data/mongod.log --fork

# Connect to mongod with SSL
# mongo --ssl --sslCAFile ca.crt --sslPEMKeyFile client.pem --host `hostname -f`
