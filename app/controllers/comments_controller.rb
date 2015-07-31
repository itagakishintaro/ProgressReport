class CommentsController < ApplicationController
  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.save
    redirect_to :back
  end

  def for_user
    @for_user = Comment.for_user(params[:user_id])
    render :json => @for_user.to_json
  end

  def back_for_user
    @back_for_user = Comment.back_for_user(params[:user_id])
    render :json => @back_for_user.to_json
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:comment, :report_id, :user_id, :created_at, :updated_at)
    end
end
