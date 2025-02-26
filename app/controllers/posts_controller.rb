class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:user, :likes)
  end

  def show
    @post = Post.find(params[:id])
    prepare_meta_tags(@post)
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
    @post.post_images.build
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = t('defaults.flash_message.created', item: Post.model_name.human)
      redirect_to posts_path
    else
      @post.post_images.build
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
    params.require(:post).permit(:title, :body, :image, post_images_attributes: [:id, :image, :caption, :_destroy])
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def prepare_meta_tags(post)
    # 投稿画像がない場合は、ogp.pngにアクセスして画像生成する
    image_url = if post.image.present?
                  post.image.url.to_s
                else
                  "#{request.base_url}/ogp/ogp.png?text=#{CGI.escape(post.title)}"
                end

    set_meta_tags og: {
                    site_name: 'KORESUKI',
                    title: "「#{post.title}」｜ KORESUKI",
                    description: "「#{post.body}」",
                    type: 'website',
                    url: request.original_url,
                    image: image_url,
                    locale: 'ja-JP'
                  },
                  twitter: {
                    card: 'summary_large_image',
                    site: '@gshota_0116',
                    title: "「#{post.title}」｜ KORESUKI",
                    image: image_url
                  }
  end
end
