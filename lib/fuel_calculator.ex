defmodule FuelCalculator do
  @moduledoc """
  Calculates the fuel required for a space mission based on a series of launch and landing steps.
  """

  @gravities %{"earth" => 9.807, "moon" => 1.62, "mars" => 3.711}

  @doc """
  Calculates the fuel required for a single launch or landing action and floors the result immediately.

  ## Examples
      iex> FuelCalculator.calculate_fuel(28801, 9.807, :launch)
      11829

      iex> FuelCalculator.calculate_fuel(28801, 1.62, :land)
      1497
  """
  @spec calculate_fuel(mass :: number, gravity :: number, action :: :launch | :land) :: number
  def calculate_fuel(mass, gravity, action) do
    fuel =
      case action do
        :launch -> mass * gravity * 0.042 - 33
        :land -> mass * gravity * 0.033 - 42
      end

    floor(max(fuel, 0))
  end

  @doc """
  Entry point for fuel requirement calculation.

  ## Examples
      iex> FuelCalculator.calculate_fuel_requirement(28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}])
      {:ok, 51898}

      iex> FuelCalculator.calculate_fuel_requirement(14606, [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}])
      {:ok, 33388}
  """
  @spec calculate_fuel_requirement(
          mass :: number,
          steps :: list({:launch | :land, String.t()})
        ) :: {:ok, number} | {:error, String.t()}
  def calculate_fuel_requirement(mass, steps) do
    case validate_steps(steps, @gravities) do
      {:ok} ->
        steps = Enum.reverse(steps)

        {total_fuel, _} =
          Enum.reduce(steps, {0, mass}, fn {action, planet}, {acc_fuel, current_mass} ->
            gravity = Map.fetch!(@gravities, planet)
            additional_fuel = total_fuel(current_mass, gravity, action)
            {acc_fuel + additional_fuel, current_mass + additional_fuel}
          end)

        {:ok, total_fuel}

      {:error, message} ->
        {:error, message}
    end
  end

  @spec total_fuel(mass :: number, gravity :: number, action :: :launch | :land) :: number
  defp total_fuel(mass, gravity, action) do
    additional_fuel(mass, gravity, action, 0)
  end

  @spec additional_fuel(
          mass :: number,
          gravity :: number,
          action :: :launch | :land,
          added_fuel :: number
        ) :: number
  defp additional_fuel(mass, gravity, action, added_fuel) do
    new_fuel = calculate_fuel(mass, gravity, action)

    if new_fuel > 0 do
      additional_fuel(new_fuel, gravity, action, added_fuel + new_fuel)
    else
      added_fuel
    end
  end

  @spec validate_steps(
          steps :: list({:launch | :land, String.t()}),
          gravities :: map()
        ) :: {:ok} | {:error, String.t()}
  defp validate_steps(steps, gravities) do
    try do
      Enum.each(steps, fn {_action, planet} ->
        if !Map.has_key?(gravities, planet), do: raise("Invalid route format: #{planet}")
      end)

      {:ok}
    rescue
      RuntimeError ->
        {:error, "Invalid route format"}
    end
  end
end
