# vegeta

- [vegeta](#vegeta)
  - [github](#github)
  - [demo](#demo)

## github

## demo

    echo "GET http://127.0.0.1:5666" | ./vegeta/vegeta attack -rate=10/s -duration=120s > results.gob

    ./vegeta/vegeta report results.gob

