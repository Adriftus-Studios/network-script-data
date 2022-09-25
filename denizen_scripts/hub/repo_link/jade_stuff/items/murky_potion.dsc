murky_potion:
  type: item
  material: potion
  flags:
      type: <server.potion_effect_types.random>
      amplifier: <util.random.int[0].to[1]>
      duration: <util.random.int[200].to[1200]>
  mechanisms:
    hides: all
    color: <util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>
    enchantments: luck,1
  lore:
  - <&6>You're going to drink this, aren't you?
  - <&6>Type<&co> <&e>???
  - <&6>Duration<&co> <&e>???
  display name: <&6>Murky River Potion

murky_potion_handler:
  type: world
  debug: false
  events:
    on player consumes murky_potion:
      - cast <context.item.flag[type]> amplifier:<context.item.flag[amplifier]> duration:<context.item.flag[duration]>t
