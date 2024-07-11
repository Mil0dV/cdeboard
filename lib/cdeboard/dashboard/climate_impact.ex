defmodule Cdeboard.Dashboard.ClimateImpact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leaderboard" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(climate_impact, attrs) do
    climate_impact
    |> cast(attrs, [])
    |> validate_required([])
  end
end
