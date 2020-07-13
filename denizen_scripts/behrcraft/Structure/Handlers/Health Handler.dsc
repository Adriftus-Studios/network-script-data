Health_Handler:
    type: yaml data
#    debug: false
#    events:
#        on entity damages entity:
#            - if <context.entity.has_flag[HealthDisplay]>:
#                - remove <context.entity.flag[HealthDisplay].as_entity>
#
#            - spawn Armor_Stand[custom_name_visible=true;invulnerable=true;visible=false;gravity=false;custom_name=<&c><context.entity.health.round_up><&4>/<&c><context.entity.health_max>;attach_to=<context.entity>|l@0,0.5,0,world] <context.entity.location.add[0,0.5,0]> save:Healthbar
#            - flag <context.entity> HealthDisplay:<entry[HealthBar].spawned_entity>
#        on entity death:
#            - if <context.entity.has_flag[HealthDisplay]||false>:
#                - remove <context.entity.flag[HealthDisplay].as_entity>
#            