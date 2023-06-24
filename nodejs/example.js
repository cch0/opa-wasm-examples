import { loadPolicy } from "@open-policy-agent/opa-wasm";
import { readFileSync } from "fs";

const policyWasm = readFileSync("../config/policy.wasm");

const data = JSON.parse(readFileSync("../config/data.json", 'utf-8'))

const input = JSON.parse(readFileSync("../config/opa_input.json", 'utf-8'))


loadPolicy(policyWasm).then((policy) => {

    policy.setData(data)

    const resultSet = policy.evaluate(input);

    console.log("resultSet is ", resultSet)

    if (resultSet == null) {
      console.error("evaluation error");
    } else if (resultSet.length == 0) {
      console.log("undefined");
    } else {
      console.log("label = ", resultSet[0].result.label);
      console.log("rule = ", resultSet[0].result.rule);
    }

  }, (error) => {
    console.error("Failed to load policy: " + error);
  });

