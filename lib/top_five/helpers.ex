defmodule TopFive.Helpers do
  @game_prefix "tf_"
  @thing_prefix "thing_"
  @user_prefix "user_"

  def rand_hex(bytes) do
    :crypto.strong_rand_bytes(bytes) |> Base.encode16(case: :lower)
  end

  def to_user_id(socket) do
    @user_prefix <> socket.id
  end

  def new_game_id() do
    @game_prefix <> rand_hex(4)
  end

  def new_thing_id() do
    @thing_prefix <> rand_hex(6)
  end

  def cn(classes) do
    classes
    |> Enum.filter(& &1)
    |> Enum.join(" ")
  end
end
