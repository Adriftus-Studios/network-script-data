mythic_item_dropper:
  Type: world
  Debug: false
  Events:
    On mythicmob mob killed by:player:
      - define name <context.entity.mythicmob.internal_name>
      - if <util.random.int[1].to[100]> <= <script[mythic_drop_rates].data_key[mob.<[name]>]>
      - choose <[name]>:
#        - case Orc:
#          - define drop OrcTool_pickaxe
        - case OrcAdept:
          - define drop OrcWeapon_Sparkler
        - case OrcShaman:
          - define drop OrcWeapon_Zapper
        - case OrcBerserker:
          - define drop OrcWeapon_Chopper
        - case OrcChampion:
          - define drop OrcWeapon_Crusher
#        - case OrcArcher:
#          - define drop OrcWeapon
#        - case OrcWargmaster:
#          - define drop OrcWeapon
#        - case OrcDrummer:
#          - define drop OrcWeapon
        - case OrcBeastmaster:
          - define drop OrcWeapon_Poker
        - case default:
          - stop
      - drop <[drop]> <context.entity.location>

mythic_drop_rates:
  type: data
  data:
    mob:
      Orc: 98
      OrcAdept: 99
      OrcShaman: 99
      OrcBerserker: 99
      OrcChampion: 99
      OrcBeastmaster: 99
