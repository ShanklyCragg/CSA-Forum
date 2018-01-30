class API::PostsController < API::ApplicationController
  include UsersCommon

  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_current_page, except: [:index]
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts.json
  def index
    @posts = Post.paginate(page: params[:page],
                             per_page: params[:per_page])
                  .order(created_at: :desc)

    #Create an array with all unread comments for a user. This will be filtered when we loop through each post.
    @read_comments = ReadComment.where(user_id: current_user.id)

  end

  # GET /api/posts/1.json
  def show
  end

  # POST /api/posts.json
  def create

    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.json { render :show, status: :created, location: @post }
      else
       format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.json { render :show, status: :ok, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_current_page
      @current_page = params[:page] || 1
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :is_anon, :user_id)
    end
end
