ActiveAdmin.register User, as: 'Artist' do
  config.remove_action_item(:new)
  permit_params :first_name, :last_name

  filter :first_name_or_last_name_cont, as: :string, label: 'Name'
  filter :artist_profile_name_cont, as: :string, label: 'Artist Name'
  filter :artist_profile_contact_information_name_cont, as: :string, label: 'Contact Name'
  filter :artist_profile_exclusive, as: :select, label: 'Exclusive'
  filter :artist_profile_contact_information_country_cont, as: :string, label: 'Country'
  filter :artist_profile_contact_information_state_cont, as: :string, label: 'State'
  filter :artist_profile_contact_information_city_cont, as: :string, label: 'City'
  filter :artist_profile_payment_information_payee_name_cont, as: :string, label: 'Payee Name'
  filter :artist_profile_payment_information_bank_name_cont, as: :string, label: 'Bank name'
  filter :email
  filter :created_at

  controller do
    def scoped_collection
      end_of_association_chain.artist
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    column :roles do |artist|
      artist.roles.map(&:titleize)
    end
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
      row :roles do
        artist.roles.map(&:titleize)
      end
    end

    panel 'Artist Profile' do
      if artist.artist_profile.blank?
        row 'No Record Found'
      else
        panel('', class: 'align-right') do
          link_to 'Edit artist profile', edit_admin_artist_profile_path(artist.artist_profile), class: 'medium button'
        end
        attributes_table_for artist.artist_profile do
          row :name
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
          row :exclusive
          row :sounds_like
          row :bio
          row :key_facts
          row :social
          row :created_at
          row :updated_at

          panel 'Contact Information' do
            panel('', class: 'align-right') do
              if artist.artist_profile.contact_information.present?
                link_to 'Edit contact Information', edit_admin_contact_information_path(artist.artist_profile.contact_information), class: 'medium button'
              else
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
              if artist.artist_profile.payment_information.present?
                link_to 'Edit payment Information', edit_admin_payment_information_path(artist.artist_profile.payment_information), class: 'medium button'
              else
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
              if artist.artist_profile.tax_information.present?
                link_to 'Edit tax Information', edit_admin_tax_information_path(artist.artist_profile.tax_information), class: 'medium button'
              else
                link_to 'Add tax Information', new_admin_tax_information_path(tax_information: { artist_profile_id: artist.artist_profile.id }), class: 'medium button'
              end
            end

            attributes_table_for artist.artist_profile.tax_information do
              if artist.artist_profile.tax_information.blank?
                row 'No Record Found'
              else
                row :ssn
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
              column :actions do |note|
                link_to 'view', admin_note_path(note), class: 'small button'
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
          column :actions do |album|
            link_to t('active_admin.view'), admin_album_path(album), class: 'small button'
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

          column :actions do |users_agreement|
            link_to t('active_admin.view'), admin_users_agreement_path(users_agreement), class: 'small button'
          end
        end
      end
    end

    panel 'Publishers' do
      panel('', class: 'align-right') do
        link_to 'Add new Publisher', new_admin_publisher_path(publisher: { user_id: artist.id }), class: 'medium button'
      end

      table_for artist.publishers do
        if artist.publishers.blank?
          column 'No Records Found'
        else
          column :id
          column :name
          column :actions do |publisher|
            link_to t('active_admin.view'), admin_publisher_path(publisher), class: 'small button'
          end
        end
      end
    end

    panel 'Collaborators Details' do
      @collaborator_details = artist.collaborators_details.includes(:collaborator)
      table_for @collaborator_details do
        if @collaborator_details.blank?
          column 'No Records Found'
        else
          column :id
          column :collaborator do |collaborators_detail|
            link_to collaborators_detail.collaborator.email, admin_collaborator_path(collaborators_detail.collaborator)
          end

          column :access do |collaborators_detail|
            collaborators_detail.access&.titleize
          end

          column :status do |collaborators_detail|
            collaborators_detail.status&.titleize
          end

          column :actions do |collaborator|
            link_to t('active_admin.view'), admin_artists_collaborator_path(collaborator), class: 'small button'
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
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
    column (:roles) { |artist| artist.roles.map(&:titleize) }
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end


end
