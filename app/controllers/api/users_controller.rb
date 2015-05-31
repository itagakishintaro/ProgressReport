module Api
  class UsersController < ApplicationController
    def with_progresses
      @user_with_progresses = User.with_progress_points
      render :json => @user_with_progresses.to_json
    end
  end
end