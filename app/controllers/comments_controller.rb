class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:success] = 'コメントを削除しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = 'コメント削除に失敗しました'
      render post_path(@post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)  # formでpost_idパラメータを送信して、コメントへpost_idを格納する
  end
end