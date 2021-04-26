defmodule WorkflowApi.Application.Usecases.ManageDemoApp do

  alias WorkflowApi.Application.Usecases.ManageSequence
  alias WorkflowApi.Application.Usecases.ManageSheet

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

    message_response_register = "Obrigado por se cadastrar!"

    # Enviando resposta de registro para cliente.
    ManageSequence.execute_sequence(
      %{
        "name" => "response client register",
        "params" => [
          params,
          message_response_register
        ]
      },
      sequence_repository,
      function_repository
    )

    # Registrando dados do cliente no spreadsheet.
    ManageSheet.append(
      %{
        "spreadsheet_id" => "1pr5CNEnRTd9evyXBFRBWmFgCHM0IuiXA_KGvlFJpw2M",
        "range" => "Página2!A1",
        "majorDimension" => "ROWS",
        "values" => [[params["name"], params["email"], client_code, params["whatsapp"]]]
      }
    )

    register_action =
      case ManageSequence.execute_sequence(
      %{
        "name" => "client register action",
        "params" => []
      },
      sequence_repository,
      function_repository
    ) do
      {:ok, %{show_modal: _modal}= reg_action } ->
        modal_message = "Bem vindo! Você já pode começar seus teste gratuito."

        Map.put(reg_action, :message, modal_message)

      {:ok, reg_action } -> reg_action
    end

    {:ok, register_action}
  end
end
