class AdsController < ApplicationController
  # the before filter applies to only two actions: create and destroy, not index ...
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def create
    @ad  = current_user.ads.build(params[:ad])
    if @ad.save
      flash[:success] = "Ad created!"
      redirect_to root_path
    else
	  @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @ad.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @ad = Ad.find(params[:id])
      redirect_to root_path unless current_user?(@ad.user)
    end
end
