defmodule HelloExWeb.GameLive do
  alias Phoenix.PubSub
  use HelloExWeb, :live_view

  @topic "game:"

  def mount(%{"game_id" => game_id}, _session, socket) do
    if connected?(socket) do
      user_data = %{
        id: toUserId(socket)
      }

      PubSub.subscribe(HelloEx.PubSub, @topic <> game_id)
      broadcast_join(game_id, user_data)
      {:ok, assign(socket, game_id: game_id, users: [], user: user_data)}
    else
      {:ok, assign(socket, game_id: game_id, users: [])}
    end
  end

  def terminate(_reason, socket) do
    if connected?(socket) do
      broadcast_leave(socket.assigns.game_id, toUserId(socket))
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
       Enum.filter(socket.assigns.users, fn user -> user.id == user_id end)
     )}
  end

  defp broadcast_join(game_id, user_data) do
    PubSub.broadcast(HelloEx.PubSub, @topic <> game_id, {:user_joined, user_data})
  end

  defp broadcast_leave(game_id, user_id) do
    PubSub.broadcast(HelloEx.PubSub, @topic <> game_id, {:user_left, user_id})
  end

  defp toUserId(socket) do
    "user_" <> socket.id
  end
end
