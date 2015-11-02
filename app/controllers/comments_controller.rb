class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to reports_path
    else
      redirect_to reports_path
      flash[:alert] = "#{@comment.errors.full_messages[0]} in comment"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text, :report_id)
  end
end
