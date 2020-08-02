Definition_Registry:
    type: task
    debug: false
    definitions: Definitions
    speed: 0
    script:
        - foreach <[Definitions]>:
            - define <[Key]> <[Value]>
