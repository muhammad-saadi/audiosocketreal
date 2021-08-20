ActiveAdmin.register ArtistProfile do
  menu false

  actions :edit, :update, :index, :show

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
  filter :email
  filter :user, as: :searchable_select, collection: User.artist, label: 'Artist'
  filter :exclusive
  filter :banner_image_status, as: :select, collection: -> { images_status_list }
  filter :profile_image_status, as: :select, collection: -> { images_status_list }
  filter :created_at

  permit_params :name, :email, :exclusive, :user_id, :sounds_like, :country, :bio, :key_facts, :social_raw, :banner_image, :profile_image,
                :banner_image_status, :profile_image_status, :pro, :ipi, :website_link, genre_ids: [], additional_images: []

  index do
    selectable_column
    id_column
    column :name
    column 'Artist', :user
    column :exclusive
    column :banner_image_status do |profile|
      profile.banner_image_status&.titleize
    end

    column :profile_image_status do |profile|
      profile.profile_image_status&.titleize
    end
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :banner_image, as: :file
      f.input :banner_image_status, as: :select, collection: images_status_list, include_blank: false
      f.input :profile_image, as: :file
      f.input :profile_image_status, as: :select, collection: images_status_list, include_blank: false
      f.input :additional_images, as: :file, input_html: { multiple: true }
      f.input :country, as: :searchable_select, collection: CountryStateSelect.countries_collection.map(&:first), include_blank: 'Select a Country'
      f.input :exclusive
      f.input :sounds_like
      f.input :pro, as: :searchable_select, collection: pro_list, include_blank: false
      f.input :ipi
      f.input :genres, as: :searchable_select, collection: genres_list
      f.input :bio
      f.input :key_facts
      f.input :social_raw, as: :text, label: 'Social'
      f.input :website_link
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end
end
