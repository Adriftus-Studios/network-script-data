throw_item:
  type: task
  debug: false
  script:
    - shoot snowball[item=brick] speed:3
    - take item_in_hand quantity:1
  