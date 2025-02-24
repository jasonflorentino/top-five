defmodule TopFiveWeb.PageController do
  use TopFiveWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end

  def phoenix(conn, _params) do
    render(conn, :phoenix_test, layout: false)
  end
end
