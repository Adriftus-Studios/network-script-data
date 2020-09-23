Group_Role_Assigner:
  type: task
  definitions: Author|EmojiID|MessageID|Group|Action
  debug: false
  script:
  # - ██ [ Queue Stopping Cache Data     ] ██
    - if !<script.data_key[SpecialMessages].contains[<[MessageID]>]>:
      - stop
    - if !<script.list_keys[Emojis.Channels].include[<script.list_keys[Emojis.Notifications]>].include[<script.data_key[Emojis.Alerts]>].contains[<[EmojiID]>]>:
      - stop

  # - ██ [ Cache Data            ] ██
    - define UserRoles <[Author].roles[<[Group]>].parse[ID]>
    - choose <[MessageID]>:
      - case 733087289147654255:
        - define AvailableRoles <script.list_keys[Roles.Channels].include[<script.list_keys[Roles.Notifications]>]>
        - if <[EmojiID]> == 732707020884410558 && <[Action]> == Add:
          - foreach <[AvailableRoles]> as:Role:
            - if !<[UserRoles].contains[<[Role]>]>:
              - discord id:AdriftusBot add_role user:<[Author]> role:<[Role]> group:<[Group]>
        - else:
          - foreach <[AvailableRoles]> as:Role:
            - if <[UserRoles].contains[<[Role]>]>:
              - discord id:AdriftusBot remove_role user:<[Author]> role:<[Role]> group:<[Group]>
        - stop
      - case 733087302057984000:
        - define Role <script.data_key[Emojis.Channels.<[EmojiID]>]>
      - case 733087314028265532:
        - define Role <script.data_key[Emojis.Notifications.<[EmojiID]>]>
      - default:
        - stop
    - inject locally RoleAdjust

  RoleAdjust:
    - Choose <[Action]>:
      - case Add:
        - discord id:AdriftusBot add_role user:<[Author]> role:<[Role]> group:<[Group]>
      - case Remove:
        - discord id:AdriftusBot remove_role user:<[Author]> role:<[Role]> group:<[Group]>
      - case Spam:
        - stop

  SpecialMessages:
    - 733087289147654255
    - 733087302057984000
    - 733087314028265532
  Emojis:
    Alerts:
      - 732707020884410558
      - 732707021039861800
    Channels:
      639245303303634944: 732771947338793030
      681948102856278085: 732772412008955984
      732737467739930625: 732772238935326743
      732749470264983562: 732772042952278067
      732755178180313118: 732771970365521960
    Notifications:
      711988424537800765: 732772337681694782
      712157326328725534: 732772558289764463
      725918870166306886: 725883964887400489
      725910497680949368: 732772194605727786
      701266781972594708: 732772256492814429
      732748865844805684: 732772000849985607


  Roles:
    Channels:
      732771947338793030: Minecraft
      732772412008955984: Hytale
      732772238935326743: Destiny
      732772042952278067: Diablo
      732771970365521960: Wizard 101
    Notifications:
      732772337681694782: Network
      732772558289764463: Event
      725883964887400489: BehrCraft
      732772194605727786: Gielinor
      732772256492814429: Destiny
      732772000849985607: Diablo
    misc:
      602011398138101760: "Minecraft Explorer"
      732777026842263582: "⁣ ⁣ ⁣⁣ ⁣ ⁣ ⁣ ⁣ Notifications ⁣ ⁣ ⁣ ⁣ ⁣ ⁣⁣ ⁣ ⁣ ⁣"
      712037337764462683: Ignored
      602038729443377152: Jailed
