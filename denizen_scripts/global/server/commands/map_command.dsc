map_command:
  type: command
  debug: false
  name: map
  description: View the World Map
  usage: /map
  script:
    - narrate "<element[<&color[#000001]>------------------------<&nl><&color[#000001]>Click me to open the World Map<&nl><&color[#000001]>------------------------].on_click[http://maps.adriftus.net].type[OPEN_URL]>"