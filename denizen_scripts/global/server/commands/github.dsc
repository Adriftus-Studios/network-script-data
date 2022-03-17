github_command:
  type: command
  name: github
  debug: false
  description: Gives you the github link.
  usage: /github
  script:
    - define URL https://github.com/Adriftus-Studios/network-script-data/issues
    - define Hover "<proc[Colorize].context[Click to file a feature request, or bug report:|green]><&nl><proc[Colorize].context[<[URL]>|blue]>"
    - define Text "<proc[Colorize].context[Click for the:|yellow]> <&b><&n>Github <&b><&n>Link"
    - narrate <proc[msg_url].context[<def[Hover]>|<def[Text]>|<def[URL]>]>
