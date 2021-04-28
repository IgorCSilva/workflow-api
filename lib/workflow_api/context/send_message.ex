defmodule WorkflowApi.Context.SendMessage do

  def send_whatsapp_message(map, message) do
    %{"whatsapp" => whatsapp} = Map.take(map, ["whatsapp"])

    message_to_send =
      "=============== Envio de mensagem pelo whatsapp =================\n" <>
      "Para: #{whatsapp}\n" <>
      "Mensagem: #{message}\n" <>
      "=================================================================="

    IO.inspect(message_to_send)

    {:ok, "Message sent to client whatsapp."}
  end
end
