#/bin/sh

echo "creating root cert ..."
openssl req -new -newkey rsa:2048 -x509 -sha256 \
        -days 3650 -nodes -out cert.pem -keyout key.pem \
        -subj "/CN=ipfs-test-ca.example.com" \
        -addext "extendedKeyUsage = clientAuth, serverAuth"