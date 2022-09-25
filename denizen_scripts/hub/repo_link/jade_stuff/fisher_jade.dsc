fishbot_jade_menu:
  type: inventory
  debug: false
  inventory: chest
  title: Jade's Inventory
  size: 54
  gui: true
  slots:
    - [] [] [] [] [jade_skull_item] [] [] [] []
    - [] [jade_key_item] [] [] [] [] [] [jade_event_item] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

jade_skull_item:
  type: item
  debug: false
  material: player_head
  display name: <&6>Jade's Info
  mechanisms:
    skull_skin: 33d885df-8840-422c-8ebf-a97a2ae0566c|ewogICJ0aW1lc3RhbXAiIDogMTY1NzY0OTMxNTYzMCwKICAicHJvZmlsZUlkIiA6ICI5ZWEyMTQ0NGFiNjI0MWZkYjg5YjE2NDFhNDg2MGZiZiIsCiAgInByb2ZpbGVOYW1lIiA6ICI3QUJDSE9VTiIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS85MTJjYzEzNGIwZDc3YzIxNGVhNDdiNzMzYTMxMGI1YzBkYTY5OTViMzRlMzA2ZTc3ZmI3ZWE3NDEyOWVjOTllIiwKICAgICAgIm1ldGFkYXRhIiA6IHsKICAgICAgICAibW9kZWwiIDogInNsaW0iCiAgICAgIH0KICAgIH0KICB9Cn0=
  lore:
    - <&6>Jade<&sq>s level<&co> <&e><player.flag[fishbot.jade.level]>
    - <&6>Experience to level<&co> <&e><script[fishbot_data_storage].data_key[exp_per_level.<player.flag[fishbot.jade.level]>].sub[<player.flag[fishbot.jade.experience_earned]>]> <&6>(<&e><player.flag[fishbot.jade.experience_earned].div[<script[fishbot_data_storage].data_key[exp_per_level.<player.flag[fishbot.jade.level]>]>]><&pc><&6>)

jade_event_item:
  type: item
  debug: false
  material: clock
  display name: <&6>Jades Scheedule
  lore:
  - <&b>Click<&6> to see the scheduled events.

jade_key_item:
  type: item
  debug: false
  material: tripwire_hook
  mechanisms:
    custom_model_data: 1
  display name: <&6>Jades Key Ring
  lore:
  - <&6>Current Keys<&co> <&e><player.flag[fishbot.keys]>
  - <&b>Click<&6> to add more.

jade_boost_info:
  type: item
  debug: false
  material: book
  display name: <&e>Event Schedule!
  lore:
  - <&6>Click to see when planned server boosts will be active.


fishbot_jade_assignment:
  type: assignment
  debug: false
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    on damage:
    - inject fishbot_jade_speech
    on click:
    - inject fishbot_jade_speech


fishbot_jade_speech:
  type: task
  debug: false
  script:
  - if <player.has_flag[fishbot.fishing_now]>:
    - narrate "<&6>Sorry boss, I'm too busy to talk right now, catch me after the trip?"
    - stop
  - if <player.flag[fishbot.caught_items].size> > <element[54].sub[<player.flag[fishbot.barrel_expanded].if_null[0].mul[9]>]>:
    - narrate "<&6>Hey boss, my <&c>barrels are full<&6>. When are you picking up the stuff?"
    - stop
  - else:
    - narrate "<&6>Howdy there, how can I help you?"
    - wait 10t
    - inventory open d:fishbot_jade_menu
    - stop

fishbot_jade_item_events:
  type: world
  debug: false
  events:
    on player clicks jade_key_item in inventory:
      - determine passively cancelled
      - playsound sound:UI_BUTTON_CLICK <player.location>
      - inventory open d:fishbot_jade_key_inventory
    on player clicks jade_event_item in inventory:
      - determine passively cancelled
      - playsound sound:UI_BUTTON_CLICK <player.location>
      - inventory open d:fishbot_jade_event_inventory

fishbot_jade_event_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: Jade's Schedule
  size: 9
  gui: true
  slots:
  - [standard_back_button] [standard_filler] [jade_sunday] [jade_monday] [jade_tuesday] [jade_wednesday] [jade_thursday] [jade_friday] [jade_saturday]

fishbot_jade_event_inventory_events:
  debug: false
  type: world
  events:
    on player clicks standard_back_button in fishbot_jade_event_inventory:
      - inventory open d:fishbot_jade_menu
      - playsound sound:UI_BUTTON_CLICK <player.location>

jade_sunday:
  type: item
  debug: false
  material: player_head
  display name: <&6>Sunday<&co>
  mechanisms:
    skull_skin: 33d885df-8840-422c-8ebf-a97a2ae0566c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDVhM2E0MDRjY2RiNDBhZWI3MzY1MTQ3ZjBmY2YyNDkyY2ZkNjliNzgxZmMwYjI4ODNkMWM5YjljMzdlM2NlZiJ9fX0=
  lore:
  - <&e>First <&6>Weekend<&co> <&e>Catch rate increased by 20<&pc><&6>.
  - <&e>Second <&6>Weekend<&co> <&e>Item Chance increased by 20<&pc><&6>.
  - <&e>Third <&6>Weekend<&co> <&e>Fish Chance increased by 20<&pc><&6>.
  - <&e>Fourth <&6>Weekend<&co> <&e>Experience increased by 30<&pc><&6>.
  - <&e>Fifth <&6>Weekend<&co> <&e>Legendary Fish chance increased by 4<&pc><&6>.

jade_monday:
  type: item
  debug: false
  material: player_head
  display name: <&6>Monday<&co>
  mechanisms:
    skull_skin: 33d885df-8840-422c-8ebf-a97a2ae0566c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODQzMGIwMmIxNTVlNjY5MjczYTc3ODQwYjA3ZjQ1M2U3OWIzOTQ4OTBhNGQ2MGI0MGM3YWMzMGFhNzhmZTkzNiJ9fX0=
  lore:
  - <&e>Speed Fishing<&6><&co>
  - <&6>-10<&pc><&e>Catch Time<&6>.
  - <&6>+10<&pc><&e>Catch Rate<&6>.

jade_tuesday:
  type: item
  debug: false
  material: player_head
  display name: <&6>Tuesday<&co>
  mechanisms:
    skull_skin: 33d885df-8840-422c-8ebf-a97a2ae0566c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZmJlODE3ODkyZjgxYTdhMTUyYTQxZTE5ZWQyMzY0YmRkNTNhNWNlMjVjZTA3M2UxZWVlOWVjMTRmNDNjZmRiOCJ9fX0=
  lore:
  - <&6>No Bonuses

jade_wednesday:
  type: item
  debug: false
  material: player_head
  display name: <&6>Wednesday<&co>
  mechanisms:
    skull_skin: 33d885df-8840-422c-8ebf-a97a2ae0566c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjczZmY2YzU3YzBjNjM3MWY5ZTU5ZWVjYWY0NzdlNzE0M2Q1NjgyZTEwZGE0ZTRkODJlYjBjYjI0ZGNiYWQxYSJ9fX0=
  lore:
  - <&e>Good Fishing<&6><&co>
  - <&6>25<&pc> increased <&e>Good Catch Chance<&6>.

jade_thursday:
  type: item
  debug: false
  material: player_head
  display name: <&6>Thursday<&co>
  mechanisms:
    skull_skin: 33d885df-8840-422c-8ebf-a97a2ae0566c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZmJlODE3ODkyZjgxYTdhMTUyYTQxZTE5ZWQyMzY0YmRkNTNhNWNlMjVjZTA3M2UxZWVlOWVjMTRmNDNjZmRiOCJ9fX0=
  lore:
  - <&6>No Bonuses

jade_friday:
  type: item
  debug: false
  material: player_head
  display name: <&6>Friday<&co>
  mechanisms:
    skull_skin: 33d885df-8840-422c-8ebf-a97a2ae0566c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzY4NDc0ZjJiZGJiYjNmNjEzZWU5YTcxMDJiNzZkZDRjZTk2YjQ4ZjJkZmZmNGUxNTM3OGM2M2E1Y2MzY2Q3ZSJ9fX0=
  lore:
  - <&e>Peaceful Fishing<&6><&co>
  - <&6>10<&pc> decreased <&e>Attack Chance<&6>.

jade_saturday:
  type: item
  debug: false
  material: player_head
  display name: <&6>Saturday<&co>
  mechanisms:
    skull_skin: 33d885df-8840-422c-8ebf-a97a2ae0566c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDVhM2E0MDRjY2RiNDBhZWI3MzY1MTQ3ZjBmY2YyNDkyY2ZkNjliNzgxZmMwYjI4ODNkMWM5YjljMzdlM2NlZiJ9fX0=
  lore:
  - <&e>First <&6>Weekend<&co> <&e>Catch rate increased by 20<&pc><&6>.
  - <&e>Second <&6>Weekend<&co> <&e>Item Chance increased by 20<&pc><&6>.
  - <&e>Third <&6>Weekend<&co> <&e>Fish Chance increased by 20<&pc><&6>.
  - <&e>Fourth <&6>Weekend<&co> <&e>Experience increased by 30<&pc><&6>.
  - <&e>Fifth <&6>Weekend<&co> <&e>Legendary Fish chance increased by 4<&pc><&6>.

fishbot_jade_key_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: Jade's Keyring
  procedural items:
    - define item_quantity <player.flag[fishbot.keys]||0>
    - if <[item_quantity]> < 1:
      - determine air
    - if <[item_quantity]> > 64:
      - repeat <[item_quantity].div[64].round_down>:
        - define bait_list:->:fishing_dungeon_key[quantity=64]
        - define item_quantity <[item_quantity].sub[64]>
    - define bait_list:->:fishing_dungeon_key[quantity=<[item_quantity]||0>]
    - determine <[bait_list]>
  size: 9
  slots:
  - [standard_accept_button] [standard_filler] [] [] [] [] [] [standard_filler] [standard_back_button]

fishbot_jade_key_inventory_events:
  type: world
  debug: false
  events:
    on player clicks item in fishbot_jade_key_inventory:
      - if <context.item.material.name> == gray_stained_glass_pane || <context.item.material.name||air> == air || <context.raw_slot> > 27:
        - stop
    on player clicks item in fishbot_jade_key_inventory*:
      - if <context.item.script.name||null> != fishing_dungeon_key && <context.item.material.name> != air:
        - determine passively cancelled
      - if <list[standard_filler|standard_accept_button|standard_back_button].contains_any[<context.item.script.name.if_null[null]>]>:
        - determine passively cancelled
        - choose <context.item.script.name>:
          - case default:
            - stop
          - case standard_accept_button standard_back_button:
            - define amount <element[0]>
            - foreach <context.inventory.list_contents.exclude[standard_filler|standard_accept_button|standard_back_button|air]> as:item:
              - if <list[standard_filler|standard_accept_button|standard_back_button|null].contains_any[<[item].script.name||null>]>:
                - foreach next
              - define amount <[amount].add[<[item].quantity>]>
            - flag <player> fishbot.keys:<[amount]>
            - wait 2t
            - playsound sound:UI_BUTTON_CLICK <player.location>
            - inventory open d:fishbot_jade_menu
    on player closes fishbot_jade_key_inventory:
      - define amount <element[0]>
      - foreach <context.inventory.list_contents.exclude[standard_filler|standard_accept_button|standard_back_button|air]> as:item:
        - if <list[standard_filler|standard_accept_button|standard_back_button|null].contains_any[<[item].script.name||null>]>:
          - foreach next
        - define amount <[amount].add[<[item].quantity>]>
      - define flag_path fishbot.bait.<context.inventory.script.name.after[bait_inventory_]>
      - flag <player> <[flag_path]>:<[amount]>
