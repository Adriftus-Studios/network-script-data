behrs_discord_toolbox:
  type: world
  debug: false
  events:
    on discord reaction added:
      - if <context.emoji.name> != settings:
        - stop

      - define msg_url https://discordapp.com/channels/<context.group.id>/<context.channel.id>/<context.message.id>
      - define embed <discordembed.url[<[url]>].color[16774656]>
      - if !<context.author.roles[<context.message.channel.group.id>].parse[id].contains[731591651142926456]> && !<context.author.roles[<context.message.channel.group.id>].parse[id].contains[679101171201474571]>:
        - stop

      - define message <list>
      - define message "<[message].include_single[**Message Contents:**].include_single[`<context.message.message>`]>"
      - define message "<[message].include_single[**UserTag (Author):** `<context.message.author.as_element.replace[discorduser@].with[<&lt>discorduser<&lb>]><&rb><&gt>`]>"
      - define message "<[message].include_single[**MessageTag:** `<context.message.as_element.replace[discordmessage@].with[<&lt>discordmessage<&lb>]><&rb><&gt>`]>"
      - define message "<[message].include_single[**ChannelTag:** `<context.message.channel.as_element.replace[discordchannel@].with[<&lt>discordchannel<&lb>]><&rb><&gt>`]>"
      - define message "<[message].include_single[**GroupTag:** `<context.message.channel.group.as_element.replace[discordgroup@].with[<&lt>discordgroup<&lb>]><&rb><&gt>`]>"

      - define embed1 "<[embed].title[Message Contents].description[<[message].separated_by[<n>]>]>"
      - if !<context.is_direct||false>:
        - discord id:adriftusbot send_embed channel:<context.channel> embed:<[embed1]>
      - else:
        - discord id:adriftusbot send_embed user:<context.author> embed:<[embed1]>

      - if <context.message.reactions.is_empty> && <context.author.roles[<context.message.channel.group.id>].is_empty>:
        - stop

      - define message <list>
      - if !<context.message.reactions.is_empty>:
        - define message "<[message].include_single[**Message Reactions:**]>"
        - foreach <context.message.reactions.parse[before[/]]> as:reaction:
          - define message "<[message].include_single[- <[reaction].formatted> - <[reaction].name> - `<[reaction].replace[discordemoji@].with[<&lt>discordemoji<&lb>]><&rb><&gt>`]>"
      - if !<context.author.roles[<context.message.channel.group.id>].is_empty>:
        - define message "<[message].include_single[**RoleTags (Author):**]>"
        - foreach <context.author.roles[<context.message.channel.group.id>]||<list[]>> as:role:
          - define message "<[message].include_single[ <[role].name> - `<[role].id>`|`<[role].as_element.replace[discordrole@].with[<&lt>discordrole<&lb>]><&rb><&gt>`]>"

      - define embed2 "<[embed].title[Roles and Emojis].description[<[message].separated_by[<n>]>]>"

      - if !<context.is_direct||false>:
        - discord id:adriftusbot send_embed channel:<context.channel> embed:<[embed2]>
      - else:
        - discord id:adriftusbot send_embed user:<context.author> embed:<[embed2]>
