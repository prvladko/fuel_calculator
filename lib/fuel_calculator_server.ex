defmodule FuelCalculatorServer do
  use GenServer

  def start_link(default), do: GenServer.start_link(__MODULE__, default, name: __MODULE__)

  def calculate_fuel(mass, steps), do: GenServer.call(__MODULE__, {:calculate, mass, steps})

  def handle_call({:calculate, mass, steps}, _from, state) do
    result = FuelCalculator.calculate_fuel_requirement(mass, steps)
    {:reply, result, state}
  end
end
