defmodule OffresProches.FilterJobs do
  use Poison.Encode

  def get_job_list() do
    Poison.encode!(%{
      "jobs" => [
        %{
          "profession_id" => 7,
          "contract_type" => "INTERNSHIP",
          "name" =>
            "[Louis Vuitton Germany] Praktikant (m/w) im Bereich Digital Retail (E-Commerce)",
          "office_latitude" => 48.1392154,
          "office_longitude" => 11.5781413
        },
        %{
          "profession_id" => 5,
          "contract_type" => "INTERNSHIP",
          "name" => "Bras droit de la fondatrice",
          "office_latitude" => 48.885247,
          "office_longitude" => 2.3566441
        }
      ]
    })
  end

  def calc_distance_km({lat1, lon1}, {lat2, lon2}) do
    floor(Distance.GreatCircle.distance({lat1, lon1}, {lat2, lon2}) / 1000)
  end

  def is_in_radius({lat1, lon1}, {lat2, lon2}, radius) do
    calc_distance_km({lat1, lon1}, {lat2, lon2}) - radius <= 0
  end

  def stream_csv(file) do
    file
    |> File.stream!()
    |> CSV.decode(separator: ?,, headers: true)
  end

  def filter_datastream_by_location_and_radius(data, {lat, lon}, radius) do
    data
    |> Stream.filter(fn x ->
      is_in_radius(
        {String.to_float(Map.get(x, "office_latitude")),
         String.to_float(Map.get(x, "office_longitude"))},
        {lat, lon},
        radius
      )
    end)
    |> Enum.take(3)
  end
end
