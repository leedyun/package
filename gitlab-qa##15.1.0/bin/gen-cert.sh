#!/bin/bash

DIR=$(dirname $0)
CA=${DIR}/../tls_certificates/authority/ca.crt
CA_KEY=${DIR}/../tls_certificates/authority/ca.key

server="$1"
server_dir=${DIR}/../tls_certificates/${server}

case "${server}" in
    'gitaly'|'gitlab' )
        HOST="${server}.test"
        KEY=${server_dir}/${HOST}.key
        CSR=${server_dir}/${HOST}.csr
        CRT=${server_dir}/${HOST}.crt
        ;;
    * )
        echo "Unknown server name specified: ${server}"
        exit 1
        ;;
esac

rm -vr ${server_dir} 2> /dev/null
mkdir -p ${server_dir}

openssl genrsa -out ${KEY} 4096 # Generate a key
openssl req -new -key ${KEY} -subj "/C=US/ST=California/L=San Francisco/O=The GitLab Authors/CN=${HOST}" -out ${CSR}
openssl x509 -req -days 3650 -in ${CSR} -CA ${CA} -CAkey ${CA_KEY} -extfile <(echo "subjectAltName = DNS:${HOST}") -set_serial 1 -out ${CRT}
