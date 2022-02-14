ActiveAdmin.register User, as: 'Artist' do
  config.remove_action_item(:new)
  permit_params :first_name, :last_name, :admin_note

  filter :first_name_or_last_name_cont, as: :string, label: 'Name'
  filter :artist_profile_name_cont, as: :string, label: 'Artist Name'
  filter :artist_profile_email_cont, as: :string, label: 'Artist Email'
  filter :artist_profile_contact_information_name_cont, as: :string, label: 'Contact Name'
  filter :artist_profile_exclusive, as: :select, label: 'Exclusive'
  filter :artist_profile_contact_information_country_cont, as: :string, label: 'Country'
  filter :artist_profile_contact_information_state_cont, as: :string, label: 'State'
  filter :artist_profile_contact_information_city_cont, as: :string, label: 'City'
  filter :artist_profile_payment_information_payee_name_cont, as: :string, label: 'Payee Name'
  filter :artist_profile_payment_information_bank_name_cont, as: :string, label: 'Bank name'
  filter :email
  filter :created_at
  filter :updated_at

  controller do
    def scoped_collection
      end_of_association_chain.artist
    end
  end

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    column :roles, &:roles_string
    actions defaults: false do |artist|
      item 'View', admin_artist_path(artist), class: 'member_link' if authorized?(:show, artist)
      item 'Edit', edit_admin_artist_path(artist, index: true), class: 'member_link' if authorized?(:update, artist)
      item 'Delete', admin_artist_path(artist), method: :delete, class: 'member_link' if authorized?(:destroy, artist)
    end
  end

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
      row :roles do
        artist.roles_string
      end
      row :admin_note
    end

    panel 'Artist Profile' do
      if artist.artist_profile.blank?
        attributes_table_for artist.artist_profile do
          row 'No Record Found'
        end
      else
        panel('', class: 'align-right') do
          if authorized?(:update, artist.artist_profile)
            link_to 'Edit artist profile', edit_admin_artist_profile_path(artist.artist_profile), class: 'medium button'
          end
        end
        attributes_table_for artist.artist_profile do
          row :name
          row :email
          row :banner_image do
            if artist.artist_profile.banner_image.attached?
              span image_tag(artist.artist_profile.banner_image, width: 320, height: 100)
              br
              span link_to 'Download', rails_blob_path(artist.artist_profile.banner_image, disposition: "attachment"), class: 'small button'
            end
          end

          row :banner_image_status do
            artist.artist_profile.banner_image_status&.titleize
          end

          row :profile_image do
            if artist.artist_profile.profile_image.attached?
              span image_tag(artist.artist_profile.profile_image, width: 100, height: 100)
              br
              span link_to 'Download', rails_blob_path(artist.artist_profile.profile_image, disposition: "attachment"), class: 'small button'
            end
          end

          row :profile_image_status do
            artist.artist_profile.profile_image_status&.titleize
          end

          row :additional_images do
            ul do
              artist.artist_profile.additional_images.each do |img|
                li do
                  span image_tag(img, width: 100, height: 100)
                  br
                  span link_to 'Download', rails_blob_path(img, disposition: "attachment"), class: 'small button'
                end
              end
            end
          end
          row :country
          row :exclusive
          row :sounds_like
          row :pro
          row :ipi
          row :genres do
            artist.artist_profile.genre_names
          end
          row :bio
          row :key_facts
          row :social
          row :website_link
          row :created_at, &:formatted_created_at
          row :updated_at, &:formatted_updated_at
        end

        panel 'Contact Information' do
          panel('', class: 'align-right') do
            if artist.artist_profile.contact_information.present? && authorized?(:update, ContactInformation)
              link_to 'Edit contact Information', edit_admin_contact_information_path(artist.artist_profile.contact_information), class: 'medium button'
            elsif authorized?(:create, ContactInformation)
              link_to 'Add contact Information', new_admin_contact_information_path(contact_information: { artist_profile_id: artist.artist_profile.id }), class: 'medium button'
            end
          end

          attributes_table_for artist.artist_profile.contact_information do
            if artist.artist_profile.contact_information.blank?
              row 'No Record Found'
            else
              row :name
              row :phone
              row :email
              row :street
              row :postal_code
              row :city
              row :state
              row :country
            end
          end
        end

        panel 'Payment Information' do
          panel('', class: 'align-right') do
            if artist.artist_profile.payment_information.present? && authorized?(:update, PaymentInformation)
              link_to 'Edit payment Information', edit_admin_payment_information_path(artist.artist_profile.payment_information), class: 'medium button'
            elsif authorized?(:create, PaymentInformation)
              link_to 'Add payment Information', new_admin_payment_information_path(payment_information: { artist_profile_id: artist.artist_profile.id }), class: 'medium button'
            end
          end

          attributes_table_for artist.artist_profile.payment_information do
            if artist.artist_profile.payment_information.blank?
              row 'No Record Found'
            else
              row :payee_name
              row :bank_name
              row :routing
              row :account_number
              row :paypal_email
              row :updated_at, &:formatted_updated_at
            end
          end
        end

        panel 'Tax Information' do
          panel('', class: 'align-right') do
            if artist.artist_profile.tax_information.present?  && authorized?(:update, TaxInformation)
              link_to 'Edit tax Information', edit_admin_tax_information_path(artist.artist_profile.tax_information), class: 'medium button'
            elsif authorized?(:create, TaxInformation)
              link_to 'Add tax Information', new_admin_tax_information_path(tax_information: { artist_profile_id: artist.artist_profile.id }), class: 'medium button'
            end
          end

          attributes_table_for artist.artist_profile.tax_information do
            if artist.artist_profile.tax_information.blank?
              row 'No Record Found'
            else
              row :tax_id
              row :tax_forms do |tax_information|
                ul do
                  tax_information.tax_forms.each do |form|
                    li do
                      link_to 'Preview', rails_blob_url(form), class: 'small button'
                    end
                    br
                  end
                end
              end
            end
          end
        end

        panel 'Artist Notes' do
          table_for artist.artist_profile.notes do
            if artist.artist_profile.notes.blank?
              column 'No Records Found'
            else
              column :id
              column :status
              if authorized?(:show, Note)
                column :actions do |note|
                  link_to 'view', admin_note_path(note), class: 'small button'
                end
              end
            end
          end
        end
      end
    end

    panel 'Albums' do
      table_for artist.albums do
        if artist.albums.blank?
          column 'No Records Found'
        else
          column :id
          column :name
          if authorized?(:show, Album)
            column :actions do |album|
              span link_to t('active_admin.view'), admin_album_path(album), class: 'small button'
              span link_to 'Download', download_zip_admin_album_path(album), class: 'small button'
            end
          end
        end
      end
    end

    panel 'Agreements' do
      @users_agreements = artist.users_agreements.artist.includes(:agreement)
      table_for @users_agreements do
        if @users_agreements.blank?
          column 'No Records Found'
        else
          column :id
          column :agreement
          column 'Agreement Type' do |users_agreement|
            users_agreement.agreement.agreement_type&.titleize
          end

          column :status do |users_agreement|
            users_agreement.status&.titleize
          end

          if authorized?(:show, UsersAgreement)
            column :actions do |users_agreement|
              link_to t('active_admin.view'), admin_users_agreement_path(users_agreement), class: 'small button'
            end
          end
        end
      end
    end

    panel 'Publishers' do
      if authorized?(:create, Publisher)
        panel('', class: 'align-right') do
          link_to 'Add new Publisher', new_admin_publisher_path(publisher: { user_id: artist.id }), class: 'medium button'
        end
      end

      table_for artist.publishers do
        if artist.publishers.blank?
          column 'No Records Found'
        else
          column :id
          column :name
          if authorized?(:show, Publisher)
            column :actions do |publisher|
              link_to t('active_admin.view'), admin_publisher_path(publisher), class: 'small button'
            end
          end
        end
      end
    end

    panel 'Collaborators Details' do
      @collaborator_details = artist.collaborators_details.includes(:collaborator, :collaborator_profile)
      table_for @collaborator_details do
        if @collaborator_details.blank?
          column 'No Records Found'
        else
          column :id
          column :collaborator do |collaborators_detail|
            link_to collaborators_detail.collaborator.full_name, admin_collaborator_path(collaborators_detail.collaborator)
          end

          column :access do |collaborators_detail|
            collaborators_detail.access&.titleize
          end

          column :status do |collaborators_detail|
            collaborators_detail.status&.titleize
          end

          column :pro do |collaborators_detail|
            collaborators_detail.collaborator_profile&.pro
          end

          column :ipi do |collaborators_detail|
            collaborators_detail.collaborator_profile&.ipi
          end

          if authorized?(:show, ArtistsCollaborator)
            column :actions do |collaborator|
              link_to t('active_admin.view'), admin_artists_collaborator_path(collaborator), class: 'small button'
            end
          end
        end
      end
    end
    active_admin_comments
  end

  csv do
    column (:artist_name) { |artist| (artist.artist_profile&.name) }
    column (:exclusive) { |artist| (formatted_boolean(artist.artist_profile&.exclusive)) }
    column (:payee_name) { |artist| (artist.artist_profile&.payment_information&.payee_name) }
    column (:city) { |artist| (artist.artist_profile&.contact_information&.city) }
    column (:state) { |artist| (artist.artist_profile&.contact_information&.state) }
    column (:postal_code) { |artist| (artist.artist_profile&.contact_information&.postal_code) }
    column (:country) { |artist| (artist.artist_profile&.contact_information&.country) }
    column (:phone) { |artist| (artist.artist_profile&.contact_information&.phone) }
    column (:email) { |artist| (artist.artist_profile&.contact_information&.email) }
    column (:tax_id) { |artist| (artist.artist_profile&.tax_information&.tax_id) }
    column ('Date Updated') { |artist| artist.formatted_updated_at }
    column (:bank_name) { |artist| (artist.artist_profile&.payment_information&.bank_name) }
    column (:routing) { |artist| (artist.artist_profile&.payment_information&.routing) }
    column (:account_number) { |artist| (artist.artist_profile&.payment_information&.account_number) }
    column (:paypal_email) { |artist| (artist.artist_profile&.payment_information&.paypal_email) }
    column (:updated?) { |artist| (formatted_boolean(artist.artist_profile&.update_count > 1)) }
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :admin_note, input_html: { class: 'autogrow', rows: 4, cols: 20 }
    end

    f.actions do
      f.action :submit
      f.cancel_link(params[:index].present? ? { action: 'index' } : { action: 'show' })
    end
  end
end
