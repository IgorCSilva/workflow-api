defmodule WorkflowApiWeb.LinkView do
  use WorkflowApiWeb, :view

  alias WorkflowApiWeb.LinkView

  def render("index.json", %{links: links}) do
    %{data: render_many(links, LinkView, "link.json")}
  end

  def render("show.json", %{link: link}) do
    %{data: render_one(link, LinkView, "link.json")}
  end

  def render("link.json", %{link: link}) do
    %{
      id: link.id,
      workflow_link_id: link.workflow_link_id,
      from: link.from,
      to: link.to
    }
  end
end
