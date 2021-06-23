ActiveAdmin.register ArtistProfile do
  config.remove_action_item(:new)

  includes :user

  filter :name
  filter :user, as: :searchable_select, collection: User.artist, label: 'Artist'
  filter :exclusive
  filter :banner_image_status, as: :select, collection: ArtistProfile.banner_image_statuses.keys.map { |key| [key.titleize, key] }
  filter :cover_image_status, as: :select, collection: ArtistProfile.cover_image_statuses.keys.map { |key| [key.titleize, key] }

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

  show do
    attributes_table do
      row :name
      row :banner_image do
        image_tag(artist_profile.banner_image, width: 100, height: 100) if artist_profile.banner_image.attached?
      end

      row :banner_image_status do
        artist_profile.banner_image_status&.titleize
      end

      row :cover_image do
        image_tag(artist_profile.cover_image, width: 100, height: 100) if artist_profile.cover_image.attached?
      end

      row :cover_image_status do
        artist_profile.cover_image_status&.titleize
      end

      row :additional_images do
        ul do
          artist_profile.additional_images.each do |img|
            li do
              image_tag(img, width: 100, height: 100)
            end
          end
        end
      end
      row :exclusive
      row :sounds_like
      row :bio
      row :key_facts
      row :social
      row 'Artist' do
        artist_profile.user
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :banner_image, as: :file
      f.input :banner_image_status, as: :select, collection: ArtistProfile.banner_image_statuses.keys.map { |key|
                                    [key.titleize, key] }, include_blank: false
      f.input :cover_image, as: :file
      f.input :cover_image_status, as: :select, collection: ArtistProfile.cover_image_statuses.keys.map { |key|
                                    [key.titleize, key] }, include_blank: false
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
