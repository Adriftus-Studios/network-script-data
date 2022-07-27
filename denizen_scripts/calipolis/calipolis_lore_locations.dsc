calipolis_lore_locations_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  title: Placeholder
  gui: true

calipolis_lore_location_tp:
  type: item
  debug: false
  material: feather
  mechanisms:
    custom_model_data: 3

calipolis_lore_locations_next_page_button:
  type: item
  debug: false
  material: leather_horse_armor
  display name: <&a>Next Page
  mechanisms:
    color: <color[#55FF55]>
    custom_model_data: 1001
  flags:
    run_script: calipolis_lore_locations_next_page

calipolis_lore_locations_previous_page_button:
  type: item
  debug: false
  material: leather_horse_armor
  display name: <&a>Previous Page
  mechanisms:
    color: <color[#55FF55]>
    custom_model_data: 1000
  flags:
    run_script: calipolis_lore_locations_prev_page

calipolis_lore_locations_back_button:
  type: item
  debug: false
  material: feather
  display name: <&c>Back To Travel Menu
  mechanisms:
    custom_model_data: 3

calipolis_lore_locations_open:
  type: task
  debug: false
  data:
    locations:
      # Page 1
      - KaluPalu
      - OctoberBay
      - TheCalony
      - LibraryOfCal
      - CelebrationRona
      - SecretSoupSociety
      - CoronationHall
      - ThundersnowPalace
      # Page 2
      - FreedomWingsBase
      - Olympics
      - Courthhouse
      - Cathedral
      - IrohFuneralSite
      - Masquerade
      - SASWarcore
      - ThroneRoom
      # Page 3
      - Airship
      - KalliopeTomb
      - CloningFacility
      - FinalBattle
      - CalipolisCouncil
    location_data:
      KaluPalu:
        name: <&6>Kalu Palu
        lore:
          - <&e>One of the last remnants of an era long passed
          - <&e>Though once said to be an ancient people that thrived off the land
          - <&e>only their ruins remain.
      LibraryOfCal:
        name: <&6>Library of Calexandria
        lore:
          - <&e>Knowledge and revelations are abound amongst these shelves
          - <&e>If ever you need answers this is the place to start
    slot_map:
      back: 46
      next_page: 9
      last_page: 1
      slots:
      - 10
      - 15
      - 19
      - 24
      - 28
      - 33
      - 37
      - 42
  definitions: page
  script:
    - define page 1 if:<[page].exists.not>
    - define inventory <inventory[calipolis_lore_locations_inventory]>
    - define title_string:|:<&chr[F808]><&chr[2000]>
    - if <[page]> == 1:
      - define title_string:|:<&chr[F701]><&chr[2101]><&chr[F801]><&chr[2001]><&chr[F601]><&chr[2102]><&chr[F801]><&chr[2002]>
      - define title_string:|:<&chr[F702]><&chr[2103]><&chr[F801]><&chr[2003]><&chr[F601]><&chr[2104]><&chr[F801]><&chr[2004]>
      - define title_string:|:<&chr[F702]><&chr[2105]><&chr[F801]><&chr[2005]><&chr[F601]><&chr[2106]><&chr[F801]><&chr[2006]>
      - define title_string:|:<&chr[F702]><&chr[2107]><&chr[F801]><&chr[2007]><&chr[F601]><&chr[2108]><&chr[F801]><&chr[2008]>
    - else if <[page]> == 2:
      - define title_string:|:<&chr[F701]><&chr[2109]><&chr[F801]><&chr[2009]><&chr[F601]><&chr[2110]><&chr[F801]><&chr[2010]>
      - define title_string:|:<&chr[F702]><&chr[2111]><&chr[F801]><&chr[2011]><&chr[F601]><&chr[2112]><&chr[F801]><&chr[2012]>
      - define title_string:|:<&chr[F702]><&chr[2113]><&chr[F801]><&chr[2013]><&chr[F601]><&chr[2114]><&chr[F801]><&chr[2014]>
      - define title_string:|:<&chr[F702]><&chr[2115]><&chr[F801]><&chr[2015]><&chr[F601]><&chr[2116]><&chr[F801]><&chr[2016]>
    - else if <[page]> == 3:
      - define title_string:|:<&chr[F701]><&chr[2117]><&chr[F801]><&chr[2017]><&chr[F601]><&chr[2118]><&chr[F801]><&chr[2018]>
      - define title_string:|:<&chr[F702]><&chr[2119]><&chr[F801]><&chr[2019]><&chr[F601]><&chr[2120]><&chr[F801]><&chr[2020]>
      - define title_string:|:<&chr[F702]><&chr[2121]><&chr[F801]><&chr[2021]>
    - adjust <[inventory]> title:<&f><&font[adriftus:travel_menu]><[title_string].unseparated>
    - define slots <script.data_key[data.slot_map.slots]>
    - define locations <script.data_key[data.locations]>
    - foreach <[locations].get[<[page].sub[1].mul[8].add[1]>].to[<[page].mul[8]>]>:
      - if <script.data_key[data.location_data.<[value]>].exists>:
        - define display <script.parsed_key[data.location_data.<[value]>.name]>
        - define lore <script.parsed_key[data.location_data.<[value]>.lore]>
        - define item calipolis_lore_location_tp[display=<[display]>;lore=<[lore]>;flag=target:<[value]>]
      - else:
        - define item calipolis_lore_location_tp[display=PLACEHOLDER;lore=PLACEHOLDER;flag=target:<[value]>]
      - inventory set slot:<[slots].get[<[loop_index]>]> o:<[item]> d:<[inventory]>

    # Next Page
    - if <[locations].size> > <[page].mul[8]>:
      - inventory set slot:<script.data_key[data.slot_map.next_page]> o:calipolis_lore_locations_next_page_button[flag=page:<[page]>] d:<[inventory]>

    # Previous Page
    - if <[page]> > 1:
      - inventory set slot:<script.data_key[data.slot_map.last_page]> o:calipolis_lore_locations_previous_page_button[flag=page:<[page]>] d:<[inventory]>

    # Back Button
    - inventory set slot:<script.data_key[data.slot_map.back]> o:calipolis_lore_locations_back_button d:<[inventory]>

    - inventory open d:<[inventory]>

calipolis_lore_locations_next_page:
  type: task
  debug: false
  script:
    - run calipolis_lore_locations_open def:<context.item.flag[page].add[1]>

calipolis_lore_locations_prev_page:
  type: task
  debug: false
  script:
    - run calipolis_lore_locations_open def:<context.item.flag[page].sub[1]>