defmodule WorkflowApiWeb.SequenceView do
  use WorkflowApiWeb, :view

  alias WorkflowApiWeb.{SequenceView, BlockView, LinkView}

  def render("index.json", %{sequences: sequences}) do
    %{data: render_many(sequences, SequenceView, "sequence.json")}
  end

  def render("show.json", %{sequence_result: result}) do
    %{data: render_one(result, SequenceView, "sequence_result.json")}
  end

  def render("sequence_result.json", %{sequence: result}) do
    result
  end

  def render("show.json", %{sequence: sequence}) do
    %{data: render_one(sequence, SequenceView, "sequence.json")}
  end

  def render("sequence.json", %{sequence: sequence}) do
    %{
      id: sequence.id,
      name: sequence.name,
      description: sequence.description,
      blocks: render_many(sequence.blocks, BlockView, "block.json"),
      links: render_many(sequence.links, LinkView, "link.json")
    }
  end
end
