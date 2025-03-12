defmodule TopFiveWeb.GameChoosingComponent do
  use Phoenix.LiveComponent
  import TopFive.Helpers

  def render(assigns) do
    ~H"""
    <div>
      <p class={cn(["font-bold"])}>
        <%= if @user.is_choosing do %>
          You must choose! <% round = Map.get(@rounds, @user.id) %>
          <%= if round do %>
            <.live_component
              module={TopFiveWeb.ItemRankingComponent}
              id="chooser_rankings"
              keys={round[:chooser_rankings]}
              key_data={@items}
              user={@user}
            />
          <% end %>
        <% else %>
          {user =
            Enum.find(@users, fn user ->
              IO.inspect(user, label: "jason:user")
              user[:is_choosing] == true
            end)

          if user != nil do
            user[:name]
          else
            "someone"
          end} is choosing!
        <% end %>
      </p>
    </div>
    """
  end
end
