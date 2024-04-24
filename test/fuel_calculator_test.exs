defmodule FuelCalculatorTest do
  use ExUnit.Case, async: true
  doctest FuelCalculator

  describe "calculate_fuel/2" do
    test "calculates fuel correctly for launch on Earth" do
      assert FuelCalculator.calculate_fuel(28801, 9.807, :launch) == 11829
    end

    test "calculates fuel correctly for landing on Moon" do
      assert FuelCalculator.calculate_fuel(28801, 1.62, :land) == 1497
    end
  end

  describe "calculate_fuel_requirement/2" do
    test "calculates total fuel for Apollo 11 mission" do
      route1 = [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]
      assert FuelCalculator.calculate_fuel_requirement(28801, route1) == {:ok, 51898}
    end

    test "calculates total fuel for Mars mission" do
      route2 = [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]
      assert FuelCalculator.calculate_fuel_requirement(14606, route2) == {:ok, 33388}
    end

    test "calculates total fuel for passenger ship mission" do
      route3 = [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "moon"},
        {:land, "mars"},
        {:launch, "mars"},
        {:land, "earth"}
      ]

      assert FuelCalculator.calculate_fuel_requirement(75432, route3) == {:ok, 212_161}
    end

    test "returns error for invalid routes including unknown planets" do
      invalid_route = [
        {:launch, "earth"},
        {:land, "jupiter"},
        {:launch, "mars"},
        {:land, "earth"}
      ]

      assert FuelCalculator.calculate_fuel_requirement(14606, invalid_route) ==
               {:error, "Invalid route format"}
    end

    test "returns error when route starts with unknown planet" do
      assert FuelCalculator.calculate_fuel_requirement(28801, [{:launch, "pluto"}]) ==
               {:error, "Invalid route format"}
    end

    test "returns error when route has multiple unknown planets" do
      invalid_route = [
        {:launch, "earth"},
        {:land, "jupiter"},
        {:launch, "saturn"},
        {:land, "earth"}
      ]

      assert FuelCalculator.calculate_fuel_requirement(14606, invalid_route) ==
               {:error, "Invalid route format"}
    end

    test "returns {:ok, 0} when no fuel is required" do
      route = [{:launch, "earth"}, {:land, "moon"}]
      assert FuelCalculator.calculate_fuel_requirement(0, route) == {:ok, 0}
    end
  end
end
