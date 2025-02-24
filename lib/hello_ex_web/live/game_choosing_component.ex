defmodule HelloExWeb.GameChoosingComponent do
  use Phoenix.LiveComponent
  import HelloExWeb.Helpers

  def render(assigns) do
    ~H"""
    <p>Choosing!</p>
    """
  end
end
