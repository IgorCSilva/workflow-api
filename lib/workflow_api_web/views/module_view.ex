defmodule WorkflowApiWeb.ModuleView do
  use WorkflowApiWeb, :view

  alias WorkflowApiWeb.{ModuleView, FunctionView}

  def render("index.json", %{modules: modules}) do
    %{data: render_many(modules, ModuleView, "module.json")}
  end

  def render("show.json", %{module: module}) do
    %{data: render_one(module, ModuleView, "module.json")}
  end

  def render("module.json", %{module: module}) do
    %{
      id: module.id,
      module: module.module,
      label: module.label,
      description: module.description,
      functions: render_many(module.functions, FunctionView, "function.json")
    }
  end
end
