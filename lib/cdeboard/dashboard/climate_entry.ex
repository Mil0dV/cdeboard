defmodule Cdeboard.Dashboard.ClimateEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "climate_entries" do
    field :name, :string
    field :impact, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(climate_entry, attrs) do
    climate_entry
    |> cast(attrs, [:name, :impact])
    |> validate_required([:name, :impact])
  end
end
