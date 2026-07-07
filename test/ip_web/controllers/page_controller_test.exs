defmodule IpWeb.PageControllerTest do
  use IpWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "We Protect What's Next"
  end
end
