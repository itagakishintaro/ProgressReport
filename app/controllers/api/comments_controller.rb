module Api
  class CommentsController < ApplicationController
    def for_user
      @for_user = Comment.for_user(params[:user_id])
      render :json => @for_user.to_json
    end
  end
end