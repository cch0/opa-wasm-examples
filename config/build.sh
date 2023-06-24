#!/usr/bin/env bash

opa build -t wasm -o ../out/bundle.tar.gz -e example/label_to_use example.rego data.json

