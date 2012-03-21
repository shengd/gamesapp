class UsersController < ApplicationController
  #only logged in users (don't filter this filter by action, it sets @user)
  before_filter :user_signed_in
  #only admins and users who own the pertinent data
  before_filter :user_authorized, only: [:edit, :update]
  #only admins
  before_filter :user_admin, only: [:create, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page])

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @users }
    #end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    if @user.save
      #sign_in @user
      flash[:success] = "Welcome to Gamesapp!"
      redirect_to @user
    else
      render 'new'
    end
#    respond_to do |format|
#      if @user.save
#        format.html { redirect_to @user, notice: 'User was successfully created.' }
#        format.json { render json: @user, status: :created, location: @user }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @user.errors, status: :unprocessable_entity }
#      end
#    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path

    #respond_to do |format|
    #  format.html { redirect_to users_url }
    #  format.json { head :no_content }
    #end
  end

  private
  def user_signed_in
    unless signed_in?
      store_location
      redirect_to login_path, notice: "Please sign in."
    end
  end

  def user_authorized
    @user = User.find(params[:id])
    redirect_to_root unless @user.admin? or current_user? @user
  end

  def user_admin
    redirect_to_root unless  current_user.admin?
  end

  def redirect_to_root
    redirect_to root_path, error: "I can't let you do that, Dave."
  end
end
