mask_adriftus_blood_bandit:
  type: data
  display_data:
    category: Adriftus
    material: stick
    display_name: <&6>Adriftus<&co> <&c>Blood Bandit
    description: "<&c>Scot's Character"
  mask_data:
    permission: adriftus.admin
    id: adriftus_blood_bandit
    on_equip_task: mask_adriftus_blood_bandit_equip
    on_unequip_task: mask_adriftus_blood_bandit_unequip
    display_name: <&c>Blood Bandit
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTYyMDQwMTc2ODczNSwKICAicHJvZmlsZUlkIiA6ICJiNTM5NTkyMjMwY2I0MmE0OWY5YTRlYmYxNmRlOTYwYiIsCiAgInByb2ZpbGVOYW1lIiA6ICJtYXJpYW5hZmFnIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzY2OWJlNDJlMmJhY2NiNzZiZDRlNDAwZGIwZWJjYjdkZDAyMWMyODQ2Y2UwMzA4YmZmZjIxM2NmOTQ2YTU5NGYiCiAgICB9CiAgfQp9;XNSl0IEDkJO0QTfMK3fAeeM0TC4p1JhwIqvZ11QfprXatxi0LkPWSrSBRPi5PtK0Dr3wcFvc1PITA3gYt2rXf0AptpNDPyk8jYET1ozi2+4KitHxNebhj0+6i0iTQ4dzmLOiZHmSPGmhIGvC49H3YL4C3MHFZFOiHSQEaPVPQpeQpfGenj8qnoWKZ/mTViLiLgeaAkpN4Rm7+MBz/0PSV/lYn9SRB/xwDeNs5NO8yh9/7MBJawX0qhO+tAp1hyJr7Hv9YCT5+JPUuxT75zh2+rHqP/TYVa4ipOAAuZhw10c0jPqZJh1BLeTw8KAdGSu7PvqX+OX9Bo+yM13cbIistynv51wK2YNYhDRY7thiVYvIKpveLoeaWl36KjJM4XMd2A/6evVqyHl451GLf1YpfHtuGL1N9rkAKoeCzFbrtbkiEJHsYa6w8r/M8T/3OAzTBULu/K0Ox08/wYcZ4WWlSQfc3VNtvrfBlw+JiKUwWyBSUrBFDT81lPMj+cYTdw0xmT5V4VOZlSh8yb6bOFFta14tu576b0Qg9x4omDF5I0GO3nzCo/ZDKI9WqzF+VufKs1AEt7vHQaTltGhwElg9BviqUZqKRHu70zpPCRDoBzkbLsvinkNl/m3nE5pm5+3sR/0x+Bt2q3PlXlkQWQOo8ngGWecmBn56Q2ZU2qfP99w=

mask_adriftus_blood_bandit_equip:
  type: task
  debug: false
  script:
    - adjust <player> health_data:200/200

mask_adriftus_blood_bandit_unequip:
  type: task
  debug: false
  script:
    - adjust <player> health_data:20/20