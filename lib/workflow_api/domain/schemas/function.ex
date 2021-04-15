defmodule WorkflowApi.Domain.Schemas.Function do
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
  schema "functions" do
    field :function, :string
    field :label, :string
    field :description, :string, default: ""
    field :arity, :integer
    field :argumentsType, {:array, :string}
    field :responsesType, {:array, :string}
    # field :block_position_x, :integer, default: 100
    # field :block_position_y, :integer, default: 100

    belongs_to :module, Module, type: :binary_id

    timestamps()
  end

  @doc """
  Initial Changeset to create a function.
  """
  def changeset(params) do
    %Function{}
    |> cast(params, [:function, :label, :description, :arity, :argumentsType, :responsesType])
    |> validate_required([:function, :label, :arity, :argumentsType, :responsesType])
    |> changeset_create_update()
  end

  @doc """
  Initial Changeset to update a plan.
  """
  def changeset_update(function, params) do
    function
    |> cast(params, [:function, :label, :description, :arity, :argumentsType, :responsesType, :id])
    |> changeset_create_update()
  end

  @doc """
  Changeset with create and update validations.
  """
  def changeset_create_update(changeset) do
    changeset
    |> validate_number(:arity, greater_than: -1)

  end

  @doc """
  Validating id format.
  """
  # def validate_id_format(changeset, field) do
  #   validate_change(changeset, field, fn (field, value) ->

  #     case Ecto.UUID.cast(value) do
  #       {:ok, _id} -> []
  #       :error -> [{field, "id inválido."}]
  #       _ -> [{field, "Erro referente ao id fornecido."}]
  #     end
  #   end)
  # end
end
