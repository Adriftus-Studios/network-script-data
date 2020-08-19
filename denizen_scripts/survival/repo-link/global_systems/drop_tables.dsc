drop_table_data:
  type: data
  worlds: mainland
  ## The Mobs Level
  mob_level:
    1:
      # % chance of getting this drop
      1000:
        - 0/1
      500:
        - 1/1
      50:
        - 2/1
    2:
      1000:
        - 0/2
      500:
        - 1/2
      50:
        - 2/2
    3:
      1000:
        - 0/3
      500:
        - 1/3
      50:
        - 2/3
    4:
      1000:
        - 0/4
      500:
        - 1/4
      50:
        - 2/4
    5:
      1000:
        - 0/5
      500:
        - 1/5
      50:
        - 2/5
    6:
      1000:
        - 0/6
      500:
        - 1/6
      50:
        - 2/6
    7:
      1000:
        - 0/7
      500:
        - 1/7
      50:
        - 2/7
    8:
      1000:
        - 0/8
      500:
        - 1/8
      50:
        - 2/8
    9:
      1000:
        - 0/9
      500:
        - 1/9
      50:
        - 2/9
    10:
      1000:
        - 0/10
      500:
        - 1/10
      50:
        - 2/10

drop_table:
  type: task
  debug: false
  definitions: mob_level
  script:
    - define number <util.random.int[1].to[10000]>
    - foreach <script[drop_table_data].list_keys[mob_level.<[mob_level]>].numerical>:
      - if <[value]> >= <[number]>:
        - define drop_data  <script[drop_table_data].data_key[mob_level.<[mob_level]>.<[value]>].random>
        - define drop <proc[get_random_soul].context[<[drop_data].before[/]>|<[drop_data].after[/]>]>
        - foreach stop

mob_death_event:
  type: world
  debug: false
  whitelist: zombie|creeper|skeleton|spider|drowned|witch|husk|withers|evoker|ravager|pillager|vex|illusioner|silverfish|stray|vindicator|cave_spider|enderman
  events:
    on entity dies in:mainland:
      - if <script[mob_death_event].data_key[whitelist].contains[<context.entity.entity_type>]> && <context.entity.is_mythicmob>:
        - define mob_level <context.entity.mythicmob.level>
        - inject drop_table
        - if <[drop]||null> != null:
          - determine <context.drops.include[<[drop]>]>
