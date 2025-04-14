class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def top; end

  def policy; end

  def terms; end
end
