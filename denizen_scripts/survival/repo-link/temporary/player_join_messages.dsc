player_join_messages:
    type: world
    debug: false
    events:
        on player joins:
            - wait 1s
            - narrate "<&4>[<&c>Note<&4>] <&b>This server is in <&6>ALPHA<&3>. <&b>Until released, you can play semi-survival on <&6>BehrCraft<&b> by typing <&3><&dq><&6>/<&e>play behrcraft<&3><&dq>"
