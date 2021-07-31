defmodule WorkflowApi.Domain.Schemas.Sequence do
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

  # alias WorkflowApi.Domain.Schemas.{Sequence}

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "sequences" do
    field :name, :string
    field :description, :string, default: ""
    field :functions_sequence, {:array, :string}
    # embeds_many :blocks, Block, on_replace: :delete
    # embeds_many :links, Link, on_replace: :delete

    timestamps()
  end

  @doc """
  Initial Changeset to create a function.
  """
  def changeset(sequence, params) do
    sequence
    |> cast(params, [:name, :description, :functions_sequence])
    # |> cast_embed(:blocks)
    # |> cast_embed(:links)
    |> validate_required([:name, :functions_sequence])

  end
end
