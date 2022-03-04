# Oasis Protocol Node Docker Image

Dockerfile for building an `oasis-node` docker image. The image is built on
latest Debian using upstream provided binaries.

The image is published on docker hub at `munaynetwork/oasis-node`. The image is
tagged using the upstream tagging convention to keep things simple.

## How to use

In order to successfully use the image there are two prerequisites:

* A `config.yml` for the node, the following would suffice for `mainnet`.

```yaml
datadir: /node/data

log:
  level:
    default: warn
    tendermint: info
    tendermint/context: error
  format: JSON

genesis:
  file: /node/etc/genesis.json

consensus:
  tendermint:
    core:
      listen_address: tcp://0.0.0.0:26656
    p2p:
      seed:
        - "E27F6B7A350B4CC2B48A6CBE94B0A02B0DCB0BF3@35.199.49.168:26656"
```

* The `genesis.json` file, either for [testnet](https://github.com/oasisprotocol/testnet-artifacts/releases/download/2022-03-03/genesis.json) or [mainnet](https://github.com/oasisprotocol/mainnet-artifacts/releases/download/2021-04-28/genesis.json)

Assuming the files above are stored in the `etc/` directory on the local machine
run the following command to start the node.

```bash
docker run --rm --name oasis-node -v $(pwd)/etc:/node/etc -v node-data:/node/data munaynetwork/oasis-node
```

Note that the above invocation uses `node-data` named volume to persist state
between container restarts.

## Building

If, for whatever reason, you would like to build the image yourself, run the
following from inside a repository clone.

```bash
docker build -t oasis-node .
```

## Notes

At it is now, the image doesn't support the use of custom node keys and thus
node registration.

The image *might* not be ready for production usage. You have been warned.
