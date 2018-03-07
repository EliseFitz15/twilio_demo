module MemberHelper
  def demo_member
    Member.new(
      client_member_id: demo_client.name,
      first_name: interaction_params[:first_name],
      last_name: interaction_params[:last_name],
      email: "#{interaction_params[:first_name]}#{rand(1000)}@kokofitclub.com",
      phone: interaction_params[:phone],
      date_of_birth: 30.years.ago,
      gender: %w[F M].sample
    )
  end

  def demo_membership
    demo_member.memberships << Membership.new(location_id: demo_location.id, started_at: Date.yesterday)
  end

  def demo_client
    Client.find_or_create_by(name: 'Demo Client')
  end

  def demo_location
    Location.find_or_create_by(
      client_id: demo_client.id,
      customer_location_id: '111',
      name: 'Rockland Koko',
      street_1: '300 Ledgewood Place',
      city: 'Rockland',
      state: 'MA',
      zip_code: '02370',
      latitude: '42.163001',
      longitude: '-70.907604'
    )
  end
end
