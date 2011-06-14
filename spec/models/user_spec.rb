require 'spec_helper'

describe User do
   before(:each) do
    @attr = { 
	    :name => "Example User", 
		:email => "user@example.com",
		:password => "foobar",
		:password_confirmation => "foobar"
	}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
   it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
   it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end 
  
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
	
	it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
	
	describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 
    end
	
	describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end 
  # Add for testing an admin attribute
  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  # Add test for has_many association
  describe "ad associations" do

    before(:each) do
      @user = User.create(@attr)
	  @ad1 = Factory(:ad, :user => @user, :created_at => 1.day.ago)
      @ad2 = Factory(:ad, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a ads attribute" do
      @user.should respond_to(:ads)
    end
	
	it "should have the right ads in the right order" do
      @user.ads.should == [@ad2, @ad1]
    end
	
	it "should destroy associated ads" do
      @user.destroy
      [@ad1, @ad2].each do |ad|
        Ad.find_by_id(ad.id).should be_nil
      end
    end
	
	# test for feed 
	describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
        @user.feed.include?(@ad1).should be_true
        @user.feed.include?(@ad2).should be_true
      end

      it "should not include a different user's ads" do
        ad3 = Factory(:ad,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(ad3).should be_false
      end
    end
  end
end
