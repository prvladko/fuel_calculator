defmodule FuelCalculatorTest do
  use ExUnit.Case, async: true

  describe "calculate_fuel/2" do
    test "calculate total mission fuel for Apollo 11" do
      route1 = [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]
      assert FuelCalculator.calculate_fuel_requirement(28801, route1) == {:ok, 51898}
    end

    test "Mars route" do
      route2 = [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]
      assert FuelCalculator.calculate_fuel_requirement(14606, route2) == {:ok, 33388}
    end

    test "Passenger ship" do
      route3 = [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]
      assert FuelCalculator.calculate_fuel_requirement(75432, route3) == {:ok, 212161}
    end

    test "returns error for invalid routes including unknown planets" do
      invalid_route = [{:launch, "earth"}, {:land, "jupiter"}, {:launch, "mars"}, {:land, "earth"}]
      assert FuelCalculator.calculate_fuel_requirement(14606, invalid_route) == {:error, "Invalid route format"}
    end

    test "handling unknown planet gracefully" do
      assert FuelCalculator.calculate_fuel_requirement(28801, [{:launch, "pluto"}]) == {:error, "Invalid route format"}
    end
  end
end
