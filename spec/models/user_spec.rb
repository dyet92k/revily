require 'spec_helper'

describe User do
  pause_events!

  context 'associations' do
    it { expect(subject).to belong_to(:account) }
    it { expect(subject).to have_many(:contacts) }
    it { expect(subject).to have_many(:user_schedule_layers) }
    it { expect(subject).to have_many(:schedule_layers).through(:user_schedule_layers) }
    it { expect(subject).to have_many(:policy_rules) }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:email) }
    it { expect(subject).to validate_presence_of(:password) }
    # it { should validate_presence_of(:state) }
  end

  context 'attributes' do
    it { expect(subject).to have_readonly_attribute(:uuid) }
    it 'uses uuid for #to_param' do
      obj = create(subject.class)
      expect(obj.to_param).to eq obj.uuid
    end
  end
end
