defmodule WorkflowApi.Application.Usecases.ManageWorkflowApi do

  @doc """
  Retorna todos os módulos filhos de Context.
  """
  def modules do
    {:ok, list} = :application.get_key(:workflow_api, :modules)

    Enum.filter(list, fn module ->
      module
      |> to_string()
      |> String.starts_with?("Elixir.WorkflowApi.Context")
    end)

  end
  def modules_functions() do

    modules_functions =
      modules()
      |> get_modules_functions()

    IO.inspect(modules_functions)
    modules_functions
  end

  def get_modules_functions(modules) do
    Enum.map(modules, fn module ->
      %{
        module: module,
        functions: module.__info__(:functions)
      }
    end)
  end

  def set_sequence(params) do
    IO.inspect(params)

    sequence_name = params["sequence_name"]

    :ets.insert(:sequence_operations, {sequence_name, Map.take(params, ["sequence", "links"])})

    {:ok, "ok"}
  end

  def sequences() do
    :ets.tab2list(:sequence_operations)
  end

  @spec get_sequence(any) :: [tuple]
  def get_sequence(sequence_name) do
    :ets.lookup(:sequence_operations, sequence_name)
  end

  def execute_sequence(params) do

    sequence_name = params["sequence_name"]
    IO.inspect(params)
    case :ets.lookup(:sequence_operations, sequence_name) do
      [] ->
        {:error, "Sequence name not found"}

      [{_key_sequence_name, []}] ->
        {:ok, "Empty sequence!"}

      [{_key_sequence_name, stored_sequence}] ->
        # Pegando a sequência de operações, ignorando a lista de links.
        sequence_operations = stored_sequence["sequence"]

        IO.inspect(sequence_operations)

        # Calculando aridade da sequẽncia completa.
        sequence_arity = count_arity_sequence(sequence_operations)

        # Sequência de parâmetros.
        sequence_params = params["sequence"]

        if Enum.count(sequence_params) != sequence_arity do
          {:error, "The number of params must be #{sequence_arity}"}
        else

          process_sequence(sequence_operations, sequence_params, :start)
        end

      _ -> {:error, "Some error occurred."}
    end
  end

  def count_arity_sequence(sequence) do
    [head | tail] = sequence

    total_tail_arity =
      Enum.reduce(tail, 0, fn block, acc ->
        if block["arity"] == 0 do
          acc
        else
          acc + block["arity"] - 1
        end
      end)

    total_tail_arity + head["arity"]
  end

  def process_sequence([], _params, result) do
    {:ok, result}
  end

  def process_sequence(sequence, params, result) do

    # Pegando o primeiro bloco da lista.
    [block | tail] = sequence

    # formated_params = format_params(block,  result)

    if result == :start do
      block_operation_response = apply(String.to_atom(block["module"]), String.to_atom(block["function"]), Enum.slice(params, 0..(block["arity"] - 1)))
      IO.inspect(block_operation_response)

      process_sequence(tail, Enum.drop(params, block["arity"]), block_operation_response)

    else
      cond do
        block["arity"] == 0 ->
          block_operation_response = apply(String.to_atom(block["module"]), String.to_atom(block["function"]), [])
          IO.inspect(block_operation_response)
          process_sequence(tail, params, block_operation_response)

        block["arity"] == 1 ->
          block_operation_response = apply(String.to_atom(block["module"]), String.to_atom(block["function"]), [result])
          IO.inspect(block_operation_response)
          process_sequence(tail, params, block_operation_response)

        true ->
          block_operation_response = apply(String.to_atom(block["module"]), String.to_atom(block["function"]), [result | Enum.slice(params, 0..((block["arity"]- 1) - 1))])
          IO.inspect(block_operation_response)

          process_sequence(tail, Enum.drop(params, block["arity"] - 1), block_operation_response)
      end




    end


    # case {block.module_name_atom} do
    #   {WorkflowApi.Context.Calculator} ->

    #     block_operation_response = apply(block.module_name_atom, block.function_atom, formated_params)
    #     IO.inspect(block_operation_response)

    #     process_blocks(tail, block_operation_response)
    # end
  end

  def format_params(block_params, result) do
    params_list = Enum.map(block_params, fn p ->
      p["value"]
    end)

    unless result == :start do
      [result | params_list]
    else
      params_list
    end
  end
end
