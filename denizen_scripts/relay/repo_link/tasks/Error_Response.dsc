error_response:
  type: task
  debug: false
  definitions: data
  script:
    # % ██ [ define base definitions             ] ██
    - define development_guild <discord_group[a_bot,631199819817549825]>
    - define embed <discord_embed>

    # % ██ [ check if the channel exists         ] ██
    - if !<[data.server].advanced_matches_text[<[development_guild].channels.parse[name]>]>:
      - ~discordcreatechannel id:a_bot group:<[development_guild]> name:<[data.server]> "description:Error reporting for <[data.server]>" type:text category:634752968759050270 save:new_channel
      - define channel <entry[new_channel].channel>
    - else:
      - define channel <[development_guild].channel[<[data.server]>]>

    # % ██ [ check if the thread exists          ] ██
    - if <[channel].active_threads.is_empty> || !<util.time_now.format[MMMM-dd-u].advanced_matches_text[<[channel].active_threads.parse[name]>]>:
      - ~discordcreatethread id:a_bot name:<util.time_now.format[MMMM-dd-u]> parent:<[channel]> save:new_thread
      - define thread <entry[new_thread].created_thread>
    - else:
      - define thread <[channel].active_threads.highest[id]>

    # % ██ [ construct base embed content        ] ██
    - define embed_data.color 0,254,255

    # % ██ [ construct footer, check ratelimits  ] ██
    - if !<[data.rate_limited].exists>:
      - define embed_data "<[embed_data].with[footer].as[Script Error Count (*/hr)<&co> <[data.error_rate]>]>"
    - else:
      - define embed_data "<[embed_data].with[footer].as[<&lb>Rate-limited<&rb> Script error count (*/hr)<&co> <[data.error_rate]>]>"
      - define embed_data <[embed_data].with[footer_icon].as[https://cdn.discordapp.com/emojis/901634983867842610.gif?size=56&quality=lossless]>

    # % ██ [ construct player content            ] ██
    - if <[data.player_data].exists>:
      - define embed_data.author_name "Player Attached<&co> <[data.player_data.name]>"
      - define embed_data.author_icon_url https://crafatar.com/avatars/<[data.player_data.uuid].replace[-]>
      - define embed "<[embed].add_inline_field[player name].value[`<[data.player_data.name]>`]>"
      - define embed "<[embed].add_inline_field[player uuid].value[`<[data.player_data.uuid]>`]>"

    # % ██ [ construct error content             ] ██
    - if <[data.content].exists>:
      - define description <list>
      - define snipped false
      - foreach <[data.content]> key:script as:content:
        # % ██ [ define the file and link        ] ██
        - define data.script_data.file <[data.script_data.file_path].after[/plugins/Denizen/scripts/]>

        # % ██ [ format global scripts           ] ██
        - if <[data.script_data.file].starts_with[global]>:
          - define data.script_data.file_link https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/<[data.script_data.file].after[global/server/].replace[<&sp>].with[<&pc>20]>
          - define data.script_data.file_short global/<[data.script_data.file].after[global/server/]>

        # % ██ [ format test scripts             ] ██
        - else if <[data.server]> == test:
          - define data.script_data.file_link https://github.com/Adriftus-Studios/test/blob/main/<[data.script_data.file].after[test/].replace[<&sp>].with[<&pc>20]>
          - define data.script_data.file_short /<[data.script_data.file].after[test/]>

        # % ██ [ format all other scripts        ] ██
        - else:
          - define data.script_data.file_link https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/<[data.server]>/server/<[data.script_data.file].after[/server/].replace[<&sp>].with[<&pc>20]>
          - define data.script_data.file_short /<[data.script_data.file].after[/server/]>

        # % ██ [ format link if lines evident    ] ██
        - if <[data.script_data.line]> != (unknown):
          - define data.script_data.file_link <[data.script_data.file_link]><&ns>L<[data.script_data.line]>
        - define data.script_data.formatted_file **<&lb>`<&lb><[data.script_data.file_short]><&rb>`<&rb>(<[data.script_data.file_link]>)**

        # % ██ [ add error content               ] ██
        - define description "<[description].include_single[**`<[script]>`** | <[data.script_data.formatted_file]><&co>]>"
        - foreach <[content]> key:line as:message:
          - define error_content "<list_single[<&co>warning<&co>`Line <[line]>`<&co>]>"
          - if !<[message].is_empty>:
            - define error_content "<[error_content].include_single[<&gt> <[message].parse[strip_color.replace[`].with[<&sq>].proc[error_formatter]].separated_by[<n><&gt> ]>]>"
          - else:
            - define error_content "<[error_content].include_single[<&lt>a:warn:942230068372062239<&gt>**No error message** - Consider providing better context.]>"

          # % ██ [ check for description limit   ] ██
          - if <[description].include[<[error_content]>].separated_by[<n>].length> < 4000:
            - define description <[description].include[<[error_content]>]>
          - else:
            - define description "<[description].include_single[<&lt>a:warn:942230068372062239<&gt>**Snipped error count** - consider minimizing erroneous output.]>"
            - define snipped true
            - foreach stop

    # % ██ [ construct description content     ] ██
      - define embed <[embed].with[description].as[<[description].separated_by[<n>]>]>
    - else:
      - define embed "<[embed].with[description].as[<&lt>a:warn:942230068372062239<&gt>**No error content** - Consider providing better context.]>"

    # % ██ [ construct definitions content       ] ██
    - if !<[data.definition_map].is_empty.if_null[true]>:
      - define definition_content <[data.definition_map].proc[object_formatting].strip_color.replace[`].with[<&sq>]>
      - if <[definition_content].length> < 950:
        - define definition_content ```yml<n><[definition_content]><n>```
      - else:
        - define definition_content ```yml<n><[definition_content].substring[0,950].before_last[<n>]><n>⚠**Snipped!**```
      - define embed <[embed].add_field[Definitions<&co>].value[<[definition_content]>]>

    # % ██ [ complete embed content              ] ██
    - define embed <[embed].with_map[<[embed_data]>]>

    # % ██ [ send embed                          ] ██
    - ~discordmessage id:a_bot channel:<[thread]> <[embed]>

error_formatter:
  type: procedure
  debug: false
  definitions: text
  script:
    - define text <[text].strip_color>

    # % ██ [ ie: Debug.echoError(context, "Tag " + tagStr + " is invalid!"); ] ██
    - if "<[text].starts_with[Tag <&lt>]>" && "<[text].ends_with[<&gt> is invalid!]>":
      - determine "Tag `<[text].after[Tag ].before_last[ is invalid!]>` returned invalid."

    # % ██ [ ie: Debug.echoError(event.getScriptEntry(), "Unfilled or unrecognized sub-tag(s) '<R>" + attribute.unfilledString() + "<W>' for tag <LG><" + attribute.origin + "<LG>><W>!"); ] ██
    - else if "<[text].starts_with[Unfilled or unrecognized sub-tag(s) ']>":
      - define string "<[text].after[sub-tag(s) '].before_last[' for tag <&lt>]>"
      - determine "Unfilled or borked sub-tag(s) `<[string]>` <[text].after[<[string]>].before[' for tag <&lt>]> for tag<&co> `<&lt><[text].after[<[string]>].after[<&lt>].before_last[!]>`."

    # % ██ [ ie: Debug.echoError(event.getScriptEntry(), "The returned value from initial tag fragment '<LG>" + attribute.filledString() + "<W>' was: '<LG>" + attribute.lastValid.debuggable() + "<W>'."); ] ██
    - else if "<[text].starts_with[The returned value from initial tag fragment]>":
      - define tag "<[text].after[fragment '].before[' was<&co> ']>"
      - define parse_value "<[text].after_last[' was<&co> '].before_last['.]>"
      - determine "The returned value from initial tag fragment<&co> `<&lt><[tag]><&gt>` returned<&co> `<[parse_value]>`"

    # % ██ [ ie: Debug.echoError(context, "'ObjectTag' notation is for documentation purposes, and not to be used literally." ] ██
    - else if "<[text].starts_with['ObjectTag' notation is for documentation purposes]>":
      - determine "<&lt><&co>a<&co>901634983867842610<&gt> **<[text]>**"
    # % ██ [ ie: Debug.echoError(event.getScriptEntry(), "Almost matched but failed (missing [context] parameter?): " + almost); ] ██
    # % ██ [ ie: Debug.echoError(event.getScriptEntry(), "Almost matched but failed (possibly bad input?): " + almost); ] ██

    # % ██ [ ie: Debug.echoError(context, "(Initial detection) Tag processing failed: " + ex.getMessage()); ] ██

    # % ██ [ ie: attribute.echoError("Tag-base '" + base + "' returned null."); ] ██

    # % ██ [ ie: Debug.echoError("No tag-base handler for '" + event.getName() + "'."); ] ██
    # % ██ [ ie: Debug.echoError("Tag filling was interrupted!"); ] ██
    # % ██ [ ie: Debug.echoError("Tag filling timed out!"); ] ██

    - else:
      - determine <[text]>
