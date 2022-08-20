stat_tracking:
  type: world
  debug: false
  events:
    on player crafts item bukkit_priority:MONITOR:
      - flag player stats.crafting.<context.item>:+:<context.amount>
      - flag server stats.crafting.<context.item>:+:<context.amount>
    on entity dies bukkit_priority:MONITOR:
      - flag server stats.death.<context.entity.entity_type>:+:<context.amount>
    on player breaks block bukkit_priority:MONITOR:
      - flag player stats.mining.<context.material.name>:+:1
      - flag server stats.mining.<context.material.name>:+:1
    on player places block bukkit_priority:MONITOR:
      - flag player stats.mining.<context.material.name>:+:1
      - flag server stats.mining.<context.material.name>:+:1
    on mcmmo player activates ability for skill:
      - flag player stats.mcmmo.skill_use.<context.skill>:+:1
    on mcmmo player gains xp for skill:
      - flag player stats.mcmmo.skill_gain.<context.cause>:<context.skill>:+:<context.xp>