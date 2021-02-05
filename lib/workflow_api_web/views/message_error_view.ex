defmodule WorkflowApiWeb.MessageErrorView do
  use WorkflowApiWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("message_error.json", %{message_error: message_error}) do
    %{errors: message_error}
  end
end
