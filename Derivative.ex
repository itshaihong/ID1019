defmodule Deriv do

  def test() do
    e = {:add, {:add, {:ln, {:var,:x}}, {:cos, {:var, :x}}}, {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, -2}}}, {:add, {:mul, {:num, -3}, {:var, :x}}, {:num, 5}}}}
    IO.write("expression: #{pprint(e)}\n")
    d = simplify(deriv(e, :x))
    IO.write("derivative: #{pprint(d)}\n")
    e
#    e2 = {:exp, {:var,:x}, {:num, -1}}
#   IO.write("#{deriv(e2, :x)} \n")
#    e3 = {:exp, {:var,:x}, {:num, 0.5}}
#    IO.write("#{deriv(e3, :x)} \n")
#    e4 = {:ln, {:var, :x}}
#   IO.write("#{deriv(e4, :x)} \n")
#    e5 = {:sin, {:var, :x}}
#    IO.write("#{deriv(e5, :x)} \n")
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

  def deriv({:exp, {:var, v}, {:num, n}}, v) do
    {:mul, {:num, n}, {:exp, {:var, v}, {:num, n-1}}}
  end

  def deriv({:ln, {:var, v}}, v) do
    {:exp, {:var, v}, {:num, -1}}
  end

  def deriv({:sin, {:var, v}}, v) do
    {:cos, {:var, v}}
  end

  def deriv({:cos, {:var, v}}, v) do
    {:mul, {:num, -1}, {:sin, {:var, v}}}
  end
  #========pprint=======================

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end

  def pprint({:add, e1, {:num, n}}) do
    if n<0 do
      "(#{pprint(e1)} - #{pprint({:num, -n})})"
    else
      "(#{pprint(e1)} + #{pprint({:num, n})})"
    end
  end
  def pprint({:add, e1, {:mul, {:num, n}, e2}}) do
    if n<0 do
      if n==-1 do "(#{pprint(e1)} - #{pprint(e2)})"
      else "(#{pprint(e1)} - #{pprint({:mul, {:num, -n}, e2})})" end
    else
      "(#{pprint(e1)} + #{pprint({:mul, {:num, n}, e2})})"
    end
  end
  def pprint({:add, e1, e2}) do
    "(#{pprint(e1)} + #{pprint(e2)})"
  end #key problem solved for subtracting


  def pprint({:mul, e1, {:num, n}}) do
    if n<0 do
      if n==-1 do "- #{pprint(e1)}"
      else "- #{pprint({:mul, {:num, -n}, e1})}" end
    else "#{pprint({:mul, {:num, n}, e1})}" end
  end
  def pprint({:mul, e1, {:mul, {:num, n}, e2}}) do
    if n<0 do
      if n==-1 do "- #{pprint({:mul, e1, e2})}"
      else "- #{pprint({:mul, {:mul, {:num, -n}, e1}, e2})}" end
    else "#{pprint({:mul, {:mul, {:num, n}, e1}, e2})}" end
  end
  def pprint({:mul, e1, e2}) do
    "#{pprint(e1)} * #{pprint(e2)}"
  end #key problem solved for multiplying negative

  def pprint({:exp, {:var, v}, {:num, n}}) do "#{v} ^ #{n}" end
  def pprint({:ln, {:var, v}}) do "ln#{v}" end
  def pprint({:cos, {:var, v}}) do "cos#{v}" end
  def pprint({:sin, {:var, v}}) do "sin#{v}" end

  #========simplify====================

  def simplify({:num, n}) do {:num, n} end
  def simplify({:var, v}) do {:var, v} end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2 }) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, {:var, v}, {:num, 1}}) do {:var, v} end
  def simplify({:exp, {:var, v}, {:num, 0}}) do {:num, 1} end
  def simplify({:exp, {:var, v}, {:num, n}}) do
    {:exp, {:var, v}, {:num, n}}
  end

  def simplify({:ln, {:var, v}}) do {:ln, {:var, v}} end
  def simplify({:cos, {:var, v}}) do {:cos, {:var, v}} end
  def simplify({:sin, {:var, v}}) do {:sin, {:var, v}} end

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
