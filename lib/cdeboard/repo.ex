defmodule Cdeboard.Repo do
  use Ecto.Repo,
    otp_app: :cdeboard,
    adapter: Ecto.Adapters.SQLite3
end
