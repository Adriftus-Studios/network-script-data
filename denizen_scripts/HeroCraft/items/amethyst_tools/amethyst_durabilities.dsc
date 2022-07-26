Amethyst_durabilities:
  type: world
  debug: false
  events:

    on player breaks block with:Amethyst_axe|Amethyst_pickaxe|Amethyst_shovel|Amethyst_sword|Amethyst_hoe|Amethyst_shears|:
      - define slot <player.held_item_slot>
      - choose <player.item_in_hand.script.name.after[_]>:
        - case axe pickaxe shovel hoe shears:
          - define value 1
        - case sword:
          - define value 2
      - inject custom_durability_process_task

    on player damages entity with:Amethyst_axe|Amethyst_pickaxe|Amethyst_shovel|Amethyst_sword|Amethyst_hoe|Amethyst_shears|:
      - define slot <player.held_item_slot>
      - choose <player.item_in_hand.script.name.after[_]>:
        - case axe pickaxe shovel:
          - define value 2
        - case hoe sword:
          - define value 1
        - case shears:
          - define value 0
      - inject custom_durability_process_task

    on player right clicks dirt with:Amethyst_hoe:
      - define slot <player.held_item_slot>
      - if <context.hand> == offhand:
        - define slot 41
      - define value 1
      - inject custom_durability_process_task

    on player right clicks *_log|stem with:Amethyst_axe:
      - define slot <player.held_item_slot>
      - if <context.hand> == offhand:
        - define slot 41
      - if <context.location.material.name.contains[stripped]>:
        - stop
      - define value 1
      - inject custom_durability_process_task

    on player right clicks dirt|grass_block with:Amethyst_shovel:
      - define slot <player.held_item_slot>
      - if <context.hand> == offhand:
        - define slot 41
      - define value 1
      - inject custom_durability_process_task
