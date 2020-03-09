defmodule OffresProches.FilterJobs do
  use Poison.Encode

  def get_job_list(params) do
    './data/technical-test-jobs.csv'
    |> stream_csv()
    |> filter_stream_by_location_and_radius({params["lat"], params["lon"]}, params["rad"])
    |> Enum.to_list()
    |> Poison.encode!(pretty: true)
  end

  def calc_distance_km({lat1, lon1}, {lat2, lon2}) do
    floor(
      Distance.GreatCircle.distance(
        {String.to_float(lat1), String.to_float(lon1)},
        {String.to_float(lat2), String.to_float(lon2)}
      ) / 1000
    )
  end

  def is_in_radius({lat1, lon1}, {lat2, lon2}, radius) do
    calc_distance_km(
      {lat1, lon1},
      {lat2, lon2}
    ) - String.to_integer(radius) <= 0
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
      Map.get(x, "office_latitude") != "" and Map.get(x, "office_longitude") != ""
    end)
    |> Stream.filter(fn x ->
      is_in_radius(
        {Map.get(x, "office_latitude"), Map.get(x, "office_longitude")},
        {lat, lon},
        radius
      )
    end)
    |> Stream.map(fn x ->
      Map.put_new(
        x,
        "distance",
        calc_distance_km(
          {Map.get(x, "office_latitude"), Map.get(x, "office_longitude")},
          {lat, lon}
        )
      )
    end)
  end
end
