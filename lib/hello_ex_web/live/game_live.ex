defmodule HelloExWeb.GameLive do
  alias Phoenix.PubSub
  use HelloExWeb, :live_view

  @topic "game:"

  def mount(%{"game_id" => game_id}, _session, socket) do
    IO.inspect(connected?(socket), label: "mount")

    user_id = HelloExWeb.Helpers.to_user_id(socket)

    user_data = %{
      id: user_id,
      name: :crypto.strong_rand_bytes(4) |> Base.encode16(case: :lower)
    }

    users = Map.values(HelloEx.GamePlayers.get_users(game_id))

    IO.inspect(users, label: "users")
    IO.inspect(connected?(socket), label: "connected")

    if connected?(socket) do
      PubSub.subscribe(HelloEx.PubSub, @topic <> game_id)
      broadcast_join(game_id, user_data)
    end

    {:ok, assign(socket, game_id: game_id, users: users, user: user_data)}
  end

  def terminate(_reason, socket) do
    if connected?(socket) do
      broadcast_leave(socket.assigns.game_id, HelloExWeb.Helpers.to_user_id(socket))
    end
  end

  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    {:noreply, assign(socket, :game_id, game_id)}
  end

  def handle_info({:user_joined, user_data}, socket) do
    {:noreply, update(socket, :users, &[user_data | &1])}
  end

  def handle_info({:user_left, user_id}, socket) do
    {:noreply,
     assign(
       socket,
       :users,
       Enum.filter(socket.assigns.users, fn user -> user.id != user_id end)
     )}
  end

  defp broadcast_join(game_id, user_data) do
    HelloEx.GamePlayers.upsert_user(game_id, user_data.id, user_data)
    PubSub.broadcast(HelloEx.PubSub, @topic <> game_id, {:user_joined, user_data})
  end

  defp broadcast_leave(game_id, user_id) do
    HelloEx.GamePlayers.del_user(game_id, user_id)
    PubSub.broadcast(HelloEx.PubSub, @topic <> game_id, {:user_left, user_id})
  end
end
