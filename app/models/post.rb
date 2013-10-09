# -*- coding: utf-8 -*-
class Post < ActiveRecord::Base
  attr_accessible :context,
                  :file_url,
                  :title,
                  :user_id,
                  :image
  # Relations
  # ===========================================================                
  belongs_to :user  
  has_attached_file :image,   
                    processor: 'mini_magick',
                    path: "#{Rails.root}/public/system/:class/:attachment/:id/:basename_:style.:extension",
                    url: "/system/:class/:attachment/:id/:basename_:style.:extension",                 
                    styles: {
                      thumb:
                        {
                          geometry: '',
                          convert_options: '-gravity north -resize "200x200^" -crop "200x200+0+0" +repage'
                        }
                      }
  # Validation
  # ===========================================================
  validates :title, presence: true
  validates_attachment_content_type :image, content_type: [ /^image\/(?:jpg|jpeg|gif|png)$/, nil ], message: "Неподдерживаемый тип файла"
  
  # Callbacks
  # ===========================================================
  before_post_process :randomize_file_name
  before_create :download_image
  


  private

  def download_image
    open_from_url
  end

  def randomize_file_name
    return if image_file_name.nil?
    if image_file_name_changed?
     extension = File.extname(image_file_name).downcase
     self.image.instance_write(:file_name, "#{SecureRandom.hex}#{extension}")
    end
  end 

  def open_from_url
    url = self.file_url
    begin
      io = open(url)
      def io.original_filename; base_uri.path.split('/').last; end
      self.image = io.original_filename.blank? ? nil : io
    rescue    
      nil
    end
  end
end
