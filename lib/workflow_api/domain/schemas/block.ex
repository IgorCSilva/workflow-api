defmodule WorkflowApi.Domain.Schemas.Block do
  @moduledoc """
      Schema for plan informations
      - name: plan name.
      - price: plan price for the period.
      - period: duration (in months) of the subscription plan.
      - plan_services: service ids list. Only used to create a plan.
      - subscription_info: informations about store subscription.
      - services: services that plan offers.
    """
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :workflow_block_id, :integer
    field :workflow_block_pos_x, :integer
    field :workflow_block_pos_y, :integer
    field :function_id, :string
  end

  @doc """
  Initial Changeset to create a function.
  """
  def changeset(block, params) do
    block
    |> cast(params, [:workflow_block_id, :workflow_block_pos_x, :workflow_block_pos_y, :function_id])
    |> validate_required([:workflow_block_id, :workflow_block_pos_x, :workflow_block_pos_y, :function_id])

  end
end
