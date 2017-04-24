class CommentsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :destroy]



  # POST /comments
  # POST /comments.json
  def create
    @job = Job.find(params[:job_id])
    @comment = @job.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to job_path(@job), notice: 'Review was successfully created!'
    else
      redirect_to job_path(@job), alert: "Comment can't be blank!"
    end
  end


  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @job = Job.find(params[:job_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to job_path(@job), alert: "You have deleted the comment successfully"
  end

  private


    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:job_id, :body, :user_id)
    end
end
