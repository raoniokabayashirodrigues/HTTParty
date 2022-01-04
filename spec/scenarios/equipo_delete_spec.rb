describe "Delete /equipos/{equipo_id}" do
  before(:all) do
    @payload = { email: "raoni.rodriguess@gmail.com", password: "pwd123" }
    result = Sessions.new.login(@payload)
    @user_id = result.parsed_response["_id"]
  end
  #
  context "Deletar equipamento" do
    before(:all) do
      @payload =
        {
          thumbnail: thumbnail = Helpers::get_thumb("pedais.jpg"),
          name: "Pedais do Morelo",
          category: "Outros",
          price: 1000,
        }
      MongoDB.new.remove_equipo(@payload[:name], @user_id)
      #
      equipo = Equipos.new.create(@payload, @user_id)
      @equipo_id = equipo.parsed_response["_id"]
      #
      @result = Equipos.new.remove_by_id(@equipo_id, @user_id)
    end
    it "Deve retornar 204" do
      expect(@result.code).to eq(204)
    end
  end

  context "Equipo não existe" do
    before(:all) do
      @result = Equipos.new.remove_by_id(MongoDB.new.get_mongo_id, @user_id)
    end
    it "Deve retornar 204" do
      expect(@result.code).to eq(204)
    end
  end
end
