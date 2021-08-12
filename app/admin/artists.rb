ActiveAdmin.register User, as: 'Artist' do
  config.remove_action_item(:new)
  permit_params :first_name, :last_name

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
    column :created_at
    column :updated_at
    column :roles, &:roles_string
    actions defaults: false do |artist|
      item 'View', admin_artist_path(artist), class: 'member_link' if Pundit.policy(current_admin_user, [:active_admin, artist]).show?
      item 'Edit', edit_admin_artist_path(artist, index: true), class: 'member_link' if Pundit.policy(current_admin_user, [:active_admin, artist]).update?
      item 'Delete', admin_artist_path(artist), method: :delete, class: 'member_link' if Pundit.policy(current_admin_user, [:active_admin, artist]).destroy?
    end
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
      row :roles do
        artist.roles_string
      end
    end

    panel 'Artist Profile' do
      if artist.artist_profile.blank?
        row 'No Record Found'
      else
        panel('', class: 'align-right') do
          if Pundit.policy(current_admin_user, [:active_admin, artist.artist_profile]).update?
            link_to 'Edit artist profile', edit_admin_artist_profile_path(artist.artist_profile), class: 'medium button'
          end
        end
        attributes_table_for artist.artist_profile do
          row :name
          row :email
          row :banner_image do
            image_tag(artist.artist_profile.banner_image, width: 320, height: 100) if artist.artist_profile.banner_image.attached?
          end

          row :banner_image_status do
            artist.artist_profile.banner_image_status&.titleize
          end

          row :profile_image do
            image_tag(artist.artist_profile.profile_image, width: 100, height: 100) if artist.artist_profile.profile_image.attached?
          end

          row :profile_image_status do
            artist.artist_profile.profile_image_status&.titleize
          end

          row :additional_images do
            ul do
              artist.artist_profile.additional_images.each do |img|
                li do
                  image_tag(img, width: 100, height: 100)
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
          row :created_at
          row :updated_at

          panel 'Contact Information' do
              panel('', class: 'align-right') do
                if artist.artist_profile.contact_information.present? && Pundit::policy(current_admin_user, [:active_admin, ContactInformation]).update?
                  link_to 'Edit contact Information', edit_admin_contact_information_path(artist.artist_profile.contact_information), class: 'medium button'
                elsif Pundit::policy(current_admin_user, [:active_admin, ContactInformation]).create?
                  link_to 'Add contact Information', new_admin_contact_information_path(contact_information: { artist_profile_id: artist.artist_profile.id }), class: 'medium button'
                end
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
            if artist.artist_profile.payment_information.present? && Pundit::policy(current_admin_user, [:active_admin, PaymentInformation]).update?
              link_to 'Edit payment Information', edit_admin_payment_information_path(artist.artist_profile.payment_information), class: 'medium button'
            elsif Pundit::policy(current_admin_user, [:active_admin, PaymentInformation]).create?
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
              row :updated_at
            end
          end
        end

        panel 'Tax Information' do
          panel('', class: 'align-right') do
            if artist.artist_profile.tax_information.present?  && Pundit::policy(current_admin_user, [:active_admin, TaxInformation]).update?
              link_to 'Edit tax Information', edit_admin_tax_information_path(artist.artist_profile.tax_information), class: 'medium button'
            elsif Pundit::policy(current_admin_user, [:active_admin, TaxInformation]).create?
              link_to 'Add tax Information', new_admin_tax_information_path(tax_information: { artist_profile_id: artist.artist_profile.id }), class: 'medium button'
            end
          end

          attributes_table_for artist.artist_profile.tax_information do
            if artist.artist_profile.tax_information.blank?
              row 'No Record Found'
            else
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

        panel 'Notes' do
          table_for artist.artist_profile.notes do
            if artist.artist_profile.notes.blank?
              column 'No Records Found'
            else
              column :id
              column :status
              if Pundit::policy(current_admin_user, [:active_admin, Note]).show?
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
          if Pundit::policy(current_admin_user, [:active_admin, Album]).show?
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

          if Pundit::policy(current_admin_user, [:active_admin, UsersAgreement]).show?
            column :actions do |users_agreement|
              link_to t('active_admin.view'), admin_users_agreement_path(users_agreement), class: 'small button'
            end
          end
        end
      end
    end

    panel 'Publishers' do
      if Pundit::policy(current_admin_user, [:active_admin, Publisher]).create?
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
          if Pundit::policy(current_admin_user, [:active_admin, Publisher]).show?
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

          if Pundit::policy(current_admin_user, [:active_admin, ArtistsCollaborator]).show?
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
    column :id
    column :email
    column :first_name
    column :last_name
    column (:created_at) { |artist| formatted_datetime(artist.created_at.localtime) }
    column (:updated_at) { |artist| formatted_datetime(artist.updated_at.localtime) }
    column :roles, &:roles_string
    column (:name) { |artist| (artist.artist_profile&.name) }
    column (:email) { |artist| (artist.artist_profile&.email) }
    column (:country) { |artist| (artist.artist_profile&.country) }
    column (:exclusive) { |artist| (artist.artist_profile&.exclusive) }
    column (:sounds_like) { |artist| (artist.artist_profile&.sounds_like) }
    column (:pro) { |artist| (artist.artist_profile&.pro) }
    column (:ipi) { |artist| (artist.artist_profile&.ipi) }
    column (:genres) { |artist| (artist.artist_profile&.genre_names) }
    column (:bio) { |artist| (artist.artist_profile&.bio) }
    column (:key_facts) { |artist| (artist.artist_profile&.key_facts) }
    column (:social) { |artist| (artist.artist_profile&.social) }
    column (:website_link) { |artist| (artist.artist_profile&.website_link) }
    column (:name) { |artist| (artist.artist_profile&.contact_information&.name) }
    column (:phone) { |artist| (artist.artist_profile&.contact_information&.phone) }
    column (:email) { |artist| (artist.artist_profile&.contact_information&.email) }
    column (:street) { |artist| (artist.artist_profile&.contact_information&.street) }
    column (:postal_code) { |artist| (artist.artist_profile&.contact_information&.postal_code) }
    column (:city) { |artist| (artist.artist_profile&.contact_information&.city) }
    column (:state) { |artist| (artist.artist_profile&.contact_information&.state) }
    column (:country) { |artist| (artist.artist_profile&.contact_information&.country) }
    column (:payee_name) { |artist| (artist.artist_profile&.payment_information&.payee_name) }
    column (:bank_name) { |artist| (artist.artist_profile&.payment_information&.bank_name) }
    column (:routing) { |artist| (artist.artist_profile&.payment_information&.routing) }
    column (:account_number) { |artist| (artist.artist_profile&.payment_information&.account_number) }
    column (:paypal_email) { |artist| (artist.artist_profile&.payment_information&.paypal_email) }

  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
    end

    f.actions do
      f.action :submit
      f.cancel_link(params[:index].present? ? { action: 'index' } : { action: 'show' })
    end
  end
end
