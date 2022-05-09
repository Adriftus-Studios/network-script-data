arabic_to_roman:
  type: procedure
  debug: false
  definitions: ARABIC
  data:
    1000: M
    500: D
    400: CD
    100: C
    90: XC
    50: L
    40: XL
    10: X
    9: IX
    5: V
    4: IV
    1: I
  script:
  - define NBR <script.data_key[data]>
  - while <[ARABIC]> > 0:
    - define HIGHEST <[NBR].keys.filter_tag[<[filter_value].is[or_less].than[<[ARABIC]>]>].highest>
    - define ROMAN:->:<[NBR].get[<[HIGHEST]>]>
    - define ARABIC <[ARABIC].sub[<[HIGHEST]>]>
    - if <[loop_index]> > 100:
      - determine ERROR
  - determine <[ROMAN].separated_by[]>
