class GroupsController < ApplicationController
  def index; end

  def new
    @group = Group.new
  end

  def create
    @group = Group.create(group_params)

    if @group.valid?
      redirect_to action: 'show', code: @group.code
    else
      invalid_group
    end
  end

  # deals with the form post to the group show page; layer of indirection
  def redirect
    if Group.find_by_code(params[:code])
      redirect_to action: 'show', code: params[:code]
    else
      not_found
    end
  end

  def show
    @group = Group.find_by_code(params[:code])

    # check if group found
    not_found unless @group

    # attempt to load restaurants
    not_valid_location unless @group.retrieve_restaurants

    # update session id and add user to group
    # user came in from different group
    session[:current_user_id] = Group.add_user_by_code(params[:code])
    @user_count = @group.users.count

    Broadcaster.broadcast(Broadcaster::USER_CHANNEL, { user_count: @user_count })
  end

  # action associated with the list app
  def app
    @group = Group.find_by_code(params[:code])
  end

  def user_submit
    @user = User.find(session[:current_user_id])

    # user can only submit once
    if @user.submitted
      flash[:notice] = t(:already_submitted)
    else
      @user.submit_choices(params[:id])
    end

    redirect_to action: 'app'
  end

  # group should be deleted at end of program
  def delete
    # TODO implement
  end

  private

  def group_params
    params.require(:group).permit(:location, :radius)
  end

  # error handling

  def invalid_group
    flash[:alert] = t(:invalid_group)
    redirect_to action: 'new'
  end

  def not_valid_location
    flash[:alert] = t(:location_not_found)
    redirect_to action: 'index'
  end

  # handles not found case
  def not_found
    flash[:alert] = t(:group_not_found)
    redirect_to action: 'index'
  end
end
