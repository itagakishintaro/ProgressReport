module Api
  class UsersController < ApplicationController
    def with_progresses
      @user_with_progresses = User.select('users.id, users.name, SUM(progresses.point) AS point, progresses.updated_at').joins(:progresses).group('users.id').order('point desc')
      render :json => @user_with_progresses.to_json
    end
  end
end