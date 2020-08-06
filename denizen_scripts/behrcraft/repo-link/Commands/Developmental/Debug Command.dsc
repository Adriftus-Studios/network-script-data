debug_Command:
    type: command
    name: debug
    debug: false
    description: Debugs the command you type.
    usage: /debug (run)/<&lt>commandname<&gt> (Args)
    permission: behrry.essentials.debug
    script:
    # @ ██ [  Check for args ] ██
        - if <context.args.first||null> == null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check if we're running a scriptname or command ] ██
        - if <context.args.first> == run && <context.args.get[2]||null> != null && <context.args.get[2]> != debug:
            - if <context.args.get[3]||null> == null:
                - run <context.args.get[2]>
            - else:
                - run <context.args.get[2]> path:<context.raw_args.after[<context.args.first><&sp>]>
            
    # @ ██ [  check if they have a debug location ] ██
        - else:
            - execute as_op "denizen debug -r"
            - if <context.args.size> == 1:
            # @ ██ [  /command ] ██
                - execute as_op "<context.args.first>"
            - else:
            # @ ██ [  /command arg1+ ] ██
                - execute as_op "<context.args.first> <context.raw_args.after[<context.args.first><&sp>]>"
            - execute as_op "denizen submit"




#test:
#    type: task
#    debug: false
#    script:
#        - define Loc <player.location.sub[0,3,0]>
#        - define Distance 100
#        - define Frequency 4
#        - repeat <[Distance]>:
#            - define mod <[Value]>
#            - if <[mod].is_even>:
#                - repeat <[mod]>:
#                    - define Loc <[Loc].sub[0,0,16]>
#                    - chunkload <[Loc].chunk> duration:1s
#                    - wait <[Frequency]>t
#                - repeat <[mod]>:
#                    - define Loc <[Loc].add[16,0,0]>
#                    - chunkload <[Loc].chunk> duration:1s
#                    - wait <[Frequency]>t
#            - else:
#                - repeat <[mod]>:
#                    - define Loc <[Loc].add[0,0,16]>
#                    - chunkload <[Loc].chunk> duration:1s
#                    - wait <[Frequency]>t
#                - repeat <[mod]>:
#                    - define Loc <[Loc].sub[16,0,0]>
#                    - chunkload <[Loc].chunk> duration:1s
#                    - wait <[Frequency]>t
#            - announce to_console "<&e>Completion<&6>:<&a> <[mod].div[<[Distance]>].round_to[5].mul[100]>%"
#            #- announce to_console "<&e>Completion<&6>:<&a> <element[<[Mod]>].div[<[Distance].mul[<[Distance].sub[1].mul[2].div[2].add[1]>]>]>%"
#        - announce to_console "<&a>Chunkloading Complete<&2>."



prank:
    type: task
    script:
        - foreach <script[pronk].data_key[dialogue]> as:text:
            - announce "<&a>☼<&sp><&r><player.name.display_name><&r> <[text]>"
            - if <[Loop_Index]> < 3:
                - wait 15t
            - else if <[Loop_Index]> < 8:
                - wait 10t
            - else if <[loop_index]> < 11:
                - wait 5t
            - else:
                - wait 3t
pronk:
    type: data
    dialogue:
        - "What the fuck"
        - "did you just fucking say about me"
        - "you little bitch?"
        - "I'll have you know"
        - "I graduated top of my class in the Navy Seals"
        - "and I've been involved in numerous secret raids on Al-Quaeda"
        - "and I have over 300 confirmed kills."
        - "I am trained in gorilla warfare"
        - "and I'm the top sniper in the entire US armed forces."
        - "You are nothing to me but just another target."
        - "I will wipe you the fuck out with precision"
        - "the likes of which has never been seen before on this Earth"
        - "mark my fucking words."
        - "You think you can get away with saying that shit to me over the Internet?"
        - "Think again, fucker."
        - "As we speak I am contacting my secret network of spies across the USA"
        - "and your IP is being traced right now so you better prepare for the storm"
        - "maggot."
        - "The storm that wipes out the pathetic little thing you call your life."
        - "You're fucking dead, kid."
        - "I can be anywhere, anytime,"
        - "and I can kill you in"
        - "over seven hundred ways,"
        - "and that's just with my bare hands."
        - "Not only am I extensively"
        - "trained in unarmed combat,"
        - "but I have access to the entire arsenal"
        - "of the United States Marine Corps"
        - "and I will use it to its full extent to"
        - "wipe your miserable ass off the face of the continent,"
        - "you little shit."
        - "If only you could have known what unholy retribution your"
        - "little clever comment was about to bring down upon you"
        - "maybe you would have held your fucking tongue."
        - "But you couldn't, you didn't, and now you're paying the price, you goddamn idiot."
        - "I will shit fury all over you and you will drown in it."
        - "You're fucking dead, kiddo."



lightmeupdaddy:
    type: task
    debug: false
    script:
        - foreach <player.we_selection.blocks> as:b:
            - light <[b]> 15
