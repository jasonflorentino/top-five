defmodule TopFiveWeb.ThingNameComponent do
  alias TopFiveWeb.ButtonComponent
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <form phx-submit="handle_submit" phx-target={@myself} class="flex flex-col gap-2 w-full">
      <div class="flex flex-col gap-1">
        <input type="hidden" id="game_id" name="game_id" value={@game_id} />
        <input type="hidden" id="player_id" name="player_id" value={@user.id} />
        <label for="item_name" class="text-sm">Enter a thing</label>
        <div class="flex gap-2">
          <input
            id="item_name"
            name="item_name"
            type="text"
            autocomplete="off"
            class="w-3/4 rounded bg-gray-800/80 hover:bg-gray-700/50 focus:bg-gray-700/50"
            phx-change="input_change"
            phx-target={@myself}
            value={Map.get(assigns, :input_value, "")}
          />
          <.live_component
            module={ButtonComponent}
            id="submit-item"
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
        %{"item_name" => item_name},
        socket
      ) do
    {:noreply, assign(socket, input_value: item_name, disabled: String.length(item_name) < 1)}
  end

  def handle_event(
        "handle_submit",
        params,
        socket
      ) do
    send(self(), {socket.assigns.submit_event, params})

    {:noreply, assign(socket, input_value: "", disabled: true)}
  end
end
