defmodule Client do
  @moduledoc """
  Cria processos representando clientes e, para cada um, realiza um número
  determinado de requisições ao servidor.
  """

  # Nome do nó do servidor.
  @server_node :"workflow2@igor-Inspiron-5590"

  # Repository
  @sequence_repository Application.get_env(:workflow_api, :sequence_repository)
  @function_repository Application.get_env(:workflow_api, :function_repository)

  @doc """
  Mostra o tempo de duração de uma request na tela caso n esteja dentro
  do range determinado.
  """
  def print_time(time, n)

  def print_time(time, n) when n > 1000 do
    IO.inspect(time)
  end

  def print_time(_, _), do: nil

  @doc """
  Lança processos representando os clientes.
  """
  def create_clients(n_clients, n_operations, server_node \\ @server_node) do

    # Loop para criar a quantidade de clientes determinada por n_clients.
    Enum.each(1..n_clients, fn(n_client) ->

      if (n_client == 1) do
        # Caso o cliente seja o primeiro executar a função que faz as requisições
        # ao servidor, mede o tempo de resposta e mostra na tela.
        _pid = spawn(Client, :call_and_time, [n_operations, server_node])
      else
        # Caso o cliente não seja o primeiro executar a função que apenas faz as
        # requisições ao servidor.
        _pid = spawn(Client, :call, [n_operations, server_node])
      end
    end)
  end

  @doc """
  Realiza uma quantidade de requisições ao servidor
  e mede o tempo decorrido de cada uma.
  """
  def call_and_time(n_operations, server_node) do

    # Loop para executar as várias requisições.

    # Variando a operação de acordo com n.
    # Com :timer.tc o tempo de execução é medido. Como argumento passamos :erpc(módulo
    # para chamadas rpc), :call(a função do módulo que quero executar), e os parâmetros
    # indicando o nome do nó do servidor, o módulo daquele nó, a função que desejo executar
    # e os parâmetros desta última função, respectivamente.
    Enum.each(1..n_operations, fn(n) ->
      {time, _result} = :timer.tc(:erpc, :call, [server_node, WorkflowApi.Application.Usecases.ManageSequence, :execute_sequence, [%{"name" => "postman","params" => [[1, 2], 5]}, @sequence_repository, @function_repository]])
      print_time(time, n)
    end)
  end

  @doc """
  Realiza uma quantidade de requisições ao servidor.
  """
  def call(n_operations, server_node) do

    # Loop para realizar as operações.
    Enum.each(1..n_operations, fn(_) ->

      # Variando as operações de acordo com o valor de n.
      # As requisições são feitas ao servidor utilizando a função call do
      # módulo :erpc. Os parâmetros indicam o nome do nó do servidor, o
      # módulo daquele nó, a função que desejo executar e os parâmetros da
      # função, respectivamente.

      :erpc.call(server_node, WorkflowApi.Application.Usecases.ManageSequence, :execute_sequence, [%{"name" => "postman","params" => [[1, 2], 5]}, @sequence_repository, @function_repository])

    end)
  end

end
