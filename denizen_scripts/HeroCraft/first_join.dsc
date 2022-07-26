first_join:
  type: world
  debug: false
  events:
    on player joins:
      - if !<player.has_flag[has_joined]>:
        - teleport <player> <location[0,1000,0,HeroCraft]>
        - wait 1s
        - title "title:<&color[#000001]>Welcome to Herocraft!!!" fade_in:1s stay:5s fade_out:1s
        - wait 7s
        - teleport <player> <location[0,400,0,HeroCraft].random_offset[12500,0,12500]>
        - equip <player> chest:elytra[flag=on_drop:delete_item]
        - wait 1t
        - adjust <player> gliding:true
        - flag player has_joined
        - while <player.location.below.material.name.contains_text[air]>:
          - wait 5s
          - while stop if:<player.is_online.not>
        - take item:elytra
        - equip head:leather_helmet chest:leather_chestplate legs:leather_leggings feet:leather_boots
        - foreach stone_sword|stone_pickaxe|stone_axe|stone_shovel|tpa_crystal|campfire|food_crate as:item:
          - give <[item]>
