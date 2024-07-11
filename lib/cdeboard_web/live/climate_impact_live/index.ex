defmodule CdeboardWeb.ClimateImpactLive.Index do
  use CdeboardWeb, :live_view

  alias Cdeboard.Dashboard
  alias Cdeboard.Dashboard.ClimateImpact

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(Dashboard.list_leaderboard())
    {:ok, stream(socket, :leaderboard, Dashboard.list_leaderboard())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Climate impact")
    |> assign(:climate_entries, Dashboard.get_climate_entries!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Climate impact")
    |> assign(:climate_entries, %ClimateImpact{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Leaderboard")
    |> assign(:climate_entries, nil)
  end

  @impl true
  def handle_info({CdeboardWeb.ClimateImpactLive.FormComponent, {:saved, climate_entries}}, socket) do
    {:noreply, stream_insert(socket, :leaderboard, climate_entries)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    climate_entries = Dashboard.get_climate_entries!(id)
    {:ok, _} = Dashboard.delete_climate_entries(climate_entries)

    {:noreply, stream_delete(socket, :leaderboard, climate_entries)}
  end
end
