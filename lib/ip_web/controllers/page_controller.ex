defmodule IpWeb.PageController do
  use IpWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def terms(conn, _params) do
    render(conn, :terms)
  end
end
