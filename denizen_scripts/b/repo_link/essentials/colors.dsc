colors_command:
  type: command
  name: colors
  debug: false
  description: Lists the colors in a click menu
  usage: /colors
  permission: behr.essentials.colors
  script:
    - if !<context.args.is_empty>:
      - narrate "<&c>Invalid usage - just /colors"
      - stop

    - if <server.has_flag[command.colors]>:
      - narrate <server.flag[command.colors]>
      - stop

    - define message <list>
    - foreach <list[&0|&1|&2|&3|&4|&5|&6|&7|&8|&9|&a|&b|&c|&d|&e|&f].sub_lists[7]> as:colors:
      - define line <list>
      - foreach <[colors]> as:color:
        - define line "<[line].include_single[<[color].parse_color.on_hover[<&a>Shift-Click to insert<&co><n><&r><[color].parse_color>This color!]>]>"
      - define message <[message].include_single[<[line]>]>

    - foreach <map[&k=tacos;&l=Bold;&M=Strike;&r=Reset;&o=Italic;&n=Underline]> key:format as:text:
      - define formats "<[formats].include_single[<&hover[<&a>Shift-Click to insert<&co><n><&r><[format].parse_color>This <[text]> format!]><[format].parse_color><[text].with_insertion[<[format]>]><&end_hover>]>"

    - define message "<[message].include_single[<&2>+<element[<&a>Shift-Click To Insert].pad_left[28].with[-]><&2>-----+"]>"
    - define message <[message].include_single[<&sp.repeat[3]><[message].include[<[formats].sub_lists[3]>].parse[separated_by[<&sp.repeat[3]>]].separated_by[<n>]>]>
    - define message "<[message].include_single[<&8><&lb><&7>Note<&8><&rb><&7><&co> Color before Formats!<&nl><&2>+<element[].pad_left[22].with[-]><&2>-----+]>"

    - narrate <[message]>
    - flag server command.colors:<[message]>

old_Colors_Command:
    type: command
    name: colors
    debug: false
    description: Lists the colors in a click-menu
    usage: /colors
    permission: behr.essentials.colors
    script:
    # % ██ [ Verify args ] ██
        - if !<context.args.is_empty>:
            - Inject Command_Syntax

    # % ██ [ Create color lists ] ██
        - define Colors <list[&0|&1|&2|&3|&4|&5|&6|&7|&8|&9|&a|&b|&c|&d|&e|&f]>
        - foreach <list[1|2]> as:Line:
            - define Math1 <[Loop_Index].add[<[Loop_Index].sub[1].mul[7]>]>
            - define Math2 <[Loop_Index].add[<[Loop_Index].sub[1].mul[8]>].add[7]>
            - foreach <[Colors].get[<[Math1]>].to[<[Math2]>]> as:Color:
                - define Hover "<proc[Colorize].context[Shift-Click to Insert:|green]><&nl><[Color].parse_color>This Color!"
                - define Text <[Color].parse_color><[Color]>
                - define Insert <[Color]>
                - define Key<[Loop_Index]> <proc[msg_hover_ins].context[<[Hover]>|<[Text]>|<[Insert]>]>
                - define List<[Line]>:->:<[Key<[Loop_Index]>]>

    # % ██ [ Create format lists ] ██
        - define formats "<List[&k/tacos|&l/Bold|&M/Strike|&r/ Reset|&o/Italic|&n/Underline]>"
        - foreach <list[3|4|5]> as:line:
            - define Math1 <[Loop_Index].mul[2].sub[1]>
            - define Math2 <[Loop_Index].mul[2]>
            - foreach <[Formats].get[<[Math1]>].to[<[Math2]>]> as:Format:
                - define Hover "<proc[Colorize].context[Shift-Click to Insert:|green]><&nl><&e><[Format].before[/].parse_color><[Format].after[/]>!"
                - define Text <[Format].before[/].parse_color><[Format].after[/]><&sp><&sp><&sp>
                - define Insert <[Format].before[/]>
                - define Key<[Loop_Index]> <proc[msg_hover_ins].context[<[Hover]>|<[Text]>|<[Insert]>]>
                - define List<[Line]>:->:<[Key<[Loop_Index]>]>

    # % ██ [ Narrate ] ██
        - narrate "<&2>+<element[<&a>Shift-Click To Insert].pad_left[28].with[-]><&2>-----+"
        - repeat 5:
            - narrate <&sp><&sp><[List<[Value]>].separated_by[<&sp><&sp>]>
        - narrate "<&8>[<&7>Note<&8>]<&7>: Color before Formats!<&nl><&2>+<element[].pad_left[22].with[-]><&2>-----+"
