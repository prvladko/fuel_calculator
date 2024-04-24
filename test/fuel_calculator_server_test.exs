defmodule FuelCalculatorServerTest do
  use ExUnit.Case, async: true

  alias FuelCalculatorServer

  setup do
    {:ok, pid} = FuelCalculatorServer.start_link([])
    {:ok, pid: pid}
  end

  describe "calculate_fuel/2" do
    test "calculates fuel correctly for valid routes", %{pid: pid} do
      route1 = [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]
      assert FuelCalculatorServer.calculate_fuel(28801, route1) == {:ok, 51898}

      route2 = [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]
      assert FuelCalculatorServer.calculate_fuel(14606, route2) == {:ok, 33388}

      route3 = [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "moon"},
        {:land, "mars"},
        {:launch, "mars"},
        {:land, "earth"}
      ]

      assert FuelCalculatorServer.calculate_fuel(75432, route3) == {:ok, 212_161}
    end

    test "returns error for invalid routes", %{pid: pid} do
      invalid_route = [
        {:launch, "earth"},
        {:land, "jupiter"},
        {:launch, "mars"},
        {:land, "earth"}
      ]

      assert FuelCalculatorServer.calculate_fuel(14606, invalid_route) ==
               {:error, "Invalid route format"}
    end
  end
end
