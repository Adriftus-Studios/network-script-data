# -- /bugreport - Adriftus Bug Report
mod_bug_report_command:
  type: command
  debug: false
  name: bugreport
  description: Adriftus Bug Report
  usage: /bugreport
  aliases:
    - reportbug
  script:
    - narrate "<&6>Adriftus <&e>Bug Report"
    - narrate "<&f>Network<&co> <proc[msg_url].context[<script[mod_bug_report_url].parsed_key[1hover]>|<script[mod_bug_report_url].parsed_key[1text]>|<script[mod_bug_report_url].parsed_key[1url]>]>"
    - narrate "<&f>HeroCraft<&co> <proc[msg_url].context[<script[mod_bug_report_url].parsed_key[2hover]>|<script[mod_bug_report_url].parsed_key[2text]>|<script[mod_bug_report_url].parsed_key[2url]>]>"

# -- /bugreport - URL Data
mod_bug_report_url:
  type: data
  1url: https://github.com/Adriftus-Studios/network-script-data/issues
  1hover: <&e>View the issues page on our GitHub.
  1text: <&b>Adriftus-Studios/network-script-data/issues
  2url: https://discord.com/channels/771099589713199145/903456196596494398
  2hover: <&e>View the issues channel on Syntrocity's Discord Server.
  2text: <&b>#issues
