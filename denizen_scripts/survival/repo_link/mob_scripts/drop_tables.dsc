mob_death_event:
  type: world
  debug: false
  whitelist: zombie|creeper|skeleton|spider|drowned|witch|husk|withers|evoker|ravager|pillager|vex|illusioner|silverfish|stray|vindicator|cave_spider|enderman|phantom|slime
  blacklist: <&B>Maggots <&f>- <&E>Lv.*|<&b>Voidworm <&f>- <&E>Lv.*
  events:
    on entity dies in:mainland|spawn:
      - if !<context.damager.is_player||false>:
        - stop
      - else if <script[mob_death_event].data_key[whitelist].contains[<context.entity.entity_type>]> && <context.entity.is_mythicmob> && !<script[mob_death_event].data_key[blacklist].contains[<context.entity.name>]>:
        - define mob_level <context.entity.mythicmob.level||0>
        - if <[mob_level]> == 0:
          - stop
        - inject soul_drop_table
        - inject legendary_drop_table
        - if <[soul_drop]||null> != null:
          - determine <context.drops.include[<[soul_drop]>]>
        - if <[legendary_drop]||null> != null:
          - determine <context.drops.include[<[legendary_drop]>]>



soul_drop_table:
  type: task
  debug: false
  definitions: mob_level
  script:
    - define chance <util.random.int[1].to[15000]>
    - if <[chance]> < 1000 && <[chance]> >= 500:
      - define soul_drop <proc[get_random_soul].context[0|<[mob_level]>]>
    - else if <[chance]> < 500 && <[chance]> >= 50:
      - define soul_drop <proc[get_random_soul].context[1|<[mob_level]>]>
    - else if <[chance]> < 50:
      - define drop <proc[get_random_soul].context[2|<[mob_level]>]>


legendary_drop_table:
  type: task
  debug: false
  definitions: mob_level
  script:
    - define chance <util.random.int[1].to[1000]>
    - if <[chance].mul[<[mob_level]>]> < 100 :
      - define drop_item <util.random.int[1].to[2]>
      - choose <[drop_item]>:
        - case 1:
          - define legendary_drop legendary_item_behr_claw
        - case 2:
          - define legendary_drop legendary_item_devin_bucket
        - case 3:
          - define legendary_drop legendary_item_bill_cane