defmodule HelloExWeb.Helpers do
  @user_prefix "user_"

  def to_user_id(socket) do
    @user_prefix <> socket.id
  end
end
