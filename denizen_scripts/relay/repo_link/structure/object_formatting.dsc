object_formatting:
  type: procedure
  definitions: object|padding
  debug: false
  script:
    - if <[padding]||invalid> == invalid:
      - define padding 0

    - define space "<element[ ].repeat[<[padding]>]>"
    - define values <list>

    - if <[object].object_type> == map:
      - foreach <[object]>:
        - choose <[value].object_type>:
          - case map:
            - define values <[values].include_single[<&e><[key]><&6>:<&a><n><proc[format_map].context[<list_single[<[value]>].include[<[padding].add[2]>|false]>]>]>
          - case list:
            - define values <[values].include_single[<&e><[key]><&6>:<&a><n><proc[format_list].context[<list_single[<[value]>].include[<[padding].add[2]>|false]>]>]>
          - default:
            - define values "<[values].include_single[<&e><[key]><&6>:<&a> <[value]>]>"

      - determine <[space]><[values].separated_by[<n><[space]>]>

format_map:
  type: procedure
  definitions: map|padding|inline
  debug: false
  script:
    - if <[padding]||invalid> == invalid:
      - define padding 0

    - define values <list>
    - define space "<element[ ].repeat[<[padding]>]>"
    - if <[inline]||false>:
      - define initial_space <empty>
    - else:
      - define initial_space <[space]>

    - foreach <[map]>:
      - choose <[value].object_type>:
        - case map:
          - define values <[values].include_single[<&e><[key]><&6>:<&a><n><proc[format_map].context[<list_single[<[value]>].include[<[padding].add[2]>|false]>]>]>
        - case list:
          - define values <[values].include_single[<&e><[key]><&6>:<&a><n><proc[format_list].context[<list_single[<[value]>].include[<[padding].add[2]>|false]>]>]>
        - default:
          - define values "<[values].include_single[<&e><[key]><&6>:<&a> <[value]>]>"

    - determine <[initial_space]><[values].separated_by[<n><[space]>]>

format_list:
  type: procedure
  definitions: list|padding|inline
  debug: false
  script:
    - if <[padding]||invalid> == invalid:
      - define padding 0

    - define values <list>
    - define space "<element[ ].repeat[<[padding]>]>"
    - if <[inline]||false>:
      - define initial_space <empty>
    - else:
      - define initial_space <[space]>

    - foreach <[list]>:
      - choose <[value].object_type>:
        - case map:
          - define values <[values].include_single[<proc[format_map].context[<list_single[<[value]>].include[<[padding].add[2]>|true]>]>]>
        - case list:
          - define values <[values].include_single[<proc[format_list].context[<list_single[<[value]>].include[<[padding].add[2]>|true]>]>]>
        - default:
          - define values <[values].include_single[<[value]>]>

    - determine "<[initial_space]><&e>-<&a> <[values].separated_by[<n><[space]><&e>-<&a> ]>"
