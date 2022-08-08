glowberries_glow:
    type: world
    debug: false
    events:
        after player consumes glow_berries:
            - cast night_vision <player> amplifier:2 duration:10s hide_particles
            - cast glowing <player> duration:10s