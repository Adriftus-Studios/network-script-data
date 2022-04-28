item_flags:
  type: world
  debug: false
  events:
    on player clicks item_flagged:run_script in inventory bukkit_priority:LOWEST:
      - if <context.item.flag[run_script].object_type> == List:
        - foreach <context.item.flag[run_script]>:
          - inject <[value]>
      - else:
        - inject <context.item.flag[run_script]>
    on player clicks item_flagged:cancelled in inventory bukkit_priority:LOWEST:
      - determine cancelled
    on player drops item_flagged:no_drop bukkit_priority:LOWEST:
      - determine cancelled
    on player drops item_flagged:on_drop bukkit_priority:LOWEST:
      - inject <context.item.flag[on_drop]>
    on player dies:
      - determine <context.drops.filter[has_flag[no_drop_on_death].not]>
    on player right clicks block with:item_flagged:right_click_script:
      - if <context.item.flag[right_click_script].object_type> == List:
        - foreach <context.item.flag[right_click_script]>:
          - inject <[value]>
      - else:
        - inject <context.item.flag[right_click_script]>
    on player left clicks block with:item_flagged:left_click_script:
      - if <context.item.flag[left_click_script].object_type> == List:
        - foreach <context.item.flag[left_click_script]>:
          - inject <[value]>
      - else:
        - inject <context.item.flag[left_click_script]>
    on entity damages entity with:item_flagged:on_damage:
      - if <context.damager.item_in_hand.flag[on_damage].object_type> == List:
        - foreach <context.damager.item_in_hand.flag[on_damage]>:
          - inject <[value]>
      - else:
        - inject <context.damager.item_in_hand.flag[on_damage]>
    on projectile launched:
      - stop if:<context.entity.item.has_flag[on_projectile_launched].not||true>
      - if <context.entity.item.flag[on_projectile_launched].object_type> == List:
        - foreach <context.entity.item.flag[on_projectile_launched]>:
          - inject <[value]>
      - else:
        - inject <context.entity.item.flag[on_projectile_launched]>
    on entity picks up item_flagged:on_item_pickup:
      - if <context.item.flag[on_item_pickup].object_type> == List:
        - foreach <context.item.flag[on_item_pickup]>:
          - inject <[value]>
      - else:
        - inject <context.item.flag[on_item_pickup]>
    on dropped_item added to world:
      - if <context.entity.item.has_flag[on_item_drop]>:
        - if <context.entity.item.flag[on_item_drop].object_type> == List:
          - foreach <context.entity.item.flag[on_item_drop]>:
            - inject <[value]>
        - else:
          - inject <context.entity.item.flag[on_item_drop]>
    on entity shoots item_flagged:on_item_shot:
      - if <context.item.flag[on_item_shot].object_type> == List:
        - foreach <context.item.flag[on_item_shot]>:
          - inject <[value]>
      - else:
        - inject <context.item.flag[on_item_shot]>
