# frozen_string_literal: true

require "rails_helper"

RSpec.describe Riding, type: :model do

  it "requires a name" do
    riding = described_class.create(name: "", riding_code: "10101", province: "Test Province")
    expect(riding.errors).to include(:name)
  end

  it "requires a riding code" do
    riding = described_class.create(name: "Test Riding", riding_code: "", province: "Test Province")
    expect(riding.errors).to include(:riding_code)
  end

  it "requires a province" do
    riding = described_class.create(name: "Test Riding", riding_code: "10101", province: "")
    expect(riding.errors).to include(:province)
  end

  it "requires a unique riding code" do
    Riding.create!(name: "Test Riding", riding_code: "10101", province: "Test Province")

    riding = described_class.create(name: "Test Riding", riding_code: "10101", province: "Test Province")

    expect(riding.errors.full_messages).to include("Riding code has already been taken")
  end

  it "has many polling locations" do
    riding = described_class.create(name: "Test Riding", riding_code: "10101", province: "Test Province")
    polling_location_a = PollingLocation.create(
      riding_id: riding.id,
      title: "Test Title A",
      address: "Test Address A",
      city: "Test City A",
      postal_code: "K1A 0A6"
    )
    polling_location_b = PollingLocation.create(
      riding_id: riding.id,
      title: "Test Title B",
      address: "Test Address B",
      city: "Test City B",
      postal_code: "V0J 2N0"
    )

    riding.polling_locations << [polling_location_a, polling_location_b]

    expect(riding).to be_valid
    expect(riding.polling_locations).to contain_exactly(polling_location_a, polling_location_b)
  end

  it "has many polls" do
    riding = described_class.create(name: "Test Riding", riding_code: "10101", province: "Test Province")

    poll_a = Poll.create(riding_id: riding.id, number: "1")
    poll_b = Poll.create(riding_id: riding.id, number: "2")

    expect(riding).to be_valid
    expect(riding.polls).to contain_exactly(poll_a, poll_b)
  end
end
