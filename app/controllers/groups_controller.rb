class GroupsController < ApplicationController
  def index; end

  def new
    @group = Group.new
  end

  def create
    # instantiate create object
    redirect_to action: 'index'
  end

  # deals with the form post to the group show page; layer of indirection
  def redirect
    if Group.find_by_code(params[:code])
      redirect_to action: 'show', code: params[:code]
    else
      not_found
    end
  end

  # page for specific group
  def show
    @group = Group.find_by_code(params[:code])
    not_found unless @group
    session[:user_id] = Group.add_user_by_code(params[:code]) unless session[:user_id]
  end

  # group should be deleted at end of program
  def delete
    # TODO implement
  end

  private

  # handles not found case
  def not_found
    flash[:alert] = t(:group_not_found)
    redirect_to action: 'index'
  end
end
