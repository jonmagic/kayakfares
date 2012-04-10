require 'spec_helper'

describe KayakFares do
  let(:params) { {:from => "SBN", :to => "VRN", :depart => "5/15/2012", :return => "5/20/2012"} }
  subject { KayakFares.new(params) }

  before(:each) do
    VCR.use_cassette "search" do
      subject.load_page
    end
  end

  it "should pass a test" do
    subject.should be_instance_of(KayakFares)
  end

  describe "#compiled_params" do
    it "compiles and escapes params" do
      subject.compiled_params.should == "l1=SBN&l2=VRN&d1=5%2F15%2F2012&d2=5%2F20%2F2012"
    end
  end

  describe "#url" do
    it "returns api url with parameters" do
      subject.url.should == "http://www.kayak.com/s/search/air?l1=SBN&l2=VRN&d1=5%2F15%2F2012&d2=5%2F20%2F2012"
    end
  end

  describe "#load_page" do
    it "loads the search page" do
      subject.load_page.should be_instance_of(Mechanize::Page)
    end
  end

  describe "#extract_rows" do
    it "returns instance of Nokogiri::XML::NodeSet" do
      subject.extract_rows.should be_instance_of(Nokogiri::XML::NodeSet)
    end

    context "first item in array" do
      it "is an instance of Nokogiri::XML::Element" do
        subject.extract_rows[0].should be_instance_of(Nokogiri::XML::Element)
      end
    end
  end

  describe "#results" do
    it "should be an instance of array" do
      subject.results.should be_instance_of(Array)
    end

    context "first item in array" do
      let(:result) { subject.results[0] }

      it "has price" do
        result[:price].should == "$1240"
      end

      it "has airline" do
        result[:airline].should == "Multiple Airlines"
      end

      it "has leg0 departure time" do
        result[:leg0_departure_time].should == "7:44p"
      end

      it "has leg0 arrival time" do
        result[:leg0_arrival_time].should == "10:35p"
      end

      it "has leg0 duration" do
        result[:leg0_duration].should == "20h 51m"
      end

      it "has leg1 departure time" do
        result[:leg1_departure_time].should == "6:55a"
      end

      it "has leg1 arrival time" do
        result[:leg1_arrival_time].should == "11:26p"
      end

      it "has leg1 duration" do
        result[:leg1_duration].should == "22h 31m"
      end

      it "has a booking url" do
        result[:booking_url].should == "http://www.kayak.com/book/flight?code=-1834988415.NECDjXkE5.0.F.AIRFAREDOTCOM,AIRFAREDOTCOM.123964.1c0c248fe00bda24d7ad8b0304f6e0ec&sub=E-15139c05ccb&resultid=1c0c248fe00bda24d7ad8b0304f6e0ec&sr=1&pg=0&cp=0-46-264"
      end
    end
  end
end