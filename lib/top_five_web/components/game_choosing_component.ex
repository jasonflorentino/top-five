defmodule TopFiveWeb.GameChoosingComponent do
  use Phoenix.LiveComponent
  import TopFive.Helpers

  def render(assigns) do
    ~H"""
    <p class={cn(["font-bold"])}>Choosing!</p>
    """
  end
end
