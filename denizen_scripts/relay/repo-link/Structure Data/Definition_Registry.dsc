Definition_Registry:
    type: task
    debug: false
    definitions: Definitions
    script:
        - foreach <[Definitions]>:
            - define <[Key]> <[Value]>
