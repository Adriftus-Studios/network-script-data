Creeper_Prime_Signal:
  type: world
  debug: false
  events:
    on entity explosion primes:
      - If <context.entity.is_mythicmob>:
        - mythicsignal <context.entity> PrimetimeShowtime source:<context.entity>
