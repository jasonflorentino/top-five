defmodule HelloEx.Game do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def game_players_get(map) do
    Map.get(map, :game_players, %{})
  end

  def game_players_set(map, players) do
    Map.put(map, :game_players, players)
  end

  def game_items_get(map) do
    Map.get(map, :game_items, %{})
  end

  def game_items_set(map, items) do
    Map.put(map, :game_items, items)
  end

  def add_item(game_id, item_data) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      items = game_items_get(game)
      items = Map.put(items, item_data.key, item_data)

      game = game_items_set(game, items)
      Map.put(map, game_id, game)
    end)
  end

  def upsert_player(game_id, user_id, user_data) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      players = game_players_get(game)
      players = Map.put(players, user_id, user_data)

      game = game_players_set(game, players)
      Map.put(map, game_id, game)
    end)
  end

  def del_player(game_id, user_id) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      players = game_players_get(game)
      players = Map.delete(players, user_id)

      if map_size(players) > 0 do
        game = game_players_set(game, players)
        Map.put(map, game_id, game)
      else
        Map.delete(map, game_id)
      end
    end)
  end

  def del_game(game_id) do
    Agent.update(__MODULE__, fn map ->
      Map.delete(map, game_id)
    end)
  end

  def get_players(game_id) do
    Agent.get(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      game_players_get(game)
    end)
  end

  def get_items(game_id) do
    Agent.get(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      game_items_get(game)
    end)
  end
end
