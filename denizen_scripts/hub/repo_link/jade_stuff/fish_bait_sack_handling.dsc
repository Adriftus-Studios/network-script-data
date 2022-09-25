fishbot_baitsack_handling:
  type: world
  debug: false
  events:
    on player clicks block location_flagged:fish_bait_sack:
      - determine passively cancelled
      - ratelimit <player> 2t
      - inventory open d:jade_bait_inventory
    on player clicks item in jade_bait_inventory*:
      - if <context.item.material.name> == gray_stained_glass_pane || <context.item.material.name||air> == air || <context.raw_slot> > 27:
        - stop
      - inventory open d:bait_inventory_<context.item.script.name.after[bait_counter_]>
      - playsound sound:UI_BUTTON_CLICK <player>
    on player clicks item in bait_inventory_*:
      - if <context.item.script.name.after[fishing_bait_]||null> != <context.inventory.script.name.after[bait_inventory_]> && <context.item.material.name> != air:
        - determine passively cancelled
      - if <list[standard_filler|standard_accept_button|standard_back_button].contains_any[<context.item.script.name.if_null[null]>]>:
        - determine passively cancelled
        - choose <context.item.script.name>:
          - case default:
            - stop
          - case standard_accept_button standard_back_button:
            - define amount <element[0]>
            - playsound sound:UI_BUTTON_CLICK <player>
            - foreach <context.inventory.list_contents.exclude[standard_filler|standard_accept_button|standard_back_button|air]> as:item:
              - if <list[standard_filler|standard_accept_button|standard_back_button|null].contains_any[<[item].script.name||null>]>:
                - foreach next
              - define amount <[amount].add[<[item].quantity>]>
            - define flag_path fishbot.bait.<context.inventory.script.name.after[bait_inventory_]>
            - flag <player> <[flag_path]>:<[amount]>
            - wait 2t
            - inventory open d:jade_bait_inventory
    on player closes bait_inventory_*:
      - define amount <element[0]>
      - foreach <context.inventory.list_contents.exclude[standard_filler|standard_accept_button|standard_back_button|air]> as:item:
        - if <list[standard_filler|standard_accept_button|standard_back_button|null].contains_any[<[item].script.name||null>]>:
          - foreach next
        - define amount <[amount].add[<[item].quantity>]>
      - define flag_path fishbot.bait.<context.inventory.script.name.after[bait_inventory_]>
      - flag <player> <[flag_path]>:<[amount]>

jade_bait_inventory:
  type: inventory
  inventory: chest
  title: Jade's Bait Sack
  gui: true
  debug: false
  size: 27
  slots:
  - [bait_counter_worm] [standard_filler] [bait_counter_leech] [standard_filler] [bait_counter_rabbit] [standard_filler] [bait_counter_chum] [standard_filler] [bait_counter_magma]
  - [standard_filler] [bait_counter_gilded] [standard_filler] [bait_counter_silverfish] [standard_filler] [bait_counter_slime] [standard_filler] [bait_counter_clay] [standard_filler]
  - [bait_counter_endmite] [standard_filler] [bait_counter_shulker] [standard_filler] [bait_counter_mysterious] [standard_filler] [bait_counter_golden] [standard_filler] [bait_counter_blinding]


bait_counter_worm:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 1
  display name: <&f>Worms
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.worm]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.worm.level]><&6>.
  - <&6>Obtained by<&co><&e> digging up dirt type blocks<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_worm:
  type: inventory
  debug: false
  inventory: chest
  title: Worm Bait
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.worm]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_worm[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_worm[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_leech:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 3
  display name: <&f>Leeches
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.leech]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.leech.level]><&6>.
  - <&6>Obtained by<&co><&e> killing sea life<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_leech:
  type: inventory
  debug: false
  inventory: chest
  title: Leech Bait
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.leech]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_leech[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_leech[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_rabbit:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 5
  display name: <&f>Rabbits Feet
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.rabbit]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.rabbit.level]><&6>.
  - <&6>Obtained by<&co><&e> killing rabbits<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_rabbit:
  type: inventory
  debug: false
  inventory: chest
  title: Rabbit's Foot Bait
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.rabbit]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_rabbit[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_rabbit[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_chum:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 6
  display name: <&f>Chum
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.chum]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.chum.level]><&6>.
  - <&6>Obtained by<&co><&e> killing sea life, combining leeches<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_chum:
  type: inventory
  debug: false
  inventory: chest
  title: Chum Bait
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.chum]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_chum[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_chum[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_magma:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 8
  display name: <&f>Magma Lures
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.magma]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.magma.level]><&6>.
  - <&6>Obtained by<&co><&e> killing magma cubes, combining magma cream<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_magma:
  type: inventory
  debug: false
  inventory: chest
  title: Magma Lure Bait
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.magma]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_magma[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_magma[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]


bait_counter_gilded:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 10
  display name: <&f>Gilded Worms
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.gilded]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.gilded.level]><&6>.
  - <&6>Obtained by<&co><&e> gilding worms<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_gilded:
  type: inventory
  debug: false
  inventory: chest
  title: Gilded Worm Bait
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.gilded]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_gilded[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_gilded[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_silverfish:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 12
  display name: <&f>Silverfish Bait
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.silverfish]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.silverfish.level]><&6>.
  - <&6>Obtained by<&co><&e> killing silverfish<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_silverfish:
  type: inventory
  debug: false
  inventory: chest
  title: Silverfish
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.silverfish]||0>
    - if <[item_quantity]> == 0:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_silverfish[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_silverfish[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_slime:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 14
  display name: <&f>Slime Balls
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.slime]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.slime.level]><&6>.
  - <&6>Obtained by<&co><&e> killing slimes<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_slime:
  type: inventory
  debug: false
  inventory: chest
  title: Slime Balls
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.slime]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_slime[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_slime[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_clay:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 15
  display name: <&f>Clay Balls
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.clay]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.clay.level]><&6>.
  - <&6>Obtained by<&co><&e> breaking clay blocks<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_clay:
  type: inventory
  debug: false
  inventory: chest
  title: Clay Balls
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.clay]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_clay[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_clay[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_endmite:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 16
  display name: <&f>Endmites
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.endmite]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.endmite.level]><&6>.
  - <&6>Obtained by<&co><&e> killing endmites, corrupting silverfish with end pearls<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_endmite:
  type: inventory
  debug: false
  inventory: chest
  title: Endmite Bait
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.endmite]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_endmite[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_endmite[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_shulker:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 18
  display name: <&f>Shulker Tongues
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.shulker]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.shulker.level]><&6>.
  - <&6>Obtained by<&co><&e> killing shulkers<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_shulker:
  type: inventory
  debug: false
  inventory: chest
  title: Shulker Tongues
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.shulker]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_shulker[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_shulker[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_mysterious:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 20
  display name: <&f>Mysterious Shards
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.mysterious]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.mysterious.level]><&6>.
  - <&6>Obtained by<&co><&e> killing humanoids<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_mysterious:
  type: inventory
  debug: false
  inventory: chest
  title: Mysterious Shards
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.mysterious]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_mysterious[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_mysterious[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_golden:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 22
  display name: <&f>Golden Fragments
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.golden]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.golden.level]><&6>.
  - <&6>Obtained by<&co><&e> combining shulker tongues, mysterious shards<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_golden:
  type: inventory
  debug: false
  inventory: chest
  title: Golden Fragments
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.golden]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_golden[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_golden[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

bait_counter_blinding:
  type: item
  debug: false
  material: amethyst_shard
  mechanisms:
    custom_model_data: 24
  display name: <&f>Blinding Shards
  lore:
  - <&6>Current Count<&co> <&e><player.flag[fishbot.bait.blinding]||0><&6>.
  - <&6>Requires Jade level<&co><&e> <script[fishbot_data_storage].data_key[bait.blinding.level]><&6>.
  - <&6>Obtained by<&co><&e> combining natural light items, and gilded fragments<&6>.
  - <&sp>
  - <&b>Left Click<&6> to add bait.

bait_inventory_blinding:
  type: inventory
  debug: false
  inventory: chest
  title: Blinding Shards
  procedural items:
    - define item_quantity <player.flag[fishbot.bait.blinding]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_bait_blinding[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_bait_blinding[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]
