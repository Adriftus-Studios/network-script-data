ambient_noise:
  type: task
  debug: false
  definitions: targets|sound|rate
  script:
    - repeat <[rate]>:
      - ~playsound <[sound]> <[targets]>

ambient_noise_fluctuate:
  type: task
  debug: false
  definitions: targets|sound|rate
  script:
    - repeat <[rate]>:
      - ~playsound <[sound]> <[targets]> pitch:<util.random.decimal[0.9].to[1.1]>
