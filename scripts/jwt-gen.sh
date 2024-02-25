#!/bin/bash

base64urlencoded() {
    base64 | tr '+/' '-_' | tr -d '='
}

SIMMETRIC_KEY=fantasticjwt

HEADER='{"typ":"JWT","alg":"HS256","kid":"0001"}'
PAYLOAD='{"name":"testname","sub":"testsub","iss":"testiss"}'

HEADER_ENC=$(echo -n $HEADER | base64urlencoded)
PAYLOAD_ENC=$(echo -n $PAYLOAD | base64urlencoded)
HEADER_PAYLOAD_ENC="${HEADER_ENC}.${PAYLOAD_ENC}"

SIGNATURE_ENC=$(echo -n $HEADER_PAYLOAD_ENC | openssl dgst -binary -sha256 -hmac $SIMMETRIC_KEY | base64urlencoded)

JWT="${HEADER_ENC}.${PAYLOAD_ENC}.${SIGNATURE_ENC}"

echo $JWT
