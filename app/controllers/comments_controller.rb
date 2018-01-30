class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /posts/:post_id/comments
  # GET /comments.json
  def index
    post = Post.find(params[:post_id])
    @post = Post.find(params[:post_id])
    @comments = post.comments

    #Here we add the new unique currently unread comments to the "read_comments" database
    #To do this I take away the read comments from the total comments, leaving only new ones behind
    @read_comments = ReadComment.where(user_id: current_user.id).map{|comment| comment.comment_id}

    @all_comments = post.comments.map{|comment| comment.id}

    @unread_comments = @all_comments - @read_comments

    #Then, I loop though all these new unread_comments, adding them to the "read_comments" database
    @unread_comments.each do |id|
      @new_viewed_comment = ReadComment.new
      @new_viewed_comment.user_id = current_user.id
      @new_viewed_comment.post_id = params[:post_id]
      @new_viewed_comment.comment_id = id
      @new_viewed_comment.save
    end


  end

  # GET /posts/:post_id/comments/:id
  # GET /comments/1.json
  def show
    post = Post.find(params[:post_id])
    @post = Post.find(params[:post_id])
    @comment = post.comments.find(params[:id])
  end

  # GET /posts/:post_id/comments/new
  def new
    post = Post.find(params[:post_id])
    @post = Post.find(params[:post_id])
    if params[:parent_id]
    @parent_title = post.comments.find(params[:parent_id])
    end
    @comment = post.comments.new(:parent_id => params[:parent_id])

  end

  # GET /posts/:post_id/comments/:id/edit
  def edit
    post = Post.find(params[:post_id])
    @post = Post.find(params[:post_id])
    @comment = post.comments.find(params[:id])
  end

  # POST /posts/:post_id/comments
  # POST /comments.json
  def create
    post = Post.find(params[:post_id])
    @post = Post.find(params[:post_id])
    @comment = post.comments.create(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_comments_path }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/:post_id/comments/:id
  # PATCH/PUT /comments/1.json
  def update
    post = Post.find(params[:post_id])
    @post = Post.find(params[:post_id])
    @comment = post.comments.find(params[:id])

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to ([@comment.post, @comment]) }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/:post_id/comments/1
  # DELETE /comments/1.json
  def destroy
    post = Post.find(params[:post_id])
    @post = Post.find(params[:post_id])
    @comment = post.comments.find(params[:id])
    @comment.is_anon = 't'
    @comment.body = '[DELETED]'
    @comment.save
    respond_to do |format|
      format.html { redirect_to post_comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:title, :body, :is_anon, :parent_id, :post_id, :user_id)
    end
end
