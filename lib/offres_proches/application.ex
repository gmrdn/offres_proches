defmodule OffresProches.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: OffresProches.Router, options: [port: cowboy_port()]}
    ]

    opts = [strategy: :one_for_one, name: OffresProches.Supervisor]
    Logger.info("Starting server on http://127.0.0.1:" <> Integer.to_string(cowboy_port()) <> "/")
    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:offres_proches, :cowboy_port, 4000)
end
