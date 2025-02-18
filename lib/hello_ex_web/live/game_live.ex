defmodule HelloExWeb.GameLive do
  use HelloExWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"game_id" => game_id}, _uri, socket) do
    {:noreply, assign(socket, :game_id, game_id)}
  end

  def handle_event("new_game", _value, socket) do
    {:noreply, socket}
  end
end
