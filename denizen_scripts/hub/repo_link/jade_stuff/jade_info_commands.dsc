jade_privatifier:
  debug: false
  type: task
  script:
      - if <context.interaction.user.has_flag[fishbot_ratelimiter]> && !<context.options.get[private].if_null[false]>:
        - ~discordinteraction reply interaction:<context.interaction> "Please wait 10 seconds between public command usage!" ephemeral:true
        - stop
      - if !<context.options.get[private].if_null[false]>:
        - ~discordmessage channel:<context.channel> id:jade "<discord_embed.with_map[<[embed]>]>"
        - flag <context.interaction.user> fishbot_ratelimiter expire:200t
        - ~discordinteraction delete interaction:<context.interaction>
      - else:
        - ~discordmessage user:<context.interaction.user> id:jade "<discord_embed.with_map[<[embed]>]>"
        - ~discordinteraction reply interaction:<context.interaction> "Please see your DMs for the requested information!" ephemeral:true

fishbot_area_command_handler:
  type: world
  debug: false
  events:
     on discord slash command name:jade_areas:
      - foreach <script[fishbot_data_storage].list_keys[area]> as:area:
        - if <context.interaction.user.flag[minecraft.account_linked].flag[fishbot.jade.level]> >= <script[fishbot_data_storage].data_key[area.<[area]>.min_level]>:
          - define name <[area].to_titlecase>
          - define level <script[fishbot_data_storage].data_key[area.<[area]>.min_level]>
          - define legendary_fish <script[fishbot_data_storage].list_keys[area.<[area]>.legendary_fish].formatted.replace_text[_].with[<&sp>].to_titlecase>
          - define key_cost <script[fishbot_data_storage].data_key[area.<[area]>.key_cost]>
          - define item_chance <script[fishbot_data_storage].data_key[area.<[area]>.item_chance]>
          - define rare_fish_chance <script[fishbot_data_storage].data_key[area.<[area]>.rare_chance]>
          - define rare_fish <script[fishbot_data_storage].list_keys[area.<[area]>.rare_fish].formatted.replace_text[_].with[<&sp>].to_titlecase>
          - define common_fish <script[fishbot_data_storage].list_keys[area.<[area]>.common_fish].formatted.replace_text[_].with[<&sp>].to_titlecase>
          - define boat_required <script[fishbot_data_storage].data_key[area.<[area]>.boat_required].replace_text[_].with[<&sp>].to_titlecase>

          - define message:->:**<[name]><&co>**<&nl>*Level<&co>*<&sp><[level]><&nl>*Boat<&sp>Required<&co>*<&sp><[boat_required]><&nl>*Key<&sp>Cost<&co>*<&sp><[key_cost]><&nl>*Item<&sp>Chance<&co>*<&sp><[item_chance]><&nl>*Common<&sp>Fish<&co>*<&sp><[common_fish]><&nl>*Rare<&sp>Fish<&sp>Chance<&co>*<&sp><[rare_fish_chance]><&nl>*Rare<&sp>Fish<&co>*<&sp><[rare_fish]><&nl>*Legendary<&sp>Fish<&co>*<&sp><[legendary_fish]>
      - define embed.color <color[0,254,255]>
      - define embed.title "Where can Jade fish?"
      - define embed.thumbnail https://media.discordapp.net/attachments/1004961963136274506/1016198475530125353/download_14.png
      - define embed.description "<[message].separated_by[<&nl>]>"

      - inject jade_privatifier

fishbot_rod_command_handler:
  type: world
  debug: false
  events:
     on discord slash command name:jade_rods:
      - foreach <script[fishbot_data_storage].list_keys[rod]> as:rod:
        - if <context.interaction.user.flag[minecraft.account_linked].flag[fishbot.jade.level]> >= <script[fishbot_data_storage].data_key[rod.<[rod]>.level]>:
          - define message:->:<script[fishbot_data_storage].data_key[rod.<[rod]>.info].parsed>
      - define embed.color <color[0,254,255]>
      - define embed.title "What rods can Jade use?"
      - define embed.thumbnail https://cdn.discordapp.com/attachments/1004961963136274506/1016199115283124366/staff-stick.png
      - define embed.description "<[message].separated_by[<&nl>]>"

      - inject jade_privatifier


fishbot_boat_command_handler:
  type: world
  debug: false
  events:
     on discord slash command name:jade_boat:
      - foreach <script[fishbot_data_storage].list_keys[boat].exclude[none]> as:boat:
        - if <context.interaction.user.flag[minecraft.account_linked].flag[fishbot.jade.level]> >= <script[fishbot_data_storage].data_key[boat.<[boat]>.level]>:
          - define message:->:<script[fishbot_data_storage].data_key[boat.<[boat]>.info].parsed>
      - define embed.color <color[0,254,255]>
      - define embed.title "What boats can Jade use?"
      - define embed.thumbnail https://cdn.discordapp.com/attachments/1004961963136274506/1016198743822962739/download_15.png
      - define embed.description "<[message].separated_by[<&nl>]>"

      - inject jade_privatifier

fishbot_bait_command_handler:
  type: world
  debug: false
  events:
     on discord slash command name:jade_bait:
      - foreach <script[fishbot_data_storage].list_keys[bait].exclude[none]> as:bait:
        - if <context.interaction.user.flag[minecraft.account_linked].flag[fishbot.jade.level]> >= <script[fishbot_data_storage].data_key[bait.<[bait]>.level]>:
          - define message:->:<script[fishbot_data_storage].data_key[bait.<[bait]>.info].parsed>
      - define embed.color <color[0,254,255]>
      - define embed.title "What bait can Jade use?"
      - define embed.thumbnail https://cdn.discordapp.com/attachments/1004961963136274506/1016198930066837504/shopping-basket.png
      - define embed.description "<[message].separated_by[<&nl>]>"

      - inject jade_privatifier

fishbot_jade_command_handler:
  type: world
  debug: false
  events:
     on discord slash command name:jade:
      - define user <context.interaction.user.flag[minecraft.account_linked]>
      - define config <script[fishbot_data_storage]>

      - define level <[user].flag[fishbot.jade.level].if_null[0]>
      - define xp_current <[user].flag[fishbot.jade.experience_earned]>
      - define xp_required <script[fishbot_data_storage].data_key[exp_per_level.<[level]>]>
      - define xp_percent <[xp_current].div[<[xp_required]>].mul[100].round_down>


      - foreach <[user].flag[fishbot.bait].exclude[none]> as:bait:
        - define bait_message:->:*<[key].to_titlecase.if_null[None]><&co><&sp><&lt><[config].data_key[emoji_key.bait_<[key]>].if_null[<[config].data_key[emoji_key.none]>].parsed><&gt>*<&sp><[user].flag[fishbot.bait.<[key]>]||0>

      - foreach <[user].flag[fishbot.boats_stored]> as:item:
        - define boat_message:->:<[item].display.after[f].before[<&sp>].to_titlecase><&co><&sp><&lt><[config].data_key[emoji_key.boat_<[item].display.after[f].before[<&sp>]>].if_null[<[config].data_key[emoji_key.none]>].parsed><&gt><&nl>*Trips<&co>*<&sp><[item].flag[trips]>/<item[<[item].script.name>].flag[trips]>

      - foreach <[user].flag[fishbot.rods_stored]> as:item:
        - define rod_message:->:<[item].display.after[f].before[<&sp>].to_titlecase><&co><&sp><&lt><[config].data_key[emoji_key.rod_<[item].display.after[f].before[<&sp>]>].if_null[<[config].data_key[emoji_key.none]>].parsed><&gt><&nl>*Trips<&co>*<&sp><[item].flag[trips]>/<item[<[item].script.name>].flag[trips]>


      - define message **Jade<&sq>s<&sp>Stats<&co>**<&nl>*Level<&co>*<&sp><[level]><&nl>*Xp<&sp>To<&sp>Level<&co>*<&sp><[xp_required].sub[<[xp_current]>]><&sp>(<[xp_percent]><&pc>)<&nl><&nl>**Baits<&co>**<&nl><[bait_message].separated_by[<&nl>].if_null[None]><&nl><&nl>**Boats<&co>**<&nl><[boat_message].separated_by[<&nl>].if_null[None]><&nl><&nl>**Rods<&co>**<&nl><[rod_message].separated_by[<&nl>].if_null[None]>

      - define embed.color <color[0,254,255]>
      - define embed.title "What about Jade?"
      - define embed.thumbnail https://cdn.discordapp.com/attachments/1004961963136274506/1016199543290859590/women-age-group-5--v2.png
      - define embed.description "<[message]>"

      - inject jade_privatifier
