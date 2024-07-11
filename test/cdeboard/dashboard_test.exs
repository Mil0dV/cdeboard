defmodule Cdeboard.DashboardTest do
  use Cdeboard.DataCase

  alias Cdeboard.Dashboard

  describe "leaderboard" do
    alias Cdeboard.Dashboard.ClimateImpact

    import Cdeboard.DashboardFixtures

    @invalid_attrs %{}

    test "list_leaderboard/0 returns all leaderboard" do
      climate_impact = climate_impact_fixture()
      assert Dashboard.list_leaderboard() == [climate_impact]
    end

    test "get_climate_impact!/1 returns the climate_impact with given id" do
      climate_impact = climate_impact_fixture()
      assert Dashboard.get_climate_impact!(climate_impact.id) == climate_impact
    end

    test "create_climate_impact/1 with valid data creates a climate_impact" do
      valid_attrs = %{}

      assert {:ok, %ClimateImpact{} = climate_impact} = Dashboard.create_climate_impact(valid_attrs)
    end

    test "create_climate_impact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.create_climate_impact(@invalid_attrs)
    end

    test "update_climate_impact/2 with valid data updates the climate_impact" do
      climate_impact = climate_impact_fixture()
      update_attrs = %{}

      assert {:ok, %ClimateImpact{} = climate_impact} = Dashboard.update_climate_impact(climate_impact, update_attrs)
    end

    test "update_climate_impact/2 with invalid data returns error changeset" do
      climate_impact = climate_impact_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboard.update_climate_impact(climate_impact, @invalid_attrs)
      assert climate_impact == Dashboard.get_climate_impact!(climate_impact.id)
    end

    test "delete_climate_impact/1 deletes the climate_impact" do
      climate_impact = climate_impact_fixture()
      assert {:ok, %ClimateImpact{}} = Dashboard.delete_climate_impact(climate_impact)
      assert_raise Ecto.NoResultsError, fn -> Dashboard.get_climate_impact!(climate_impact.id) end
    end

    test "change_climate_impact/1 returns a climate_impact changeset" do
      climate_impact = climate_impact_fixture()
      assert %Ecto.Changeset{} = Dashboard.change_climate_impact(climate_impact)
    end
  end
end
