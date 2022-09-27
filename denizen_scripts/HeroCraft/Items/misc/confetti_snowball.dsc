confetti_ball:
  type: item
  debug: false
  material: snowball
  display name: <&6>Confetti Ball
  lore:
  - <&e>Blast some confetti!
  data:
    recipe_book_category: gadgets.1confetti_ball1
  mechanisms:
    custom_model_data: 1
  recipes:
    1:
      type: shapeless
      output_quantity: 16
      input: prismatic_dye|snowball

confetti_ball_shooter:
  type: world
  debug: false
  events:
    on player right clicks block with:confetti_ball:
      - determine passively cancelled
      - take iteminhand
      - ratelimit <player> 2t
      - playsound sound:ENTITY_SNOWBALL_THROW <player.location> pitch:0.1 volume:0.4
      - shoot snowball[item=snowball[custom_model_data=1]] speed:2 script:confetti_explosion

confetti_explosion:
  type: task
  debug: false
  definitions: location
  script:
    - define colors <list[22,255,216|241,134,255|241,228,47|0,200,0]>
    - repeat 10:
      - playeffect effect:redstone at:<[location]> visibility:50 quantity:20 special_data:<util.random.int[1].to[3]>|<util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]> offset:0.5
