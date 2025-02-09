class StaticpagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:top]
  
  def top; end
end
