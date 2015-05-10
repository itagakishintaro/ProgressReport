module Api
  class UsersController < ApplicationController
    def with_progresses
      @user_with_progresses = User.select('users.id, users.name, progresses.point, progresses.updated_at').joins(:progresses)
      render :json => @user_with_progresses.to_json
    end
  end
end