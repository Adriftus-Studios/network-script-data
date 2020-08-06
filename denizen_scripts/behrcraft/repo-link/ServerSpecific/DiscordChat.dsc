Discord_Chat_Task:
    type: task
    debug: false
    definitions: DiscordNamePlate|Message
    script:
        - define DiscordMessage "<[DiscordNamePlate]>: <[Message].unescaped>"
        - discord id:GeneralBot message channel:593523276190580736 <[DiscordMessage].parse_color.strip_color.replace[`].with['].replace[▲].with[<&lt>:pufferfish:681640271028551712<&gt>].replace[:pufferfish:].with[<&lt>:pufferfish:681640271028551712<&gt>]>
