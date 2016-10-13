class Campain < ApplicationRecord
	require 'rmagick'
  
	has_attached_file :cover, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

	def self.koala(auth, id)
    access_token = auth['token']
    facebook = Koala::Facebook::API.new(access_token)
    get_picutre_obj = facebook.get_object("me?fields=name,picture.width(200).height(200)")
    folder = 'public/profile_picture/'.+(get_picutre_obj["name"].to_s.gsub(' ','_').+("_profile.png"))
    open(folder, 'wb') do |file|   
      file << open(get_picutre_obj['picture']['data']['url'].to_s).read
    end
    result = fix_image(folder,id)
    folder_crop = 'public/profile_picture/'.+(get_picutre_obj["name"].to_s.gsub(' ','_').+("_profile_crop.png"))
    result.write(folder_crop)
    put_picture_obj = facebook.put_picture(folder_crop)
    return put_picture_obj,get_picutre_obj
  end
   
  def self.fix_image(path_of_profile_pic, id)
    source = Magick::ImageList.new(Campain.find(id).cover.path)
    source = source.resize_to_fit(500)
    des=Magick::ImageList.new(path_of_profile_pic)
    des=des.resize_to_fit(300)
    result = source.composite(des,Magick::CenterGravity, Magick::OverCompositeOp)
  end

end
