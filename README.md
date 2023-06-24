# OPA WebAssembly Examples For OPA Policy Evaluation

A collection of examples which demonstrates how to evaluate against the same policy [policy.wasm](./config/policy.wasm) using different programming languages. The policy is expected to be written in Rego and compiled by WebAssembly.

The OPA policy file included here is an example of Rego policy for evaluating PDU packets.

[opa_input.json](./config/opa_input.json) contains an example of PDU packet and [data.json](./config/data.json) contains the rules configuration parameters.

</br>
</br>

## Java Example

Execute the `com.kdf.Main` class inside the java directory. The `pom.xml` file specifies the version of `wasmtime-java` dependency which only exists in a private Maven repository.

```
2023-06-23 14:13:26 INFO - main - Main:33 - evaluation result: [{"result":{"rule":"C","label":"UNRESTRICTED"}}]
2023-06-23 14:13:26 INFO - main - Main:36 - rule: "C", label: "UNRESTRICTED"
```


</br>
</br>

## Python Example

```
cd python

source .env/bin/activate

python3 example.py
```

</br>
Output:

```
[{'result': {'rule': 'C', 'label': 'UNRESTRICTED'}}]
```

</br>
</br>

## Nodejs Example



```
cd nodejs

npm install

node example.js
```

</br>
Output:

```
resultSet is  [ { result: { rule: 'C', label: 'UNRESTRICTED' } } ]
label =  UNRESTRICTED
rule =  C
```


</br>
</br>

## OPA Eval Command Line Example

```
opa eval -d config/data.json -d config/example.rego  -i config/opa_input.json -e example/label_to_use  -f pretty  data.example.label_to_use
```

Output:

```
{
  "label": "UNRESTRICTED",
  "rule": "C"
}
```



</br>
</br>

## OPA Server Docker Example

Compared to [opa_input.json](./config/opa_input.json) file, [input.json](./config/input.json) file add the content of `opa_input.json` file as the value field with key `input` in the `input.json` file, i.e.

```
{
    "input": { ... content from opa_input.json }
}
```

</br>

Execute the command to start up OPA Server

```
docker run -it -v $PWD/config/data.json:/config/data.json -v $PWD/config/example.rego:/config/example.rego  -p 8181:8181  openpolicyagent/opa:0.54.0-dev-static-debug run --server --addr :8181 /config
```

</br>


Execute the `curl` command

```
curl -d @./config/input.json http://localhost:8181/v1/data/example/label_to_use
```

</br>

Output:
```
{"result":{"label":"UNRESTRICTED","rule":"C"}}
```

</br>
</br>

## OPA Server Local Example

Execute the command to start up OPA Server

```
opa run config/data.json config/example.rego -s --addr localhost:8181
```

</br>

Execute the `curl` command

```
curl -d @./config/input.json http://localhost:8181/v1/data/example/label_to_use
```

</br>

Output:
```
{"result":{"label":"UNRESTRICTED","rule":"C"}}
```


</br>
</br>
