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

  def show
    @group = Group.find_by_code(params[:code])
    not_found unless @group
    not_valid_location unless @group.retrieve_restaurants

    # update session id and add user to group
    # user came in from different group
    session[:current_user_id] = Group.add_user_by_code(params[:code])
    @user_count = @group.users.count

    # broadcast count to faye
    broadcast_total(@group.code, @user_count)
  end

  # deals with the form post to the group show page; layer of indirection
  def redirect
    if Group.find_by_code(params[:code])
      redirect_to action: 'show', code: params[:code]
    else
      not_found
    end
  end

  def results
    @group = Group.find_by_code(params[:code])
    list = @group.restaurants.order(user_votes: :desc)
    @gold = list.first
    @silver = list.second
    @bronze = list.third
  end

  def waiting
    @group = Group.find_by_code(params[:code])
    @user_count = @group.users.count
  end

  # action associated with the list app
  def app
    @group = Group.find_by_code(params[:code])
    @user_count = @group.users.count
  end

  # post app
  def start_app
    @group = Group.find_by_code(params[:code])
    broadcast_start(@group.code)

    redirect_to action: 'app'
  end

  def submit_app
    @user = User.find(session[:current_user_id])
    @user.submit_choices(params[:id])
    @group = Group.find_by_code(params[:code])

    user_count = @group.users.count
    broadcast_total(@group.code, user_count)

    if user_count.zero?
      broadcast_end(@group.code)
      redirect_to action: 'results'
    else
      redirect_to action: 'waiting'
    end
  end

  def end_app
    redirect_to action: 'results'
  end

  private

  def group_params
    params.require(:group).permit(:location, :radius)
  end

  def broadcast_total(group_code, count)
    full = Broadcaster.full_channel(Broadcaster::USER_CHANNEL, group_code)
    Broadcaster.broadcast(full, { user_count: count })
  end

  def broadcast_start(group_code)
    full = Broadcaster.full_channel(Broadcaster::START_CHANNEL, group_code)
    Broadcaster.broadcast(full, { dest: app_path })
  end

  def broadcast_end(group_code)
    full = Broadcaster.full_channel(Broadcaster::END_CHANNEL, group_code)
    Broadcaster.broadcast(full, { dest: results_path })
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
