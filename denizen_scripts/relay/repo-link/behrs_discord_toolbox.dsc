behrs_discord_toolbox:
  type: world
  debug: false
  events:
    on discord reaction added:
        - if <context.emoji.name> != settings:
            - stop
        - if <context.author.roles[<context.message.channel.group.id>].parse[id].contains[731591651142926456]> || <context.author.roles[<context.message.channel.group.id>].parse[id].contains[679101171201474571]>:
            - define message "**Message Contents:** <context.message.message>"
            - define "message:->:**UserTag (Author):** <context.message.author.as_element.replace[discorduser@].with[<&lt>discorduser<&lb>]><&rb><&gt>"
            - define "message:->:**MessageTag:** <context.message.as_element.replace[discordmessage@].with[<&lt>discordmessage<&lb>]><&rb><&gt>"
            - define "message:->:**ChannelTag:** <context.message.channel.as_element.replace[discordchannel@].with[<&lt>discordchannel<&lb>]><&rb><&gt>"
            - define "message:->:**GroupTag:** <context.message.channel.group.as_element.replace[discordgroup@].with[<&lt>discordgroup<&lb>]><&rb><&gt>"
            - if !<context.message.reactions.is_empty>:
                - define "message:->:**Message Reactions:**"
                - foreach <context.message.reactions.parse[before[/]]> as:reaction:
                    - define "message:->: - <[reaction].formatted> - <[reaction].name> - <[reaction].replace[discordemoji@].with[<&lt>discordemoji<&lb>]><&rb><&gt>"
            - if !<context.author.roles[<context.message.channel.group.id>].is_empty>:
                - define "message:->:**RoleTags (Author):**"
                - foreach <context.author.roles[<context.message.channel.group.id>]||<list[]>> as:role:
                    - define "message:->: - <[role].name> - <[role].as_element.replace[discordrole@].with[<&lt>discordrole<&lb>]><&rb><&gt>"
            - run discord_sendMessage def:<list[<context.group.name>|<context.channel.name>].include_single[<[message].separated_by[<&nl>]>]>
