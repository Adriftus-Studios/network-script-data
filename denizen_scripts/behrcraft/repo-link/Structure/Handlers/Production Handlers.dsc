Production_Handler:
    type: world
    debug: false
    events:
        on player clicks block with:World_Edit_Selector:
            - determine passively cancelled
            #$ Fake it until you make it
            - define Loc <player.location.cursor_on>
            - define ClickType <context.click_type>
            - define Selection <player.we_selection||null>
            - if <[ClickType].contains[left]>:
                #- execute as_op /hpos1 silent
                - define SelIndex 1
            - else if <[ClickType].contains[right]>:
                #- execute as_op /hpos2 silent
                - define SelIndex 2
            - else:
                - stop
            - inject SelectionDisplay

SelectionDisplay:
    type: task
    debug: false
    script:
        - define LocText "<&2>[<&a>Selection <[SelIndex]><&2>] <&6>[<&e><[Loc].x><&6>, <&e><[Loc].y><&6>, <&e><[Loc].z><&6>]"
        - if <[Selection]||null> != null:
            - define XSize <[Selection].max.X.sub[<[Selection].min.X>].add[1]>
            - define YSize <[Selection].max.Y.sub[<[Selection].min.Y>].add[1]>
            - define ZSize <[Selection].max.Z.sub[<[Selection].min.Z>].add[1]>
            - define math4 <[XSize].mul[<[YSize]>].mul[<[ZSize]>]>
            - if <[math4]> > 150000:
                - define Size "<&6>[<&e>Size<&6>: <&c>Real Big<&6>]"
            - else:
                - define Size "<&6>[<&e>Size<&6>: <&e><[math4].format_number> <&b>| <&e><[XSize]><&6>,<&e><[YSize]><&6>,<&e><[ZSize]><&6>]"

            - if <[Loc].material.after[<&lb>].length> > 1:
                - define MechanismList <[Loc].material.after[<&lb>].before[<&rb>].split[;]>
                - define Mechanisms <&nl><&3>[<&b>Mechanisms<&3>]<&e><&nl><&a>[<&e><[MechanismList].separated_by[<&a><&rb><&nl><&a><&lb><&e>]><&a>]
            - define Text "<[LocText]> <[Size]>"
            - define Hover "<&3>[<&b>Material<&3>] <&e><[Loc].material.name><[Mechanisms].replace[|].with[<&a>|<&e>]||>"
            - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
        - else:
            - narrate <[LocText]>
