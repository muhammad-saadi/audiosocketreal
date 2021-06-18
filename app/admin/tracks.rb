ActiveAdmin.register Track do
  permit_params :title, :status, :album_id, :public_domain, :publisher_id, :artists_collaborator_id
end
