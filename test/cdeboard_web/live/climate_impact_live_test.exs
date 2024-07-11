defmodule CdeboardWeb.ClimateImpactLiveTest do
  use CdeboardWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cdeboard.DashboardFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_climate_impact(_) do
    climate_impact = climate_impact_fixture()
    %{climate_impact: climate_impact}
  end

  describe "Index" do
    setup [:create_climate_impact]

    test "lists all leaderboard", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/leaderboard")

      assert html =~ "Listing Leaderboard"
    end

    test "saves new climate_impact", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/leaderboard")

      assert index_live |> element("a", "New Climate impact") |> render_click() =~
               "New Climate impact"

      assert_patch(index_live, ~p"/leaderboard/new")

      assert index_live
             |> form("#climate_impact-form", climate_impact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#climate_impact-form", climate_impact: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leaderboard")

      html = render(index_live)
      assert html =~ "Climate impact created successfully"
    end

    test "updates climate_impact in listing", %{conn: conn, climate_impact: climate_impact} do
      {:ok, index_live, _html} = live(conn, ~p"/leaderboard")

      assert index_live |> element("#leaderboard-#{climate_impact.id} a", "Edit") |> render_click() =~
               "Edit Climate impact"

      assert_patch(index_live, ~p"/leaderboard/#{climate_impact}/edit")

      assert index_live
             |> form("#climate_impact-form", climate_impact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#climate_impact-form", climate_impact: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leaderboard")

      html = render(index_live)
      assert html =~ "Climate impact updated successfully"
    end

    test "deletes climate_impact in listing", %{conn: conn, climate_impact: climate_impact} do
      {:ok, index_live, _html} = live(conn, ~p"/leaderboard")

      assert index_live |> element("#leaderboard-#{climate_impact.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#leaderboard-#{climate_impact.id}")
    end
  end

  describe "Show" do
    setup [:create_climate_impact]

    test "displays climate_impact", %{conn: conn, climate_impact: climate_impact} do
      {:ok, _show_live, html} = live(conn, ~p"/leaderboard/#{climate_impact}")

      assert html =~ "Show Climate impact"
    end

    test "updates climate_impact within modal", %{conn: conn, climate_impact: climate_impact} do
      {:ok, show_live, _html} = live(conn, ~p"/leaderboard/#{climate_impact}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Climate impact"

      assert_patch(show_live, ~p"/leaderboard/#{climate_impact}/show/edit")

      assert show_live
             |> form("#climate_impact-form", climate_impact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#climate_impact-form", climate_impact: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/leaderboard/#{climate_impact}")

      html = render(show_live)
      assert html =~ "Climate impact updated successfully"
    end
  end
end
