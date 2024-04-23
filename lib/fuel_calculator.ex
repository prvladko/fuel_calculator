defmodule FuelCalculator do
  @moduledoc """
  Documentation for `FuelCalculator`.
  """

  @gravities %{
    "earth" => 9.807,
    "moon" => 1.62,
    "mars" => 3.711
  }

  def calculate_fuel(mass, gravity, action) do
    case action do
      :launch ->
        trunc((mass * gravity * 0.042) - 33)

      :land ->
        trunc((mass * gravity * 0.033) - 42)
    end
  end

  defp total_fuel(initial_fuel, gravity, action) do
    # Call the recursive function and round after all calculations are done.
    math_floor(total_fuel_recursive(initial_fuel, gravity, action))
  end

  defp total_fuel_recursive(fuel, gravity, action) when fuel > 0 do
    additional_fuel = calculate_fuel(fuel, gravity, action)
    rounded_additional_fuel = math_floor(additional_fuel)
    fuel + total_fuel_recursive(rounded_additional_fuel, gravity, action)
  end
  defp total_fuel_recursive(_fuel, _gravity, _action), do: 0

  def calculate_fuel_requirement(mass, steps) do
    case validate_steps(steps, @gravities) do
      {:ok} ->
        {total_fuel, _} =
          Enum.reduce(steps, {0, mass}, fn {action, planet}, {acc_fuel, current_mass} ->
            gravity = Map.fetch!(@gravities, planet)
            initial_fuel = calculate_fuel(current_mass, gravity, action)
            additional_fuel = total_fuel(initial_fuel, gravity, action)
            {acc_fuel + additional_fuel, current_mass + additional_fuel}
          end)

        {:ok, total_fuel}

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate_steps(steps, gravities) do
    try do
      Enum.each(steps, fn {_action, planet} ->
        if !Map.has_key?(gravities, planet), do: raise "Invalid route format"
      end)
      {:ok}
    rescue
      RuntimeError -> {:error, "Invalid route format"}
    end
  end

  # Utilize floor directly from the :math module
  defp math_floor(value), do: :math.floor(value)
end
