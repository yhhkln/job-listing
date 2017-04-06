class WelcomeController < ApplicationController
  def index
    flash[:notice] = "加油 努力"
    flash[:warning]= "加油 努力"
    flash[:alert] = "加油 努力"
  end
end
