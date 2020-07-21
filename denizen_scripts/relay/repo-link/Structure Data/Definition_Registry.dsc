Definition_Registry:
    type: task
    debug: false
    definitions: Definitions
    speed: 0
    script:
        - foreach <[Definitions].unescaped||<list[]>> as:Pair:
            - define <[Pair].before[/]> <[Pair].after[/]>

Definition_Registry_Mapped:
    type: task
    debug: false
    definitions: Definitions
    speed: 0
    script:
        - foreach <[Definitions].keys> as:Key:
            - define <[Key]> <[Definitions].get[<[Key]>]>
