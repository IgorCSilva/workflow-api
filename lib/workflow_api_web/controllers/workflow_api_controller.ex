defmodule WorkflowApiWeb.WorkflowApiController do
  use WorkflowApiWeb, :controller

  alias WorkflowApi.Application.Usecases.ManageWorkflowApi
  alias WorkflowApiWeb.ManageErrors

  def modules(conn, _params) do

    list = ManageWorkflowApi.modules()

    conn
    |> put_status(:ok)
    |> render("index.json", %{modules: list})
  end

  def modules_functions(conn, _params) do

    list = ManageWorkflowApi.modules_functions()

    conn
    |> put_status(:ok)
    |> render("index.json", %{modules_functions: list})
  end

  def module_functions(conn, %{"module_name" => module_name}) do

    module_name_atom = String.to_atom(module_name)
    IO.inspect(module_name_atom.__info__(:functions))

    conn
    |> put_status(:ok)
    |> render("index.json", %{functions: []})
  end

  def set_sequence(conn, params) do
    case ManageWorkflowApi.set_sequence(params) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> json(%{data: "ok"})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end
  end

  def get_sequence(conn, %{"sequence_name" => sequence_name}) do
    case ManageWorkflowApi.get_sequence(sequence_name) do
      [] ->
        conn
        |> put_status(:ok)
        |> json(%{data: nil})

      [{_key, value}] ->
        conn
        |> put_status(:ok)
        |> json(%{data: value})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end
  end

  def execute_sequence(conn, params) do

    case ManageWorkflowApi.execute_sequence(params) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{sequence_result: result})

      {:error, list_errors} ->
        ManageErrors.call(conn, list_errors, :bad_request)
    end

    # result =
    #   Enum.reduce(list_atoms, nil, fn block, acc ->
    #     if is_nil(acc) do
    #       apply_params = Enum.map(block.params, fn p ->
    #         p["value"]
    #       end)
    #       resa = apply(block.module_name_atom, block.function_atom, apply_params)
    #       IO.inspect(resa)
    #       resa
    #     else
    #       apply_params = Enum.map(block.params, fn p ->
    #         p["value"]
    #       end)
    #       IO.inspect([acc | apply_params])
    #       resa = apply(block.module_name_atom, block.function_atom, [acc | apply_params])
    #       IO.inspect(resa)
    #       resa
    #     end
    #   end)

    # IO.inspect(result)

    # # IO.inspect(apply(module_name_atom, function_atom, block_1["params"]))
    # # Enum.reduce_while()
    # conn
    # |> put_status(:ok)
    # |> render("index.json", %{functions: []})
  end
end
