# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def user_image (user)
    if user.image_id
      image = Image.find(user.image_id)
      reutrn image.public_filename(:thumb)
    else
      return 'default_user.png'
    end
  end
end
