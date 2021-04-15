defmodule WorkflowApiWeb.FunctionView do
  use WorkflowApiWeb, :view

  alias WorkflowApiWeb.FunctionView

  def render("index.json", %{functions: functions}) do
    %{data: render_many(functions, FunctionView, "function.json")}
  end

  def render("show.json", %{function: function}) do
    %{data: render_one(function, FunctionView, "function.json")}
  end

  def render("function.json", %{function: function}) do
    Map.take(function, [:argumentsType, :arity, :description, :function, :id, :label, :responsesType])
  end
end
