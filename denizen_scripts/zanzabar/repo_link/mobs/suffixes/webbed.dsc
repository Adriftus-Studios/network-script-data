custom_mob_suffix_webbed:
  Type: world
  debug: false
  events:
    after entity_flagged:Webbed targets entity:
      - define cobwebUUID <util.random.uuid>
      - define targets <context.target.location.find.surface_blocks.within[2]>
      - foreach <[targets]>:
        - shoot falling_block[fallingblock_type=cobweb;fallingblock_drop_item=false] height:3 destination:<[value]> origin:<context.entity> save:web
        - flag <entry[web].shot_entity> showfake
        - playsound <context.entity.location> sound:ITEM_ARMOR_EQUIP_LEATHER pitch:1.5
        - wait <util.random.int[3].to[5]>t
      - wait 60t

mock_web_showfake:
  type: world
  debug: false
  events:
    on material falls:
      - stop if:<context.entity.has_flag[showfake].not>
      - determine passively cancelled
      - showfake <context.entity.fallingblock_material> <context.location> players:<context.location.find.players.within[40]> duration:1m
