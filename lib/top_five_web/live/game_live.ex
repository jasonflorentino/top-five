defmodule TopFiveWeb.GameLive do
  alias Phoenix.PubSub
  use TopFiveWeb, :live_view

  @topic "game:"

  def mount(%{"game_id" => game_id}, _session, socket) do
    user_id = TopFive.Helpers.to_user_id(socket)
    user_data = TopFive.Game.new_user(user_id)

    users = Map.values(TopFive.Game.get_players(game_id))
    items = Map.values(TopFive.Game.get_items(game_id))
    rounds = TopFive.Game.get_rounds(game_id)
    status = TopFive.Game.get_status(game_id)

    if connected?(socket) do
      PubSub.subscribe(TopFive.PubSub, @topic <> game_id)
      broadcast_user_update(game_id, user_data)
    end

    {:ok,
     assign(socket,
       game_id: game_id,
       game_status: status,
       users: users,
       user: user_data,
       rounds: rounds,
       items: items
     )}
  end

  def terminate(_reason, socket) do
    if connected?(socket) do
      broadcast_leave(socket.assigns.game_id, TopFive.Helpers.to_user_id(socket))
    end
  end

  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    {:noreply, assign(socket, :game_id, game_id)}
  end

  # subscription handlers

  def handle_info({:user_update, game_id}, socket) do
    users = Map.values(TopFive.Game.get_players(game_id))
    {:noreply, assign(socket, :users, users)}
  end

  def handle_info({:user_left, user_id}, socket) do
    {:noreply,
     assign(
       socket,
       :users,
       Enum.filter(socket.assigns.users, fn user -> user.id != user_id end)
     )}
  end

  def handle_info({:item_update, game_id}, socket) do
    items = Map.values(TopFive.Game.get_items(game_id))
    {:noreply, assign(socket, :items, items)}
  end

  def handle_info({:status_update, game_id}, socket) do
    user_id = TopFive.Helpers.to_user_id(socket)
    players = TopFive.Game.get_players(game_id)

    rounds = TopFive.Game.get_rounds(game_id)
    status = TopFive.Game.get_status(game_id)
    users = Map.values(players)
    user = Map.get(players, user_id)
    IO.inspect(rounds, label: "jason:rounds")

    {:noreply, assign(socket, game_status: status, rounds: rounds, users: users, user: user)}
  end

  # client event handlers

  def handle_info(
        {:set_player_name,
         %{"game_id" => game_id, "player_id" => player_id, "player_name" => player_name}},
        socket
      ) do
    user_data =
      TopFive.Game.new_user(
        player_id,
        player_name
      )

    broadcast_user_update(game_id, user_data)
    {:noreply, socket}
  end

  def handle_info(
        {:add_game_item,
         %{"game_id" => game_id, "player_id" => player_id, "item_name" => item_name}},
        socket
      ) do
    item_data = TopFive.Game.new_item(item_name, item_name, player_id)

    broadcast_item_update(game_id, item_data)
    {:noreply, socket}
  end

  def handle_event(
        "set_game_status",
        %{"game_id" => game_id, "game_status" => game_status},
        socket
      ) do
    broadcast_status_update(game_id, game_status)
    {:noreply, socket}
  end

  # broadcasters

  defp broadcast_item_update(game_id, item_data) do
    TopFive.Game.put_item(game_id, item_data)
    PubSub.broadcast(TopFive.PubSub, @topic <> game_id, {:item_update, game_id})
  end

  defp broadcast_user_update(game_id, user_data) do
    TopFive.Game.put_player(game_id, user_data.id, user_data)
    PubSub.broadcast(TopFive.PubSub, @topic <> game_id, {:user_update, game_id})
  end

  defp broadcast_status_update(game_id, status) do
    TopFive.Game.set_status(game_id, status)
    PubSub.broadcast(TopFive.PubSub, @topic <> game_id, {:status_update, game_id})
  end

  defp broadcast_leave(game_id, user_id) do
    TopFive.Game.del_player(game_id, user_id)
    PubSub.broadcast(TopFive.PubSub, @topic <> game_id, {:user_left, user_id})
  end
end
