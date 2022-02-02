class V1::PostsController < ApplicationController
  # class PostsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  # before_action :correct_user,   only: :destroy

  def index
    post = Post.all
    render json: post
  end

  def new
    # @post = Post.new
    post = Post.new
    render json: post
  end

  def create
    post = current_user.posts.build(post_params)
    post.image.attach(params[:post][:image])
    flash.now[:success] = '投稿を追加しました' if post.save
    all_posts = current_user.feed.where(privacy: false).page(params[:page]).per(9)
    user_posts = current_user.posts.where(privacy: false).page(params[:page]).per(9)
    want_posts = current_user.posts.where(privacy: false).where(tag: '実践したい').page(params[:page]).per(9)
    doing_posts = current_user.posts.where(privacy: false).where(tag: '実践中').page(params[:page]).per(9)
    master_posts = current_user.posts.where(privacy: false).where(tag: '身についた').page(params[:page]).per(9)
    like_posts = current_user.like_posts.where(privacy: false).page(params[:page]).per(9)

    render json: all_posts
    render json: user_posts
    render json: want_posts
    render json: doing_posts
    render json: master_posts
    render json: like_posts

    # @post = current_user.posts.build(post_params)
    # @post.image.attach(params[:post][:image])
    # flash.now[:success] = '投稿を追加しました' if @post.save
    # @all_posts = current_user.feed.where(privacy: false).page(params[:page]).per(9)
    # @user_posts = current_user.posts.where(privacy: false).page(params[:page]).per(9)
    # @want_posts = current_user.posts.where(privacy: false).where(tag: '実践したい').page(params[:page]).per(9)
    # @doing_posts = current_user.posts.where(privacy: false).where(tag: '実践中').page(params[:page]).per(9)
    # @master_posts = current_user.posts.where(privacy: false).where(tag: '身についた').page(params[:page]).per(9)
    # # # ↓なんかエラー出るので一時的に並び替え解除
    # @like_posts = current_user.like_posts.where(privacy: false).page(params[:page]).per(9)

    # # いいねをつけた順に表示
    # # @like_posts = current_user.likes.order(created_at: 'DESC').limit(10).map { |like| like.post }
  end

  def destroy
    # flash.now[:success] = '投稿を削除しました' if @post.destroy

    post = Post.find(params[:id])
    render json: post if post.destroy
  end

  def edit
    # @post = Post.find(params[:id])
    post = Post.find(params[:id])
    render json: post
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      render json: post
    else
      render json: post.errors
    end

    # @post = Post.find(params[:id])
    # if @post.update(post_params)
    #   flash[:success] = '投稿を編集しました'
    #   redirect_to root_url
    # else
    #   render :edit
    # end
  end

  def show
    post = Post.find(params[:id])
    comment = current_user.comments.new
    render json: post
    render json: comment

    # @post = Post.find(params[:id])
    # @comment = current_user.comments.new
  end

  def search
    if params[:keyword].present? && params[:tag].present?
      @posts = Post.where('tag LIKE ?', "%#{params[:tag]}%").where('content LIKE ?',
                                                                   "%#{params[:keyword]}%").page(params[:page]).per(9)
    elsif params[:keyword].blank? && params[:tag].present?
      @posts = Post.where('tag LIKE ?', "%#{params[:tag]}%").page(params[:page]).per(9)
    elsif params[:keyword].present? && params[:tag].blank?
      @posts = Post.where('content LIKE ?', "%#{params[:keyword]}%").page(params[:page]).per(9)
    end
  end

  # 自分だけ閲覧出来る投稿一覧
  def private_index
    @private_post = current_user.posts.where(privacy: true).page(params[:page]).per(9)
    @want_posts = current_user.posts.where(privacy: true).where(tag: '実践したい').page(params[:page]).per(9)
    @doing_posts = current_user.posts.where(privacy: true).where(tag: '実践中').page(params[:page]).per(9)
    @master_posts = current_user.posts.where(privacy: true).where(tag: '身についた').page(params[:page]).per(9)
  end

  private

  def post_params
    params.require(:post).permit(:content, :image, :tag, :url, :privacy)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
