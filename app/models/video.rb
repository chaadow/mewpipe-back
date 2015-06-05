class Video < ActiveRecord::Base

  # Associations
  belongs_to :user

  has_attached_file :file, :path => ":rails_root/public/files/:filename"

  # Upload
  resource :upload do
    post do
        # takes the :file value and assigns it to a variable
        file = params[:file]

        # the file parameter needs to be converted to a
        # hash that paperclip understands as:
        attachment = {
            :filename => file[:filename],
            :type => file[:type],
            :headers => file[:head],
            :tempfile => file[:tempfile]
        }

        # creates a new User object
        video = Video.new

        # This is the kind of File object Grape understands so let's
        # pass the hash to it
        video.file = ActionDispatch::Http::UploadedFile.new(attachment)

        # easy
        video.file_path = attachment[:filename]

        # even easier
        video.name = "dummy name"

        # and...
        video.save
    end
end

end
