defmodule FuelCalcServerTest do
  use ExUnit.Case

  setup do
    {:ok, _pid} = FuelCalcServer.start_link([])
  end

  test "GenServer calculates fuel for a given mission" do
    steps = [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]
    assert FuelCalcServer.calculate_fuel(28801, steps) == 51898
  end
end
