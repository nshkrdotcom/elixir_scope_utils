defmodule ElixirScope.UtilsTest do
  use ExUnit.Case
  doctest ElixirScope.Utils

  test "greets the world" do
    assert ElixirScope.Utils.hello() == :world
  end
end
