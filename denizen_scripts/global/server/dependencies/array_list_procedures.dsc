# % ██ [ Determine if a list of maps contains an entry mapped by the key ] ██
# - ██ | Usage: <proc[array_validate].context[Yaml|Parent|Key|Value]>
# ^ ██ | Yaml: The yaml file we search   | Parent: The key containing a ListTag to search
# ^ ██ | Key: The mapping value to match | Value: The value searched and validated
# + ██ | Compare to: <yaml[Yaml].read[Parent].filter_tag[<[filter_value].get[Key].is[==].to[Value]>].is_empty.not>
array_validate:
    type: procedure
    definitions: yaml|parent|key|value
    script:
        - if !<yaml[<[yaml]>].contains[<[parent]>]>:
            - determine false
        - if <yaml[<[yaml]>].read[<[parent]>].filter[get[<[key]>].is[==].to[<[value]>]].is_empty>:
            - determine false
        - else:
            - determine true

# % ██ [ Determines the value of a mapped key within a list of mappings  ] ██
# $ ██ | Note: This is intended for first-match or one result returns. See [array_lookup_multi] for a ListTag return.
# - ██ | Usage: <proc[array_validate].context[Yaml|Parent|Key|Value]>
# ^ ██ | Yaml: The yaml file we search   | Parent: The key containing a ListTag to search
# ^ ██ | Key: The mapping value to match | Value: The value searched and returned
# + ██ | Compare to: <yaml[Yaml].read[Parent].filter_tag[<[filter_value].get[Key].is[==].to[Value]>].first||invalid>
array_lookup:
    type: procedure
    definitions: yaml|parent|key|value
    script:
        - if !<yaml[<[yaml]>].contains[<[parent]>]>:
            - determine invalid
        - determine <yaml[<[yaml]>].read[<[parent]>].filter[get[<[key]>].is[==].to[<[value]>]].first>

# % ██ [ Determines the values of a mapped key within a list of mappings ] ██
# $ ██ | Note: This is intended for multiple result returns as a ListTag. See [array_lookup] for an exact match.
# - ██ | Usage: <proc[array_lookup_multi].context[Yaml|Parent|Key|Values]>
# ^ ██ | Yaml: The yaml file we search    | Parent: The key containing a ListTag to search
# ^ ██ | Key: The mapping values to match | values: The values searched and returned
# + ██ | Compare to: <yaml[Yaml].read[Parent].filter_tag[<[filter_value].contains_any[Value]>]>
array_lookup_multi:
    type: procedure
    definitions: yaml|parent|key|values
    script:
        - if !<yaml[<[yaml]>].contains[<[parent]>]>:
            - determine invalid
        - if <yaml[<[yaml]>].read[<[parent]>].is_empty>:
            - determine <list>
        - determine <yaml[<[yaml]>].read[<[parent]>].filter[get[<[key]>].contains_any[<[values]>]]>
