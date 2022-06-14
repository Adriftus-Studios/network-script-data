# The `category` key is used for organization
mod_mute_infractions:
  type: data
  1:
    Spam: 30m
    Excessive Characters: 30m
    Excessive Capitals: 30m
    Chat Maturity: 1h
  2:
    Advertising Servers: 1d
    Excessive Negativity: 12h
  3:
    Racism: 7d
    Sexism: 7d
    Disrespect to Players and/or Staff Members: 7d
    Harassment: 7d

mod_kick_infractions:
  type: data
  1:
    Spam:
      category: Chat
      slot: 12
      report_slot: 13
    Chat Maturity:
      category: Chat
      slot: 13
      report_slot: 14
    Flying:
      category: Movement Advantage
      slot: 14
      report_slot: 15
  2:
    Inappropriate Chat Usage:
      category: Chat
      slot: 21
      report_slot: 21
    Advertising:
      category: Chat
      slot: 22
      report_slot: 22
    Griefing:
      category: Harassment
      slot: 23
      report_slot: 23
  3:
    Racism:
      category: Chat
      slot: 30
      report_slot: 30
    Sexism:
      category: Chat
      slot: 31
      report_slot: 31
    Disrespectful Behaviour:
      category: Harassment
      slot: 32
      report_slot: 32
    Unfair Visual Advantage:
      category: Visual Advantage
      slot: 33
      report_slot: 33
    Unfair Movement Advantage:
      category: Movement Advantage
      slot: 34
      report_slot: 40
    Unfair Combat Advantage:
      category: Combat Advantage
      slot: 35
      report_slot: 42

mod_ban_infractions:
  type: data
  1:
    Minor Inappropriate Chat Usage:
      category: Chat
      length: 7d
      slot: 13
    Advertising:
      category: Chat
      length: 7d
      slot: 14
    X-Ray:
      category: Visual Advantage
      length: 14d
      slot: 15
  2:
    Minor Movement Advantage:
      category: Movement Advantage
      length: 14d
      slot: 21
    Minor Combat Advantage:
      category: Combat Advantage
      length: 14d
      slot: 22
    Excessive Negativity:
      category: Chat
      length: 14d
      slot: 23
    ESP:
      category: Visual Advantage
      length: 14d
      slot: 24
    Bug Abuse:
      category: Exploit
      length: 14d
      slot: 25
  3:
    Major Movement Advantage:
      category: Movement Advantage
      length: 30d
      slot: 30
    Major Combat Advantage:
      category: Combat Advantage
      length: 30d
      slot: 31
    Major Inappropriate Chat Usage:
      category: Chat
      length: 30d
      slot: 32

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
