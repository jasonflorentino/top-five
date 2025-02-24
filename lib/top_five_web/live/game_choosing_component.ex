defmodule TopFiveWeb.GameChoosingComponent do
  use Phoenix.LiveComponent
  import TopFiveWeb.Helpers

  def render(assigns) do
    ~H"""
    <p class={cn(["font-bold"])}>Choosing!</p>
    """
  end
end
