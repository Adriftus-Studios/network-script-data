Creeper_Prime_Signal:
  # $ [ converted until MythicMobs is added ]
  type: data
  debug: false
  events:
    on entity explosion primes:
      - If <context.entity.is_mythicmob>:
        - mythicsignal <context.entity.mythicmob> PrimetimeShowtime source:<context.entity>
