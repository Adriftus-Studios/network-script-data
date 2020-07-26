tutorial_data:
  type: data
  start:
    hologram:
      - "&6Welcome To Adriftus Survival"
      - "Click one of the options below to begin"
    start_button: "&6Start Tutorial"
    skip_button: "&eSkip Tutorial"
  1:
    hologram:
      - "&6Welcome To Adriftus Survival"
      - "Click one of the options below to begin"

tutorial_start:
  type: task
  script:
    - showfake barrier <cuboid[<location[tutorial_start_hologram].backward.left[2]>|<location[tutorial_start_hologram].backward.right[2].above[3]>].blocks> duration:10h
    - foreach <script[tutorial_data].data_key[start.hologram]>:
      - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<[value].parse_color>] <location[tutorial_start_hologram].-[<[loop_index].*0.25]>]> duration:10h
    - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<script[tutorial_data].data_key[start.start_button]>] <location[tutorial_start_hologram].-[<script[tutorial_data].data_key[start.hologram].size.+[2].*0.25]>]>
    - fakespawn armor_stand[custom_name_visible=true;visible=false;custom_name=<script[tutorial_data].data_key[start.stop_button]>] <location[tutorial_start_hologram].-[<script[tutorial_data].data_key[start.hologram].size.+[2].*0.25]>]>

tutorial_events:
  type: world
  events:
    on player click fake entity:
      - narrate <context.entity.entity_type>
      - narrate <context.entity.name>