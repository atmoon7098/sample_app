class AdsController < ApplicationController
  # the before filter applies to only two actions: create and destroy, not index ...
  before_filter :authenticate, :only => [:create, :destroy]

  def create
    @ad  = current_user.ads.build(params[:ad])
    if @ad.save
      flash[:success] = "Ad created!"
      redirect_to root_path
    else
      render 'pages/home'
    end
  end

  def destroy
  end
end
