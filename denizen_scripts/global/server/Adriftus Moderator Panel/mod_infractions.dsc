# The `category` key is used for organization
mod_kick_infractions:
  type: data
  test:
    1:
      Test 1:
        category: Chat
        cmd: 100
        slot: 12
    2:
      Test 2:
        category: Harassment
        cmd: 100
        slot: 21
    3:
      Test 3:
        category: Advantage
        cmd: 100
        slot: 30
  herocraft:
    1:
      Harassment and Disrespect:
        category: Behavioral
        cmd: 100
        slot: 12
    2:
      Names:
        category: Player Rules
        cmd: 100
        slots: 21
      Skins:
        category: Player Rules
        cmd: 100
        slots: 22
    3:
      Player Hunting:
        category: Game Rules
        cmd: 100
        slots: 30
  default:
    1:
      Spam:
        category: Chat
        cmd: 100
        slot: 12
        report_slot: 13
      Chat Maturity:
        category: Chat
        cmd: 100
        slot: 13
        report_slot: 14
      Flying:
        category: Advantage
        cmd: 100
        slot: 14
        report_slot: 33
    2:
      Inappropriate Chat Usage:
        category: Chat
        cmd: 100
        slot: 21
        report_slot: 15
      Advertising:
        category: Chat
        cmd: 100
        slot: 22
        report_slot: 21
      Griefing:
        category: Harassment
        cmd: 100
        slot: 23
        report_slot: 31
    3:
      Racism:
        category: Chat
        cmd: 100
        slot: 30
        report_slot: 22
      Sexism:
        category: Chat
        cmd: 100
        slot: 31
        report_slot: 23
      Disrespectful Behaviour:
        category: Harassment
        cmd: 100
        slot: 32
        report_slot: 32
      Unfair Visual Advantage:
        category: Advantage
        cmd: 100
        slot: 33
        report_slot: 40
      Unfair Movement Advantage:
        category: Advantage
        cmd: 100
        slot: 34
        report_slot: 42
      Unfair Combat Advantage:
        category: Advantage
        cmd: 100
        slot: 35
        report_slot: 30

mod_ban_infractions:
  type: data
  test:
    1:
      Test 1:
        category: Chat
        length: 7d
        cmd: 100
        slot: 12
    2:
      Test 2:
        category: Harassment
        length: 14d
        cmd: 100
        slot: 21
    3:
      Test 3:
        category: Advantage
        length: 30d
        cmd: 100
        slot: 30
  herocraft:
    1:
      Harassment and Disrespect:
        category: Behavioral
        length: 1d
        cmd: 100
        slot: 11
      Names:
        category: Player Rules
        length: 1d
        cmd: 100
        slot: 12
      Skins:
        category: Player Rules
        length: 1d
        cmd: 100
        slot: 13
      Griefing:
        category: Game Rules
        length: 1d
        cmd: 100
        slot: 14
      Obscenity:
        category: Game Rules
        length: 3d
        cmd: 100
        slot: 15
      Player Hunting:
        category: Game Rules
        length: 1d
        cmd: 100
        slot: 16
      X-Ray:
        category: Game Function
        length: 1d
        cmd: 100
        slot: 17
      Hacking and Glitching:
        category: Game Function
        length: 7d
        cmd: 100
        slot: 18
    2:
      Stream Sniping:
        category: Behavioral
        length: 7d
        cmd: 100
        slot: 20
      Griefing:
        category: Game Rules
        length: 3d
        cmd: 100
        slot: 21
      Obscenity:
        category: Game Rules
        length: 5d
        cmd: 100
        slot: 22
      X-Ray:
        category: Game Function
        length: 3d
        cmd: 100
        slot: 23
      Hacking and Glitching:
        category: Game Function
        length: 15d
        cmd: 100
        slot: 24
    3:
      Griefing:
        category: Game Rules
        length: 7d
        cmd: 100
        slot: 29
      Obscenity:
        category: Game Rules
        length: 10d
        cmd: 100
        slot: 30
      X-Ray:
        category: Game Function
        length: 7d
        cmd: 100
        slot: 31
      Hacking and Glitching:
        category: Game Function
        length: 30d
        cmd: 100
        slot: 32
    4:
      Endangerment:
        category: Behavioral
        length: 10y
        cmd: 100
        slot: 38
      Griefing:
        category: Game Rules
        length: 10y
        cmd: 100
        slot: 39
      Obscenity:
        category: Game Rules
        length: 10y
        cmd: 100
        slot: 40
      X-Ray:
        category: Game Function
        length: 10y
        cmd: 100
        slot: 41
      Hacking and Glitching:
        category: Game Function
        length: 10y
        cmd: 100
        slot: 42
  default:
    1:
      Minor Inappropriate Chat Usage:
        category: Chat
        length: 7d
        cmd: 100
        slot: 12
      Advertising:
        category: Chat
        length: 7d
        cmd: 100
        slot: 13
      X-Ray:
        category: Advantage
        length: 14d
        slot: 14
    2:
      Minor Movement Advantage:
        category: Advantage
        length: 14d
        cmd: 100
        slot: 21
      Minor Combat Advantage:
        category: Advantage
        length: 14d
        cmd: 100
        slot: 22
      Excessive Negativity:
        category: Chat
        length: 14d
        cmd: 100
        slot: 23
      ESP:
        category: Advantage
        length: 14d
        cmd: 100
        slot: 24
      Bug Abuse:
        category: Exploit
        length: 14d
        cmd: 100
        slot: 25
    3:
      Major Movement Advantage:
        category: Advantage
        length: 30d
        cmd: 100
        slot: 30
      Major Combat Advantage:
        category: Advantage
        length: 30d
        cmd: 100
        slot: 31
      Major Inappropriate Chat Usage:
        category: Chat
        length: 30d
        cmd: 100
        slot: 32

mod_color_codes:
  type: data
  kick:
    1: F995F4
    2: EC10E0
    3: 8A00C4
  ban:
    1: EFF200
    2: FFA800
    3: FF0000
    4: FF0000

mod_action_past_tense:
  type: data
  Mute: muted
  Unmute: unmuted
  Ban: banned
  Unban: unbanned
  Kick: kicked
  Send: sent

# -- Returns names of infractions in the form of "<[level]>-<[infraction]>"
mod_get_infractions:
  type: procedure
  debug: false
  definitions: script
  script:
    - define result <list>
    - foreach <script[<[script]>].list_keys[].exclude[type]> as:level:
      - foreach <script[<[script]>].list_keys[<[level]>]> as:infraction:
        - define result:->:<[level]>.<[infraction]>
    - determine <[result]>
