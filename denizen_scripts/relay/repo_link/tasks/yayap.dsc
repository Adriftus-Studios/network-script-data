Yayap_DCommand:
  type: task
  definitions: Channel
  debug: false
  script:
    - define Rando <util.random.int[2].to[12]>
    - define string <element[].pad_left[<[Rando]>].with[<&chr[6969]>].replace[<&chr[6969]>].with[<&lt>a:discodog:749108129400094781<&gt>]>
    - discord id:champagne message channel:<discordchannel[adriftusbot,<[Channel]>]> "<[String]> YAY! <[String]>"
