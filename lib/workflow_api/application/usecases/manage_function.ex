defmodule WorkflowApi.Application.Usecases.ManageFunction do

  alias WorkflowApi.Domain.Schemas.Function
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  def create(params, repository) do
    # Verificando se os dados fornecidos em params são válidos.
    case changeset = Function.changeset(params) do
      # Se passar pelas validações o changeset é enviado para a criação da função.
      %Ecto.Changeset{:valid? => true} ->
        # IO.inspect(changeset)
        # Tenta inserir a função no banco de dados.
        repository.create(changeset)

      # Caso ocorra algum erro dentre as validações seu detalhamento é retornado.
      changeset -> {:error, ChangesetErrorsMessage.traverse_message(changeset)}
    end
  end

  @doc """
  Get a function or return error if we receive an invalid id.
  """
  def get(function_id, repository) do
    with {:ok, id} <- Ecto.UUID.cast(function_id) do
      repository.get(id)
    else
      :error -> {:error, "Invalid id."}
    end
  end

  def list(repository) do
    repository.list()
  end

  @doc """
  Update service info or return associated error to the
  wrong data.
  """
  def update(params, repository) do

    with {:ok, function_id} <- Map.fetch(params, "id"),
      {:uuid, {:ok, id}} <- {:uuid, Ecto.UUID.cast(function_id)},
      function <- repository.get(id),
      {:is_nil, false} <- {:is_nil, is_nil(function)},
      changeset <- Function.changeset_update(function, params),
      %Ecto.Changeset{:valid? => true} <- changeset do

        IO.inspect(changeset)
        # Atualizando informações.
        case repository.update(changeset) do
          {:ok, function} -> {:ok, function}

          {:error, changeset_update} ->
            {:error, ChangesetErrorsMessage.traverse_message(changeset_update)}
        end
    else
      :error -> {:error, "The function id was not sent."}
      {:uuid, :error} -> {:error, "Invalid id."}
      {:is_nil, true} -> {:error, "There isn't function with this id."}

      {:error, changeset} ->
        {:error, ChangesetErrorsMessage.traverse_message(changeset)}

      changeset ->
        {:error, ChangesetErrorsMessage.traverse_message(changeset)}
    end

  end


  @doc """
  Delete function by id or return error if we receive an invalid id.
  """
  def delete(id, repository) do

    with {:ok, id} <- Ecto.UUID.cast(id) do
      case repository.get(id) do
        nil -> {:error, "There isn't function with this id."}

        function -> repository.delete(function)
      end
    else
      :error -> {:error, "Invalid id."}
    end
  end
end
