defmodule OffresProches.FilterJobs do
  use Poison.Encode

  def get_job_list({lat, lon}, radius) do
    './data/technical-test-jobs.csv'
    |> stream_csv()
    |> filter_stream_by_location_and_radius({lat, lon}, radius)
    |> Enum.to_list()
    |> Poison.encode!()
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
    |> Stream.map(fn {:ok, map} -> map end)
  end

  def filter_stream_by_location_and_radius(stream, {lat, lon}, radius) do
    stream
    |> Stream.filter(fn x ->
      is_in_radius(
        {String.to_float(Map.get(x, "office_latitude")),
         String.to_float(Map.get(x, "office_longitude"))},
        {lat, lon},
        radius
      )
    end)
  end
end
