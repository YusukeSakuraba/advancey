class V1::PostsController < ApplicationController
  def index
    posts = Post.all
    render json: posts.as_json(methods: :image_url, except: :updated_at,
                               include: { user: { methods: :image_url, only: %i[id name admin] }, post_comments: { only: :id } })
  end

  def create
    post = Post.new(post_params)
    if post.save
      render json: post, methods: :image_url
    else
      render json: post.errors
    end
  end

  def destroy
    post = Post.find(params[:id])
    render json: post if post.destroy
  end

  def show
    post = Post.find(params[:id])
    render json: post.as_json(methods: :image_url,
                              include: [{ user: { methods: :image_url, only: %i[id name] } },
                                        { post_comments: { methods: :image_url, include:
                                          { user: { methods: :image_url, only: %i[id name] } } } }])
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      render json: post
    else
      render json: post.errors
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :content, :tag, :privacy, :image)
  end
end
