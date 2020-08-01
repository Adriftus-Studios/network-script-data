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
    Cyber-Bullying: 7d

mod_kick_infractions:
  type: data
  1:
    Spam:
      category: Chat
    Chat Maturity:
      category: Chat
    Flying:
      category: Movement Advantage
  2:
    Inappropriate Chat Usage:
      category: Chat
    Advertising:
      category: Chat
    Griefing:
      category: Harassment
  3:
    Racism:
      category: Chat
    Sexism:
      category: Chat
    Disrespectful Behaviour:
      category: Harassment
    Cyber-Bullying:
      category: Harassment
    Unfair Movement Advantage:
      category: Movement Advantage
    Unfair Combat Advantage:
      category: Combat Advantage

mod_ban_infractions:
  type: data
  1:
    Minor Inappropriate Chat Usage:
      category: Chat
      length: 7d
    Advertising:
      category: Chat
      length: 7d
    X-Ray:
      category: Visual Advantage
      length: 14d
  2:
    Minor Movement Advantage:
      category: Movement Advantage
      length: 14d
    Minor Combat Advantage:
      category: Combat Advantage
      length: 14d
    Excessive Negativity:
      category: Chat
      length: 14d
    ESP:
      category: Visual Advantage
      length: 14d
    Bug Abuse:
      category: Exploit
      length: 14d
  3:
    Major Movement Advantage:
      category: Movement Advantage
      length: 30d
    Major Combat Advantage:
      category: Combat Advantage
      length: 30d
    Major Inappropriate Chat Usage:
      category: Chat
      length: 30d

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
    - define result <list[]>
    - foreach <script[<[script]>].list_keys[].exclude[type]> as:level:
      - foreach <script[<[script]>].list_keys[<[level]>]> as:infraction:
        - define result:|:<[level]>.<[infraction]>
    - determine <[result]>
