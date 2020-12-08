#$ note: rename fil
link_dcommand:
  type: task
  definitions: Message|channel_id|author|group|message_id|command_alias
  debug: false
  script:
  # - ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject command_arg_registry
    - define color Code
    - inject embedded_color_formatting
    - define headers <yaml[saved_headers].parsed_key[discord.Rachela]>
    - define url https://discordapp.com/api/channels/<[channel_id]>/messages

  # - ██ [ Euth's Silly Trash ] ██
    - define chance <util.random.int[1].to[4]>
    - choose <[chance]>:
      - case 1:
        - define flavor "Zug Zug"
      - case 2:
        - define flavor "Sheesh, can't i get a day off?"
      - case 3:
        - define flavor "Don't you ever say please?"
      - case 4:
        - define flavor "Nobody ever asks HOW the haste is, just WHERE the haste is."

    - define data <script[link_dmessage].parsed_key[embed].to_json>
    - ~webget <[url]> data:<[data]> method:post headers:<[headers]> save:response

link_dmessage:
  type: data
  embed:
  #@content: non-embedded message
  #@tts: true/false
    embed:
      title: "`[Denizen Script Simpler Hastebin]`"
      url: https<&co>//one.denizenscript.com/haste/
      description: <&lt>:pepepewpew:737807327595462709<&gt> <[flavor]>
      color: <[color]>
    message_reference:
      message_id: <[message_id]>
      guild_id: <[group].id>


#|  ------------------------------------------------------------------ |
#+  https://discord.com/developers/docs/resources/channel#create-message
#+  https://discord.com/developers/docs/resources/channel#embed-object
#+  https://raw.githubusercontent.com/DV8FromTheWorld/JDA/assets/assets/docs/embeds/01-Overview.png
example:
  type: data

  embed:
    title: Title
    url: https://google.com // this is the link to the title above
    description: The title leads to the URL, if given
    color: 000000 // this is the hexadecimal color code for the embed, typically use `<[color]>`
    author:
      name: Bear
      url: http://auth.behr.com
      icon_url: link_to_my_avatar
    footer:
      name: Bear
      url: http://auth.behr.com
      icon_url: link_to_my_avatar

  message_reference:
    message_id: <[message_id]>
    guild_id: <[group].id>
  allowed_mentions:
    parse: <list>
