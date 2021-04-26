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

  @doc """
  Initial Changeset to update a plan.
  """
  # def changeset_update(_function, params) do
  #   %Function{}
  #   |> cast(params, [:name, :description, :price, :period, :id])
  #   |> GeneralFunctions.validate_uuid(:id)
  #   |> changeset_create_update(params)
  # end

  @doc """
  Changeset with create and update validations.
  """
  # def changeset_create_update(changeset, _params) do
  #   changeset
  #   |> unsafe_validate_unique(:name, Stores.Repo, message: "Este nome de plano já existe.")
  #   |> validate_length(:name, min: 4)
  #   |> validate_number(:price, greater_than: 0)
  #   |> validate_number(:period, greater_than: 0)
  #   |> unique_constraint(:name)

  # end

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
