player_death_handler:
  type: world
  debug: false
  data:

    # Random Death Messages
    # <[player]> is available as the player's name
    messages:
      # Entity Attack - Damage caused when an entity attacks another entity.
      # This category has an additional definition available
      # <[attacker]> - The name of the attacker
      ENTITY_ATTACK:

        # PVP - This one has an additional definition available
        # <[item]> - The item used to kill the other player
        PVP:
          - "<[player]><&e> was slain by <[attacker]><&e> with <[item]>."

        # When the attacker is a MythicMob
        MYTHIC_MOB:
          # generic - All mythic mobs next specifically set in this file will use this
          generic:
            - "<[player]><&e> got mythically annihilated by <[attacker]>."
          # This is an example of a specific mob
          specific_mob:
            - "<[player]> got beaten up specifically by the specific_mob."

        # Everything Else
        OTHER:
          - "<[player]><&e> was slain by <&c><[attacker]>."

      # PROJECTILE - Damage caused when attacked by a projectile.
      # This category has an additional definition available
      # <[attacker]> - The name of the attacker - defaults to "a ranged attack", if no attacker can be found
      PROJECTILE:
        - "<[player]><&e> got shot in the face by <[attacker]>."

      # Suffocation - Damage caused by being put in a block
      SUFFOCATION:
        - "<[player]><&e> died very quietly... encased in blocks."

      # Contact - Damage caused when an entity contacts a block such as a Cactus, Dripstone (Stalagmite) or Berry Bush.
      CONTACT:
        - "<[player]><&e> died to a pointy object."

      # Block Explosion - Damage caused by being in the area when a block explodes.
      BLOCK_EXPLOSION:
        - "<[player]><&e> cut the wrong wire on the bomb."

      # Fall - Damage caused when an entity falls a distance greater than 3 blocks
      FALL:
        - "<[player]><&e> learned about gravity, the hard way."

      # Fire Tick - Damage caused by direct exposure to fire
      FIRE:
        - "<[player]><&e> died a horrible, fiery death."

      # Melting - Damage caused due to a snowman melting
      MELTING:
        - "<[player]><&e> melted away, pathetically..."

      # Lava - Damage caused by direct exposure to lava
      LAVA:
        - "<[player]><&e> went swimming in lava without protection."

      # DROWNING - Damage caused by running out of air while in water
      DROWNING:
        - "<[player]><&e> forgot they couldn't breathe underwater."

      # ENTITY_EXPLOSION - Damage caused by being in the area when an entity, such as a Creeper, explodes.
      ENTITY_EXPLOSION:
        - "<[player]><&e> got a little bit exploded."

      # VOID - Damage caused by falling into the void
      VOID:
        - "<[player]><&e> stared into the void, and the void stared back."

      # LIGHTNING - Damage caused by being struck by lightning
      LIGHTNING:
        - "<[player]><&e> just had a... shocking moment."

      # SUICIDE - Damage caused by committing suicide.
      SUICIDE:
        - "<[player]><&e> made a poor life decision."

      # STARVATION - Damage caused by starving due to having an empty hunger bar
      STARVATION:
        - "<[player]><&e> starved to death."

      # POISON - Damage caused due to an ongoing poison effect
      POISON:
        - "<[player]><&e> has succumb to fatal poisoning."

      # MAGIC - Damage caused by being hit by a damage potion or spell
      MAGIC:
        - "<[player]><&e> was killed by mystical forces."

      # WITHER - Damage caused by Wither potion effect
      WITHER:
        - "<[player]><&e> withered away."

      # FALLING_BLOCK - Damage caused by being hit by a falling block which deals damage
      FALLING_BLOCK:
        - "<[player]><&e> got hit in the head by a large block."

      # FALLING_BLOCK - Damage caused in retaliation to another attack by the Thorns enchantment.
      THORNS:
        - "<[player]><&e> died to their own wrath."

      # DRAGON_BREATH - Damage caused by a dragon breathing fire.
      DRAGON_BREATH:
        - "<[player]><&e> died to find out the Dragon really needs a breath mint."

      # FLY_INTO_WALL - Damage caused when an entity runs into a wall.
      FLY_INTO_WALL:
        - "<[player]><&e> got a crash course in inertia."

      # HOT_FLOOR - Damage caused when an entity steps on MAGMA_BLOCK.
      HOT_FLOOR:
        - "<[player]><&e> died due to excessive hot foot."

      # CRAMMING - Damage caused when an entity is colliding with too many entities due to the maxEntityCramming game rule.
      CRAMMING:
        - "<[player]><&e> was squished to death in a pile of mobs."

      # DRYOUT - Damage caused when an entity that should be in water is not.
      DRYOUT:
        - "<[player]><&e> died due to being a fish out of water."

      # FREEZE - Damage caused from freezing.
      FREEZE:
        - "<[player]><&e> froze to death."

    # Moderation Information
    death_info:
      - "<&e>Location<&co> <player.location.simple>"
      - "<&e>Time of Death<&co> <util.time_now.format>"
      - "<&a>Click to open a Portal"
  events:
    on player dies bukkit_priority:HIGHEST:
      # Definitions
      - define player <proc[get_player_display_name].context[<context.entity>]>

      # Check for Custom Damage Messages
      - if <context.cause> == CUSTOM:
        - define message "<proc[get_player_display_name]><&e> was killed by <player.flag[custom_damage]>."
        - flag <context.entity> custom_damage:!
      - else:
        - choose <context.cause>:
          # ENTITY ATTACK
          - case ENTITY_ATTACK ENTITY_SWEEP_ATTACK:
            # Player vs Player
            - if <context.damager.entity_type> == PLAYER:
              - define item <context.damager.item_in_hand.display.if_null[<context.damager.item_in_hand.material.translated_name>]>
              - define item <[item].on_hover[<context.damager.item_in_hand>].type[SHOW_ITEM]>
              - define attacker <proc[get_player_display_name].context[<context.damager>]>
              - define message <script.parsed_key[data.messages.ENTITY_ATTACK.PVP].random>
              - define player <context.entity.name>
              - define attacker <context.damager.name>
              - define discord_message <script.parsed_key[data.messages.ENTITY_ATTACK.PVP].random>
            # Mythic Mob
            - else if <context.damager.is_mythicmob>:
              - define attacker <context.damager.mythicmob.display_name>
              - if <script.data_key[data.messages.MYTHIC_MOB.<context.damager.mythicmob.internal_name>].exists>:
                - define message <script.parsed_key[data.messages.ENTITY_ATTACK.MYTHIC_MOB.<context.damager.mythicmob.internal_name>].random>
                - define player <player.name>
                - define discord_message <script.parsed_key[data.messages.ENTITY_ATTACK.MYTHIC_MOB.<context.damager.mythicmob.internal_name>].random>
              - else:
                - define message <script.parsed_key[data.messages.ENTITY_ATTACK.MYTHIC_MOB.generic].random>
                - define player <player.name>
                - define discord_message <script.parsed_key[data.messages.ENTITY_ATTACK.MYTHIC_MOB.generic].random>
            # Everything Else
            - else:
              - if <context.damager.custom_name.exists>:
                - define attacker <context.damager.custom_name>
              - else:
                - define attacker <context.damager.entity_type.replace[_].with[<&sp>].to_titlecase>
              - define message <script.parsed_key[data.messages.ENTITY_ATTACK.OTHER].random>
              - define player <player.name>
              - define discord_message <script.parsed_key[data.messages.<context.cause>].random>

          # PROJECTILE
          - case PROJECTILE:
              - if !<context.damager.exists>:
                - define attacker "a ranged attack"
              - else if <context.damager.custom_name.exists>:
                - define attacker <context.damager.custom_name>
              - else:
                - define attacker <context.damager.entity_type.replace[_].with[<&sp>].to_titlecase>
              - define message <script.parsed_key[data.messages.<context.cause>].random>
              - define player <player.name>
              - define discord_message <script.parsed_key[data.messages.<context.cause>].random>

          # FIRE + FIRE TICK
          - case FIRE FIRE_TICK:
              - define message <script.parsed_key[data.messages.FIRE].random>
              - define player <player.name>
              - define discord_message <script.parsed_key[data.messages.FIRE].random>

          # EVERYTHING ELSE
          - default:
              - define message <script.parsed_key[data.messages.<context.cause>].random>
              - define player <player.name>
              - define discord_message <script.parsed_key[data.messages.<context.cause>].random>

      # PROCESSING STARTS
      - determine passively NO_MESSAGE
      - define players_final "<&font[adriftus:chat]><&chr[2001]><&r> <&7><&lb><&4>DEATH<&7><&rb><&r><&nl>     <[message]>"
      - define staff_final "<&font[adriftus:chat]><&chr[2001]><&r> <&7><&lb><&4>DEATH<&7><&rb><&r> - <element[<&7><&lb><&d>Moderation Information<&7><&rb>].on_hover[<script.parsed_key[data.death_info].separated_by[<&nl>]>].on_click[/dtd forward_portal coordinates <player.location.x> <player.location.y> <player.location.z>].type[RUN_COMMAND]><&nl>     <[message]>"
      - define staff <server.online_players.filter[has_permission[adriftus.staff]]>
      - define players <server.online_players.exclude[<[staff]>]>
      - narrate <[players_final]> targets:<[players]>
      - narrate <[staff_final]> targets:<[staff]>
      - wait 1t
      - if <yaml[chat_config].read[channels.server.integrations.Discord.<bungee.server>.active]>:
        - bungeerun relay Player_Death_Message def:<list[test|Xeane|<player.uuid>].include[<[discord_message].strip_color>]>
