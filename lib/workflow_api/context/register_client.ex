defmodule WorkflowApi.Context.RegisterClient do

  def get_name(client) do
    %{"name" => name} = Map.take(client, ["name"])
    name
  end

  def get_email(client) do
    %{"email" => email} = Map.take(client, ["email"])
    email
  end
end
