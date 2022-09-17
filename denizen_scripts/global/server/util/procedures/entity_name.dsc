entity_name:
    type: procedure
    definitions: e
    script:
    - determine "<[e].custom_name.if_null[<[e].entity_type.replace[_].with[ ].to_titlecase>]>"