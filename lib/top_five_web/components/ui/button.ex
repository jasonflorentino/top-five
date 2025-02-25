defmodule TopFiveWeb.ButtonComponent do
  use Phoenix.LiveComponent
  import TopFive.Helpers

  def render(assigns) do
    ~H"""
    <button
      id={@id}
      disabled={Map.get(assigns, :disabled, false)}
      class={
        cn([
          "px-5 py-3 rounded-md font-semibold disabled:opacity-50 disabled:cursor-not-allowed",
          getColor(Map.get(assigns, :variant)),
          Map.get(assigns, :class, "")
        ])
      }
    >
      {@text}
    </button>
    """
  end

  defp getColor(variant) do
    case variant do
      :variant_danger ->
        "bg-rose-600 text-rose-50 hover:bg-rose-700 disabled:hover:bg-rose-600"

      :variant_info ->
        "bg-sky-600 text-sky-50 hover:bg-sky-700 disabled:hover:bg-sky-600"

      :variant_success ->
        "bg-green-600 text-green-50 hover:bg-green-700 disabled:hover:bg-green-600"

      :variant_warning ->
        "bg-amber-600 text-amber-50 hover:bg-amber-700 disabled:hover:bg-amber-600"

      _ ->
        "bg-indigo-600 text-indigo-50 hover:bg-indigo-700 disabled:hover:bg-indigo-600"
    end
  end
end
