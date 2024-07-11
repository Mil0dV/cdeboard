defmodule CdeboardWeb.ClimateImpactLive.FormComponent do
  use CdeboardWeb, :live_component

  alias Cdeboard.Dashboard

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage climate_impact records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="climate_impact-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Climate impact</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{climate_impact: climate_impact} = assigns, socket) do
    changeset = Dashboard.change_climate_impact(climate_impact)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"climate_impact" => climate_impact_params}, socket) do
    changeset =
      socket.assigns.climate_impact
      |> Dashboard.change_climate_impact(climate_impact_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"climate_impact" => climate_impact_params}, socket) do
    save_climate_impact(socket, socket.assigns.action, climate_impact_params)
  end

  defp save_climate_impact(socket, :edit, climate_impact_params) do
    case Dashboard.update_climate_impact(socket.assigns.climate_impact, climate_impact_params) do
      {:ok, climate_impact} ->
        notify_parent({:saved, climate_impact})

        {:noreply,
         socket
         |> put_flash(:info, "Climate impact updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_climate_impact(socket, :new, climate_impact_params) do
    case Dashboard.create_climate_impact(climate_impact_params) do
      {:ok, climate_impact} ->
        notify_parent({:saved, climate_impact})

        {:noreply,
         socket
         |> put_flash(:info, "Climate impact created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
