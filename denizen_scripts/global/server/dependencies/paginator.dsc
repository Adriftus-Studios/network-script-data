#- returns the paginated list entries from the page specified per the limit required
paginator:
  type: procedure
  definitions: list|limit|page
  debug: false
  error:
    - debug error <&c><[error]>
    - determine <[error]>
  script:
    - if <server.has_flag[behr.essentials.mode.debug]>:
      - if <[list]||invalid> == invalid:
        - define error "Invalid list input."
        - inject locally error

      - if <[limit]||invalid> == invalid:
        - define error "Invalid limit input."
        - inject locally error

      - if <[page]||invalid> == invalid:
        - define error "Invalid page input."
        - inject locally error

    - define size <[list].size>
    - define page_count <[size].div[<[limit]>].round_up>

    - if <server.has_flag[behr.essentials.mode.debug]>:
      - if <[list].type> != list:
        - define error "Invalid list input. Got list object type as `<[list].type>`."
        - inject locally debug

      - if <[list].is_empty>:
        - define error "Empty list exception."
        - inject locally error
      - if !<[limit].is_integer>:
        - define error "Invalid limit input. Got input `<[limit]>`."
        - inject locally error

      - if !<[page].is_integer>:
        - define error "Invalid page input. Got input `<[page]>`."
        - inject locally error

      - if <[page]> > <[page_count]> || <[page]> <= 0:
        - define error "Out of range exception. Got page `<[page]>` with `<[page_count]>` page(s) available."
        - inject locally error

    - if <[size]> < <[limit]>:
      - determine <[list]>

    - define index_1 <[limit].mul[<[page].sub[1]>].add[1]>
    - define index_2 <[limit].mul[<[page].sub[1]>].add[<[limit]>]>
    - determine <[list].get[<[index_1]>].to[<[index_2]>]>

#- returns the indexes in reference of the page against the limit
#- returns a MapTag; first/index_1|last/index_2
page_indexer:
  type: procedure
  debug: false
  definitions: limit|page
  error:
    - debug error <&c><[error]>
    - determine <[error]>
  script:
    - if <server.has_flag[behr.essentials.mode.debug]>:
      - if <[limit]||invalid> == invalid:
        - define error "Invalid limit input."
        - inject locally error

      - if !<[limit].is_integer>:
        - define error "Invalid limit input. Got input `<[limit]>`."
        - inject locally error

      - if <[page]||invalid> == invalid:
        - define error "Invalid page input."
        - inject locally error

      - if !<[page].is_integer>:
        - define error "Invalid page input. Got input `<[page]>`."
        - inject locally error

    - define index_1 <[limit].mul[<[page].sub[1]>].add[1]>
    - define index_2 <[limit].mul[<[page].sub[1]>].add[<[limit]>]>
    - determine <map.with[first].as[<[index_1]>].with[last].as[<[index_2]>]>
