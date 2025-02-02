defmodule Medirepo.Bulletins.GetValidTest do
  use Medirepo.DataCase, async: true

  alias Medirepo.Bulletins
  alias Medirepo.Bulletins.Models.Bulletin
  alias Medirepo.Hospitals
  alias Medirepo.Hospitals.Models.Hospital

  import Medirepo.Factory

  describe "get_valid/4" do
    setup do
      params_hosp = build(:hospital_params)

      {:ok,
       %Hospital{
         id: hosp_id
       }} = Hospitals.create_hospital(params_hosp)

      {:ok, hosp_id: hosp_id}
    end

    test "when id is valid, returns the bulletin", %{hosp_id: hosp_id} do
      params = build(:bulletin_params, %{"hospital_id" => hosp_id})

      {:ok,
       %Bulletin{
         dt_birth: dt_nasc,
         attendance: atend,
         cd_patient: cd_pac
       }} = Bulletins.create_bulletin(params)

      response =
        Bulletins.get_valid(%{
          "login" => cd_pac,
          "password" => atend,
          "dt_nasc" => dt_nasc,
          "id" => hosp_id
        })

      assert {:ok,
              %Bulletin{
                name: "Andre"
              }} = response
    end

    test "when id is invalid, returns an error", %{hosp_id: hosp_id} do
      params = build(:bulletin_params, %{"hospital_id" => hosp_id})

      {:ok,
       %Bulletin{
         dt_birth: dt_nasc,
         attendance: atend,
         cd_patient: _cd_pac
       }} = Bulletins.create_bulletin(params)

      response =
        Bulletins.get_valid(%{
          "login" => 9999,
          "password" => atend,
          "dt_nasc" => dt_nasc,
          "id" => hosp_id
        })

      assert {:error, %Medirepo.Error{result: "Bulletin not found", status: :not_found}} =
               response
    end
  end
end
