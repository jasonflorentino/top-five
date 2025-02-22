defmodule HelloEx.GamePlayers do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def upsert_user(game_id, user_id, user_data) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      game = Map.put(game, user_id, user_data)
      Map.put(map, game_id, game)
    end)
  end

  def del_user(game_id, user_id) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      game = Map.delete(game, user_id)
      Map.put(map, game_id, game)
    end)
  end

  def del_game(game_id) do
    Agent.update(__MODULE__, fn map ->
      Map.delete(map, game_id)
    end)
  end

  def get_users(game_id) do
    Agent.get(__MODULE__, fn map ->
      Map.get(map, game_id, %{})
    end)
  end
end
