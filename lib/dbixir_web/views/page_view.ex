defmodule DbixirWeb.PageView do
  use DbixirWeb, :view

  def render("tables.json", %{tables: tables}) do
    %{data: tables}
  end

end
