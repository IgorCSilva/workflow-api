defmodule WorkflowApi.Domain.Schemas.Module do
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

  alias WorkflowApi.Domain.Schemas.{Module, Function}

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "modules" do
    field :module, :string
    field :label, :string
    field :description, :string, default: ""

    field :module_functions, {:array, :binary_id}, virtual: true

    has_many :functions, Function, on_replace: :nilify

    timestamps()
  end

  @doc """
  Initial Changeset to create a function.
  """
  def changeset(params) do
    %Module{}
    |> cast(params, [:module, :label, :description, :module_functions])
    |> validate_required([:module, :label, :module_functions])

  end

end
