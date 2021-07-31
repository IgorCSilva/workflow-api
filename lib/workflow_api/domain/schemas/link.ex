defmodule WorkflowApi.Domain.Schemas.Link do
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
    field :workflow_link_id, :integer
    field :from, :integer
    field :to, :integer
  end

  @doc """
  Initial Changeset to create a function.
  """
  def changeset(link, params) do
    link
    |> cast(params, [:workflow_link_id, :from, :to])
    |> validate_required([:workflow_link_id, :from, :to])

  end

end
