defmodule WorkflowApi.Context.ResponseMessage do

  def default_response(result) do
    "The response is: #{result}"
  end

  def calculator_response(result) do
    "The result calculated is: #{result}"
  end
end
