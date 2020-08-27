authorize_discord_connection:
  type: task
  debug: false
  definitions: state
  script:
    - flag server <[state]>

manage_discord_oauth_records:
  type: world
  debug: false
  events:
    on server start:
      - if <server.has_file[data/discord_oauth.yml]>:
        - yaml id:discord_oauth load:data/discord_oauth.yml
      - else:
        - yaml id:discord_oauth create
      - run discord_oauth_cleanup

discord_oauth_cleanup:
  type: task
  debug: false
  script:
    - if <yaml[discord_oauth].contains[accepted_states]>:
      - foreach <yaml[discord_oauth].list_keys[accepted_states]>:
        - if <yaml[discord_oauth].read[accepted_states.<[value]>.time]> > <server.current_time_millis>:
          - yaml id:discord_oauth set accepted_states.<[value]>:!

discord_oauth_remove_state:
  type: task
  debug: false
  definitions: state
  script:
      - yaml id:discord_oauth set accepted_states.<[state]>:!
      - ~yaml id:discord_oauth savefile:data/discord_oauth.yml

discord_oauth_add_state:
  type: task
  debug: false
  definitions: state
  script:
      - yaml id:discord_oauth set accepted_states.<[state]>.time:<util.time_now.add[5m].epoch_millis>
      - ~yaml id:discord_oauth savefile:data/discord_oauth.yml

discord_oauth_validate_state:
  type: procedure
  debug: false
  definitions: state
  script:
    - if <yaml[discord_oauth].contains[accepted_states.<[state]>]>:
      - determine true
    - determine false

discord_oauth_events:
  type: world
  debug: false
  events:
    on delta time minutely:
      - run discord_oauth_cleanup
