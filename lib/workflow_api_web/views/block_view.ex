defmodule WorkflowApiWeb.BlockView do
  use WorkflowApiWeb, :view

  alias WorkflowApiWeb.BlockView

  def render("index.json", %{blocks: blocks}) do
    %{data: render_many(blocks, BlockView, "block.json")}
  end

  def render("show.json", %{block: block}) do
    %{data: render_one(block, BlockView, "block.json")}
  end

  def render("block.json", %{block: block}) do
    %{
      id: block.id,
      function_id: block.function_id,
      workflow_block_id: block.workflow_block_id,
      workflow_block_pos_x: block.workflow_block_pos_x,
      workflow_block_pos_y: block.workflow_block_pos_y
    }
  end
end
