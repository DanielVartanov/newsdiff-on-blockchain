defmodule NewsDiff.PageController do
  use NewsDiff.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
