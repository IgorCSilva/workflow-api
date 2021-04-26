defmodule WorkflowApi.Application.Usecases.ManageSequence do

  alias WorkflowApi.Domain.Schemas.{Sequence}
  alias WorkflowApi.Application.Utils.ChangesetErrorsMessage

  # Resposta para funções que são void.
  @type_response_no_reply []

  def create(params, repository) do
    IO.inspect(params, label: "params")

    # IO.inspect(params)
    # Verificando se os dados fornecidos em params são válidos.
    case changeset = Sequence.changeset(%Sequence{}, params) do
      %Ecto.Changeset{:valid? => true} ->
        IO.inspect(changeset)
        repository.create(changeset)


      # Caso ocorra algum erro dentre as validações seu detalhamento é retornado.
      changeset -> {:error, ChangesetErrorsMessage.traverse_message(changeset)}
    end
  end

  def list(repository) do
    repository.list()
  end

  @doc """
  Update sequence info or return associated error to the
  wrong data.
  """
  def update(params, repository) do

    with {:ok, sequence_id} <- Map.fetch(params, "id"),
      # {:uuid, {:ok, id}} <- {:uuid, Ecto.UUID.cast(sequence_id)},
      sequence <- repository.get(sequence_id),
      {:is_nil, false} <- {:is_nil, is_nil(sequence)},
      changeset <- Sequence.changeset(sequence, params),
      %Ecto.Changeset{:valid? => true} <- changeset do

        IO.inspect(changeset)
        # Atualizando informações.
        case repository.update(changeset) do
          {:ok, sequence} ->
            IO.inspect(sequence)
            {:ok, sequence}

          {:error, changeset_update} ->
            {:error, ChangesetErrorsMessage.traverse_message(changeset_update)}
        end
    else
      :error -> {:error, "The sequence id was not sent."}
      {:uuid, :error} -> {:error, "Invalid id."}
      {:is_nil, true} -> {:error, "There isn't sequence with this id."}

      {:error, changeset} ->
        {:error, ChangesetErrorsMessage.traverse_message(changeset)}

      changeset ->
        {:error, ChangesetErrorsMessage.traverse_message(changeset)}
    end

  end

  def execute_sequence(params, repository, function_repository) do

    sequence_name = params["name"]

    case repository.get_by_name(sequence_name) do
      nil ->
        {:error, "Sequence not found"}

      sequence ->
        IO.inspect(sequence)
        # Formando uma lista com os ids das funções utilizadas.
        sequence_functions_id =
          sequence.functions_sequence
          |> Enum.uniq()

        # Buscando funções no repositório.
        case function_repository.get_by_id_list(sequence_functions_id) do
          [] ->
            {:error, "Functions not found!"}

          functions_list ->
            # Montando sequência de funções.
            sequence_functions = Enum.map(sequence.functions_sequence, fn fid ->
              Enum.find(functions_list, fn function ->
                fid == function.id
              end)
            end)

            cond do
              Enum.any?(sequence_functions, fn f -> is_nil(f) end) ->
                {:error, "Some function wasn't found."}

              true ->
                # Calculando aridade da sequẽncia completa.
                sequence_arity = count_arity_sequence(sequence_functions)

                # Sequência de parâmetros.
                sequence_params = params["params"]

                if Enum.count(sequence_params) != sequence_arity do
                  {:error, "The number of params must be #{sequence_arity}"}
                else

                  process_sequence(sequence_functions, sequence_params, @type_response_no_reply, nil)
                  # {:error, "aqui"}
                end
            end
        end
    end
  end

  def count_arity_sequence(sequence) do
    # [head | tail] = sequence

    total_arity =
      Enum.reduce(sequence, {0, @type_response_no_reply} , fn block, {current_arity, type_response} ->
        cond do
          block.arity == 0 ->
            {current_arity, block.responsesType}

            type_response == @type_response_no_reply ->
            {current_arity + block.arity, block.responsesType}

          true ->
            {current_arity + block.arity - 1, block.responsesType}
        end
      end)

    {result_arity, _type_reponse} = total_arity
    result_arity
  end

  @spec process_sequence(
          [atom | %{arity: any, function: binary, module: atom | map}],
          any,
          any,
          any
        ) :: {:ok, any}
  def process_sequence([], _params, _response_type, result) do
    {:ok, result}
  end

  def process_sequence(sequence, params, response_type, result) do

    # Pegando o primeiro bloco da lista.
    [function | tail] = sequence

    # Transformando nomes de módulo e função em atoms.
    module_atom = String.to_atom("Elixir." <> function.module.module)
    function_atom = String.to_atom(function.function)

    cond do
      function.arity == 0 ->
        block_operation_response = apply(module_atom, function_atom, [])

        process_sequence(tail, params, function.responsesType, block_operation_response)

      response_type == @type_response_no_reply ->
        block_operation_response = apply(module_atom, function_atom, Enum.slice(params, 0..(function.arity - 1)))

        process_sequence(tail, Enum.drop(params, function.arity), function.responsesType, block_operation_response)

      true ->
        block_operation_response = apply(module_atom, function_atom, Enum.slice([result | params], 0..(function.arity - 1)))

        process_sequence(tail, Enum.drop(params, function.arity - 1), function.responsesType, block_operation_response)
    end
  end

  @doc """
  Delete service by id or return error if we receive an invalid id.
  """
  def delete(id, repository) do

    with {:ok, id} <- Ecto.UUID.cast(id) do
      case repository.get(id) do
        nil -> {:error, "There isn't sequence with this id."}

        sequence -> repository.delete(sequence)
      end
    else
      :error -> {:error, "Invalid id."}
    end
  end
end
