ActiveAdmin.register ArtistProfile do
  menu false

  actions :edit, :update

  controller do
    def index
      redirect_to admin_artists_path
    end

    def show
      redirect_to admin_artist_path(ArtistProfile.find(params[:id]).user)
    end
  end

  includes :user

  filter :name
  filter :user, as: :searchable_select, collection: User.artist, label: 'Artist'
  filter :exclusive
  filter :banner_image_status, as: :select, collection: -> { images_status_list }
  filter :cover_image_status, as: :select, collection: -> { images_status_list }
  filter :created_at

  permit_params :name, :exclusive, :user_id, :sounds_like, :bio, :key_facts, :social_raw, :banner_image, :cover_image,
                :banner_image_status, :cover_image_status, additional_images: []

  index do
    selectable_column
    id_column
    column :name
    column 'Artist', :user
    column :exclusive
    column :banner_image_status do |profile|
      profile.banner_image_status&.titleize
    end

    column :cover_image_status do |profile|
      profile.cover_image_status&.titleize
    end
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :banner_image, as: :file
      f.input :banner_image_status, as: :select, collection: images_status_list, include_blank: false
      f.input :cover_image, as: :file
      f.input :cover_image_status, as: :select, collection: images_status_list, include_blank: false
      f.input :additional_images, as: :file, input_html: { multiple: true }
      f.input :exclusive
      f.input :sounds_like
      f.input :bio
      f.input :key_facts
      f.input :social_raw, as: :text
    end
    f.actions
  end
end
