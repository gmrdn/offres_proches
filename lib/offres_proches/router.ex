defmodule OffresProches.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias OffresProches.VerifyRequest
  alias OffresProches.FilterJobs

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart], json_decoder: Poison)
  plug(VerifyRequest, fields: ["lat", "lon", "rad"], paths: ["/offres_proches"])
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/offres_proches" do
    send_resp(conn, 201, FilterJobs.get_job_list(conn.query_params))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  defp handle_errors(conn, _) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
