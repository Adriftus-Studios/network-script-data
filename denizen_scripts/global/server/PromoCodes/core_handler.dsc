code_redemption_command:
  type: command
  name: code
  usage: /code (code goes here)
  description: Redeem a promo code!
  tab complete:
    1: <list>
  script:
    - if <context.args.size> != 1 || <script[promo_code_<context.args.get[1]>].container_type||null> != DATA:
      - narrate "<&c>Invalid Promo Code."
      - stop
    - if <script[promo_code_<context.args.get[1]>].data_key[expires]> && <script[promo_code_<context.args.get[1]>].parsed_key[expiration_date].is_after[<util.time_now>]>:
      - narrate "<&c>This code has expired."
      - stop
    - if <yaml[global.player.<player.uuid>].contains[codes.<context.args.get[1]>]>:
      - narrate "<&c>You have already redeemed this code on <yaml[global.player.<player.uuid>].read[codes.<context.args.get[1]>].format[MM/dd/yyyy]>"
      - stop
    - narrate <&e>----------------------------
    - narrate "<&a>Code Redeemed<&co> <&b><context.args.get[1].to_titlecase><&a>!"
    - narrate <&e>----------------------------<&nl>
    - run <script[promo_code_<context.args.get[1]>].data_key[run_task]>
    - run global_player_data_modify def:<player.uuid>|codes.<context.args.get[1]>|<util.time_now>