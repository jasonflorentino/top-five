defmodule TopFiveWeb.ItemRankingComponent do
  alias TopFiveWeb.ButtonComponent
  use Phoenix.LiveComponent
  import TopFive.Helpers

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4">
      <ol class="w-full list-none flex flex-col gap-4">
        <%= if not Enum.empty?(@keys) do %>
          <%= for {key, idx} <- Enum.with_index(@keys) do %>
            <% item_data = Enum.find(@key_data, fn item -> item.key == key end) %>
            <li class="flex gap-3 items-center">
              <button
                phx-target={@myself}
                phx-click="change_rank"
                phx-value-item_key={item_data[:key]}
                phx-value-rank_old={idx}
                phx-value-rank_new={idx - 1}
                class={
                  cn([
                    "py-2 px-3 bg-sky-400 rounded-full text-lg",
                    idx == 0 && "opacity-0 pointer-events-none"
                  ])
                }
              >
                ⬆️
              </button>
              <button
                phx-target={@myself}
                phx-click="change_rank"
                phx-value-item_key={item_data[:key]}
                phx-value-rank_old={idx}
                phx-value-rank_new={idx + 1}
                class={
                  cn([
                    "py-2 px-3 bg-sky-700 rounded-full text-lg",
                    idx == 4 && "opacity-0 pointer-events-none"
                  ])
                }
              >
                ⬇️
              </button>
              <span class="font-medium">
                {idx + 1}. {item_data[:name]}
              </span>
            </li>
          <% end %>
        <% end %>
      </ol>

      <form phx-submit="handle_submit" phx-target={@myself}>
        <.live_component
          module={ButtonComponent}
          id="submit-top-five"
          class="min-w-fit"
          text="Lock in my top five"
        />
      </form>
    </div>
    """
  end

  def handle_event(
        "change_rank",
        %{"item_key" => item_key, "rank_old" => rank_old, "rank_new" => rank_new},
        socket
      ) do
    keys =
      Map.get(socket.assigns, :keys)
      |> List.delete_at(String.to_integer(rank_old))
      |> List.insert_at(String.to_integer(rank_new), item_key)

    {:noreply, assign(socket, keys: keys)}
  end

  def handle_event("handle_submit", _params, socket) do
    keys =
      Map.get(socket.assigns, :keys)

    IO.inspect(keys, label: "jason:submit:keys")
    {:noreply, socket}
  end
end
