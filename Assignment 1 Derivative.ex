defmodule Deriv do

  def test() do
    #e = {:add, {:add, {:ln, {:var,:x}}, {:cos, {:var, :x}}}, {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, -2}}}, {:add, {:mul, {:num, -3}, {:var, :x}}, {:num, 5}}}}
    e = {:exp, {:add, {:mul, {:num, -2}, {:var, :x}}, {:num, 1}}, {:num, 3}}
    IO.write("original expression:\n")
    IO.inspect(e)
    IO.write("expression: #{pprint(e)}\n")
    d = simplify(deriv(e, :x))
    IO.write("derivative: #{pprint(d)}\n")

  end

  def derivative(n) when is_number(n) do 0 end

  def derivative(n) when is_atom(n) do 1 end

  @type literal() :: {:num, number()}
  | {:var, atom()}

  @type expr() :: {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), expr()}
  | {:ln, expr(), expr()}
  | {:sin, expr()}
  | {:cos, expr()}
  | literal()

#=========derivative====================

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, e1, deriv(e2, v)},
      {:mul, e2, deriv(e1, v)}}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul, deriv(e, v), {:mul, {:num, n}, {:exp, e, {:num, n-1}}}}
  end

  def deriv({:ln, e}, v) do
    {:mul, deriv(e, v), {:exp, e, {:num, -1}}}
  end

  def deriv({:sin, e}, v) do
    {:mul, deriv(e, v), {:cos, e}}
  end

  def deriv({:cos, e}, v) do
    {:mul, {:num, -1}, {:mul, deriv(e, v), {:sin, e}}}
  end
  #========pprint=======================

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end

  def pprint({:add, e1, e2}) do
    result = "(#{pprint(e1)} + #{pprint(e2)})"
    String.replace(result, "+ -", "- ")
  end
  def pprint({:mul, e1, e2}) do
    result = "#{pprint(e1)} * #{pprint(e2)}"
    String.replace(result, "-1 * ", "-")
  end
  def pprint({:exp, e, {:num, n}}) do "#{pprint(e)} ^ #{n}" end
  def pprint({:ln, e}) do "ln#{pprint(e)}" end
  def pprint({:cos, e}) do "cos#{pprint(e)}" end
  def pprint({:sin, e}) do "sin#{pprint(e)}" end

  #========simplify====================

  def simplify({:num, n}) do {:num, n} end
  def simplify({:var, v}) do {:var, v} end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2 }) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e, {:num, 1}}) do e end
  def simplify({:exp, e, {:num, 0}}) do {:num, 1} end
  def simplify({:exp, e, {:num, n}}) do
    {:exp, e, {:num, n}}
  end

  def simplify({:ln, e}) do {:ln, e} end
  def simplify({:cos, e}) do {:cos, e} end
  def simplify({:sin, e}) do {:sin, e} end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, e2) do {:num, 0} end
  def simplify_mul(e1, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e2}) do
    {:mul, {:num, n1*n2}, e2}
  end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end



end
