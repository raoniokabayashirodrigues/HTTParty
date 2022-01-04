describe "POST /equipos" do
  before(:all) do
    payload = { email: "raoni.rodriguess@gmail.com", password: "pwd123" }
    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "Novo Equipo" do
    before(:all) do
      payload =
        {
          thumbnail: thumbnail = Helpers::get_thumb("kramer.jpg"),
          name: "Kramer Eddie Van Hallen",
          category: "Cordas",
          price: 299,
        }

      MongoDB.new.remove_equipo(payload[:name], @user_id)
      @result = Equipos.new.create(payload, @user_id)
    end

    it "Deve retornar 200" do
      expect(@result.code).to eq(200)
    end
  end

  context "NÃO AUTORIZADO" do
    before(:all) do
      payload =
        {
          thumbnail: thumbnail = Helpers::get_thumb("fodera_bass.jpg"),
          name: "Contrabaixo",
          category: "Cordas",
          price: 299,
        }

      @result = Equipos.new.create(payload, nil)
    end

    it "Deve retornar 401" do
      expect(@result.code).to eq(401)
    end
    it "Deve retornar a mensagem: Unauthorized" do
      expect(@result.parsed_response["error"]).to eql("Unauthorized")
    end
  end
end
