ActiveAdmin.register Album do
  permit_params :name, :release_date, :user_id, :artwork, :admin_note

  includes :user

  filter :name_or_tracks_title_cont, as: :string, label: 'Search'
  filter :name_cont, as: :string, label: 'Name'
  filter :user, as: :searchable_select, collection: User.artist, label: 'Artist'
  filter :tracks_title_cont, as: :string, label: 'Track title'
  filter :created_at

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  member_action :download_zip, method: :get do
    album = Album.find(params[:id])

    xlsx_sheet = Tempfile.new("#{album.name}_tracks_data.xlsx")
    xlsx_sheet.write(album.tracks.track_detail_sheet)
    xlsx_sheet.rewind

    artwork  = [album.artwork, album.artwork.filename]
    sheet = [xlsx_sheet, "#{album.name}_tracks_data.xlsx"]

    album_file = album.tracks.to_zip << artwork
    album_file << sheet

    zipline(album_file, "#{album.name}.zip")
  end

  member_action :download_xlsx, mehtod: :get do
    album = Album.find(params[:id])
    xlsx_sheet = album.tracks.track_detail_sheet
    send_data xlsx_sheet, filename: "#{album.name}_tracks_data.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  index do
    selectable_column
    id_column
    column 'Album Name', :name
    column :release_date
    column 'Artist Name', :user_id
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    column :actions do |album|
      span link_to t('active_admin.view'), admin_album_path(album), class: 'small button'
      span link_to t('active_admin.edit'), edit_admin_album_path(album), class: 'small button'
      span link_to t('active_admin.delete'), admin_album_path(album), class: 'small button', method: :delete
      span link_to 'Download Zip', download_zip_admin_album_path(album), class: 'small button'
      span link_to 'Download XLSX', download_xlsx_admin_album_path(album), class: 'small button'
    end
  end

  show do
    attributes_table do
      row 'Album Name', &:name
      row :release_date, &:release_date
      row :artwork do
        if album.artwork.attached?
          span image_tag(album.artwork, width: 100, height: 100)
          br
          span link_to 'Download', rails_blob_path(album.artwork, disposition: "attachment"), class: 'small button'
        end
      end
      row('Artist Name'){ |r| r.user }
      row :admin_note
      row('Artist\'s PRO'){ |r| r.user.artist_profile.pro }
      row('Artist\'s IPI'){ |r| r.user.artist_profile.ipi }
    end

    panel 'Tracks' do
      panel('', class: 'align-right') do
        link_to 'Add new Track', new_admin_track_path(track: { album_id: album.id }), class: 'medium button'
      end

      table_for album.tracks do
        if album.tracks.blank?
          column 'No Records Found'
        else
          column :id
          column :title
          column :status
          column :actions do |track|
            link_to 'view', admin_track_path(track), class: 'small button'
          end
        end
      end
    end

    panel 'Publishers' do
      table_for album.user.publishers do
        if album.user.publishers.blank?
          column 'No Records Found'
        else
          column :name
          column :pro
          column :ipi
          column :actions do |publisher|
            link_to 'view', admin_publisher_path(publisher), class: 'small button'
          end
        end
      end
    end

    panel 'Agreements' do
      @users_agreements = album.user.users_agreements.includes(:agreement)
      table_for @users_agreements do
        if @users_agreements.blank?
          column 'No Records Found'
        else
          column (:agreement_type) { |users_agreement| users_agreement.agreement.agreement_type }
          column :role
          column :actions do |user_agreement|
            link_to 'view', admin_agreement_path(user_agreement.agreement), class: 'small button'
          end
        end
      end
    end

    panel 'Notes' do
      table_for album.notes do
        if album.notes.blank?
          column 'No Records Found'
        else
          column :id
          column :status
          column :actions do |note|
            link_to 'view', admin_note_path(note), class: 'small button'
          end
        end
      end
    end

    active_admin_comments
  end

  csv do
    column :id
    column :name
    column :release_date, &:formatted_release_date
    column (:user) { |album| album.user.full_name }
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
  end

  form do |f|
    f.inputs do
      f.input :name, label: "Artist Name"
      f.input :release_date, as: :date_picker
      f.input :artwork, as: :file
      f.input :user, as: :searchable_select , collection: User.artist, label: 'Artist', include_blank: 'Select an Artist'
      f.input :admin_note, input_html: { class: 'autogrow', rows: 4, cols: 20 }
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_albums_path)
    end
  end
end
