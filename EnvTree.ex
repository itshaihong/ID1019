defmodule EnvTree do
  def test() do
    t = {:node, :k, 38,
                {:node, :b, 34, nil, nil},
                {:node, :o, 40, {:node, :l, 42, nil, nil},
                                {:node, :q, 39, nil, nil}}}
    remove(t, :k)
  end

  def new() do nil end

  def add(nil, key, value) do {:node, key, value, nil, nil} end
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end
  def add({:node, k, v, left, right}, key, value) when key < k do
    {:node, k, v, add(left, key, value), right}
  end
  def add({:node, k, v, left, right}, key, value) do
    {:node, k, v, left, add(right, key, value)}
  end


  def lookup(nil, key) do nil end
  def lookup({:node, key, value, _, _}, key) do {key, value} end
  def lookup({:node, k, _, left, right}, key) when key < k do lookup(left, key) end
  def lookup({:node, k, _, left, right}, key) do lookup(right, key) end


  def remove(nil, _) do nil end
  def remove({:node, key, _, nil, right}, key) do right end
  def remove({:node, key, _, left, nil}, key) do left end
  def remove({:node, key, _, left, right}, key) do
    {replace_key, replace_value} = leftmost(right)
    {:node, replace_key, replace_value, left, remove(right, replace_key)}
  end
  def remove({:node, k, v, left, right}, key) when key < k do
    {:node, k, v, remove(left, key), right}
  end
  def remove({:node, k, v, left, right}, key) do
    {:node, k, v, left, remove(right, key)}
  end
  def leftmost({:node, key, value, nil, rest}) do {key, value} end
  def leftmost({:node, k, v, left, right}) do leftmost(left) end

end
