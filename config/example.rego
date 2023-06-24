package example

default default_label := "UNRESTRICTED"

default has_first_matching_label_rule := false

default first_matching_label_rule := null

default platform_entity_type_string := null

default pdu_has_entity_id := false

default is_entity_state_pdu := false

default is_platform_pdu := false

default pdu_type := null

default label_to_use := {"label": "I am here ?", "rule": null}

################################################################################################

# PDU can be determined
pdu_type := result {
	pdu_type_int := format_int(input.pduType, 10)
	result = data.pdu_types[pdu_type_int]
}

# get the first matching label rule
first_matching_label_rule := first_rule {
	# PDU type can be determined
	not is_null(pdu_type)

	# get the first rule in the data.label_rules which matches the PDU type
	first_rule = [rule | some i; data.label_rules[i].pduType == pdu_type.name; rule := data.label_rules[i]][0]
}

# first matching label rule can be found?
has_first_matching_label_rule {
	not is_null(first_matching_label_rule)
}

# Does PDU have entity id field?
pdu_has_entity_id {
	input[pdu_type.entityIdFieldName]
}

# Is this Entity State PDU?
is_entity_state_pdu {
	pdu_type.name == "ENTITY_STATE"
}

# Is this PDU entity kind platform?
is_platform_pdu {
	# entity kind is Platform (1)
	get_entity_kind(input.entityType) == 1
}

# create entity type string if PDU is "ENTITY_STATE" and Platform.
platform_entity_type_string = result {
	# PDU is ENTITY_STATE
	is_entity_state_pdu

	# PDU is entity kind Platform
	is_platform_pdu

	# construct string representation
	result = entity_type_to_string(input.entityType)
}

################################################################################################

# Rule A
# use matchAttribute from first matching label rule if PDU has no entity id field
label_to_use := {"label": first_matching_label_rule.matchAttribute, "rule": "A"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has no entity id field
	not pdu_has_entity_id
}

# Rule B
# use matchAttribute from first matching label rule if PDU is not ENTITY_STATE
label_to_use := {"label": first_matching_label_rule.matchAttribute, "rule": "B"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has entity id field
	pdu_has_entity_id

	# platform_entity_type_string is not available
	is_null(platform_entity_type_string)

	# PDU is not ENTITY_STATE
	not is_entity_state_pdu
}

# Rule C
# use unmatchAttribute from first matching lable rule if PDU platform_entity_type_string
# does not match platformEntityType field from the rule.
label_to_use := {"label": first_matching_label_rule.unmatchAttribute, "rule": "C"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has entity id field
	pdu_has_entity_id

	# PDU is ENTITY_STATE
	is_entity_state_pdu

	# PDU is Platform
	is_platform_pdu

	# PDU platform_entity_type_string does not match platformEntityType field from the rule
	not platform_entity_type_matches(platform_entity_type_string, first_matching_label_rule)
}

# Rule D
# use matchAttribute from first matching lable rule if PDU is ENTITY_STATE but not platform
# and label rule is not ENTITY_STATE
label_to_use := {"label": first_matching_label_rule.matchAttribute, "rule": "D"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has entity id field
	pdu_has_entity_id

	# PDU is ENTITY_STATE
	is_entity_state_pdu

	# PDU is not Platform
	not is_platform_pdu

	# first matching rule is not ENTITY_STATE
	not is_entity_state_rule(first_matching_label_rule)
}

# Rule E
# use matchAttribute from first matching label rule if matching rule is ENTITY_STATE and rule has entity kind matches PDU entity kind
label_to_use := {"label": first_matching_label_rule.matchAttribute, "rule": "E"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has entity id field
	pdu_has_entity_id

	# PDU is ENTITY_STATE
	is_entity_state_pdu

	# PDU is not Platform
	not is_platform_pdu

	# first matching rule is ENTITY_STATE
	is_entity_state_rule(first_matching_label_rule)

	# extract entity kind string
	entity_kind_str := get_entity_kind_string(input.entityType)

	# PDU entity kind matches some values from the rule's entityKinds field
	entity_kind_matches_any(entity_kind_str, first_matching_label_rule)
}

# Rule F
# use unmatchLabel from first matching label rule if matching rule is ENTITY_STATE
# but rule does not have any entity kind match PDU entity kind
label_to_use := {"label": first_matching_label_rule.unmatchAttribute, "rule": "F"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has entity id field
	pdu_has_entity_id

	# PDU is ENTITY_STATE
	is_entity_state_pdu

	# PDU is not Platform
	not is_platform_pdu

	# first matching rule is ENTITY_STATE
	is_entity_state_rule(first_matching_label_rule)

	# extract entity kind string
	entity_kind_str := get_entity_kind_string(input.entityType)

	# PDU entity kind does not match all values from the rule's entityKinds field
	not entity_kind_matches_any(entity_kind_str, first_matching_label_rule)
}

# Rule G
# use matchAttribute from first matching lable rule if PDU platform_entity_type_string
# matches platformEntityType field from the rule but label rule is not ENTITY_STATE
label_to_use := {"label": first_matching_label_rule.matchAttribute, "rule": "G"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has entity id field
	pdu_has_entity_id

	# PDU is ENTITY_STATE
	is_entity_state_pdu

	# PDU is Platform
	is_platform_pdu

	# platform_entity_type_string matches platformEntityType field from the rule
	platform_entity_type_matches(platform_entity_type_string, first_matching_label_rule)

	# first matching rule is not ENTITY_STATE
	not is_entity_state_rule(first_matching_label_rule)
}

# Rule H
# use matchAttribute from first matching lable rule if PDU platform_entity_type_string
# matches platformEntityType field from the rule but label rule is not ENTITY_STATE
label_to_use := {"label": first_matching_label_rule.matchAttribute, "rule": "H"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has entity id field
	pdu_has_entity_id

	# PDU is ENTITY_STATE
	is_entity_state_pdu

	# PDU is Platform
	is_platform_pdu

	# platform_entity_type_string matches platformEntityType field from the rule
	platform_entity_type_matches(platform_entity_type_string, first_matching_label_rule)

	# first matching rule is ENTITY_STATE
	is_entity_state_rule(first_matching_label_rule)

	# extract entity kind string
	entity_kind_str := get_entity_kind_string(input.entityType)

	# PDU entity kind matches some values from the rule's entityKinds field
	entity_kind_matches_any(entity_kind_str, first_matching_label_rule)
}

# Rule I
# use matchAttribute from first matching lable rule if PDU platform_entity_type_string
# matches platformEntityType field from the rule but label rule is not ENTITY_STATE
label_to_use := {"label": first_matching_label_rule.matchAttribute, "rule": "I"} {
	# first matching label rule can be found
	has_first_matching_label_rule

	# PDU has entity id field
	pdu_has_entity_id

	# PDU is ENTITY_STATE
	is_entity_state_pdu

	# PDU is Platform
	is_platform_pdu

	# platform_entity_type_string matches platformEntityType field from the rule
	platform_entity_type_matches(platform_entity_type_string, first_matching_label_rule)

	# first matching rule is ENTITY_STATE
	is_entity_state_rule(first_matching_label_rule)

	# extract entity kind string
	entity_kind_str := get_entity_kind_string(input.entityType)

	# PDU entity kind matches some values from the rule's entityKinds field
	not entity_kind_matches_any(entity_kind_str, first_matching_label_rule)
}

# Rule default
# Use default label when first matching label rule cannot be found
label_to_use := {"label": default_label, "rule": "default"} {
	not has_first_matching_label_rule
}

################################################################################################

# helper method to construct string representation of entity type.
entity_type_to_string(entity_type) := f {
	kind = format_int(entity_type.entityKind, 10)
	domain = format_int(entity_type.domain, 10)
	country = format_int(entity_type.country, 10)
	category = format_int(entity_type.category, 10)
	subcategory = format_int(entity_type.subcategory, 10)
	specific = format_int(entity_type.specific, 10)
	extra = format_int(entity_type.extra, 10)

	array = [kind, domain, country, category, subcategory, specific, extra]
	f := concat(".", array)
}

# helper method to determine if PDU platform entity type string matches platformEntityType field
# from rule.
platform_entity_type_matches(entity_type_string, rule) := f {
	f := entity_type_string == rule.platformEntityType
}

# helper method to determine if rule is ENTITY_STATE
is_entity_state_rule(rule) := f {
	f := rule.pduType == "ENTITY_STATE"
}

# helper method to extract entity kind
get_entity_kind(entity_type) := f {
	f := entity_type.entityKind
}

# helper method to extract entity kind as string
get_entity_kind_string(entity_type) := f {
	f := format_int(entity_type.entityKind, 10)
}

# helper method to check if PDU entity kind matches any entity kind from label rule
entity_kind_matches_any(entity_kind, rule) := f {
	kinds = [kind | some i; rule.entityKinds[i] == entity_kind; kind := rule.entityKinds[i]]
	f := count(kinds) > 0
}
