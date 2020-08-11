Blank:
    type: item
    debug: false
    material: black_stained_glass_pane
    display name: "<&f>"
  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀
LastPageArrow:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 131
    #potion_effects: "INSTANT_HEAL,false,false"
    #flags: hide_all
    display name: <&2><&chr[25c0]> <&2>L<&a>ast <&2>P<&a>age <&2><&chr[25c0]>
  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀
NextPageArrow:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 132
      #potion_effects: "INSTANT_HEAL,false,false"
        flags: hide_all
    display name: <&a><&chr[27a4]> <&2>N<&a>ext <&2>P<&a>age <&2><&chr[27a4]>
  #display name: <&a><&chr[25b6]> <&2>N<&a>ext <&2>P<&a>age <&2><&chr[25b6]>
  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀


Deposit_All:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 134
        flags: hide_all
    display name: <&2>D<&a>eposit <&2>A<&a>ll
Deposit_Equipement:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 133
        flags: hide_all
    display name: <&2>D<&a>eposit <&2>A<&a>ll <&2>E<&a>quipment
Equipment_Slot:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 136
        flags: hide_all
    display name: <&2>E<&a>quipment <&2>M<&a>enu


action_item:
    type: item
    debug: false
    material: stick
action_item_handler:
    type: world
    debug: false
    events:
        on player clicks blank in inventory:
            - determine passively cancelled
        on player clicks action_item in inventory:
            - if <context.item.has_nbt[Menu]> && <context.item.has_nbt[Action]>:
                - determine passively cancelled
                - if <context.item.has_nbt[NpcID]>:
                    - foreach <context.item.nbt_keys> as:Key:
                        - define NbtData:|:<[Key]>/<context.item.nbt[<[Key]>]>
                    - run <script[<context.item.nbt[Menu]>]> def:<[NbtData].escaped> npc:<npc[<context.item.nbt[NpcID]>]>
                    #- run <script[<context.item.nbt[Menu]>]> def:<context.item.nbt[Action]> npc:<npc[<context.item.nbt[NpcID]>]>

                - else if <context.item.has_nbt[Menu]>:
                    - foreach <context.item.nbt_keys> as:Key:
                        - define NbtData:|:<[Key]>/<context.item.nbt[<[Key]>]>
                    - run <script[<context.item.nbt[Menu]>]> def:<[NbtData].escaped>|<context.click>|<context.raw_slot>
                    #- run <script[<context.item.nbt[Menu]>]> def:<context.item.nbt[Action]>
        on player places action_item:
            - if !<player.has_flag[Meeseeks.Spawn.Warning]>:
                - flag player Meeseeks.Spawn.Warning duration:10s
                - narrate format:colorize_green "Spawn Meeseeks? Place again to confirm"
                - determine cancelled

            - if <context.item_in_hand.has_nbt[Script]>:
                - run <script[<context.item_in_hand.nbt[Script]>]> def:<context.location>
            - determine cancelled

        #on player clicks action_item in inventory:
        #    - determine passively cancelled
        #    - if !<context.item.nbt_keys.is_empty>:
        #        - foreach <context.item.nbt_keys> as:Key:
        #            - define NbtData:|:<[Key]>/<context.item.nbt[<[Key]>]>
        #        - run <script[<context.item.nbt[Menu]>]> def:<list_single[<[NbtData]>].include[<context.click>|<context.raw_slot>]>



action_item_builder:
    type: procedure
    definitions: material|display_name|NBT|shiney|lore
    debug: false
    script:
        - if <[NBT]||null> != null:
            - foreach <[NBT].unescaped> as:Nbt:
                - define Key <[NBT].before[/]>
                - define Value <[NBT].after[/]>
                - define NbtList:|:<[Key]>/<[Value]>
            - define n ;nbt=<[NbtList]>

        - if <[Shiney]||null> != null:
            - if <[Shiney]>:
                - define E ;enchantments=silk_touch,1;hides=all

        - if <[Lore]||null> != null:
            - define l ;lore=<[Lore].unescaped>

        - determine <item[Action_Item].with[material=<[Material]>;display_name=<[Display_Name]><[N]||><[E]||><[L]||>]>

Heads:
    type: data
    Minus: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDgyYzIzOTkyYTAyNzI1ZDllZDFiY2Q5MGZkMDMwN2M4MjYyZDg3ZTgwY2U2ZmFjODA3ODM4N2RlMThkMDg1MSJ9fX0=
    Plus: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWQ4NjA0YjllMTk1MzY3Zjg1YTIzZDAzZDlkZDUwMzYzOGZjZmIwNWIwMDMyNTM1YmM0MzczNDQyMjQ4M2JkZSJ9fX0=
    Neeseeks: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWJiNDMzOTFhOWRiZmY5ZWFkYWUwN2I2ODYyNTk1YzkxZDA0YzU5MzhlMjNjMjg1YWM2MGM0Yjg3NjliMjQifX19
