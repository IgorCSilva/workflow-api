defmodule WorkflowApiWeb.DemoAppView do
  use WorkflowApiWeb, :view

  alias WorkflowApiWeb.DemoAppView

  def render("show.json", %{client: client}) do
    %{data: render_one(client, DemoAppView, "client.json")}
  end

  def render("client.json", %{demo_app: demo_app}) do
    %{
      result: demo_app
    }
  end
end
