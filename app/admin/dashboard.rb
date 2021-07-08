ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    hr
    div do
      columns do
        column do
          panel link_to 'Total Artists', admin_artists_path do
            link_to User.artist.count, admin_artists_path
          end
        end

        column do
          panel link_to 'Total Albums', admin_albums_path do
            link_to Album.count, admin_albums_path
          end
        end

        column do
          panel link_to 'Total Tracks', admin_tracks_path do
            link_to Track.count, admin_tracks_path
          end
        end
      end
    end
    hr
    br
    br
    div do
      columns do
        column do
          panel link_to "Unclassified Tracks (#{Track.unclassified.count})", admin_tracks_path(scope: 'unclassified')
        end

        column do
          panel link_to "Pending Notes (#{Note.pending.count})", admin_notes_path(scope: 'pending')
        end
      end
    end
  end
end
