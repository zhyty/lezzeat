class GroupsController < ApplicationController
  def index; end

  def new
    @group = Group.new
  end

  def create
    # instantiate create object
    redirect_to action: 'index'
  end
end
