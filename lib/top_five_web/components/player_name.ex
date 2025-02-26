defmodule TopFiveWeb.PlayerNameComponent do
  alias TopFiveWeb.ButtonComponent
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <form phx-submit="set_player_name" phx-target={@myself} class="flex flex-col gap-2 w-full">
      <div class="flex flex-col gap-1">
        <input id="game_id" name="game_id" type="hidden" value={@game_id} />
        <input id="player_id" name="player_id" type="hidden" value={@user.id} />
        <label for="player_name" class="text-sm">Enter your name</label>
        <div class="flex gap-2">
          <input
            id="player_name"
            name="player_name"
            type="text"
            autocomplete="off"
            class="w-3/4 rounded bg-gray-800/80 hover:bg-gray-700/50 focus:bg-gray-700/50"
            phx-change="input_change"
            phx-target={@myself}
            value={Map.get(assigns, :input_value, "")}
          />
          <.live_component
            module={ButtonComponent}
            id="submit-name"
            class="w-1/4"
            text="Submit"
            disabled={@disabled}
          />
        </div>
      </div>
    </form>
    """
  end

  def handle_event(
        "input_change",
        %{"player_name" => player_name},
        socket
      ) do
    {:noreply, assign(socket, input_value: player_name, disabled: String.length(player_name) < 1)}
  end

  def handle_event(
        "set_player_name",
        params,
        socket
      ) do
    send(self(), {:set_player_name, params})

    {:noreply, assign(socket, input_value: "", disabled: true)}
  end
end
