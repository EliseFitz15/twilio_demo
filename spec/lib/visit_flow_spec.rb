require 'rails_helper'

describe VisitFlow do
  Request = Struct.new(:base_url)
  describe '#send_message' do
    let(:member) { create :member, :with_active_membership }
    let(:sms_client) { FakeSMS }
    let(:request) { Request.new('http://localhost:3000') }

    it 'returns true if first sent and interaction was created' do
      expect(described_class.new.send_message(member, sms_client, request: request, send_first: true)).to eq(true)
    end

    it 'returns generates interaction for first message' do
      described_class.new.send_message(member, sms_client, request: request, send_first: true)
      expect(member.interactions.last.conversation.keys.count).to eq(1)
    end

    it 'sends first message' do
      described_class.new.send_message(member, sms_client, request: request, send_first: true)
      expect(member.interactions.last.conversation['1']['body']).to start_with('Strong work at the gym today')
    end

    it 'returns true if not the first message and interaction updated' do
      interaction = create(:interaction, :with_full_conversation)
      member = interaction.member
      expect(described_class.new.send_message(member, sms_client)).to eq(true)
    end

    it 'interaction updated' do
      interaction = create(:interaction, :with_full_conversation, flow_type: 'Visit')
      member = interaction.member
      described_class.new.send_message(member, sms_client)
      expect(member.interactions.last.conversation.keys.count).to eq(5)
    end
  end
end
