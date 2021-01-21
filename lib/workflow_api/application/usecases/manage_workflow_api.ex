defmodule WorkflowApi.Application.Usecases.ManageWorkflowApi do

  def modules do
    {:ok, list} = :application.get_key(:workflow_api, :modules)

    Enum.filter(list, fn module ->
      module in [WorkflowApi.Context.Calculator]
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
    IO.inspect(params["_json"])
    sequence_name = params["route_name"]
    sequence = params["_json"]

    # {:ok, encoded_sequence} = Poison.encode(sequence)
    :ets.insert(:sequence_operations, {sequence_name, sequence})
    {:ok, "foi"}
  end

  def get_sequence(sequence_name) do
    :ets.lookup(:sequence_operations, sequence_name)
  end

  def execute_blocks(params) do
    IO.inspect(params)
    list_blocks_atoms = Enum.map(params["sequence"], fn block ->
      %{
        module_name_atom: String.to_atom(block["moduleName"]),
        function_atom: String.to_atom(block["function"]),
        params: block["params"]
      }
    end)

    IO.inspect(list_blocks_atoms)
    process_blocks(list_blocks_atoms, :start)
  end

  def process_blocks([], result) do
    {:ok, result}
  end

  def process_blocks(list, result) do

    # Pegando o primeiro bloco da lista.
    [block | tail] = list

    formated_params = format_params(block.params, result)
    IO.inspect(formated_params)


    case {block.module_name_atom} do
      {WorkflowApi.Context.Calculator} ->

        block_operation_response = apply(block.module_name_atom, block.function_atom, formated_params)
        IO.inspect(block_operation_response)

        process_blocks(tail, block_operation_response)
    end
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
