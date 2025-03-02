defmodule TopFiveWeb.GameLobbyComponent do
  alias TopFiveWeb.ButtonComponent
  alias TopFiveWeb.PlayerNameComponent
  alias TopFiveWeb.ThingNameComponent
  use Phoenix.LiveComponent
  import TopFive.Helpers

  def render(assigns) do
    ~H"""
    <div>
      <section id="bowl" class="p-3 bg-gray-900 rounded-lg">
        <div class="flex gap-1 items-start">
          <h2 class="text-xl">Items</h2>
          <%= if not Enum.empty?(@items) do %>
            <span class="text-sm">{length(@items)}</span>
          <% end %>
        </div>

        <%= if not Enum.empty?(@items) do %>
          <ul class="flex gap-2 flex-wrap py-2">
            <%= for item <- @items do %>
              <li class="px-4 py-2 bg-blue-400/20 rounded-full">
                <p>
                  <span class={cn(["font-medium"])}>
                    {String.duplicate("x", String.length(item.name))}
                  </span>
                </p>
              </li>
            <% end %>
          </ul>
        <% else %>
          <p class="py-2 flex justify-center">No Items yet</p>
        <% end %>

        <.live_component
          module={ThingNameComponent}
          id="thing_name"
          submit_event={:add_game_item}
          disabled={true}
          game_id={@game_id}
          user={@user}
        />
      </section>

      <section id="players" class="mt-6 p-3 bg-gray-900 rounded-lg ">
        <div>
          <h2 class="text-xl pb-2">Players</h2>
          <%= if not Enum.empty?(@users) do %>
            <ul class="flex gap-2 py-2">
              <%= for user <- @users do %>
                <% is_current = user.id == @user.id %>
                <li class="px-4 py-2 bg-blue-400/20 rounded-full">
                  <p>
                    <span class={cn([is_current && "font-bold", is_current && "text-green-400"])}>
                      {user.name}
                    </span>
                  </p>
                </li>
              <% end %>
            </ul>
          <% else %>
            <p>No players</p>
          <% end %>
        </div>

        <nav id="actions" class="flex flex-col gap-4 items-center">
          <.live_component
            module={PlayerNameComponent}
            id="player_name"
            submit_event={:set_player_name}
            disabled={true}
            game_id={@game_id}
            user={@user}
          />

          <form phx-submit="set_game_status">
            <input type="hidden" name="game_id" value={@game_id} />
            <input type="hidden" name="game_status" value={:game_status_choosing} />
            <.live_component
              module={ButtonComponent}
              id="start-game"
              disabled={length(@items) < 5 || length(@users) < 2}
              variant={:variant_success}
              text="Start Game"
            />
          </form>
        </nav>

        <section id="game_code">
          <h3>Game Code</h3>
          <span>{@game_id}</span>
          <button>Copy Link</button>
        </section>
      </section>
    </div>
    """
  end
end
