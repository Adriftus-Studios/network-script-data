definition_registry:
    type: task
    debug: false
    definitions: definitions
    script:
        - foreach <[definitions]>:
            - define <[key]> <[value]>
