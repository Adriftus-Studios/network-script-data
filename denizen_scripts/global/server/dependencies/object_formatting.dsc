script_formatting:
  type: procedure
  debug: false
  definitions: content|padding|inline
  # todo : definitions: ... |script_type
  script:
    - define padding 0 if:!<[padding].exists>

    - define space <&sp.repeat[<[padding]>]>
    - define values <list>

    - if <[inline].exists>:
      - define initial_space <empty>
    - else:
      - define initial_space <[space]>

    # todo : scripts are always maps, add error for malformed script container type
    # - if <[content].object_type> == map:
    - foreach <[content]> if:<[content].object_type.advanced_matches[map|list]>:
      - choose <[value].object_type>:
        - case map:
          - define values <[values].include_single[<&e><[key]><&6>:<&a><n><proc[script_formatting].context[<list_single[<[value]>].include[<[padding].add[2]>|false]>]>]>

        - case list:
          - define values <[values].include_single[<proc[script_formatting].context[<list_single[<[value]>].include[<[padding].add[2]>|true]>]>]>

        - default:
          - define values <[values].include_single[<[value]>]>

    - choose <[content].object_type>:
      - case map:
        - determine <[initial_space]><[values].separated_by[<n><[space]>]>

      - case list:
        - determine "<[initial_space]><&e>-<&a> <[values].separated_by[<n><[space]><&e>-<&a> ]>"

      - default:
        - determine <[initial_space]><[space]><[values].separated_by[<n><[space]>]>

object_formatting:
  type: procedure
  definitions: object|padding
  debug: false
  script:
    - define padding 0 if:!<[padding].exists>

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
    - define padding 0 if:!<[padding].exists>

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
    - define padding 0 if:!<[padding].exists>

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
