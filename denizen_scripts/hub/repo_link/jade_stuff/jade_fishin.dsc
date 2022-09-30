fishbot_advancement_compiler:
  type: task
  debug: false
  definitions: player|job|level
  script:
  ## Used to grant the advancements every X levels from the jobs leveling script.
    - advancement grant:<[player]> id:<[job]>_<[level]>_advancement

fishbot_command_checking:
  type: world
  debug: false
  events:
    on discord slash command name:fish:
    - ~discordinteraction defer ephemeral:true interaction:<context.interaction>

    - if !<context.interaction.user.has_flag[minecraft.account_linked]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't know who you are. Please /link your account in game!" ephemeral:true
      - stop

    - define user <context.interaction.user.flag[minecraft.account_linked]>

    - if <[user].has_flag[fishbot.fishing_now]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade is already out fishing." ephemeral:true
      - stop

    - if <[user].flag[fishbot.caught_items].size> >= <element[27].add[<[user].flag[fishbot.barrel_expanded].if_null[0].mul[9]>]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't have anywhere to put more fish. Please empty your barrel in game!" ephemeral:true
      - stop
    - define config <script[fishbot_data_storage]>
    - define area <context.options.get[area].if_null[<[user].flag[fishbot.area_previous].if_null[plains]>]>
    - if !<[config].list_keys[area].contains_any[<[area]>]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't know where that is." ephemeral:true
      - stop


    - define key_count <[user].flag[fishbot.keys].if_null[0]>
    - if <[key_count]> < <[config].data_key[area.<[area]>.key_cost]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't have enough keys to go there!" ephemeral:true
      - stop

    - define npc_level <[user].flag[fishbot.jade.level].if_null[0]>
    - if <[npc_level]> < <[config].data_key[area.<[area]>.min_level]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't feel safe going there yet." ephemeral:true
      - stop

    - define boat <context.options.get[boat]||<[user].flag[fishbot.boat_previous]>||none>
    - if !<[config].list_keys[boat].contains_any[<[boat]>]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't know what kind of boat that is." ephemeral:true
      - stop
    - define boat_tier <[config].data_key[boat.<[boat].if_null[<[user].flag[fishbot.boat_previous]>]>.tier].if_null[0]>
    - if <[boat_tier]> < <[config].data_key[area.<[area]>.boat_tier]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade's current boat just isn't up to the task." ephemeral:true
      - stop
    - if !<[user].flag[fishbot.boats_stored].parse[script.name].after[fishing_boat_].contains_any_text[<[boat]>]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't have that kind of boat." ephemeral:true
      - stop



    - define fishing_time <[config].data_key[area.<[area]>.duration]>
    - define fishing_time_modifier <element[1].sub[<server.flag[fishbot.daily.fish_time_boost]||0>]>
    - define catch_speed <[config].data_key[area.<[area]>.rate]>
    - define catch_speed_mod <element[1].sub[<server.flag[fishbot.daily.speed_boost]||0>]>
    - define catch_speed_final <[catch_speed].mul[<[catch_speed_mod]>]>
    - define catch_amount <[fishing_time].div[<[catch_speed_final]>]>

    - define bait none
    - if <context.options.get[bait].exists>:
      - define bait <context.options.get[bait]>
      - if !<[config].list_keys[bait].contains_any[<[bait]>]>:
        - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't know what kind of bait that is." ephemeral:true
        - stop
      - if <[npc_level]> < <[config].data_key[bait.<[bait]>.level]>:
        - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't know how to use that bait correctly." ephemeral:true
        - stop
      - if <[user].flag[fishbot.bait.<[bait]>]||0> == 0:
        - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't have that kind of bait." ephemeral:true
        - stop


    - define rod <context.options.get[rod]>
    - if !<[config].list_keys[rod].contains_any[<[rod]>]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't know what kind of fishing rod that is." ephemeral:true
      - stop
    - if <[npc_level]> < <[config].data_key[rod.<[rod]>.level]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't know how to use that rod correctly." ephemeral:true
      - stop
    - if !<[user].flag[fishbot.rods_stored].parse[script.name].after[fishing_rod_].contains_any_text[<[rod]>]>:
      - ~discordinteraction reply interaction:<context.interaction> "Jade doesn't have that kind of rod." ephemeral:true
      - stop

#- subtract 1 trip from the fishing rod
    - define rod_broke false
    - define rod_storage <list[]>
    - foreach <[user].flag[fishbot.rods_stored]> as:item:
      - if !<[item].script.name.after[fishing_rod_].contains_any_text[<[rod]>]> || <[foreach_skipper].exists>:
        - define rod_storage:->:<[item]>
        - foreach next
      - if <[item].flag[trips]> <= 1:
        - define rod_durability_current <[item].flag[trips]>
        - define foreach_skipper <element[1]>
        - define rod_broke true
        - foreach next
      - define item_2 <[item].with_flag[trips:<item[<[item]>].flag[trips].sub[1]>].with[lore=<item[fishing_rod_<[rod]>].lore><&6>Trips<&co><&e><&sp><[item].flag[trips].sub[1]>/<item[fishing_rod_<[rod]>].flag[trips]>]>
      - define rod_durability_current <[item].flag[trips]>
      - define rod_storage:->:<[item_2]>
      - define foreach_skipper <element[1]>
      - foreach next

#- figure out the boats durability
  #- roll for attacks and reduce if unarmored boat
    - define attack none
    - define server_daily_attack_mod <server.flag[fishbot.daily.attack_chance_modifier]||0>
    - if <util.random.int[1].to[100]> <= <[config].data_key[area.<[area]>.attack_chance].sub[<[server_daily_attack_mod]>]>:
      - define attack succeed
      - if <[config].data_key[boat.<[boat]>.armored]||0> > 0:
        - define attack fail
    - define boat_storage <list[]>
    - foreach <[user].flag[fishbot.boats_stored]> as:item2:
      - if !<[item2].script.name.after[fishing_boat_].contains_any_text[<[boat]>]> || <[foreach_skipper2].exists>:
        - define boat_storage:->:<[item2]>
        - foreach next
      - if <[attack].exists>:
        - if <[item2].flag[trips]> <= <[config].data_key[area.<[area]>.attack_damage]>:
          - define boat_durability_current <[item2].flag[trips]>
          - define foreach_skipper2 <element[1]>
          - define boat_broke true
          - foreach next
        - define item_2 <[item2].with_flag[trips:<item[<[item2]>].flag[trips].sub[<[config].data_key[area.<[area]>.attack_damage]>]>].with[lore=<item[fishing_boat_<[boat]>].lore><&6>Trips<&co><&e><&sp><[item2].flag[trips].sub[<[config].data_key[area.<[area]>.attack_damage]>]>/<item[fishing_boat_<[boat]>].flag[trips]>]>
        - define boat_durability_current <[item2].flag[trips]>
        - define boat_storage:->:<[item_2]>
        - define foreach_skipper2 <element[1]>
        - foreach next
      - define boat_durability_current <[item2].flag[trips]>
      - define boat_storage:->:<[item2]>
      - define foreach_skipper2 <element[1]>




    - define channel <context.channel>
    - define rod_durability_max <item[fishing_rod_<[rod]>].flag[trips]>
    - define boat_durability_max <item[fishing_boat_<[boat]>].flag[trips]||A>
    - define boat <context.options.get[boat].if_null[None].replace_text[_].with[<&sp>].to_titlecase>
    - define boat_msg <&lt><[config].data_key[emoji_key.boat_<[boat]>].if_null[<[config].data_key[emoji_key.none]>].parsed><&gt><&sp><context.options.get[boat].if_null[None].replace_text[_].with[<&sp>].to_titlecase><&sp>(Durability<&co><&sp><[boat_durability_current].if_null[N]>/<[boat_durability_max].if_null[A]>)
    - if <[bait]||none> != none:
        - define bait_quantity <[user].flag[fishbot.bait.<[bait]>].sub[1]>
    - define bait_msg <&lt><[config].data_key[emoji_key.bait_<[bait]>].if_null[<[config].data_key[emoji_key.none]>].parsed><&gt><&sp><context.options.get[bait].if_null[None].replace_text[_].with[<&sp>].to_titlecase>
    - define rod <[rod].replace_text[_].with[<&sp>].to_titlecase>
    - define rod_msg <&lt><[config].data_key[emoji_key.rod_<[rod]>].if_null[<[config].data_key[emoji_key.none]>].parsed><&gt><&sp><context.options.get[rod].if_null[None].replace_text[_].with[<&sp>].to_titlecase><&sp>(Durability<&co><&sp><[rod_durability_current]>/<[rod_durability_max]>)
    - define return_time <&sp><util.time_now.add[<[fishing_time]>s].format>
    - if <server.has_flag[fishbot.daily]>:
      - foreach <server.flag[fishbot.daily]> as:booster:
        - define daily_booster_message:->:<[config].data_key[boost_explainers.<[key]>]>
    - define daily_boost_message <[daily_booster_message].separated_by[<&nl>]>
    - define message "**Area<&co>**<&sp><[area].to_titlecase><&nl>**Rod<&co>**<&sp><[rod_msg]><&nl>**Boat<&co>**<&sp><[boat_msg]><&nl>**Bait<&co>**<&sp><[bait_msg]><&sp>(Quantity:<&sp><[bait_quantity].if_null[N/A]>)<&nl>**Return Time<&co>**<[return_time]><&nl><&nl>**Daily<&sp>Boosters<&co>**<&nl><[daily_boost_message].if_null[None]><[donor_messsge].if_null[]>"
    - define embed.color <color[0,254,255]>
    - define embed.title "Jade is Setting Sail!"
    - define embed.thumbnail https://media.discordapp.net/attachments/692370842813726724/1005278267303006278/water-transportation.png
    - define embed.description "<[message]>"
    - ~discordinteraction reply interaction:<context.interaction> "He's on the way!" ephemeral:true
    - ~discordmessage channel:<[channel]> id:jade "<discord_embed.with_map[<[embed]>]>"


    - if <[user].is_online>:
      - inventory close player:<[user]>
    - flag <[user]> fishbot.rods_stored:<[rod_storage]>
    - flag <[user]> fishbot.boats_stored:<[boat_storage]>
    - flag <[user]> fishbot.bait.<[bait]>:--
    - flag <[user]> fishbot.fishing_now
    - runlater fishbot_loot_calculator delay:<[fishing_time]> def.user:<[user]> def.catch_amount:<[catch_amount]> def.area:<[area]> def.bait:<[bait]> def.boat:<[boat]> def.rod:<[rod]> def.rod_broke:<[rod_broke]> def.attack:<[attack]> def.channel:<[channel]>

fishing_debugger:
  type: task
  debug: true
  script:
    - narrate fishing_debugger

create_fishbot_command:
  type: task
  debug: false
  script:
  - definemap options:
      1:
        type: string
        name: area
        description: Where will Jade set sail? (Default last used.)
        required: true

      2:
        type: string
        name: rod
        description: Which fishing rod Jade will use. (Default last used.)
        required: false

      3:
        type: string
        name: boat
        description: Which boat shall Jade take? (Default last used.)
        required: false

      4:
        type: string
        name: bait
        description: What bait you would like Jade to use. (Default last used.)
        required: false
  - ~discordcommand id:jade create name:fish "description:Send jade on his way!" group:546895939781263360 options:<[options]>
