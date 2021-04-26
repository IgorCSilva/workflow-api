defmodule WorkflowApi.Context.RegisterClient do

  def get_name(client) do
    %{"name" => name} = Map.take(client, ["name"])
    name
  end

  def get_email(client) do
    %{"email" => email} = Map.take(client, ["email"])
    email
  end

  def send_whatsapp_message(client, message) do
    %{"whatsapp" => whatsapp} = Map.take(client, ["whatsapp"])

    message_to_send =
      "=============== Envio de mensagem pelo whatsapp =================\n" <>
      "Para: #{whatsapp}\n" <>
      "Mensagem: #{message}\n" <>
      "=================================================================="

    IO.inspect(message_to_send)

    {:ok, "Message sent to client whatsapp."}
  end

  def send_email_message(client, message) do
    %{"email" => email} = Map.take(client, ["email"])

    message_to_send =
      """
      =============== Envio de mensagem para o email =================
      Para: #{email}
      Mensagem: #{message}
      ==================================================================
      """

    IO.inspect(message_to_send)

    {:ok, "Message sent to client email."}
  end

  def send_half_email_half_whatsapp(client, message) do
    %{"email" => email} = Map.take(client, ["email"])
    %{"whatsapp" => whatsapp} = Map.take(client, ["whatsapp"])


    message_to_send =
      case Enum.random(0..1) do
        0 ->
          """
          =============== Envio de mensagem para o email =================
          Para: #{email}
          Mensagem: #{message}
          ==================================================================
          """

        1 ->
          """
          =============== Envio de mensagem para o whatsapp =================
          Para: #{whatsapp}
          Mensagem: #{message}
          ==================================================================
          """
      end

    IO.inspect(message_to_send)

    {:ok, "Message sent to client email."}
  end

end
