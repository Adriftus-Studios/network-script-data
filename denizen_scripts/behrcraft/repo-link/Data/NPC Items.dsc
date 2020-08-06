NpcWatch:
    type: item
    debug: false
    material: Clock
    display name: "Item Name"
IronDoorKey:
    type: item
    debug: false
    material: tripwire_hook
    display name: "<&6>I<&e>ron <&6>D<&e>oor <&6>K<&e>ey"

Item_Handler:
    type: world
    debug: true
    events:
        on player places irondoorkey:
            - determine cancelled
        on player clicks iron_door with IronDoorKey bukkit_priority:lowest:
            - determine passively cancelled
            - if !<context.location.material.switched>:
                - playsound BLOCK_IRON_DOOR_OPEN <context.location>
            - switch <context.location> state:on
            - wait 2s
        # % ██ [ Check if the door was removed ] ██
            - if <context.location.material.name> == iron_door:
                - if <context.location.material.switched>:
                    - define Switched true
                - switch <context.location> state:off
        # % ██ [ Check if door actually closed ] ██
            - if !<context.location.material.switched> && <[Switched].exists>:
                - playsound BLOCK_IRON_DOOR_CLOSE <context.location>
          #^- wait 15t
          #^- if <context.location.material.name> == iron_door && <context.location.material.switched>:
          #^    - switch <context.location>

bob_the_sword:
    type: item
    material: iron_sword
    debug: false
    display name: "bob the sword"
    lore:
        - howdy

bob_handla:
    type: world
    debug: false
    events:
        on player clicks with bob_the_sword:
            - if <player.target.is_player||>:
                - explode power:1 <player.target.location>
                - playeffect effect:EXPLOSION_NORMAL at:<player.target.location.add[0,1,0]> visibility:50 quantity:10 offset:0.5
                - playeffect effect:EXPLOSION_LARGE at:<player.target.location.add[0,1,0]> visibility:50 quantity:1 offset:0.5
