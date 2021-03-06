class Admin::S3filesController < ApplicationController
  before_action :set_q

  def initialize
    super
    @region = 'ap-northeast-1'
    @input_bucketname = ENV['AWS_S3_INPUT_BUCKET_NAME']
    @output_bucketname = ENV['AWS_S3_OUTPUT_BUCKET_NAME']
    @s3 = s3_resource
  end

  def index
    @s3files = S3file.includes(:video).all
  end

  def new
    @s3file = S3file.new
    @s3file.build_video
  end

  def create # rubocop:disable
    @s3file = S3file.new(s3file_params.merge(file_name: s3file_params[:key].original_filename))
    if @s3file.save
      file = s3file_params[:key]
      filename = file.original_filename
      file_path = "tmp/s3/#{filename}"
      File.binwrite(file_path, file.read)
      bucket = @s3.bucket(@input_bucketname)
      key = filename
      object = bucket.object(key)
      object.upload_file(file_path, acl: 'public-read')
      redirect_to admin_s3files_path, flash: { notice: '動画を投稿しました' }
    else
      flash[:alert] = '失敗しました'
      render 'new'
    end
  end

  def show
    @s3file = S3file.find(params[:id])
  end

  def destroy
    s3file = S3file.find(params[:id])
    key = s3file.key
    bucket = @s3.bucket(@input_bucketname)
    object = bucket.object(key)
    object.delete

    s3file.destroy
    redirect_to admin_s3files_path, flash: { alert: '削除しました' }
  end

  private

  def s3_resource # rubocop:disable
    # ECS(本番環境)時
    Aws::S3::Resource.new(
      region: @region,
      credentials: Aws::ECSCredentials.new
    )

    # ローカル環境時
    # Aws::S3::Resource.new(
    #   region: @region,
    #   credentials: Aws::Credentials.new(
    #       ENV['AWS_ACCESS_KEY'],
    #       ENV['AWS_SECRET_KEY']
    #    )
    # )
  end

  def s3file_params
    params.require(:s3file).permit(:key, video_attributes: %i[id title description remarks])
  end
end
