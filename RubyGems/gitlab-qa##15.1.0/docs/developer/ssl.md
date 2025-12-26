# SSL

## Enabling https for services

In order to test services with ssl enabled, `certificate authority (CA)` certs as well as applicant key pairs have been created and are
located in [tls_certificates/](../../tls_certificates/) folder.

**All certificates are used for testing purposes only and are not present in any of release images.**

## Generating new key pairs

To create new key pair for a new service, following commands can be used:

* creating new private key:

```console
$ cd tls_certificates && mkdir service && cd service
```

```console
$ openssl genrsa -out service.key 4096
```

* creating public key and `certificate signing request (CSR)`

```console
$ openssl req -new -key service.key -out service.csr -subj "/C=US/ST=California/L=San Francisco/O=Gitlab Authors/CN=service.test" -addext "subjectAltName=DNS:service.test,DNS:extra.service.test"
```

```console
$ openssl x509 -req -days 3650 -in service.csr -CA ../authority/ca.crt -CAkey ../authority/ca.key -set_serial 1 -out service.crt -extfile <(printf "subjectAltName=DNS:service.test,DNS:extra.service.test")
```
