daily_rewards_test:
  type: task
  script:
    - if <player.has_flag[daily_rewarded]>:
      - narrate "<&c>You have already claimed your daily reward."
      - narrate "<&e>You can claim another one in <&b><player.flag[daily_rewarded].expiration.formatted><&e>!"
      - stop
    - if <server.has_flag[daily_rewarding]>:
      - narrate "<&c>Another player is claiming their daily reward."
      - narrate "<&e>You can claim yours right after them!"
      - stop
    - flag server daily_rewarding:true
    - flag player daily_rewarded:true duration:<util.time_now.add[1d].start_of_day.duration_since[<util.time_now>]>
    - animatechest <location[spawn_daily_chest]> open <player.world.players>
    - wait 10t
    - spawn dropped_item[item=diamond_sword;pickup_delay=10s;gravity=false;velocity=0,0,0;custom_name_visible=true;custom_name=<&b><player.name>'s<&sp><&a>Daily<&sp><&d>Reward...] <location[spawn_daily_item]> save:item
    - define list:!|:<yaml[daily_reward].read[rotating_items]>
    - run daily_rewards_particles
    - repeat 20:
      - adjust <entry[item].spawned_entity> item:<[list].random>
      - playsound <location[spawn_daily_chest]> sound:BLOCK_NOTE_BLOCK_SNARE volume:0.6 pitch:1.5
      - playsound <location[spawn_daily_chest]> sound:BLOCK_NOTE_BLOCK_HARP volume:0.8 pitch:1.1
      
      - wait 2t
    - repeat 12:
      - adjust <entry[item].spawned_entity> item:<[list].random>
      - playsound <location[spawn_daily_chest]> sound:BLOCK_NOTE_BLOCK_SNARE volume:0.6 pitch:1.4
      - playsound <location[spawn_daily_chest]> sound:BLOCK_NOTE_BLOCK_HARP volume:0.7 pitch:1.0
      
      - wait 5t
    - define reward_type <list[item|item|item|title|bow_trail].get[<util.random.decimal[0.01].to[1.4].*[3].round_up>]>
    - playsound <location[spawn_daily_chest]> sound:ENTITY_DRAGON_FIREBALL_EXPLODE volume:0.8 pitch:1.6
    - playeffect dragon_breath at:<location[spawn_daily_item].above[.4]> quantity:60 offset:0.1 data:0.15
    - choose <[reward_type]>:
      - case item:
        - adjust <entry[item].spawned_entity> item:<yaml[daily_reward].read[items_to_win.items].random>
        - adjust <entry[item].spawned_entity> "custom_name:<&e>You won <&b><entry[item].spawned_entity.item.material.name.replace[_].with[<&sp>].to_titlecase><&e>!"
        - give <entry[item].spawned_entity.item>
        - narrate "<&e>You won <&b><entry[item].spawned_entity.item.material.name.replace[_].with[<&sp>].to_titlecase><&e>!"
      - case title:
        - define title <yaml[daily_reward].read[items_to_win.titles].random>
        - adjust <entry[item].spawned_entity> item:name_tag
        - adjust <entry[item].spawned_entity> "custom_name:<&e>You won a title<&co> <&b><yaml[titles].read[titles.<[title]>.tag].parse_color.parsed><&e>!"
        - give "<item[title_voucher].with[display_name=<&b>Title Voucher<&co> <yaml[titles].read[titles.<[title]>.tag].parse_color>;lore=<&e>Right Click to Redeem;nbt=title/<[title]>]>"
        - narrate "<&e>You won a title<&co> <&b><yaml[titles].read[titles.<[title]>.tag].parse_color.parsed><&e>!"
      - case bow_trail:
        - define bow_trail <yaml[daily_reward].read[items_to_win.bow_trail].random>
        - adjust <entry[item].spawned_entity> item:<yaml[bowtrails].read[bowtrails.<[bow_trail]>.icon]>
        - adjust <entry[item].spawned_entity> "custom_name:<&e>You won a bow trail<&co> <&b><yaml[bowtrails].read[bowtrails.<[bow_trail]>.name].parse_color.parsed><&e>!"
        - give "<item[bowtrail_voucher].with[display_name=<&b>Bow Trail Voucher<&co> <yaml[bowtrails].read[bowtrails.<[bow_trail]>.name].parse_color>;lore=<&e>Right Click to Redeem;nbt=trail/<[bow_trail]>]>"
        - narrate "<&e>You won a bow trail<&co> <&b><yaml[bowtrails].read[bowtrails.<[bow_trail]>.name].parse_color.parsed><&e>!"
    - wait 3s
    - remove <entry[item].spawned_entity>
    - animatechest <location[spawn_daily_chest]> close <player.world.players>
    - wait 20t
    - flag server daily_rewarding:!

daily_rewards_particles:
  type: task
  script:
    - repeat 70:
      - playeffect enchantment_table at:<location[spawn_daily_item].above[1]> quantity:10 offset:0.1 data:2
      - wait 1t

daily_reward_command:
  type: command
  name: give_daily_reward
  permission: not.a.perm
  script:
    - inject daily_rewards_test player:<server.match_player[<context.args.first>]>

daily_reward_config_manager:
  type: world
  debug: false
  load_yaml:
    - if <server.has_file[data/global/network/daily_rewards.yml]>:
      - yaml id:daily_reward load:data/global/network/daily_rewards.yml
  events:
    on server start:
      - inject locally load_yaml
    on reload scripts:
      - inject locally load_yaml
