defmodule EnvList do
  def test() do
    map = [{:a, 1}, {:b, 2}, {:c, 3}]
    add(map, :d, 4)
  end

  def new() do [] end

  def add([], key, value) do  [{key,value}] end
  def add([{key,_}|rest], key, value) do [{key,value}|rest] end
  def add([head|rest], key, value) do [head|add(rest, key, value)] end

  def lookup([], key) do nil end
  def lookup([{key, h_value}|t], key) do {key, h_value} end
  def lookup([_|t], key) do lookup(t, key) end

  def remove([], key) do :error end
  def remove([{key, h_value}|t], key) do t end
  def remove([h|t], key) do [h|remove(t, key)] end

end
