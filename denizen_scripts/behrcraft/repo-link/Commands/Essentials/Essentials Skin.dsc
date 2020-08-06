Skin_Command:
    type: command
    name: skin
    debug: false
    description: Manages your player's skin.
    usage: /skin (Reset/Set <&lt>Name<&gt>/Save <&lt>Name<&gt> <&lt>URL<&gt> (Slim)/Delete <&lt>Name<&gt>/List)
    permission: Behr.Essentials.Skin
    tab complete:
        - define Arg1 <list[Reset|Set|Save|Delete|List|Rename]>
        - define Arg2 <list[Set|Delete|Rename]>
        - define Whitespace <context.raw_args.ends_with[<&sp>]>
        - if <context.args.size||0> == 0:
            - determine <[Arg1]>

        - else if <context.args.size> == 1 && !<[Whitespace]>:
            - determine <[Arg1].filter[starts_with[<context.args.first>]]>

        - if !<player.has_flag[Behr.Essentials.SavedSkins]>:
            - stop
        - define SavedSkins <player.flag[Behr.Essentials.SavedSkins].parse[before[/]]>

        - if <context.args.size> == 1 && <[Arg2].contains[<context.args.first>]> && <[Whitespace]> && <player.has_flag[Behr.Essentials.SavedSkins]>:
            - determine <[SavedSkins]>

        - else if <context.args.size> == 2 && <[Arg2].contains[<context.args.first>]> && !<[Whitespace]> && <player.has_flag[Behr.Essentials.SavedSkins]>:
            - determine <[SavedSkins].filter[starts_with[<context.args.get[2]>]]>
    script:
    # % ██ [ Check for args ] ██
        - if <context.args.size> == 0:
            - inject Command_Syntax
        
        - define SkinArg <context.args.first>
        - choose <[SkinArg]>:
            - case Reset:
                - adjust <player> skin:<player.name>
                - narrate format:Colorize_Green "Skin reset."

            - case Set:
                - if <context.args.size> != 2:
                    - inject Command_Syntax

                - define SkinName <context.args.get[2]>
                - if <player.has_flag[Behr.Essentials.SavedSkins]>:
                    - if <player.flag[Behr.Essentials.SavedSkins].parse[before[/]].contains[<[SkinName]>]>:
                        - define SkinBlob:<player.flag[Behr.Essentials.SavedSkins].map_get[<[SkinName]>]>
                        - adjust <player> skin_blob:<[SkinBlob]>
                        - narrate "<proc[Colorize].context[Skin set to:|green]> <&e><[SkinName]>"
                        - stop
                - adjust <player> skin:<[SkinName]>
                - narrate "<proc[Colorize].context[Skin set to:|green]> <&e><[SkinName]>"

            - case Save:
                - if !<list[2|3|4].contains[<context.args.size>]>:
                    - inject Command_Syntax

                - define SkinName <context.args.get[2]>
                - if <context.args.size> == 2:
                    - adjust <player> skin:<[SkinName]>
                    - flag player Behr.Essentials.SavedSkins:->:<[SkinName]>/<player.skin_blob>
                    - narrate "<proc[Colorize].context[Skin saved:|green]> <&e><[SkinName]>"
                    - narrate "<proc[Colorize].context[Skin set to:|green]> <&e><[SkinName]>"
                    - stop

                - define SkinUrl <context.args.get[3]>
                - define SkinModel <context.args.get[4].to_lowercase||empty>

                - if <player.has_flag[Behr.Essentials.SavedSkins]>:
                    - if <player.flag[Behr.Essentials.SavedSkins].parse[before[/]].contains[<[SkinName]>]>:
                        - narrate "<proc[Colorize].context[The specified skin name already exists:|red]> <&e><[SkinName]>"
                        - stop

                - if !<list[empty|slim].contains[<[SkinModel]>]>:
                    - narrate format:Colorize_Red "You must specify either empty or slim."
                    - stop

                - narrate "<&a>Retrieving the requested skin..."
                - define key <util.random.uuid>
                - run skin_url_task def:<[key]>|<[SkinUrl]>|<[SkinModel]> id:<[key]>
                - while <queue.exists[<[key]>]>:
                    - if <[loop_index]> > 20:
                        - queue <queue[<[key]>]> clear
                        - narrate "<&a>The request timed out. Is the url valid?"
                        - stop
                    - wait 5t
                # $ Quick sanity check - ideally this should never be true
                - if !<server.has_flag[<[key]>]>:
                    - stop
                - if <server.flag[<[key]>]> == null:
                    - narrate "<&a>Failed to retrieve the skin from the provided link. Is the url valid?"
                    - flag server <[key]>:!
                    - stop
                - yaml loadtext:<server.flag[<[key]>]> id:response
                - if !<yaml[response].contains[data.texture]>:
                    - narrate "<&a>An unexpected error occurred while retrieving the skin data. Please try again."
                - else:
                    - define SkinBlob <yaml[response].read[data.texture.value]>;<yaml[response].read[data.texture.signature]>
                - flag server <[key]>:!
                - yaml unload id:response

                - flag player Behr.Essentials.SavedSkins:->:<[SkinName]>/<[SkinBlob]>
                - narrate "<proc[Colorize].context[Skin saved:|green]> <&e><[SkinName]>"

                #- todo- Remove auto-apply if setting applies?
                #^ - if <player.has_flag[Behrry.Settings.SkinCommandAutoApply]>:
                - adjust <player> Skin_Blob:<[SkinBlob]>
                - narrate "<proc[Colorize].context[Skin set to:|green]> <&e><[SkinName]>"
            - case Delete:
                - if <context.args.size> != 2:
                    - inject Command_Syntax
                - define SkinName <context.args.get[2]>
                - if <player.has_flag[Behr.Essentials.SavedSkins]>:
                    - if !<player.flag[Behr.Essentials.SavedSkins].parse[before[/]].contains[<[SkinName]>]>:
                        - narrate "<proc[Colorize].context[Skin name does not exist:|red]> <&e><[SkinName]>"
                        - stop
                - define SkinBlob <player.flag[Behr.Essentials.SavedSkins].map_get[<[SkinName]>]>
                - flag player Behr.Essentials.SavedSkins:<-:<[SkinName]>/<[SkinBlob]>
                - narrate "<proc[Colorize].context[Skin deleted:|green]> <&e><[SkinName]>"
            - case List:
                - if <context.args.size> != 1:
                    - inject Command_Syntax
                - if !<player.has_flag[Behr.Essentials.SavedSkins]>:
                    - narrate format:Colorize_Red "You have no saved skins."
                    - stop
                - narrate format:Colorize_Green "Available Skins:"
                - narrate "<&a><player.flag[Behr.Essentials.SavedSkins].parse[before[/]].separated_by[<&e>, <&a>]>"
            - case Rename:
                - if <context.args.size> != 3:
                    - inject Command_Syntax
                - if !<player.has_flag[Behr.Essentials.SavedSkins]>:
                    - narrate format:Colorize_Red "You have no saved skins."
                    - stop
                - define OldSkinName <context.args.get[2]>
                - if <player.has_flag[Behr.Essentials.SavedSkins]>:
                    - if !<player.flag[Behr.Essentials.SavedSkins].parse[before[/]].contains[<[OldSkinName]>]>:
                        - narrate "<proc[Colorize].context[You do not have this skin saved:|red]> <&e><[OldSkinName]>"
                        - stop
                - define NewSkinName <context.args.get[3]>
                - if <player.has_flag[Behr.Essentials.SavedSkins]>:
                    - if <player.flag[Behr.Essentials.SavedSkins].parse[before[/]].contains[<[NewSkinName]>]>:
                        - narrate "<proc[Colorize].context[The specified skin name already exists:|red]> <&e><[NewSkinName]>"
                        - stop
                - define SkinBlob <player.flag[Behr.Essentials.SavedSkins].map_get[<[OldSkinName]>]>
                - flag player Behr.Essentials.SavedSkins:->:<[NewSkinName]>/<[SkinBlob]>
                - flag player Behr.Essentials.SavedSkins:<-:<[OldSkinName]>/<[SkinBlob]>
                - narrate "<&e>Skin<&6>: <&a><[OldSkinName]> <&e>renamed to<&6>: <&a><[NewSkinName]>"
            - default:
                - narrate "<&a>Available Sub-Commands: <&a>Reset<&6>, <&a>Set <&6>(<&a>Name<&6>), <&a>Save <&6>(<&a>url<&6>)"
                - stop

# $ ██ [ Repo SCript                     ] ██
# $ ██ [ [c]usage:
# - ██ | [c]/Skin Reset                  | Resets your skin to your default skin
# - ██ | [c]/Skin Save PlayerName        | Saves a skin by the PlayerName's Skin
# - ██ | [c]/Skin Save Name URL (slim)   | Saves a skin by the URL pasted -
# - ██ |                                   optionally making it Slim if specified
# - ██ | [c]/Skin Set Name               | Sets a skin by the name you saved -
# - ██ |                                   if it doesn't exist, you'll get whatever that player's name's skin is!
# - ██ | [c]/Skin List                   | Lists the skins you've saved
# - ██ | [c]/Skin Delete Name            | Deletes a skin by the name you saved
#@Skin_Command:
#@    type: command
#@    name: skin
#@    debug: false
#@    description: Manages your player's skin.
#@    usage: /skin (Reset/Set <&lt>Name<&gt>/Save <&lt>PlayerName<&gt>/Save <&lt>Name<&gt> URL<&gt>/List/Delete <&lt>Name<&gt>
#@    tab complete:
#^        - define Arg1 <list[Reset|Set|Save|Delete|List|Rename]>
#^        - define Arg2 <list[Set|Delete|Rename]>
#^        - if <context.args.size> == 0:
#^            - determine <[Arg1]>
#
#%   # % ██ [ /skin Arg ] ██
#^        - define Whitespace <context.raw_args.ends_with[<&sp>]>
#^        - else if <context.args.size> == 1 && !<[Whitespace]>:
#^            - determine <[Arg1].filter[starts_with[<context.args.first>]]>
#
#%   # % ██ [ Does the player even have saved skins to tab complete for? ] ██
#^        - if !<player.has_flag[SuperSuit_SavedSkins]>:
#^            - stop
#^        - define SavedSkins <player.flag[SuperSuit_SavedSkins].parse[before[/]]>
#
#%   # % ██ [ /skin Arg\s ] ██
#^        - if <context.args.size> == 1 && <[Arg2].contains[<context.args.first>]> && <[Whitespace]>:
#^            - determine <[SavedSkins]>
#
#%   # % ██ [ /skin Arg\sArg ] ██
#^        - else if <context.args.size> == 2 && <[Arg2].contains[<context.args.first>]> && !<[Whitespace]>:
#^            - determine <[SavedSkins].filter[starts_with[<context.args.get[2]>]]>
#    syntax:
#^        - narrate "<&e>Available Sub-Commands: <&a><list[Reset|Set|Save|Delete|List|Rename].separated_by[<&6>, <&a>]>"
#^        - stop
#    script:
#%   # % ██ [ Check for args ] ██
#^        - if <context.args.size> == 0:
#^            - inject locally syntax
#
#^        - define SkinArg <context.args.first>
#^        - choose <[SkinArg]>:
#%       # % ██ [ /skin reset - Resets the player's skin to their own ] ██
#^            - case Reset:
#^                - adjust <player> skin:<player.name>
#^                - narrate "<&a>Skin reset."
#
#
#%       # % ██ [ /skin set <Name> - Sets the player's skin to the Name they save their skin as ] ██
#^            - case Set:
#^                - if <context.args.size> != 2:
#^                    - narrate "<&e>Available Sub-Commands: <&a><list[Reset|Set|Save|Delete|List|Rename].separated_by[<&6>, <&a>]>"
#
#%           # % ██ [ Check if player saved skin ] ██
#^                - define SkinName <context.args.get[2]>
#^                - if <player.has_flag[SuperSuit_SavedSkins]>:
#^                    - if <player.flag[SuperSuit_SavedSkins].parse[before[/]].contains[<[SkinName]>]>:
#                    # % ██ [ Skin the owner player's skin if skin name not saved ] ██
#^                        - define SkinBlob:<player.flag[SuperSuit_SavedSkins].map_get[<[SkinName]>]>
#^                        - adjust <player> skin_blob:<[SkinBlob]>
#^                        - narrate "<&a>Skin set to: <&e><[SkinName]>"
#^                        - stop
#^                - adjust <player> skin:<[SkinName]>
#^                - narrate "<&a>Skin set to: <&e><[SkinName]>"
#
#%       # % ██ [ /skin save <PlayerName> - Saves a skin by the PlayerName's Skin ] ██
#%       # % ██ [ /Skin Save Name URL (slim) | Saves a skin by the URL pasted - optionally making it Slim if specified ] ██
#^            - case Save:
#^                - if !<list[2|3|4].contains[<context.args.size>]>:
#^                    - inject locally syntax
#
#%           # % ██ [ Check if specifying a player's name instead of name&URL ] ██
#^                - define SkinName <context.args.get[2]>
#^                - if <context.args.size> == 2:
#^                    - adjust <player> skin:<[SkinName]>
#^                    - flag player SuperSuit_SavedSkins:->:<[SkinName]>/<player.skin_blob>
#^                    - narrate "<&a>Skin saved: <&e><[SkinName]>"
#^                    - narrate "<&a>Skin set to: <&e><[SkinName]>"
#^                    - stop
#
#^                - define SkinUrl <context.args.get[3]>
#^                - define SkinModel <context.args.get[4].to_lowercase||empty>
#
#%           # % ██ [ Check if the player already has a skin saved as this name ] ██
#^                - if <player.has_flag[SuperSuit_SavedSkins]>:
#^                    - if <player.flag[SuperSuit_SavedSkins].parse[before[/]].contains[<[SkinName]>]>:
#^                        - narrate "<&c>The specified skin name already exists: <&e><[SkinName]>"
#^                        - stop
#
#%           # % ██ [ Validate skin model ] ██
#^                - if !<list[empty|slim].contains[<[SkinModel]>]>:
#^                    - narrate "<&c>You must specify either empty or slim."
#^                    - stop
#
#%           # % ██ [ webget skin from api ] ██
#^                - narrate "<&a>Retrieving the requested skin..."
#^                - define key <util.random.uuid>
#^                - run skin_url_task def:<[key]>|<[SkinUrl]>|<[SkinModel]> id:<[key]>
#^                - while <queue.exists[<[key]>]>:
#^                    - if <[loop_index]> > 20:
#^                        - queue <queue[<[key]>]> clear
#^                        - narrate "<&a>The request timed out. Is the url valid?"
#^                        - stop
#^                    - wait 5t
#%           # $ ██ [ Quick sanity check - ideally this should never be true ] ██
#^                - if !<server.has_flag[<[key]>]>:
#^                    - stop
#^                - if <server.flag[<[key]>]> == null:
#^                    - narrate "<&a>Failed to retrieve the skin from the provided link. Is the url valid?"
#^                    - flag server <[key]>:!
#^                    - stop
#^                - yaml loadtext:<server.flag[<[key]>]> id:response
#^                - if !<yaml[response].contains[data.texture]>:
#^                    - narrate "<&a>An unexpected error occurred while retrieving the skin data. Please try again."
#^                - else:
#^                    - define SkinBlob <yaml[response].read[data.texture.value]>;<yaml[response].read[data.texture.signature]>
#^                - flag server <[key]>:!
#^                - yaml unload id:response
#
#%           # % ██ [ Save & adjust the player's skin ] ██
#^                - flag player SuperSuit_SavedSkins:->:<[SkinName]>/<[SkinBlob]>
#^                - narrate "<&a>Skin saved: <&e><[SkinName]>"
#^                - adjust <player> Skin_Blob:<[SkinBlob]>
#^                - narrate "<&a>Skin set to: <&e><[SkinName]>"
#
#%       # % ██ [ /delete <SkinName> -  Deletes the player's saved skin by this name ] ██
#^            - case Delete:
#^                - if <context.args.size> != 2:
#^                    - inject locally syntax
#
#%           # % ██ [ Check if name to delete even exists ] ██
#^                - define SkinName <context.args.get[2]>
#^                - if <player.has_flag[SuperSuit_SavedSkins]>:
#^                    - if !<player.flag[SuperSuit_SavedSkins].parse[before[/]].contains[<[SkinName]>]>:
#^                        - narrate "<&a>Skin name does not exist: <&e><[SkinName]>"
#^                        - stop
#
#^                - define SkinBlob <player.flag[SuperSuit_SavedSkins].map_get[<[SkinName]>]>
#^                - flag player SuperSuit_SavedSkins:<-:<[SkinName]>/<[SkinBlob]>
#^                - narrate "<&a>Skin deleted: <&e><[SkinName]>"
#
#%       # % ██ [ /skin list - Shows you the list of saved skins ] ██
#^            - case List:
#^                - if <context.args.size> != 1:
#^                    - inject locally syntax
#
#%           # % ██ [ Check if player even has skins ] ██
#^                - if !<player.has_flag[SuperSuit_SavedSkins]>:
#^                    - narrate "<&c>You have no saved skins."
#^                    - stop
#
#^                - narrate "<&a>Available Skins:"
#^                - narrate "<&a><player.flag[SuperSuit_SavedSkins].parse[before[/]].separated_by[<&e>, <&a>]>"
#
#%       # % ██ [ /skin rename <OldName> <NewName> - Renames a skin from NameA to NameB ] ██
#^            - case Rename:
#^                - if <context.args.size> != 3:
#^                    - inject locally syntax
#
#%           # % ██ [ Check if player even has skins ] ██
#^                - if !<player.has_flag[SuperSuit_SavedSkins]>:
#^                    - narrate "<&c>You have no saved skins."
#^                    - stop
#
#%           # % ██ [ Check if old skin name is valid ] ██
#^                - define OldSkinName <context.args.get[2]>
#^                - if <player.has_flag[SuperSuit_SavedSkins]>:
#^                    - if !<player.flag[SuperSuit_SavedSkins].parse[before[/]].contains[<[OldSkinName]>]>:
#^                        - narrate "<&a>You do not have this skin saved: <&e><[OldSkinName]>"
#^                        - stop
#
#%           # % ██ [ Check if new skin name exists already ] ██
#^                - define NewSkinName <context.args.get[3]>
#^                - if <player.has_flag[SuperSuit_SavedSkins]>:
#^                    - if <player.flag[SuperSuit_SavedSkins].parse[before[/]].contains[<[NewSkinName]>]>:
#^                        - narrate "<&a>The specified skin name already exists: <&e><[NewSkinName]>"
#^                        - stop
#
#%           # % ██ [ Swaperonies ] ██
#^                - define SkinBlob <player.flag[Behr.Essentials.SavedSkins].map_get[<[OldSkinName]>]>
#^                - flag player SuperSuit_SavedSkins:->:<[NewSkinName]>/<[SkinBlob]>
#^                - flag player SuperSuit_SavedSkins:<-:<[OldSkinName]>/<[SkinBlob]>
#^                - narrate "<&e>Skin<&6>: <&a><[OldSkinName]> <&e>renamed to<&6>: <&a><[NewSkinName]>"
#^            - default:
#^                - narrate "<&a>Available Sub-Commands: <&a>Reset<&6>, <&a>Set <&6>(<&a>Name<&6>), <&a>Save <&6>(<&a>url<&6>)"
#^                - stop
#@ - Thanks mergu
#@skin_url_task:
#@    type: task
#@    debug: false
#@    definitions: key|url|model
#@    script:
#^        - define req https://api.mineskin.org/generate/url
#^        - if <[model]> == slim:
#^            - define req <[req]>?model=slim
#^        - ~webget <[req]> post:url=<[url]> timeout:5s save:res
#^        - flag server <[key]>:<entry[res].result||null>
