defmodule TopFiveWeb.Helpers do
  @user_prefix "user_"

  def to_user_id(socket) do
    @user_prefix <> socket.id
  end

  def cn(classes) do
    classes
    |> Enum.filter(& &1)
    |> Enum.join(" ")
  end
end
