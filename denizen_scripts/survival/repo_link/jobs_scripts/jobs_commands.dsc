jobs_command:
  type: command
  debug: false
  name: jobs2
  usage: /jobs2 (player) (level|experience) (add|set) (job name)
  description: used for any jobs command related things
  tab completions:
    1: <player.has_permission[jobs.moderator].if_true[<server.online_players.parse[name]>].if_false[]>
    2: <player.has_permission[jobs.administrator].if_true[level|experience].if_false[]>
    3: <player.has_permission[jobs.administrator].if_true[add|set].if_false[]>
    4: <player.has_permission[jobs.administrator].if_true[<script[Jobs_data_script].list_keys[jobs_list]>].if_false[]>
  script:
  - choose <context.args.size>:
      ##If not specified, opens jobs ui. meant for players
      - case 0:
        - inventory open d:jobs_info_gui
      ##If player has moderator permission, it will let them open the jobs window for other players, may be an edge case but players need help sometimes.
      - case 1:

        - if !<player.has_permission[jobs.moderator]>:
          - narrate "<&c>You do not have permission for this command."
          - determine cancelled

        - if <server.match_player[<context.args.get[1]>].if_null[true]>:
          - narrate "<&c>This player is offline, or does not exist"
          - stop
        - inventory open d:jobs_info_gui player:<server.match_player[<context.args.get[1]>]>

      ##These all require admin permission, and are all for manually leveling or setting a players experience.
      ##Its configed to still fire level up and achievements when adding.
      ##Use set to do it without firing the event.
      - case 2:
        - if !<player.has_permission[jobs.administrator]>:
          - narrate "<&c>You do not have permission for this command."
          - stop
        - narrate "<&c>Please specify <&e>add<&6>/<&e>set<&c>, a <&e>job<&c>, and an <&e>amount<&c>."

      - case 3:
        - if !<player.has_permission[jobs.administrator]>:
          - narrate "<&c>You do not have permission for this command."
          - stop
        - narrate "<&c>Please specify a <&e>job<&c>, and an <&e>amount<&c>."

      - case 4:
        - if !<player.has_permission[jobs.administrator]>:
          - narrate "<&c>You do not have permission for this command."
          - stop
        - narrate "<&c>Please specify an <&e>amount<&c>."

      - case 5:
        - if !<player.has_permission[jobs.administrator]>:
          - narrate "<&c>You do not have permission for this command."
        - if <server.match_player[<context.args.get[1]>].if_null[true]>:
          - narrate "<&c>This player is offline, or does not exist"
          - stop
        - if !<list[level|experience].contains_any[<context.args.get[2]>]>:
          - narrate "<&c>Please choose a valid attribute."
          - stop
        - if !<list[add|set].contains_any[<context.args.get[3]>]>:
          - narrate "<&c>Please choose a valid operation."
          - stop
        - if !<script[Jobs_data_script].list_keys[jobs_list].contains_any[<context.args.get[4]>]>:
          - narrate "<&c>Please choose a valid profession."
          - stop

        ##sets the operation type (add|set) then performs the various operations based off the other arguments
        - choose <context.args.get[3]>:
          - case add:
            - choose <context.args.get[2]>:
              - case level:
                - flag <server.match_player[<context.args.get[1]>]> jobs.<context.args.get[4]>.level:+:<context.args.get[5]>
                - narrate "<&a>Gave <&e><context.args.get[5]> <&e><context.args.get[4]><&a> level(s) <&a>to <&e><context.args.get[1]><&a>."
                - narrate "<&e><player.name> <&a>gave <&e><context.args.get[5]> <&e><context.args.get[4]><&a> level(s) <&a>to you." targets:<server.match_player[<context.args.get[1]>]>
                - stop
              - case experience:
                - define player <server.match_player[<context.args.get[1]>]>
                - define job <context.args.get[4]>
                - define total_experience <context.args.get[5]>
                - narrate "<&a>Gave <&e><context.args.get[5]> <&e><context.args.get[4]><&a> experience <&a> to <&e><context.args.get[1]><&a>."
                - narrate "<&e><player.name> <&a>gave <&e><context.args.get[5]> <&e><context.args.get[4]><&a> experience <&a>to you." targets:<server.match_player[<context.args.get[1]>]>
                - run jobs_exp_adding def.player:<server.match_player[<context.args.get[1]>]> def.job:<context.args.get[4]> def.total_experience:<context.args.get[5]>
                - stop
          - case set:
            - choose <context.args.get[2]>:
              - case level:
                - flag <server.match_player[<context.args.get[1]>]> jobs.<context.args.get[4]>.level:<context.args.get[5]>
                - narrate "<&a>Set <&e><context.args.get[1]>'s <&e><context.args.get[4]><&a> level to <&e><context.args.get[5]><&a>."
                - narrate "<&e><player.name><&a> set your <&e><context.args.get[4]><&a> level to <&e><context.args.get[5]><&a>."
                - stop
              - case experience:
                - flag <server.match_player[<context.args.get[1]>]> jobs.<context.args.get[4]>.experience_earned:<context.args.get[5]>
                - narrate "<&a>Set <&e><context.args.get[1]> <&e><context.args.get[4]><&a> experience earned this level to <&e><context.args.get[5]><&a>."
                - narrate "<&e><player.name><&a> set your <&e><context.args.get[4]><&a> experience earned this level to <&e><context.args.get[5]><&a>."

#TODO /jobs_Top|/top_jobs command handling
