defmodule WorkflowApiWeb.WorkflowApiView do
  use WorkflowApiWeb, :view

  alias WorkflowApiWeb.WorkflowApiView

  def render("index.json", %{modules: modules}) do
    %{data: render_many(modules, WorkflowApiView, "modules.json")}
  end

  def render("modules.json", %{workflow_api: module}) do
    %{
      module_name: module
    }
  end

  def render("index.json", %{modules_functions: modules}) do
    %{data: render_many(modules, WorkflowApiView, "modules_functions.json")}
  end

  # def render("modules_functions.json", %{workflow_api: module}) do
  #   %{
  #     module: module.module,
  #     functions: Enum.map(module.functions, fn func ->
  #       Tuple.to_list(func)
  #     end)
  #   }
  # end

  def render("modules_functions.json", %{workflow_api: module}) do
    %{
      module: module.module,
      functions: render_many(module.functions, WorkflowApiView, "function.json")
    }
  end

  def render("index.json", %{functions: functions}) do
    %{data: render_many(functions, WorkflowApiView, "function.json")}
  end

  def render("function.json", %{workflow_api: {functions_name, functions_arity}}) do
    %{
      name: functions_name,
      arity: functions_arity
    }
  end

  def render("show.json", %{sequence_result: result}) do
    %{ data: render_one(result, WorkflowApiView, "result.json")}
  end

  def render("result.json", %{workflow_api: result}) do
    %{
      result: result
    }
  end
end
