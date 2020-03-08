defmodule OffresProches.Application do

  use Application
  require Logger


  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: OffresProches.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: OffresProches.Supervisor]
    Logger.info("Starting server on http://127.0.0.1:4000/")
    Supervisor.start_link(children, opts)
  end
end
