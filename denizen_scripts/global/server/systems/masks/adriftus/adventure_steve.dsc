mask_adriftus_adventure_steve:
  type: data
  display_data:
    category: Adriftus
    material: stick
    display_name: <&6>Adriftus<&co> Adventure Steve
    description: "<&d>Devin's fake player, I guess?"
  mask_data:
    permission: adriftus.admin
    id: adriftus_adventure_steve
    on_equip_task: mask_adriftus_adventure_steve_equip
    on_unequip_task: mask_adriftus_adventure_steve_unequip
    display_name: <&f>AdventureSteve
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTYxMzU5OTM4MjAzOCwKICAicHJvZmlsZUlkIiA6ICI4NDMwMDNlM2JlNTY0M2Q5OTQxMTBkMzJhMzU2MTk2MCIsCiAgInByb2ZpbGVOYW1lIiA6ICJHYWJvTWNHYW1lciIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS8zODk4NjM3OGQ1NGQ1MTM1MzE0ZmZhMzllODE3ODdkMWU5YTUyYzhmNzJkMDAyYzllZTMxMzMwZjNmNzFjNTUiCiAgICB9CiAgfQp9;mLfIIWr3hT25W+wzbol5kdWrwGGoHtJiyRIpd0sLdx4ngnMmPlN6qw5TtURk+hvXq0lo3k8PTb0MAx7UbtY2AUb5yuha+V1BLIL8rSiYV0AxXqsq4qF+SxOpCVea/La2J/WdpYS2/rXsfLonyr+dYt928mv7k7EtWeMwNp4SQkB7MEA8lFF/7MotZGeptWrPV5D4Yc6buxywCYqhxB4zKZ8gTSHf7WaSZqBR9I6Lk04b7bII0D4r1hlY8hVdpzsFSmT28c4ejJhaV5gtysiBS7enT310fspOseptTUByVaHIRCDX52npqQzyumgS/1GgWXcsAH+SJptck5YDvtwn9DjUW6OZVBGY9x/t+LuQkd3JwEnSudINBE0UBOkxPPWeu+Mkoe8WHueMRo2UxhLBTedJG3LdOm0edOjEdixP/4a+oiQV7Wlctd1mxV8OcWzwhlnkk4L5qyxhWaVMti/5NdtFoyjDd5L90+cZxtS/RYGWpyuplhtYfCyH7lOQnCsJ92USnaYDF34dURNdIvUjuV1q2zPkcL1sxYzXFTV7+dbYPPKgEfsdtohXBrjtfkjuOnpVMhZvQg4PMleaAAcTizX9cCx3RYFrcB0d4uE4UcdNlkwGsSDoe91Rkan4L9F8e8zxXzPFEa6XlF7DBSZtZkh8VaFsP1hXG8TzMVygIXE=

mask_adriftus_adventure_steve_equip:
  type: task
  debug: false
  script:
    - execute as_server "lp user <player.name> parent set default"

mask_adriftus_adventure_steve_unequip:
  type: task
  debug: false
  script:
    - execute as_server "lp user <player.name> parent set admin"