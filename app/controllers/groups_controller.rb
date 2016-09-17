class GroupsController < ApplicationController
  def index; end

  def new
    @group = Group.new
    @current_user = "fuck jack"
  end

  def create
    # TODO call Yelp API with params
    # instantiate create object
    redirect_to action: 'index'
  end
end
