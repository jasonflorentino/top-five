defmodule HelloExWeb.NewGameLive do
  use HelloExWeb, :live_view

  def render(assigns) do
    ~H"""
    <button
      phx-click="new_game"
      class="border-0 block w-full px-3 p-3 text-green-100 bg-green-600 rounded"
    >
      <span class="font-semibold">
        New Game
      </span>
    </button>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  def handle_event("new_game", _params, socket) do
    game_id = :crypto.strong_rand_bytes(4) |> Base.encode16(case: :lower)
    {:noreply, push_navigate(socket, to: ~p"/game/#{game_id}")}
  end
end
