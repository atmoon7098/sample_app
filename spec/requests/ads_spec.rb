require 'spec_helper'

describe "Ads" do
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new ad" do
        lambda do
          visit root_path
          fill_in :ad_description, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Ad, :count)
      end
    end

    describe "success" do

      it "should make a new ad" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :ad_description, :with => description
          click_button
          response.should have_selector("span.description", :description => description)
        end.should change(Ad, :description).by(1)
      end
    end
  end
end
