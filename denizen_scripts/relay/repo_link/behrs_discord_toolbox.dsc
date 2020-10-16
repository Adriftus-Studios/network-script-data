behrs_discord_toolbox:
  type: world
  debug: false
  events:
    on discord reaction added for:adriftusbot:
      - if <context.emoji.name> != settings:
        - stop
      
      - define embed <discordembed.color[16774656]>
      - define direct_message <context.is_direct||false>
      - define message <context.message>
      - define author <context.author>

      - if !<[direct_message]>:
        - define channel <context.channel>
        - define group <context.group>
        - define msg_url https://discordapp.com/channels/<context.group.id>/<context.channel.id>/<[message].id>
        - define embed <[embed].url[<[msg_url]>]>

      - if !<[author].roles[626078288556851230].parse[id].contains[731591651142926456]> && !<[author].roles[601677205445279744].parse[id].contains[679101171201474571]>:
        - stop

      - define context <list>
      - define context "<[context].include_single[**Message Contents:**].include_single[`<[message].message>`]>"
      - define context "<[context].include_single[**UserTag (Author):** `<[author].as_element.replace[discorduser@].with[<&lt>discorduser<&lb>]><&rb><&gt>`]>"

      - if !<[direct_message]>:
        - define context "<[context].include_single[**MessageTag:** `<[message].as_element.replace[discordmessage@].with[<&lt>discordmessage<&lb>]><&rb><&gt>`]>"
        - define context "<[context].include_single[**ChannelTag:** `<[channel].as_element.replace[discordchannel@].with[<&lt>discordchannel<&lb>]><&rb><&gt>`]>"
        - define context "<[context].include_single[**GroupTag:** `<[group].as_element.replace[discordgroup@].with[<&lt>discordgroup<&lb>]><&rb><&gt>`]>"

      - define embed1 "<[embed].title[Message Contents].description[<[context].separated_by[<n>]>]>"
      - if !<[direct_message]>:
        - ~discord id:adriftusbot send_embed channel:<[channel]> embed:<[embed1]>
      - else:
        - ~discord id:adriftusbot send_embed user:<[author]> embed:<[embed1]>

      - if <[message].reactions.is_empty> && <[author].roles[<[group].id>].is_empty>:
        - stop
      - wait 5t

      - define context <list>
      - if !<[message].reactions.is_empty>:
        - define context "<[context].include_single[**Message Reactions:**]>"
        - foreach <[message].reactions.parse[before[/]]> as:reaction:
          - define context "<[context].include_single[- <[reaction].formatted> - <[reaction].name> - `<[reaction].replace[discordemoji@].with[<&lt>discordemoji<&lb>]><&rb><&gt>`]>"
      - if !<[author].roles[<[group].id>].is_empty>:
        - define context "<[context].include_single[**RoleTags (Author):**]>"
        - foreach <[author].roles[<[group].id>]||<list[]>> as:role:
          - define context "<[context].include_single[ <[role].name> - `<[role].id>`|`<[role].as_element.replace[discordrole@].with[<&lt>discordrole<&lb>]><&rb><&gt>`]>"

      - define embed2 "<[embed].title[Roles and Emojis].description[<[context].separated_by[<n>]>]>"

      - if !<[direct_message]>:
        - ~discord id:adriftusbot send_embed channel:<[channel]> embed:<[embed2]>
      - else:
        - ~discord id:adriftusbot send_embed user:<[author]> embed:<[embed2]>
