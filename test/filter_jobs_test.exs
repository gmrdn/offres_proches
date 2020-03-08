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
end
