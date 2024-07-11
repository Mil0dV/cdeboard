defmodule Cdeboard.Repo.Migrations.CreateLeaderboard do
  use Ecto.Migration

  def change do
    create table(:leaderboard) do

      timestamps(type: :utc_datetime)
    end
  end
end
