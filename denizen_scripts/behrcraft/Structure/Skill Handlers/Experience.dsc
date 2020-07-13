# - ███ [  When a player is directly connected to event:                          ] ███
# ^ ███ [    - run add_xp def:<#>|<skill> instantly                               ] ███
# ^ ███ [   ex:run add_xp def:100|farming instantly                               ] ███
# - ███ [                                                                         ] ███
# - ███ [  When a player is NOT directly connected to the event:                  ] ███
# ^ ███ [    - run add_xp_nostring def:<#>|<skill>|<player> instantly             ] ███
# ^ ███ [   ex:run add_xp_nostring def:100|farming|<player[Behr_Riley]> instantly ] ███

# @ ███ [ returns xp needed for next level                                        ] ███
xp_calc:
    type: procedure
    debug: false
    definitions: lvl
    script:
        - define pow_term <[lvl].div[7]>
        - define mul_term <element[300].mul[<element[2].power[<[pow_term]>]>]>
        - determine <[lvl].add[<[mul_term]>].round_down.div[4].round_down>
        #- define Line <element[0.5].mul[<[Lvl].power[2]>].sub[<[Lvl].mul[0.5]>].add[<element[2].power[<element[1].div[7]>].mul[300].mul[<element[2].power[<[lvl].div[7]>].sub[1].div[<element[2].power[<element[1].div[7]>].sub[1]>]>]>].round_down.div[4].round>



#@testcalc:
#@    type: task
#@    debug: false
#@    script:
#^        - define Correct <list[83|91|102|112|124|138|151|168|185|204|226|249|274|304|335|369|408]>
#^        - repeat 17:
#^            - define NewXP <proc[xp_calc2].context[<[value]>]>
#^            - if <[Correct].get[<[value]>]> == <[NewXP]>:
#^                - define xp "<&2>[<&a><&chr[2714]><&2>]<&a> <[NewXP]>"
#^            - else:
#^                - define xp "<&4>[<&c><&chr[2716]><&4>]<&c> <[NewXP]>"
#^            - narrate "<&e>Level<&6>:<&a> <[Value]> <&b> <&e>Exp<&6>: <[xp]> <&b><[Correct].get[<[value]>]>"



# % ███ [ Grants the provided amount of xp to a player                            ] ███
add_xp:
    type: task
    debug: false
    definitions: xp|skill
    script:
        - if !<player.has_flag[behrry.skill.<[skill]>.Exp]>:
            - flag player behrry.skill.<[skill]>.Exp:0
        - if !<player.has_flag[behrry.skill.<[skill]>.ExpReq]>:
            - flag player behrry.skill.<[skill]>.ExpReq:0
        - if !<player.has_flag[behrry.skill.<[skill]>.Level]>:
            - flag player behrry.skill.<[skill]>.Level:1
        
        - flag player Behrry.Economy.Coins:+:<[xp].round_up>
        - flag player behrry.skill.<[skill]>.Exp:+:<[xp]>
        - while <[xp]> > 0:
            - define xp_req <proc[xp_calc].context[<player.flag[behrry.skill.<[skill]>.Level]>]>
            - define to_add <[xp_req].sub[<player.flag[behrry.skill.<[skill]>.ExpReq]>]>
            - define xp <[xp].sub[<[to_add]>]>
            - if <[xp]> >= 0:
                - flag player behrry.skill.<[skill]>.Level:++
                - flag player behrry.skill.<[skill]>.ExpReq:0
                - if <player.flag[behrry.skill.<[skill]>.level].mod[10]> == 0:
                    - toast "<&e>Congratulations! Your <&6><[Skill]><&e> level is now <&6><player.flag[behrry.skill.<[skill]>.Level]>." icon:emerald frame:challenge
                - else:
                    - toast "<&e>Congratulations! Your <&6><[Skill]><&e> level is now <&6><player.flag[behrry.skill.<[skill]>.Level]>." icon:emerald frame:task
                - narrate "Congratulations, you've just advanced a <&6><[skill]><&r> level. <&nl>Your <&6><[skill]><&r> level is now <&6><player.flag[behrry.skill.<[skill]>.Level]><&f>."
            - else:
                - flag player behrry.skill.<[skill]>.ExpReq:+:<[xp].add[<[to_add]>]>

# % ███ [ Grants the provided amount of xp to an unstrung player                  ] ███
add_xp_nostring:
    type: task
    debug: false
    definitions: xp|skill|player
    script:
        - if !<[player].has_flag[behrry.skill.<[skill]>.Exp]>:
            - flag <[player]> behrry.skill.<[skill]>.Exp:<[xp]>
        - if !<[player].has_flag[behrry.skill.<[skill]>.ExpReq]>:
            - flag <[player]> behrry.skill.<[skill]>.ExpReq:0
        - if !<[player].has_flag[behrry.skill.<[skill]>.Level]>:
            - flag <[player]> behrry.skill.<[skill]>.Level:1
            
        - flag player behrry.skill.<[skill]>.Exp:+:<[xp]>
        - while <[xp]> > 0:
            - define xp_req <proc[xp_calc].context[<[player].flag[behrry.skill.<[skill]>.Level]>]>
            - define to_add <[xp_req].sub[<[player].flag[behrry.skill.<[skill]>.ExpReq]>]>
            - define xp <[xp].sub[<[to_add]>]>
            - if <[xp]> >= 0:
                - flag <[player]> behrry.skill.<[skill]>.Level:++
                - flag <[player]> behrry.skill.<[skill]>.ExpReq:0
                - toast targets:<[Player]> "<&e>Congratulations! Your <&6><[Skill]><&e> level is now <&6><[player].flag[behrry.skill.<[skill]>.Level]>." icon:bow frame:challenge
                - narrate targets:<[Player]> "Congratulations, you've just advanced a <&6><[skill]><&r> level! <&nl>Your <&6><[skill]><&r> level is now <&6><[player].flag[behrry.skill.<[skill]>.Level]><&f>."
            - else:
                - flag <[player]> behrry.skill.<[skill]>.ExpReq:+:<[xp].add[<[to_add]>]>

Experience_Handler:
    type: world
    debug: false
    events:
        on player joins:
            - if !<player.has_flag[Behrry.skill.Hitpoints.level]>:
                - flag player behrry.skill.Hitpoints.Exp:1154
                - flag player behrry.skill.Hitpoints.Level:10

clearer:
    type: task
    script:
        - define Player <server.match_player[Fox]>
        - flag <[Player]> behrry.skill.Mining.Exp:0
        - flag <[player]> behrry.skill.Mining.Level:0
        - flag <[Player]> behrry.skill.Mining.ExpReq:0

