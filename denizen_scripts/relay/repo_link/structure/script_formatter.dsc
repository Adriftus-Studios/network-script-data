script_formatting:
  type: procedure
  definitions: object|padding|inline
  debug: false
  script:
    - define padding 0 if:!<[padding].exists>

    - define space <&sp.repeat[<[padding]>]>
    - define values <list>

    - if <[inline].is_truthy>:
      - define initial_space <empty>
    - else:
      - define initial_space <[space]>

    - define debug.object <[object]>
    - foreach <[object]>:
      - if <[object].object_type> == map:
        - choose <[value].object_type>:
          - case map:
            - define values <[values].include_single[<[key]><&co><n><proc[script_formatting].context[<list_single[<[value]>].include[<[padding].add[2]>|false]>]>]>

          - case list:
            - define values <[values].include_single[<[key]><&co><n><proc[script_formatting].context[<list_single[<[value]>].include[<[padding].add[2]>|false]>]>]>

          - default:
            - define values "<[values].include_single[<[key]><&co> <[value]>]>"

      - else if <[object].object_type> == list:
        - choose <[value].object_type>:
          - case map:
            - define values <[values].include_single[<proc[script_formatting].context[<list_single[<[value]>].include[<[padding].add[2]>|true]>]>]>

          - case list:
            - define values <[values].include_single[<proc[script_formatting].context[<list_single[<[value]>].include[<[padding].add[2]>|true]>]>]>

          - default:
            - define values <[values].include_single[<[value]>]>


    - choose <[object].object_type>:
      - case map:
        - determine <[space]><[values].separated_by[<n><[space]>]>
      - case list:
        - determine "<[initial_space]>- <[values].separated_by[<n><[space]>- ]>"
      - default:
        - define values <[values].include_single[<[value]>]>
