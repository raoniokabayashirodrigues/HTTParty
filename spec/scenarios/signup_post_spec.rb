describe "POST /Signup" do
  context "Novo usuário" do
    before(:all) do
      payload = { name: "Ton Cruise Rodrigues", email: "ton.cruise@gmail.com", password: "pwd123" }
      MongoDB.new.remove_user(payload[:email])
      @result = Signup.new.create(payload)
    end
    it "Valida status code" do
      expect(@result.code).to eql(200)
    end
    it "Valida ID do usuário" do
      expect(@result.parsed_response["_id"].length).to eql(24)
    end
  end

  context "Usuário já existe" do
    before(:all) do
      payload = { name: "Ton Cruise Rodrigues", email: "ton.cruise@gmail.com", password: "pwd123" }
      Signup.new.create(payload)
      @result = Signup.new.create(payload)
    end

    it "Valida status code 409" do
      expect(@result.code).to eql(409)
    end

    it "Deve retornar a mensagem de erro: Email already exists :(" do
      expect(@result.parsed_response["error"]).to eql("Email already exists :(")
    end
  end

  context "Nome é obrigatório" do
    before(:all) do
      payload = { name: "", email: "ton.cruise@gmail.com", password: "pwd123" }
      @result = Signup.new.create(payload)
    end

    it "Valida status code 412" do
      expect(@result.code).to eql(412)
    end

    it "Deve retornar a mensagem de erro: required name" do
      expect(@result.parsed_response["error"]).to eql("required name")
    end
  end

  context "Email é obrigatório" do
    before(:all) do
      payload = { name: "Ton Cruise Rodrigues", email: "", password: "pwd123" }
      @result = Signup.new.create(payload)
    end

    it "Valida status code 412" do
      expect(@result.code).to eql(412)
    end

    it "Deve retornar a mensagem de erro: required email" do
      expect(@result.parsed_response["error"]).to eql("required email")
    end
  end
  context "Senha é obrigatória" do
    before(:all) do
      payload = { name: "Ton Cruise Rodrigues", email: "ton.cruise@gmail.com", password: "" }
      @result = Signup.new.create(payload)
    end

    it "Valida status code 412" do
      expect(@result.code).to eql(412)
    end

    it "Deve retornar a mensagem de erro: required password" do
      expect(@result.parsed_response["error"]).to eql("required password")
    end
  end
end
