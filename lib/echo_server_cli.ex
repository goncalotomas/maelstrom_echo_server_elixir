defmodule EchoServer.CLI do
  def main(_args) do
    IO.puts(:stderr, "Online")
    loop(%{})
  end

  defp loop(state) do
    message = read_message()
    body = message["body"]

    case body["type"] do
      "init" ->
        node_id = body["node_id"]
        IO.puts(:stderr, "Initialized node #{node_id}")

        reply(node_id, message, %{
          "type" => "init_ok"
        })

        loop(%{node_id: node_id})

      "echo" ->
        IO.puts(:stderr, "Echoing #{body["echo"]}")

        reply(state.node_id, message, %{
          "type" => "echo_ok",
          "echo" => body["echo"]
        })

        loop(state)
    end
  end

  defp reply(node_id, message, body) do
    response_body =
      Map.merge(body, %{
        "in_reply_to" => message["body"]["msg_id"],
        "msg_id" => :erlang.unique_integer([:positive, :monotonic])
      })

    response = %{
        "body" => response_body,
        "src" => node_id,
        "dest" => message["src"]
      })

    {:ok, response} = JSON.encode(response)
    IO.puts(:stderr, "Sending #{response}")
    IO.puts(:stdio, response)
  end

  defp read_message() do
    raw_message = IO.read(:stdio, :line)
    IO.puts(:stderr, "Received #{raw_message}")
    {:ok, message} = JSON.decode(raw_message)
    message
  end
end
