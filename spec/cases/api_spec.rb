require "spec_helper"

describe Faroo do 
  METHODS = ["news","web"]
  METHODS.each do |method|
    describe "Faroo::#{method}" do
      it "throws an exception if access is denied" do
        VCR.use_cassette "api/#{method}/no_token" do
          api_key = "a"
          api = Faroo.new(api_key)
          expect {api.send(method,"test")}.to raise_error
        end
      end
      it "returns some results" do
        VCR.use_cassette "api/#{method}/1" do
          api = Faroo.new(ENV["TOKEN"])
          expect(api.send(method,"test").empty?).to eq(false)
        end
      end
      it "returns the correct number of results" do
        VCR.use_cassette "api/#{method}/2" do
          api = Faroo.new(ENV["TOKEN"], {num_results: 8})
          expect(api.send(method,"test").length).to eq(8)
        end
      end
      it "return the same result using the same cassette" do
        VCR.use_cassette "api/#{method}/4" do
          api = Faroo.new(ENV["TOKEN"])
          result1 = api.send(method,"test")
          VCR.use_cassette "api/#{method}/5" do
            result2 = api.send(method,"test")
            expect(result1 == result2).to eq(true)
          end
        end
      end
      it "return different results using the start parameters" do
        VCR.use_cassette "api/#{method}/4" do
          api = Faroo.new(ENV["TOKEN"])
          result1 = api.send(method,"test")
          VCR.use_cassette "api/#{method}/6" do
            result2 = api.send(method,"test",2)
            expect(result1 != result2).to eq(true)
          end
        end
      end
      it "return different results using the language parameters" do
        VCR.use_cassette "api/#{method}/4" do
          api = Faroo.new(ENV["TOKEN"])
          result1 = api.send(method,"test")
          VCR.use_cassette "api/#{method}/7" do
            result2 = api.send(method,"test",1,"zh")
            expect(result1 != result2).to eq(true)
          end
        end
      end
      it "return empty if no results" do
        VCR.use_cassette "api/#{method}/8" do
          api = Faroo.new(ENV["TOKEN"])
          expect(api.send(method,"ahtneanhean").empty?).to eq(true)
        end
      end
    end
  end
end
