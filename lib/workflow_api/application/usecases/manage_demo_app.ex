defmodule WorkflowApi.Application.Usecases.ManageDemoApp do

  alias WorkflowApi.Application.Usecases.ManageSequence

  def register_client(params, sequence_repository, function_repository) do
    IO.inspect(params)

    client_code =
      case ManageSequence.execute_sequence(
        %{
          "name" => "client code",
          "params" => [
            params
          ]
        },
        sequence_repository,
        function_repository
      ) do

        {:ok, client_code} -> client_code

        _ -> params["email"]
      end
    IO.inspect(Map.put(params, :code, client_code))

    {:ok, Map.put(params, :code, client_code)}
  end
end
