Herocraft_RTP:
  type: task
  debug: false
  script:
      - if !<player.has_advancement[denizen:joined_herocraft]>:
        - run achievement_give def:joined_herocraft
        - flag player has_joined
      - teleport <player> <location[0,1000,0,HeroCraft]>
      - wait 1s
      - title "title:<&color[#010000]>Drop in!" "subtitle:Prepare to Glide!" fade_in:1s stay:5s fade_out:1s
      - wait 7s
      - teleport <player> <location[0,400,0,HeroCraft].random_offset[12500,0,12500]>
      - define current_chest <player.equipment_map.get[chestplate].if_null[<item[air]>]>
      - equip <player> chest:elytra[flag=on_drop:delete_item;flag=run_script:determine_air;flag=on_item_pickup:<list[remove_this_entity|cancel]>;flag=no_drop_on_death:true]
      - wait 1t
      - adjust <player> gliding:true
      - flag player hot_dropping
      - while <player.location.below.material.name.contains_text[air]>:
        - wait 5s
        - while stop if:<player.is_online.not>
      - if !<player.is_online>:
        - inventory clear
        - flag player hot_dropping:!
        - flag player has_joined:!
        - stop
      - take item:elytra
      - equip <player> chest:<[current_chest]>
      - wait 2s
      - if !<player.has_advancement[denizen:failed_hot_drop]> && <player.has_flag[hot_dropping]>:
        - run achievement_give def:completed_hot_drop
      - flag player hot_dropping:!

hot_drop_death:
  type: task
  debug: false
  events:
    on player dies flagged:hot_dropping:
      - flag player hot_dropping:!
      - wait 5s
      - if <player.is_online>:
        - run achievement_give def:failed_hot_drop
      - else:
        - inventory clear
        - flag player hot_dropping:!
        - flag player has_joined:!

herocraft_first_join:
  type: world
  debug: false
  events:
    after player joins:
      - if !<player.has_advancement[denizen:herocraft]>:
        - wait 2s
        - run achievement_give_parent def:herocraft
