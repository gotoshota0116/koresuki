class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:top]

  def top; end

  def policy; end

  def terms; end
end
