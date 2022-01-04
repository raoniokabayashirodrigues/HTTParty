describe "GET /equipos/{equipo_id}" do
  before(:all) do
    @payload = { email: "raoni.rodriguess@gmail.com", password: "pwd123" }
    result = Sessions.new.login(@payload)
    @user_id = result.parsed_response["_id"]
  end
  #
  context "Obter único equipo" do
    before(:all) do
      @payload =
        {
          thumbnail: thumbnail = Helpers::get_thumb("sanfona.jpg"),
          name: "Sanfona",
          category: "Outros",
          price: 5999,
        }
      MongoDB.new.remove_equipo(@payload[:name], @user_id)
      #
      equipo = Equipos.new.create(@payload, @user_id)
      @equipo_id = equipo.parsed_response["_id"]
      #
      @result = Equipos.new.get_by_id(@equipo_id, @user_id)
    end
    it "Deve retornar 200" do
      expect(@result.code).to eq(200)
    end

    it "Deve validar nome" do
      expect(@result.parsed_response).to include("name" => @payload[:name])
    end
  end

  context "Equipo não existe" do
    before(:all) do
      @result = Equipos.new.get_by_id(MongoDB.new.get_mongo_id, @user_id)
    end

    it "Deve retornar 404" do
      expect(@result.code).to eql(404)
    end
  end
end

describe "GET /equipo" do
  before(:all) do
    payload = { email: "penelope.rodriguess@gmail.com", password: "pwd123" }
    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end
  context "Obtem lista" do
    before(:all) do
      payloads = [
        {
          thumbnail: thumbnail = Helpers::get_thumb("fodera_bass.jpg"),
          name: "Baixo Fodera",
          category: "Cordas",
          price: 29235,
        },
        {
          thumbnail: thumbnail = Helpers::get_thumb("sanfona.jpg"),
          name: "Sanfona",
          category: "Outros",
          price: 6805,
        },
        {
          thumbnail: thumbnail = Helpers::get_thumb("trompete.jpg"),
          name: "Trompete",
          category: "Outros",
          price: 1050,
        },
      ]

      payloads.each do |payload|
        MongoDB.new.remove_equipo(payload[:name], @user_id)
        Equipos.new.create(payload, @user_id)
      end
      @result = Equipos.new.list(@user_id)
    end
    it "Deve retornar 200" do
      expect(@result.code).to eq(200)
    end

    it "Deve retornar uma lista de equipos" do
      puts @result.parsed_response
      puts @result.parsed_response.class
      expect(@result.parsed_response).not_to be_empty
    end
  end
end
