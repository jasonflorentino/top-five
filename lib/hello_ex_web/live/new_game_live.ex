defmodule HelloExWeb.NewGameLive do
  use HelloExWeb, :live_view

  def render(assigns) do
    ~H"""
    <button phx-click="new_game">New Game</button>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("new_game", _params, socket) do
    game_id = :crypto.strong_rand_bytes(4) |> Base.encode16(case: :lower)
    {:noreply, push_navigate(socket, to: ~p"/game/#{game_id}")}
  end
end
