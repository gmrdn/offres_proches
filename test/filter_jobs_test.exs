defmodule OffresProches.FilterJobsTest do
  use ExUnit.Case, async: true
  alias OffresProches.FilterJobs

  @marseille {43.2805546, 5.2400687}
  @aix {43.536137, 5.2475193}
  @paris {48.8589996, 2.2066329}

  test "Get a parsable json file" do
    json = FilterJobs.get_job_list()
    assert {:ok, parsed} = Poison.Parser.parse(json)
  end

  test "Should calculate the distance between two locations" do
    distance = FilterJobs.calc_distance_km(@marseille, @aix)
    assert distance == 28
  end

  test "Should know that Aix is in the radius of Marseille plus 30 km" do
    assert FilterJobs.is_in_radius(@marseille, @aix, 30) == true
  end

  test "Should know that Paris is not in the radius of Marseille plus 30 km" do
    assert FilterJobs.is_in_radius(@paris, @marseille, 30) == false
  end

  test "Should filter a CSV file by radius" do
    data = [
      %{
        "contract_type" => "INTERNSHIP",
        "name" =>
          "[Louis Vuitton Germany] Praktikant (m/w) im Bereich Digital Retail (E-Commerce)",
        "office_latitude" => "48.1392154",
        "office_longitude" => "11.5781413",
        "profession_id" => "7"
      },
      %{
        "contract_type" => "INTERNSHIP",
        "name" => "Bras droit de la fondatrice",
        "office_latitude" => "48.885247",
        "office_longitude" => "2.3566441",
        "profession_id" => "5"
      },
      %{
        "contract_type" => "FULL_TIME",
        "name" => "[Louis Vuitton North America] Team Manager, RTW - NYC",
        "office_latitude" => "40.7630463",
        "office_longitude" => "-73.973527",
        "profession_id" => "31"
      }
    ]

    assert FilterJobs.filter_datastream_by_location_and_radius(data, @paris, 30) ==
             [
               %{
                 "contract_type" => "INTERNSHIP",
                 "name" => "Bras droit de la fondatrice",
                 "office_latitude" => "48.885247",
                 "office_longitude" => "2.3566441",
                 "profession_id" => "5"
               }
             ]
  end
end
