shared_context :doorkeeper_app_with_token do
  let(:client) { create(:client) }
  let(:doorkeeper_application) { create(:application, owner: client) }
  let(:access_token) { create(:access_token, application_id: doorkeeper_application.id) }
  let(:auth_header) do
    { Authorization: "Bearer #{access_token.token}" }
  end
end
