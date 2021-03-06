class Api::V1::CommentsController < ApiController
  before_action :set_q, :set_comment, only: [:show]

  def index
    @video = Video.find(params[:video_id])
    @comments = @video.comments.order('created_at DESC')
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.context.blank?
      render json: @comment.errors, status: :unprocessable_entity
    else
      @comment.save
      render :index, status: :created
    end
  end

  def show
    render json: @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:context, :user_id, :video_id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
