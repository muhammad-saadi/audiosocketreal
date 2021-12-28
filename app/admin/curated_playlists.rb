ActiveAdmin.register CuratedPlaylist do
  config.sort_order = 'order_asc'

  actions :all, except: [:new, :create]

  includes :playlist_tracks

  permit_params :name, :category, :order

  filter :name
  filter :created_at
  filter :updated_at

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  member_action :add, method: :post do
    consumer_playlist = ConsumerPlaylist.find(params[:id])
    curated_playlist = CuratedPlaylist.new(name: consumer_playlist.name, playlist_image: consumer_playlist.playlist_image&.blob, banner_image: consumer_playlist.banner_image&.blob)
    if curated_playlist.save && (curated_playlist.tracks = consumer_playlist.tracks)
      flash[:notice] = 'Added to Curated Playlist'
    else
      flash[:alert] = curated_playlist.errors.full_messages.to_sentence
    end

    redirect_to admin_consumer_playlists_path
  end

  index do
    selectable_column
    column :order
    column :name
    column 'No. of Tracks' do |curated_playlist|
      curated_playlist.playlist_tracks.size
    end
    column :updated_at
    actions(name: 'Actions')
  end

  show do
    attributes_table do
      row :name
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
      f.cancel_link({ action: 'show' })
    end
  end
end
