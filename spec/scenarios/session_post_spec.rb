##################################################################################
describe "POST /sessions" do
  context "Login com Sucesso" do
    before(:all) do
      payload = { email: "raoni.rodriguess@gmail.com", password: "pwd123" }
      @response = Sessions.new.login(payload)
    end
    it "Valida status code" do
      expect(@response.code).to eql(200)
    end
    it "Valida ID do usuário" do
      expect(@response.parsed_response["_id"].length).to eql(24)
    end
  end

  ##################################################################################
  examples = Helpers::get_fixture("login")

  examples.each do |e|
    context "Tentativa de Login - #{e[:title]}" do
      before(:all) do
        @response = Sessions.new.login(e[:payload])
      end
      it "Valida status code - #{e[:code]}" do
        expect(@response.code).to eql(e[:code])
      end
      it "Valida mensagem de erro - #{e[:error]}" do
        expect(@response.parsed_response["error"]).to eql(e[:error])
      end
    end
  end
end
