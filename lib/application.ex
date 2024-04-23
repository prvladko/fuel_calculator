defmodule FuelCalculator.Application do
  @moduledoc false

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      {FuelCalculatorServer, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
