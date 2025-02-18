defmodule HelloExWeb.PageController do
  use HelloExWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end

  def phoenix(conn, _params) do
    render(conn, :phoenix_test, layout: false)
  end
end
