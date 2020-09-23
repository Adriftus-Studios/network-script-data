SoundBoard_Command:
  type: command
  debug: false
  name: SoundBoard
  permissions: test
  
  usage: /Soundboard (Favorites/Page <&lt>#<&gt>/Search <&lt>Sound<&gt>/play <&lt>Sound<&gt>)
  description: Plays sounds or opens the Sound Board.
  tab complete:
    - define List <list[Favorites|Page|Search|Play]>
    - if <context.args.size> == 0:
      - determine <[List]>
    - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
      - determine <[List].filter[starts_with[<context.args.last>]]>
    
    - define Sounds <server.sound_types.parse[replace[_].with[<&sp>].to_titlecase.replace[<&sp>].with[_]]>
    - if <context.raw_args.ends_with[<&sp>]>:
      - choose <context.args.first>:
        - case Page:
          - determine <util.list_numbers_to[30]>
        - case Search Play:
          - determine <[Sounds]>
        - default:
          - determine <empty>
    - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
      - choose <context.args.first>:
        - case Page:
          - determine <util.list_numbers_to[30].filter[starts_with[<context.args.last>]]>
        - case Search:
          - determine <[Sounds].filter[contains[<context.args.last>]]>
        - case Play:
          - determine <[Sounds].filter[starts_with[<context.args.last>]]>
        - default:
          - determine <empty>
  script:
    - choose <context.args.size>:
      - case 0:
        - run SoundBoard def:<list[Action/Main_Menu].escaped>
      - case 1:
        - choose <context.args.first>:
          - case Favorites:
            - run SoundBoard def:<list[Action/Favorites_Menu|page/1].escaped>
          - default:
            - inject Command_Syntax Instantly
      - case 2:
        - choose <context.args.first>:
          - case Page:
            - define Page <context.args.get[2]>
            - define MaxPage <server.sound_types.size.div[27]>
            - if <[Page]> > 0 && <[Page]> < <[MaxPage]> && !<[Page].contains[.]>:
              - run SoundBoard def:<list[Action/SoundBoard_Menu|Page/<[Page]>].escaped>
            - else:
              - narrate "<&4>I<&c>nvalid <&4>N<&c>umber<&4>. <&6>/<&e>page 1<&6>-<&e><[MaxPage]>"
          - case Search:
            - run SoundBoard def:<list[Action/Searched_Menu|Query/<context.args.get[2]>|Page/1].escaped>
            - narrate "<&6>S<&e>howing <&6>R<&e>esults <&6>f<&e>or<&6>: <&a><context.args.get[2]>"
          - case play:
            - if <server.sound_types.contains[<context.args.get[2]>]>:
              - playsound <player> sound:<context.args.get[2]>
            - else:
              - narrate "<&4>I<&c>nvalid <&4>S<&c>ound<&4>."
          - default:
            - inject Command_Syntax Instantly
      - default:
        - inject Command_Syntax Instantly
SoundHandler:
  type: world
  debug: false
  events:
    on player chats flagged:Behrry.Developmental.SearchWait bukkit_priority:lowest priority:-1:
      - determine passively cancelled
      - flag player Behrry.Developmental.SearchWait:!
      - flag player Behrry.Developmental.SearchedSounds
      - narrate "<&6>S<&e>howing <&6>R<&e>esults <&6>f<&e>or<&6>: <&a><context.message>"
      - run SoundBoard def:<list[Action/Searched_Menu|Query/<context.message.escaped>|Page/1].escaped>
SoundBoard:
  type: task
  debug: false
  definitions: nbt|click|slot
  script:
    - if <[nbt]||null> != null:
      - foreach <[nbt].unescaped> as:Data:
        - define <[Data].before[/]> <[Data].after[/]>
    - else:
      - define Action Main_Menu
    
    - choose <[Action]>:
      - case Main_Menu:
        - playsound sound:ENTITY_ENDER_EYE_DEATH <player> pitch:<util.random.decimal[1.8].to[2]>
        - define Size 9
        - define Display "<&6>S<&e>ound <&6>B<&e>oard"
        - define "Lore:!|:<empty>|<&7>View & Play Sounds"
        - define NBT:!|:Menu/SoundBoard|Action/SoundBoard_Menu|Page/1
        - define Skin <script[Letters].data_key[Misc.Note]>
        - define SoftMenu:|:blank|Blank|<item[Action_Item].with[material=player_head;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;Skull_Skin=a|<[Skin]>]>
        - inject Locally FavoritesButton Instantly
        - inject Locally SearchButton Instantly
        - define SoftMenu:|:<[Favorites]>|Blank|<[Search]>|Blank|Blank|Blank

        - define Inventory <inventory[Generic[title=<&2>Sound<&sp>Menu;size=<[Size]>;contents=<[SoftMenu]>]]>
        - inventory open d:<[Inventory]>
      - case Searched_Menu:
        - playsound sound:ENTITY_ENDER_EYE_DEATH <player> pitch:<util.random.decimal[1.8].to[2]>
        - inject Locally MainMenuButton Instantly
        - define Query <[Query].unescaped>
        - define Sounds <server.sound_types.filter[contains[<[Query]>]]>
        - if <[Sounds].is_empty>:
          - narrate "<&4>N<&c>o <&4>R<&c>esults."
          - run SoundBoard def:<list[Action/Main_Menu].escaped>
          - stop
        - define InvSize <[Sounds].size.div[9].round_up.min[4].max[2].mul[9]>
        - define Index <proc[PageNumbers].context[<[Page]>|<[InvSize].sub[9]>]>
        - define SoundSelection <[Sounds].get[<[Index].first>].to[<[Index].get[2]>]>
        - define MaxPage <[Sounds].size.div[9].round_up>
        - inject Locally SoundButtons Instantly
        - define ActiveMenu Searched_Menu
        - inject Locally PageButtons Instantly
        - inject Locally FavoritesButton Instantly
        - inject Locally StopSoundButton Instantly
        - inject Locally SearchButton Instantly

        - define Inventory "<inventory[Generic[Size=<[InvSize]>;title=<[Page]>/<[MaxPage]> Sounds w/:<[Query]>]]>"
        - if <element[9].sub[<element[<[Sounds].Size>].mod[9]>]> != 0:
          - repeat <element[9].sub[<element[<[Sounds].Size>].mod[9]>]>:
            - define Items:|:<item[Blank]>

        - define SoftMenu:|:<[Left].first>|<[Left].get[2]>|<[MainMenu]>|<[Favorites]>|<[StopSound]>|<[Search]>|<item[Blank]>|<[Right].first>|<[Right].get[2]>
        
        - inventory set d:<[Inventory]> o:<[Items].parse[with[nbt=<list[Query/<[Query]>]>]]>
        - inventory set d:<[Inventory]> o:<[SoftMenu].parse[with[nbt=<list[Query/<[Query]>]>]]> slot:<[InvSize].sub[8]>
        - inventory open d:<[Inventory]>

      - case Favorites_Menu:
        - playsound sound:ENTITY_ENDER_EYE_DEATH <player> pitch:<util.random.decimal[1.8].to[2]>
        - inject Locally MainMenuButton Instantly
        - if !<player.has_flag[Behrry.Developmental.FavoriteSounds]>:
          - define SoftMenu:|:Blank|Blank|<[MainMenu]>|Blank|Blank|Blank|Blank|Blank|Blank
          - define InvSize 9
          - define Inventory <inventory[Generic[Size=9]]>
        - else:
          - define Sounds <player.flag[Behrry.Developmental.FavoriteSounds]>
          - define InvSize <[Sounds].size.div[9].round_up.min[4].max[2].mul[9]>
          - define Index <proc[PageNumbers].context[<[Page]>|<[InvSize].sub[9]>]>
          - define SoundSelection <[Sounds].get[<[Index].first>].to[<[Index].get[2]>]>
          - define MaxPage <[Sounds].size.div[9].round_up>
          - inject Locally SoundButtons Instantly
          - define ActiveMenu FavoritesMenu
          - inject Locally PageButtons Instantly
          - inject Locally StopSoundButton Instantly
          - define Inventory "<inventory[Generic[Size=<[InvSize]>;title=Favorites <[Page]>/<[MaxPage]>]]>"
          - if <element[9].sub[<element[<[Sounds].Size>].mod[9]>]> != 0:
            - repeat <element[9].sub[<element[<[Sounds].Size>].mod[9]>]>:
              - define Items:|:Blank

          - define SoftMenu:|:<[Left].first>|<[Left].get[2]>|<[MainMenu]>|Blank|<[StopSound]>|Blank|Blank|<[Right].first>|<[Right].get[2]>
          
          - inventory set d:<[Inventory]> o:<[Items]>
        - inventory set d:<[Inventory]> o:<[SoftMenu]> slot:<[InvSize].sub[8]>
        - inventory open d:<[Inventory]>


      - case SoundBoard_Menu:
        - playsound sound:ENTITY_ENDER_EYE_DEATH <player> pitch:<util.random.decimal[1.8].to[2]>
        - define Index <proc[PageNumbers].context[<[Page]>|27]>
        - define Sounds <server.sound_types>
        - define SoundSelection <[Sounds].get[<[Index].first>].to[<[Index].get[2]>]>
        - define MaxPage <[Sounds].size.div[27].round_down>
        - inject Locally SoundButtons Instantly
        - define ActiveMenu SoundBoard_Menu
        - inject Locally PageButtons Instantly
        - inject Locally MainMenuButton Instantly
        - inject Locally FavoritesButton Instantly
        - inject Locally StopSoundButton Instantly
        - inject Locally SearchButton Instantly

        - define SoftMenu:|:<[Left].first>|<[Left].get[2]>|<[MainMenu]>|<[Favorites]>|<[StopSound]>|<[Search]>|Blank|<[Right].first>|<[Right].get[2]>

        - define Title "<&2>Sounds <&6><[Page]><&4>/<&6><[MaxPage]>"
        - define Inventory <inventory[Generic[Size=36;title=<[Title]>]]>
        - inventory set d:<[Inventory]> o:<[Items]>
        - inventory set d:<[Inventory]> o:<[SoftMenu]> slot:28
        - inventory open d:<[Inventory]>
      - case PlaySound:
        - choose <[Click]>:
          - case DROP:
            - if <player.has_flag[Behrry.Developmental.FavoriteSounds]>:
              - if <player.flag[Behrry.Developmental.FavoriteSounds].contains[<[Sound]>]>:
                - narrate "<&c>This sound is already in your favorites."
                - stop
            - inventory adjust d:<player.open_inventory> slot:<[Slot]> material:Lime_Stained_glass
            - inventory adjust d:<player.open_inventory> slot:<[Slot]> "lore:<list[<empty>|<&3>Ctrl<&b>+<&3>Q<&b>:<&7> Remove from Favorites|<&3>Shift<&b>+<&3>Click<&b>: <&7>Script Copy|<&3>Click<&b>: <&7>Play sound]>"
            - playsound <player> sound:BLOCK_NOTE_BLOCK_BASS pitch:2
            - narrate "<&6>[<&e><[Sound].replace[_].with[ ].to_titlecase><&6>] <&2>a<&a>dded <&2>t<&a>o <&2>f<&a>avorites"
            - flag player Behrry.Developmental.FavoriteSounds:->:<[Sound]>

          - case Control_drop:
            - if <player.has_flag[Behrry.Developmental.FavoriteSounds]>:
              - if <player.flag[Behrry.Developmental.FavoriteSounds].contains[<[Sound]>]>:
                - flag player Behrry.Developmental.FavoriteSounds:<-:<[Sound]>
                - inventory adjust d:<player.open_inventory> slot:<[Slot]> material:White_Stained_Glass
                - inventory adjust d:<player.open_inventory> slot:<[Slot]> "lore:<list[<empty>|<&3>Q Key<&b>:<&7> Add to Favorites|<&3>Click<&b>:<&3>Shift<&b>+<&3>Click<&b>: <&7>Script Copy| <&7>Play sound]>"
                - playsound <player> sound:BLOCK_NOTE_BLOCK_BASS pitch:1
                - narrate "<&6>[<&e><[Sound].replace[_].with[ ].to_titlecase><&6>] <&4>R<&c>emoved <&4>f<&c>rom <&4>f<&c>avorites."
          - case Shift_Left Shift_Right:
            - define Insert "- playsound sound:<[Sound]> <&lt>player<&gt>"
            - define Hover "<&2>Shift Click to Insert<&2>:<&nl><&e><[Insert]>"
            - define Text "<&e><[Sound]>"
            - playsound sound:ENTITY_ENDER_EYE_DEATH <player> pitch:0
            - narrate "<&a>Shift Click for Copy<&2>: <proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>"
          - default:
            - playsound <player> sound:<[Sound]>
      - case StopSound:
        - actionbar "<&4>Sounds Stopped"
        - execute as_op "stopsound <player.name> master" silent
      - case Search:
        - inventory close
        - flag player Behrry.Developmental.SearchWait duration:30s
        - while <player.has_flag[Behrry.Developmental.SearchWait]> && <player.is_online>:
          - title "subtitle:<&2>T<&a>ype <&2>S<&a>ound <&2>S<&a>earch" fade_in:0t
          - actionbar '<&4>"<&c>stop<&4>"<&7> to cancel<&4><element[.].repeat[<[Loop_Index].mod[3]>]>'
          - wait 1s
  PageButtons:
    - if <[Page]> == 1:
      - define Left <list[<item[Blank]>|<item[Blank]>]>
    - else:
      - define Display "<&6><&chr[25c0]><&sp> [<&e>Previous<&6>]"
      - define "Lore:!|:<empty>|<&7>Change Page"
      - define NBT:!|:Menu/SoundBoard|Action/<[ActiveMenu]>|Page/<[Page].sub[1]>
      - define Skin <script[Letters].data_key[Misc.Left]>
      - define Previous <item[Action_Item].with[material=player_head;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;skull_skin=a|<[Skin]>]>
      - if <[Page].sub[1]> == 1:
        - define Left <list[<item[Blank]>|<[Previous]>]>
      - else:
        - define Display "<&6><&chr[25c0]><&sp> [<&e>First<&6>]"
        - define NBT:!|:Menu/SoundBoard|Action/<[ActiveMenu]>|Page/1
        - define Skin <script[Letters].data_key[Misc.First]>
        - define First <item[Action_Item].with[material=player_head;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;skull_skin=a|<[Skin]>]>
        - define Left <list[<[First]>|<[Previous]>]>

    - if <[Page]> == <[MaxPage]>:
      - define Right <list[<item[Blank]>|<item[Blank]>]>
    - else:
      - define Display "<&6>[<&e>Next<&6>] <&chr[25b6]>"
      - define "Lore:!|:<empty>|<&7>Change Page"
      - define NBT:!|:Menu/SoundBoard|Action/<[ActiveMenu]>|Page/<[Page].add[1]>
      - define Skin <script[Letters].data_key[Misc.Right]>
      - define Next <item[Action_Item].with[material=player_head;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;skull_skin=a|<[Skin]>]>
      
      - if <[Page].add[1]> == <[MaxPage]>:
        - define Right <list[<item[Blank]>|<[Next]>]>
      - else:
        - define Display "<&6>[<&e>Last<&6>] <&chr[25b6]>"
        - define NBT:!|:Menu/SoundBoard|Action/<[ActiveMenu]>|Page/<[MaxPage]>
        - define Skin <script[Letters].data_key[Misc.Last]>
        - define Last <item[Action_Item].with[material=player_head;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;skull_skin=a|<[Skin]>]>
        - define Right <list[<[Next]>|<[Last]>]>

  MainMenuButton:
    - define Display "<&6>M<&e>ain <&6>M<&e>enu"
    - define "Lore:!|:<empty>|<&7>Return to Main Menu"
    - define NBT:!|:Menu/SoundBoard|Action/Main_Menu|Page/1
    - define Skin <script[Letters].data_key[Misc.Note]>
    - define MainMenu <item[Action_Item].with[material=player_head;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;skull_skin=a|<[Skin]>]>
  FavoritesButton:
    - define Display "<&d><&l><&chr[272F]> <&5>F<&d>avorites"
    - define "Lore:!|:<empty>|<&7>Show Favorites"
    - define NBT:!|:Menu/SoundBoard|Action/Favorites_Menu|Page/1
    - define Skin <script[Letters].data_key[Misc.Star]>
    - define Favorites <item[Action_Item].with[material=player_head;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;skull_skin=a|<[Skin]>]>
  SoundButtons:
    - foreach <[SoundSelection]> as:Sound:
      - if <player.flag[Behrry.Developmental.FavoriteSounds].contains[<[Sound]>]||false>:
        - define Material Lime_Stained_Glass
        - define "Lore:!|:<empty>|<&3>Ctrl<&b>+<&3>Q<&b>:<&7> Remove from Favorites"
      - else:
        - define Material White_stained_glass
        - define "Lore:!|:<empty>|<&3>Q Key<&b>:<&7> Add to Favorites"
      - define Display "<&e><[Sound].replace[_].with[<&sp>].to_titlecase>"
      - define "Lore:|:<&3>Shift<&b>+<&3>Click<&b>: <&7>Script Copy|<&3>Click<&b>: <&7>Play sound"
      - define NBT:!|:Menu/SoundBoard|Action/PlaySound|Sound/<[Sound]>
      - define Item <item[Action_Item].with[material=<[Material]>;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;enchantments=silk_touch,1;flags=hide_all]>
      - define Items:|:<[Item]>
  SearchButton:
    - define Display "<&6>S<&e>earch"
    - define "Lore:!|:<empty>|<&7>Search for Sounds"
    - define NBT:!|:Menu/SoundBoard|Action/Search
    - define skin <script[Letters].data_key[Misc.Question]>
    - define Search <item[Action_Item].with[material=player_head;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>;skull_skin=a|<[Skin]>]>
  StopSoundButton:
    - define Display "<&4>S<&c>top <&4>S<&c>ounds"
    - define "Lore:!|:<empty>|<&7>Click to stop all sounds"
    - define NBT:!|:Menu/SoundBoard|Action/StopSound
    - define StopSound <item[Action_Item].with[material=Barrier;display_name=<[Display]>;lore=<[Lore]>;NBT=<[NBT]>]>
PageNumbers:
  type: procedure
  definitions: Page|Size
  debug: false
  script:
    - define i1 <[Size].mul[<[Page].sub[1]>].add[1]>
    - define i2 <[Size].mul[<[Page].sub[1]>].add[<[Size]>]>
    - determine <list[<[i1]>|<[i2]>]>
    


Letters:
  type: data
  Misc:
    Question: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTAzNWM1MjgwMzZiMzg0YzUzYzljOGExYTEyNTY4NWUxNmJmYjM2OWMxOTdjYzlmMDNkZmEzYjgzNWIxYWE1NSJ9fX0=
    Note: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjIyZTQwYjRiZmJjYzA0MzMwNDRkODZkNjc2ODVmMDU2NzAyNTkwNDI3MWQwYTc0OTk2YWZiZTNmOWJlMmMwZiJ9fX0=
    Left: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODFjOTZhNWMzZDEzYzMxOTkxODNlMWJjN2YwODZmNTRjYTJhNjUyNzEyNjMwM2FjOGUyNWQ2M2UxNmI2NGNjZiJ9fX0=
    First: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjU2YWJiNGM3NGQxMWJiM2VjY2E5ZWQ0MjcwY2RiZGRlZWE5NzA1ODIyZmQzM2I5NGUwNWM0N2MzZWU1NmY5MCJ9fX0=
    Right: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzMzYWU4ZGU3ZWQwNzllMzhkMmM4MmRkNDJiNzRjZmNiZDk0YjM0ODAzNDhkYmI1ZWNkOTNkYThiODEwMTVlMyJ9fX0=
    Last: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWVmNjY0ZDUwNmU5NzUzNDkzOTE5ODVjMWNkMDcxY2VhN2Q0NjMxNzYzZTVhMmY5MTRmYTQ3MGNjMmJkYTIwYSJ9fX0=
    Star: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWJlNzIwMzlhNDBmMTAwMmZiYTZhYjFiYjVmN2YwMGQ3MGY1M2I0YjQ4YzJlOWJmMGYxYmVhNzA4MzAwODFhYyJ9fX0=
  characters:
    a: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTUxN2I0ODI5YjgzMTkyYmQ3MjcxMTI3N2E4ZWZjNDE5NjcxMWU0MTgwYzIyYjNlMmI4MTY2YmVhMWE5ZGUxOSJ9fX0=
    b: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTExMzFhY2E1ZmNmZTZlNThmNjE2ZmY4YmVmZDAyNzQxNmZlNmI5OGViNWVjNjQyZTAzNWVkODMzOTYwN2JmMCJ9fX0=
    c: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjJlNTk0ZWExNTQ4NmViMTkyNjFmMjExMWU5NTgzN2FkNmU5YTZiMWQ1NDljNzBlY2ZlN2Y4M2U0MTM2MmI1NyJ9fX0=
    d: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmIzMWI3OWUzODBkZjMxZDVhNGQ2NDliMWFlOWZjMDIwNjdkN2U5OTQ4NzEyMmQwNGQ2ZDZhYjdmN2RlNjE4MSJ9fX0=
    e: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjc3MTY1YzlkYjc2M2E5YWNkMTNjMDYyMjBlOTJkM2M5NzBkZmEzNmRhYzU2ZTU5NTdkMDJkMzZmNWE5ZjBiOCJ9fX0=
    f: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODQ0MmIwNjZlMGU1ZTA5YTZlNmJiOTk4OWNjMjc0NTFmMmJkNzhmYjBkYzcyMTA4YWE5NDBmYzlkYjFjMjRlMSJ9fX0=
    g: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWMxYThmYzhlYTQ1ZDc0NDMwNzkxNmViNTBkZGNhNWU0MDA2NWEzNDYxYThlNDY5NDkwNDM5ZjllMjRmNGYyNCJ9fX0=
    h: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZGNhMjRhYzhjMTNkMjE3MjBmZjVhY2JmMmVlZTcyNzBjNWIzNjYyMzgzMjA4ZGI5MzcyMWQwNTQ5YjQ1YjllNSJ9fX0=
    i: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODRiY2M5NTMxYWRlMmUwNjM5YTZhZTAzYzc4YmMwN2ExYTliZTYwZmM2ZjNlM2ZlMzkzNzBmYjU2YzZiNTk3NiJ9fX0=
    j: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWIwNjBiYmU0ZDZkNjAxNDY5YjQ5ZTEwNTI1M2ViYWUwNTI5MzA5OGE5NzRiNmYyZDU2ODRmOTQxY2E1YTVmYyJ9fX0=
    k: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjM3ZTUxY2UwZDRjOGVhZGY2NzU5NDFhNDVlMTBiOTI4ZTQzZDIyZWFiNTM5YWM4ODZlZGJmNDBiYjg3ZWMwZiJ9fX0=
    l: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjA2YmM0MTdlM2MwNmIyMjczNWQ1MzlmOWM2YzhmZDdjMWVmZDE5MjM2ZTJjMzgxNTM0MDUxZDlkNmJlZTgwNCJ9fX0=
    m: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWQ3MTYyNTZkNzI3YmExZGYxOGY4MjZmMTE5MDUxYzMzYTM5NDIwOWE5NWJlODM3Y2NmNmZhZTllZTZiODcxYiJ9fX0=
    N: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTcxM2QyNjAxZTM1MjQyZDM1MDE4Y2VjZTNiMzRjNjFiZjUwMDFmNWRiZDc0NjNhNGM1NTg3YWMzNjViM2QxZiJ9fX0=
    o: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzUzODViMDVlN2FmNTQ2MzViMTBmMDJjZGIwMDQ1NjcyYzkxYzcyNGNmMTY0ZTUxOTNhNGY3YmU3MjkyZmYzMCJ9fX0=
    p: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjU1MzE0MWFhYmU4OWE4YTU4MDRhMTcyMTMzYjQzZDVkMGVlMDU0OWNjMTlkYjAzODU2ODQwNDNjZmE5NDZhNSJ9fX0=
    q: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTRkNzQ2ZTdlMzUzNGU3Mjk5NTZmMWEwNDc1NzgzMmZhM2JmOWUyZDE0ZWY2ZDBkYjhkY2ZjNGUyMTUzMjMzOCJ9fX0=
    r: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTU4MjdmNDVhYWU2NTY4MWJiMjdlM2UwNDY1YWY2MjI4ZWQ2MjkyYmI2M2IwYTc3NjQ1OTYyMjQ3MjdmOGQ4MSJ9fX0=
    s: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZGNkN2QxNGM2ZGI4NDFlNTg2NDUxMWQxNmJhNzY3MGIzZDIwMzgxNDI0NjY5ODFmZWIwNWFmYzZlNWVkYzZjYiJ9fX0=
    t: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjk0YWMzNmQ5YTZmYmZmMWM1NTg5NDEzODFlNGRjZjU5NWRmODI1OTEzZjZjMzgzZmZhYTcxYjc1NmE4NzVkMyJ9fX0=
    u: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTgwNjBmYWVjNDUwOTdlZWZhNjgwODhhNWMwNzY1Nzc0MzQyNmUwNDUzZjhiNjZjZjI2YjgzOWMwNDg2NGMwMCJ9fX0=
    v: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZmEzZmE5MTZiNWU1OTE1ZTAyNmI5MWIyNjQ1NDQzOThmZjAyZDFlZWRlNzYzMGJjODE1OGYzYTY2M2NhMDJhZCJ9fX0=
    w: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjMzMjRkMWZhMDcwY2Y2OThmMmJlNTM5ZDY5ZmY0MzhhYWE2YjFmNDk0YzVlMDEzYzdlZTlkOWMzM2ViODNjMCJ9fX0=
    x: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTVkNWM3NWY2Njc1ZWRjMjkyZWEzNzg0NjA3Nzk3MGQyMjZmYmQ1MjRlN2ZkNjgwOGYzYTQ3ODFhNTQ5YjA4YyJ9fX0=
    y: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWFkMzBlOWUyNTcwNWM1MWI4NDZlNzRlNzc3OTYyM2I2OWMwNzQ0NjQ1ZGEwMDA0ZDRkYjBmZTQ2MzM2ZmY4ZSJ9fX0=
    z: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWEyNGIwZjZjMTg0ZmYxNzM2ODZjN2QxMjhkZjUzNmQxMGI3MjgwZjgwMDg2MzZhNTU0NmYxYzc3NzIzNDM1NCJ9fX0=
