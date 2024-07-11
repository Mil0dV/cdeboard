defmodule Cdeboard.Repo.Migrations.CreateClimateEntries do
  use Ecto.Migration

  def change do
    create table(:climate_entries) do
      add :name, :string
      add :impact, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
