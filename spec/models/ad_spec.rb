require 'spec_helper'

describe Ad do

  before(:each) do
    @user = Factory(:user)
    @attr = { :description => "value for description" }
  end
  
  it "should create a new instance given valid attributes" do
    @user.ads.create!(@attr)
  end
  
  describe "user associations" do

    before(:each) do
      @ad = @user.ads.create(@attr)
    end

    it "should have a user attribute" do
      @ad.should respond_to(:user)
    end

    it "should have the right associated user" do
      @ad.user_id.should == @user.id
      @ad.user.should == @user
    end
  end
  
  describe "validations" do

    it "should require a user id" do
      Ad.new(@attr).should_not be_valid
    end

    it "should require nonblank description" do
      @user.ads.build(:description => "  ").should_not be_valid
    end

    #it "should reject long content" do
    #  @user.microposts.build(:content => "a" * 141).should_not be_valid
    #end
  end
end
