Reaction_Handler:
  type: world
  debug: false
  events:
  # @ ██ [ Add Reactions                      ] ██
    on discord reaction added:
  # - ██ [ Queue Stopping Cache Data          ] ██
      - inject locally VerifyEmoji
    # % ██ [ Cache Data                       ] ██
      - inject locally ReactionCache

    # % ██ [ Run Channel Organization Scripts ] ██
      - ~Run Group_Role_Assigner def:<list[<[User]>].include[<[EmojiID]>|<[MessageID]>|601677205445279744|Add]>

    # @ ██ [ Remove Reactions                 ] ██
    on discord reaction removed:
  # - ██ [ Queue Stopping Cache Data          ] ██
      - inject locally VerifyEmoji
  # % ██ [ Cache Data                         ] ██
      - inject locally ReactionCache

  # % ██ [ Run Channel Organization Scripts     ] ██
      - ~Run Group_Role_Assigner def:<list[<[User]>].include[<[EmojiID]>|<[MessageID]>|601677205445279744|Remove]>

  VerifyEmoji:
    - if !<context.custom>:
      - stop
    
  ReactionCache:
    - define User <context.author>
    - define EmojiID <context.emoji_id>
    - define MessageID <context.message_id>
    - define Group <context.group>
