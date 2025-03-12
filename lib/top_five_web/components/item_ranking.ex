defmodule TopFiveWeb.ItemRankingComponent do
  use Phoenix.LiveComponent
  import TopFive.Helpers

  def render(assigns) do
    ~H"""
    <ol class="w-full list-none flex flex-col gap-4">
      <%= if not Enum.empty?(@keys) do %>
        <%= for {key, idx} <- Enum.with_index(@keys) do %>
          <% item_data = Enum.find(@key_data, fn item -> item.key == key end) %>
          <li class="flex gap-3 items-center">
            <button
              phx-target={@myself}
              phx-click="change_rank"
              phx-value-item_id={item_data[:id]}
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
              phx-value-item_id={item_data[:id]}
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
    """
  end

  def handle_event(
        "change_rank",
        %{"item_id" => item_id, "rank_old" => rank_old, "rank_new" => rank_new},
        socket
      ) do
    IO.inspect(
      %{"item_id" => item_id, "rank_old" => rank_old, "rank_new" => rank_new},
      label: "jason:change"
    )

    {:noreply, socket}
  end
end
