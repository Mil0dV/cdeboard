defmodule Cdeboard.DashboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cdeboard.Dashboard` context.
  """

  @doc """
  Generate a climate_impact.
  """
  def climate_impact_fixture(attrs \\ %{}) do
    {:ok, climate_impact} =
      attrs
      |> Enum.into(%{

      })
      |> Cdeboard.Dashboard.create_climate_impact()

    climate_impact
  end
end
