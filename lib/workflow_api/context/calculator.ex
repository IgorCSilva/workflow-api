defmodule WorkflowApi.Context.Calculator do

  def add(a, b) do
    a + b
  end

  def sub(a, b) do
    a - b
  end

  def mul(a, b) do
    a * b
  end

  def calc_div(a, b) do
    div(a, b)
  end

  def doble(value) do
    value * 2
  end

  def square(value) do
    value * value
  end

  def times_10(value) do
    value * 10
  end
end
