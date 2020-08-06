help_override:
  type: world
  events:
    on help command:
      - if <context.args.first||null> == null:
        - foreach <yaml[help].read[default].parse[parsed]>:
          - narrate <[value]>
      - else if <yaml.list.contains[help.<context.args.first>]>:
        - if <context.args.get[2]||null> == null:
          - narrate <&2><list.pad_right[<context.args.first.length.+[10]>].with[-].unseparated>
          - narrate "<&2>---- <&e><context.args.first.to_titlecase> <&2>----"
          - narrate <&2><list.pad_right[<context.args.first.length.+[10]>].with[-].unseparated>
          - foreach <yaml[help.<context.args.first>].read[default].parse[parsed]>:
            - narrate <[value]>
        - else if <yaml[help.<context.args.first>].read[<context.args.get[2]>]||null> != null:
          - narrate <&2><list.pad_right[<context.args.get[2].length.+[10]>].with[-].unseparated>
          - narrate "<&2>---- <&e><context.args.get[2].to_titlecase> <&2>----"
          - narrate <&2><list.pad_right[<context.args.get[2].length.+[10]>].with[-].unseparated>
          - foreach <yaml[help.<context.args.first>].read[<context.args.get[2]>].parse[parsed]>:
            - narrate <[value]>
        - else:
          - narrate "<&c>Unknown Subsection<&co> <&b><context.args.get[2]>"
      - else:
          - narrate "<&c>Unknown Help Topic<&co> <&b><context.args.first>"
      - determine fulfilled

help_management:
  type: world
  load_data:
    - foreach <yaml.list.filter[starts_with[help]]>:
      - yaml unload id:<[value]>
    - ~yaml id:help load:data/help/default.yml
    - foreach <server.list_files[data/help].exclude[default.yml]>:
      - ~yaml id:help.<[value].before[.]> load:data/help/<[value]>
  events:
    on server start:
      - inject locally load_data
    on script reload:
      - inject locally load_data
