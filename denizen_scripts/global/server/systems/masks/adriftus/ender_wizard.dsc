mask_ender_wizard:
  type: data
  display_data:
    category: Adriftus
    material: end_crystal
    display_name: <&6>Adriftus<&co> <&d>Ender Wizard
    description: "<&d>Free the End!"
  mask_data:
    id: ender_wizard
    display_name: <&d>Ender Wizard
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTYzNjQ3MDc5MzY4NywKICAicHJvZmlsZUlkIiA6ICIwNTVhOTk2NTk2M2E0YjRmOGMwMjRmMTJmNDFkMmNmMiIsCiAgInByb2ZpbGVOYW1lIiA6ICJUaGVWb3hlbGxlIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2Q0ZjdmYTA3YTdlOWY1NzU2ZWMxNGQ0YjUyYmIzNzk5ZjE2N2JkMTgxNjE2YmM5ODQ5ZmI5NGVkZjk1MTFmZjYiLAogICAgICAibWV0YWRhdGEiIDogewogICAgICAgICJtb2RlbCIgOiAic2xpbSIKICAgICAgfQogICAgfQogIH0KfQ==;BnPptUMoz6YAK1UVzGOipaY4a7U28aBhazRO5U7pToBuwMuH2b669AFM0T+/0d0LnmbzzHICFXv0npg+1NEoaCFfWf71koXXfJD/8lnO+ePlIWah7RrWWhha5gYY1UsUggGz7LJeUpieIqFIvRj+ZCF4Tu0nCSrN7O3FftVWWTyhL7CbxXhzlZ21MRwh2SfTDK+F4KdlUA5xfO5X+QL1RO6dSLZ91YHbf1xpkbJO5kxEmLDk77H5aoAUpM7us+FiKsxHDOLzRn6Cqmo4DvueONjWlK4jKuQciu0xDaeopZAgUJqojkdLzb2RGZfMTRmsUSP6g7TF9y1clJnjm165NnwlHG025ZOr0CLdOi/4HJHEHe+ug3h6P0RfKnszUae8flocQlt1vimgt71GgxGvQfdNs2DAKCA/5LeZXT9BZqbHf7AuTZ/KK0t6aSp1xgqETDCaOdgEnyclDQcg0LpV2elSPjyqOgT7A89F8LTAFAxxFrAKj2+BtM83C6BeGiFaAJowyqchDUQbfRhc04g9M8iTtSmacIj6bzLBeBRXjeR4Mqzdx1hfhUXXMzO2J9MMyx0/qOrtgbjDhV6iHyBihrNO3yjkcLJp3rfJa/1tVsvXbhSoGdCAFEuiDH3FGyQi0vzqazdedkLT7d8YnnkDQ0UvX6qfraRwsk1MzvZKYsM=
    particle:
      rate: 5
      effect: dragon_breath
      quantity: 2
      offset: 0.5
    on_equip_task: mask_ender_wizard_equip
    on_unequip_task: mask_ender_wizard_unequip

mask_ender_wizard_equip:
  type: task
  debug: false
  script:
    - flag player right_click_script:->:mask_ender_wizard_trades

mask_ender_wizard_unequip:
  type: task
  debug: false
  script:
    - flag player right_click_script:<-mask_ender_wizard_trades

mask_ender_wizard_trades:
  type: task
  debug: false
  data:
    trades:
      - trade[result=ender_pearl;inputs=diamond;max_uses=9999]
      - trade[result=shulker_shell;inputs=diamond[quantity=12];max_uses=9999]
  script:
    - opentrades <script.data_key[data.trades]> "title:<&d>Ender Wizard Trades"