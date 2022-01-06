ActiveAdmin.register ConsumerPlaylist do
  actions :all, except: [:new, :create]

  permit_params :name, :folder_id

  includes :folder, :playlist_tracks

  filter :folder
  filter :consumer
  filter :name
  filter :created_at
  filter :updated_at

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    column :name
    column :consumer
    column 'No. of Tracks' do |consumer_playlist|
      consumer_playlist.playlist_tracks.size
    end
    column :updated_at
    column :actions do |consumer_playlist|
      span link_to t('active_admin.view'), admin_consumer_playlist_path(consumer_playlist), class: 'small button'
      span link_to t('active_admin.edit'), edit_admin_consumer_playlist_path(consumer_playlist), class: 'small button'
      span link_to t('active_admin.delete'), admin_consumer_playlist_path(consumer_playlist), class: 'small button', method: :delete, data: { confirm: 'Are you sure you want to delete this?' }
      span link_to 'Add To Curated Playlist', add_admin_curated_playlist_path(consumer_playlist), class: 'small button', method: :post
    end
  end

  show do
    attributes_table do
      row :name
      row :folder_id do |consumer_playlist|
        consumer_playlist.folder&.name
      end
      row :consumer
      row :banner_image do
        image_tag(resource.banner_image, width: 320, height: 100) if consumer_playlist.banner_image.attached?
      end
      row :playlist_image do
        image_tag(resource.playlist_image, width: 100, height: 100) if consumer_playlist.playlist_image.attached?
      end
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at

      panel 'Playlist Tracks' do
        consumer_playlist = ConsumerPlaylist.find(params[:id])
        table_for consumer_playlist.playlist_tracks do
          if consumer_playlist.playlist_tracks.blank?
            column 'No Records Found'
          else
            column :id
            column :track
            column :order
            column :note
          end
        end
      end
    end

    active_admin_comments
  end
end
