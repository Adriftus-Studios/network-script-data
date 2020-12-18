load_worlds:
  type: world
  worlds_to_load: mainland|spawn
  events:
    on server prestart:
      - foreach <script[load_worlds].data_key[worlds_to_load]>:
        - createworld <[value]>
