class UploadsController < ApplicationController
  before_action :authenticate_user!

  def create
    uploaded_file = params[:file]

    blob = ActiveStorage::Blob.create_and_upload!(
      io: uploaded_file,
      filename: uploaded_file.original_filename,
      content_type: uploaded_file.content_type
    )

    render json: { image_url: url_for(blob), signed_id: blob.signed_id }, status: :ok
  end
end
