defmodule TopFive.Repo do
  use Ecto.Repo,
    otp_app: :top_five,
    adapter: Ecto.Adapters.SQLite3
end
