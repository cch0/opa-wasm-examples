# Import the module
from opa_wasm import OPAPolicy
import json

# Load a policy by specifying its file path
policy = OPAPolicy('../config/policy.wasm')


data_file = open('../config/data.json')
data = json.load(data_file)

# Optional: Set policy data
policy.set_data(data)

# load the input
input_file = open('../config/opa_input.json')
input = json.load(input_file)


# Evaluate the policy
result = policy.evaluate(input)

# [{'result': {'rule': 'C', 'label': 'UNRESTRICTED'}}]
print(result)

