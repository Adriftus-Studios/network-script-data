load_worlds:
  type: world
  worlds_to_load: mainland|spawn
  events:
    on server prestart:
      - foreach <script[load_worlds].yaml_key[worlds_to_load]>:
        - createworld <[value]>