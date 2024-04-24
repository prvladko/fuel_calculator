# FuelCalculator

## Calculates the fuel required for a single launch or landing action and floors the result immediately.

```elixir
      iex> FuelCalculator.calculate_fuel(28801, 9.807, :launch)
      11829

      iex> FuelCalculator.calculate_fuel(28801, 1.62, :land)
      1497
```

## Entry point for fuel requirement calculation.

```elixir
      iex> FuelCalculator.calculate_fuel_requirement(28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}])
      {:ok, 51898}

      iex> FuelCalculator.calculate_fuel_requirement(14606, [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}])
      {:ok, 33388}
```
