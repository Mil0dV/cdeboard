defmodule Cdeboard.Dashboard do
  @moduledoc """
  The Dashboard context.
  """

  import Ecto.Query, warn: false
  alias Cdeboard.Repo

  alias Cdeboard.Dashboard.ClimateImpact

  @doc """
  Returns the list of leaderboard.

  ## Examples

      iex> list_leaderboard()
      [%ClimateImpact{}, ...]

  """
  def list_leaderboard do
    Repo.all(ClimateImpact)
  end

  @doc """
  Gets a single climate_impact.

  Raises `Ecto.NoResultsError` if the Climate impact does not exist.

  ## Examples

      iex> get_climate_impact!(123)
      %ClimateImpact{}

      iex> get_climate_impact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_climate_impact!(id), do: Repo.get!(ClimateImpact, id)

  @doc """
  Creates a climate_impact.

  ## Examples

      iex> create_climate_impact(%{field: value})
      {:ok, %ClimateImpact{}}

      iex> create_climate_impact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_climate_impact(attrs \\ %{}) do
    %ClimateImpact{}
    |> ClimateImpact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a climate_impact.

  ## Examples

      iex> update_climate_impact(climate_impact, %{field: new_value})
      {:ok, %ClimateImpact{}}

      iex> update_climate_impact(climate_impact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_climate_impact(%ClimateImpact{} = climate_impact, attrs) do
    climate_impact
    |> ClimateImpact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a climate_impact.

  ## Examples

      iex> delete_climate_impact(climate_impact)
      {:ok, %ClimateImpact{}}

      iex> delete_climate_impact(climate_impact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_climate_impact(%ClimateImpact{} = climate_impact) do
    Repo.delete(climate_impact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking climate_impact changes.

  ## Examples

      iex> change_climate_impact(climate_impact)
      %Ecto.Changeset{data: %ClimateImpact{}}

  """
  def change_climate_impact(%ClimateImpact{} = climate_impact, attrs \\ %{}) do
    ClimateImpact.changeset(climate_impact, attrs)
  end
end
