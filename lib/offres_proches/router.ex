defmodule OffresProches.Router do
  use Plug.Router

  alias OffresProches.VerifyRequest

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(VerifyRequest, fields: ["lat", "lon", "rad"], paths: ["/offres_proches"])

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/offres_proches" do
    send_resp(conn, 201, "Liste d'offres")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
