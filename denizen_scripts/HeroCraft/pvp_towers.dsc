# Armor Stand Flag
# tower_id: Tower's ID

# Server Flags
# pvp_towers.towers.<[tower_id]>.entity: armor stand entity
# pvp_towers.towers.<[tower_id]>.range: range for KOTH area
# pvp_towers.towers.<[tower_id]>.owner: set to NEUTRAL on creation
# pvp_towers.towers.<[tower_id]>.progress: set to 0 on creation
# pvp_towers.info.<[tower_id]>.material: collected material
# pvp_towers.info.<[tower_id]>.interval: how many minutes between gathers

# Noted Inventories
# pvp_tower_<[tower_id]>: used for collecting materials

# Location Flags
# on_right_click:pvp_tower_open_cache
# tower_id:<[tower_id]>
# the above are required on the tower chest

PvP_Tower_Marker:
  type: entity
  entity_type: armor_stand
  mechanisms:
    custom_name: PvP_tower_marker
    custom_name_visible: false
    marker: true
    visible: false
    gravity: false
  flags:
    on_entity_added: PvP_tower_loop

PvP_tower_loop:
  type: task
  debug: false
  definitions: tower_id
  script:
    - if <context.entity.exists>:
      - define entity <context.entity>
    - else:
      - define entity <server.flag[pvp_towers.towers.<[tower_id]>.entity]>
    - define tower_id <[entity].flag[tower_id]> if:<[tower_id].exists.not>
    - if <server.flag[pvp_towers.towers.<[tower_id]>.progress]> != 1:
      - bossbar create pvp_tower_<[tower_id]> progress:<server.flag[pvp_towers.towers.<[tower_id]>.progress]> "title:<&a>Capturing<&co> <town[<server.flag[pvp_towers.towers.<[tower_id]>.owner]>].name>" players:<[entity].location.find_players_within[120]>
    - else if <server.flag[pvp_towers.towers.<[tower_id]>.progress]> == 0:
      - bossbar create pvp_tower_<[tower_id]> progress:<server.flag[pvp_towers.towers.<[tower_id]>.progress]> title:<&7>NEUTRAL players:<[entity].location.find_players_within[120]>
    - else:
      - bossbar create pvp_tower_<[tower_id]> progress:1 "title:<&a>Owned<&co> <town[<server.flag[pvp_towers.towers.<[tower_id]>.owner]>].name>" players:<[entity].location.find_players_within[120]>
    - define range <server.flag[pvp_towers.towers.<[tower_id]>.range]>
    - wait 1t
    - while <[entity].is_spawned>:
      - if <[loop_index].mod[3]> == 0:
        - define bossbar_players <[entity].location.find_players_within[120]>
        - bossbar pvp_tower_<[tower_id]> update players:<[bossbar_players]>
      - define players <[entity].location.find_players_within[<[range]>]>
      - define towns <[players].filter[has_town].parse[town]>
      - if <[towns].size> == 1:
        - run PvP_tower_increment def:<[tower_id]>|<[towns].first>
      - wait 3s
    - if <context.entity.is_spawned>:
      - run PvP_tower_loop def:<[tower_id]>
    - else:
      - bossbar remove pvp_tower_<[tower_id]>

PvP_tower_increment:
  type: task
  debug: false
  definitions: tower_id|town
  script:
    - define current_owner <town[<server.flag[pvp_towers.towers.<[tower_id]>.owner]>]>
    - define progress <server.flag[pvp_towers.towers.<[tower_id]>.progress]>
    - if <[current_owner]> == neutral:
      - define new_progress <[progress].add[0.01]>
      - flag server pvp_towers.towers.<[tower_id]>.owner:<[town]>
      - bossbar update pvp_tower_<[tower_id]> "title:<&a>Capturing<&co> <[town].name>" progress:<[new_progress]>
    - else if <[current_owner]> != <[town]>:
      - define new_progress <[progress].sub[0.01]>
      - if <[new_progress]> <= 0:
        - run PvP_tower_neutralize def:<[tower_id]>|<[town]>
    - else:
      - define new_progress <[progress].add[0.01]>
      - if <[new_progress]> >= 1 && <server.has_flag[pvp_towers.towers.<[tower_id]>.reset].not>:
        - run PvP_tower_capture def:<[tower_id]>|<[town]>
    - define final_progress <[new_progress].max[0].min[1]>
    - bossbar PvP_tower_<[tower_id]> update progress:<[final_progress]>
    - flag server pvp_towers.towers.<[tower_id]>.progress:<[final_progress]>

PvP_tower_neutralize:
  type: task
  debug: false
  definitions: tower_id|town
  script:
    - announce "<[tower_id]> has been nautralized by <[town].name>"
    - flag server pvp_towers.towers.<[tower_id]>.owner:neutral
    - flag server pvp_towers.towers.<[tower_id]>.reset:!
    - flag server pvp_towers.gathering:<-:<[tower_id]>
    - bossbar update pvp_tower_<[tower_id]> title:<&7>Neutral progress:0

PvP_tower_capture:
  type: task
  debug: false
  definitions: tower_id|town
  script:
    - announce "<[tower_id]> has been captured by <[town].name>"
    - inventory clear d:pvp_tower_<[tower_id]>
    - flag server pvp_towers.towers.<[tower_id]>.reset
    - flag server pvp_towers.gathering:->:<[tower_id]>
    - bossbar update pvp_tower_<[tower_id]> "title:<&a>Owned<&co> <[town].name>" progress:1

pvp_tower_periodic_gather:
  type: world
  debug: false
  events:
    on delta time minutely:
      - stop if:<server.has_flag[pvp_towers.gathering].not>
      - flag server pvp_towers.gathering:<server.flag[pvp_towers.gathering].deduplicate>
      - foreach <server.flag[pvp_towers.gathering]>:
        - if <server.flag[pvp_towers.info.<[value]>.interval]> == <server.flag[pvp_towers.info.<[value]>.current]>:
          - flag server pvp_towers.info.<[value]>.current:0
          - give <server.flag[pvp_towers.info.<[value]>.material]> to:pvp_tower_<[value]>
        - else:
          - flag server pvp_towers.info.<[value]>.current:+:1
        - wait 1t

pvp_tower_open_cache:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - define tower_id <context.location.flag[tower_id]>
    - stop if:<player.town.equals[<server.flag[pvp_towers.towers.<[tower_id]>.owner]>].not>
    - inventory open d:pvp_tower_<[tower_id]>