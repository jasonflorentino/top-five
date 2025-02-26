defmodule TopFiveWeb.GameLobbyComponent do
  alias TopFiveWeb.ButtonComponent
  alias TopFiveWeb.PlayerNameComponent
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
                    {item.name}
                  </span>
                </p>
              </li>
            <% end %>
          </ul>
        <% else %>
          <p class="py-2 flex justify-center">No Items yet</p>
        <% end %>

        <form phx-submit="add_game_item" class="flex flex-col gap-2 w-full">
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
              />
              <.live_component module={ButtonComponent} id="submit-item" class="w-1/4" text="Submit" />
            </div>
          </div>
        </form>
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
