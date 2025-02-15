class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_post, only: %i[ edit update destroy]

  def index
    @posts = Post.includes(:user)
  end

  def show
    @post = Post.find(params[:id])
    prepare_meta_tags(@post)
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = t('defaults.flash_message.created', item: Post.model_name.human)
      redirect_to posts_path
    else
      flash.now[:alert] = t('defaults.flash_message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = t('defaults.flash_message.updated', item: Post.model_name.human)
      redirect_to post_path(@post)
    else
      flash.now[:alert] = t('defaults.flash_message.not_updated', item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    flash[:notice] = t('defaults.flash_message.deleted', item: Post.model_name.human)
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def prepare_meta_tags(post)
    image_url = "#{request.base_url}/ogp/ogp.png?text=#{CGI.escape(post.title)}"

    set_meta_tags og: {
                    title: 'KORESUKI',
                    description: "〜わたしの好き「#{post.title.to_s}」を投稿しました〜",
                    type: 'website',
                    url: request.original_url,
                    image: image_url,
                    locale: 'ja-JP'
                  },
                  # twitter:は Twitter のシェアプレビュー用設定
                  twitter: {
                    card: 'summary_large_image',
                    site: '@gshota_0116',
                    description: "〜わたしの好き「#{post.title.to_s}」を投稿しました〜\n#KORESUKI",
                    image: image_url,
                  }
  end
end
