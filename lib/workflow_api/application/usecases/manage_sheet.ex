defmodule WorkflowApi.Application.Usecases.ManageSheet do

  # Connect with Spreadsheets.
  defp connect do
    case Goth.Token.for_scope("https://www.googleapis.com/auth/spreadsheets") do
      {:ok, token} -> {:ok, GoogleApi.Sheets.V4.Connection.new(token.token)}

      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Read data from spreadsheet.
  """
  def read(params) do
    with {:ok, conn} <- connect(),
      %{"spreadsheet_id" => spreadsheet_id, "range" => range} <- params,
      {:ok, %GoogleApi.Sheets.V4.Model.ValueRange{values: values}} <-
        GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_values_get(conn, spreadsheet_id, range) do

      {:ok, values}

    else
      {:error, %Tesla.Env{body: body}} -> Poison.decode(body)
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Append data in spreadsheet.
  """
  def append(params) do
    with {:ok, conn} <- connect(),
      %{
        "spreadsheet_id" => spreadsheet_id,
        "range" => range,
        "majorDimension" => majorDimension,
        "values" => values
      } <- params,
      {:ok, %GoogleApi.Sheets.V4.Model.AppendValuesResponse{updates: updates}} <-
        GoogleApi.Sheets.V4.Api.Spreadsheets.sheets_spreadsheets_values_append(
          conn,
          spreadsheet_id,
          range,
          [
            {
              :body,
              %GoogleApi.Sheets.V4.Model.ValueRange{
                majorDimension: majorDimension,
                range: range,
                values: values
              }
            },
            {
              :valueInputOption,
              "USER_ENTERED"
            }
          ]
        ) do

      {:ok, updates}

    else
      {:error, %Tesla.Env{body: body}} -> Poison.decode(body)
      {:error, reason} -> {:error, reason}
      catch_error -> IO.inspect(catch_error)
    end
  end
end
