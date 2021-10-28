ActiveAdmin.register CuratedPlaylist do
  config.sort_order = 'order_asc'

  actions :all, except: [:new, :create]

  permit_params :name, :category, :order

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  member_action :add, method: :post do
    consumer_playlist = ConsumerPlaylist.find(params[:id])
    curated_playlist = CuratedPlaylist.create(name: consumer_playlist.name, playlist_image: consumer_playlist.playlist_image.blob, banner_image: consumer_playlist.banner_image.blob)
    curated_playlist.tracks = consumer_playlist.tracks
    redirect_to admin_consumer_playlists_path, notice: 'Added to Curated Playlist'
  end

  index do
    selectable_column
    id_column
    column :name
    column :order
    column :actions do |curated_playlist|
      span link_to t('active_admin.view'), admin_curated_playlist_path(curated_playlist), class: 'small button'
      span link_to t('active_admin.edit'), edit_admin_curated_playlist_path(curated_playlist), class: 'small button'
      span link_to t('active_admin.delete'), admin_curated_playlist_path(curated_playlist), class: 'small button', method: :delete, data: { confirm: 'Are you sure you want to delete this?' }
    end
  end

  show do
    attributes_table do
      row :name
      row :consumer
      row :banner_image do
        image_tag(resource.banner_image, width: 320, height: 100) if curated_playlist.banner_image.attached?
      end
      row :playlist_image do
        image_tag(resource.playlist_image, width: 100, height: 100) if curated_playlist.playlist_image.attached?
      end
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at

      panel 'Playlist Tracks' do
        curated_playlist = CuratedPlaylist.find(params[:id])
        table_for curated_playlist.playlist_tracks do
          if curated_playlist.playlist_tracks.blank?
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

  form do |f|
    f.inputs do
      f.input :name
      f.input :category
      f.input :order
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_albums_path)
    end
  end

end
