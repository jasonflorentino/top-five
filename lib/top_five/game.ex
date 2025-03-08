defmodule TopFive.Game do
  require Logger
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def log_state(state) do
    Logger.debug("GameState: #{inspect(state)}")
    state
  end

  # entities

  def new_user(id, name \\ TopFive.Helpers.rand_hex(4)) do
    %{
      id: id,
      name: name,
      is_choosing: false
    }
  end

  def new_item(key, name, added_by) do
    %{
      id: TopFive.Helpers.new_thing_id(),
      key: key,
      name: name,
      added_by: added_by
    }
  end

  def new_round(chooser_id, items_ranked) do
    %{
      chooser: chooser_id,
      chooser_rankings: items_ranked,
      group_rankings: items_ranked
    }
  end

  # get/set

  def game_items_get(map) do
    Map.get(map, :game_items, %{})
  end

  def game_items_set(map, items) do
    Map.put(map, :game_items, items)
  end

  def game_players_get(map) do
    Map.get(map, :game_players, %{})
  end

  def game_players_set(map, players) do
    Map.put(map, :game_players, players)
  end

  def game_rounds_get(map) do
    Map.get(map, :game_rounds, %{})
  end

  def game_rounds_set(map, rounds) do
    Map.put(map, :game_rounds, rounds)
  end

  def game_status_get(map) do
    Map.get(map, :game_status, :game_status_setup)
  end

  def game_status_set(map, status) do
    Map.put(map, :game_status, status)
  end

  # controllers

  def put_item(game_id, item_data) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      items = game_items_get(game)
      items = Map.put(items, item_data.key, item_data)

      game = game_items_set(game, items)
      Map.put(map, game_id, game) |> log_state
    end)
  end

  def put_player(game_id, user_id, user_data) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      players = game_players_get(game)
      players = Map.put(players, user_id, user_data)

      game = game_players_set(game, players)
      Map.put(map, game_id, game) |> log_state
    end)
  end

  def set_status(game_id, game_status) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      game = game_status_set(game, game_status)

      game =
        case TopFive.Helpers.normalize_status(game_status) do
          "game_status_choosing" ->
            handle_status_choosing(game)

          _ ->
            Logger.warning("set_status: Unknown status #{game_status}")
            game
        end

      Map.put(map, game_id, game) |> log_state
    end)
  end

  def handle_status_choosing(game) do
    players = game_players_get(game)
    {user_id, player} = Enum.random(players)
    player = Map.put(player, :is_choosing, true)
    players = Map.put(players, user_id, player)

    items_ranked = game_items_get(game) |> choose_items_to_rank()

    rounds =
      game
      |> game_rounds_get()
      |> Map.put(player[:id], new_round(player[:id], items_ranked))

    game |> game_players_set(players) |> game_rounds_set(rounds)
  end

  def choose_items_to_rank(items) do
    items
    |> Map.to_list()
    |> Enum.take_random(5)
    |> Enum.map(fn {item_key, _item} -> item_key end)
  end

  def del_player(game_id, user_id) do
    Agent.update(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      players = game_players_get(game)
      players = Map.delete(players, user_id)

      if map_size(players) > 0 do
        game = game_players_set(game, players)
        Map.put(map, game_id, game) |> log_state
      else
        Map.delete(map, game_id) |> log_state
      end
    end)
  end

  def del_game(game_id) do
    Agent.update(__MODULE__, fn map ->
      Map.delete(map, game_id) |> log_state
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

  def get_rounds(game_id) do
    Agent.get(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      game_rounds_get(game)
    end)
  end

  def get_status(game_id) do
    Agent.get(__MODULE__, fn map ->
      game = Map.get(map, game_id, %{})
      game_status_get(game)
    end)
  end
end
