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
    - foreach <[content]> if:<[content].object_type.advanced_matches_text[map|list]>:
      - choose <[value].object_type>:
        - case map:
          - define values <[values].include_single[<[key]>:<n><proc[script_formatting].context[<list_single[<[value]>].include[<[padding].add[2]>|false]>]>]>

        - case list:
          - define values <[values].include_single[<proc[script_formatting].context[<list_single[<[value]>].include[<[padding].add[2]>|true]>]>]>

        - default:
          - define values <[values].include_single[<[value]>]>

    - choose <[content].object_type>:
      - case map:
        - determine <[initial_space]><[values].separated_by[<n><[space]>]>

      - case list:
        - determine "<[initial_space]>- <[values].separated_by[<n><[space]>- ]>"

      - default:
        - determine <[initial_space]><[space]><[values].separated_by[<n><[space]>]>
