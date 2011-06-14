require 'spec_helper'

describe AdsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  # test action for creating ads and destroy ad, need user to signin
  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do
      # if description is blank, it should not be allowed to create an ad
      before(:each) do
        @attr = { :description => "" }
      end

      it "should not create an ad" do
        lambda do
          post :create, :ad => @attr
        end.should_not change(Ad, :count)
      end

      it "should render the home page" do
        post :create, :ad => @attr
        response.should render_template('pages/home')
      end
    end
    
    describe "success" do
      # if description provided, it should create an Ad and bump up the count by 1 
      before(:each) do
        @attr = { :description => "Lorem ipsum" }
      end

      it "should create an ad" do
        lambda do
          post :create, :ad => @attr
        end.should change(Ad, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :ad => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :ad => @attr
        flash[:success].should =~ /ad created/i
      end
    end
  end
end