defmodule WorkflowApi.Context.Text do

  def upper_case(str) do
    String.upcase(str)
  end

  def remove_blank_spaces(str) do
    String.replace(str, " ", "")
  end
end
