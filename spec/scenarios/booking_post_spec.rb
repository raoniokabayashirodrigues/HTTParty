describe "POST /equipos/{equipo_id}/bookings" do
  before(:all) do
    payload_ed = { email: "ed@gmail.com", password: "pwd123" }
    result = Sessions.new.login(payload_ed)
    @ed_id = result.parsed_response["_id"]
  end

  context "Solicitar locação" do
    before(:all) do
      #   dado que "Joe Perry" tem uma "Fender Strato" para locação
      payload_joe = { email: "joe@gmail.com", password: "pwd123" }
      result_joe = Sessions.new.login(payload_joe)
      joe_id = result_joe.parsed_response["_id"]

      fender = {
        thumbnail: thumbnail = Helpers::get_thumb("fender-sb.jpg"),
        name: "Fender Strato",
        category: "Cordas",
        price: 12658,
      }

      MongoDB.new.remove_equipo(fender[:name], joe_id)
      result = Equipos.new.create(fender, joe_id)
      fender_id = result.parsed_response["_id"]

      # quando solicito a locação da Fender do Joe Perry
      @result = Equipos.new.booking(fender_id, @ed_id)
    end

    it "Espero retornar 200" do
      expect(@result.code).to eq(200)
    end
  end
end
