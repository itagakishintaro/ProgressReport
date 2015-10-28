class UsersController < Devise::RegistrationsController
  before_action :set_user, only: [:destroy, :create]

  # GET /users
  # GET /users.json
  def index
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def with_progresses
    @user_with_progresses = User.with_progress_points
    render :json => @user_with_progresses.to_json
  end

  def sign_up
    if current_user.try(:admin?)
      @user = User.new
    else
      redirect_to reports_path
    end
  end

  def admin_create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to reports_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :sign_up }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :created_at, :updated_at, :admin)
    end
end
