defmodule WorkflowApiWeb.SpreadSheetView do
  use WorkflowApiWeb, :view

  alias WorkflowApiWeb.SpreadSheetView

  def render("append_updates.json", %{spread_sheet: updates}) do
    %{
      data: %{
        spreadsheetId: updates.spreadsheetId,
        updatedCells: updates.updatedCells,
        updatedColumns: updates.updatedColumns,
        updatedData: updates.updatedData,
        updatedRange: updates.updatedRange,
        updatedRows: updates.updatedRows
      }
    }
  end
end
