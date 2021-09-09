ActiveAdmin.register User, as: 'Collaborator' do
  menu false
  actions :edit, :update
  permit_params :first_name, :last_name

  controller do
    def update
      if resource.update(permitted_params[:user])
        redirect_to admin_artists_collaborator_path(params[:user][:artists_collaborator])
      else
        super
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :artists_collaborator, input_html: { value: params[:artists_collaborator] }, as: :hidden
    end

    f.actions do
      f.action :submit
      f.cancel_link(params[:artists_collaborator].present? ? admin_artists_collaborator_path(params[:artists_collaborator]) : { action: 'show' })
    end
  end
end
