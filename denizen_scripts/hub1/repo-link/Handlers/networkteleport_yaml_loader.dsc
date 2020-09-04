networkteleport_yaml_load:
    type: world
    events:
        on server start:
        - yaml create id:networkteleport_requests
        - yaml create id:networkteleporthere_requests
        - yaml create id:networkteleport_cooldowns
        - yaml create id:networkteleporthere_cooldowns
        - createworld 4_buildings
