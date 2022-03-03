calculate_durability_damage:
    type: procedure
    definitions: unbreaking_level
    debug: false
    script:
    - determine <element[1].div[<[unbreaking_level].add[1]>]>

calculate_fortune_drops:
    type: procedure
    definitions: fortune_level|quantity
    debug: false
    script:
    - define quantity <[quantity]||1>
    - define list:|:1
    - repeat <[fortune_level].add[1]>:
        - define list:|:<[value]>
    - determine <[quantity].mul[<util.random.decimal[1].to[<[list].random>]>]||1>