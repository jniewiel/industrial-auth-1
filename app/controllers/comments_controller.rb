# app/controllers/comments_controller.rb

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :authorize_comment, except: %i[ index new create ]

  # GET /comments or /comments.json
  def index
    @comments = policy_scope(Comment)
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    authorize(@comment)
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    authorize(@comment)

    if @comment.save
      redirect_to(root_path, { :notice => "Comment was successfully created." })
    else
      render({ :template => "comments/new", :status => :unprocessable_entity })
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    if @comment.update(comment_params)
      redirect_to(root_url, { :notice => "Comment was successfully updated." })
    else
      render({ :template => "comments/edit", :status => :unprocessable_entity })
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy
    redirect_to(root_url, { :notice => "Comment was successfully destroyed." })
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def authorize_comment
      authorize(@comment)
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:author_id, :photo_id, :body)
    end
end
