# frozen_string_literal: true

require "rails_helper"

RSpec.describe PollingLocation, type: :model do
  let(:riding) { Riding.create(name: "MyString", riding_code: "MyString", province: "MyString") }

  it "requires a title" do
    polling_location = described_class.create(title: "", address: "Test Address", city: "Test", postal_code: "K1A 0A6", riding_id: riding.id)
    expect(polling_location.errors).to include(:title)
  end

  it "requires a address" do
    polling_location = described_class.create(title: "Test Title", address: "", city: "Test", postal_code: "K1A 0A6", riding_id: riding.id)
    expect(polling_location.errors).to include(:address)
  end

  it "requires a city" do
    polling_location = described_class.create(title: "Test Title", address: "Test Address", city: "", postal_code: "K1A 0A6", riding_id: riding.id)
    expect(polling_location.errors).to include(:city)
  end

  it "requires a postal_code" do
    polling_location = described_class.create(title: "Test Title", address: "Test Address", city: "Test", postal_code: "", riding_id: riding.id)
    expect(polling_location.errors).to include(:postal_code)
  end

  it "must belong to a riding" do
    polling_location = described_class.create(title: "Test Title", address: "Test Address", city: "Test", postal_code: "K1A 0A6")
    expect(polling_location.errors).to include(:riding)
  end

  it "can have many polls" do
    poll_a = Poll.create(riding_id: riding.id, number: "1")
    poll_b = Poll.create(riding_id: riding.id, number: "2")

    polling_location = described_class.create(title: "Test Title", address: "Test Address", city: "Test", postal_code: "K1A 0A6", riding_id: riding.id)
    polling_location.polls << [poll_a, poll_b]

    expect(polling_location).to be_valid
    expect(polling_location.polls).to contain_exactly(poll_a, poll_b)
  end

  context "within a riding" do
    it "polling location must be unique" do
      PollingLocation.create!(title: "Test Title", address: "Test Address", city: "Test", postal_code: "K1A 0A6", riding_id: riding.id)

      polling_location = described_class.create(title: "Test Title", address: "Test Address", city: "Test", postal_code: "K1A 0A6", riding_id: riding.id)

      expect(polling_location).not_to be_valid
      expect(polling_location.errors[:title]).to include("Polling location has already been taken")
    end
  end

  context "across ridings" do
    it "polling location must be unique" do
      riding_a = Riding.create(name: "MyString A", riding_code: "MyString A", province: "MyString A")
      riding_b = Riding.create(name: "MyString B", riding_code: "MyString B", province: "MyString B")
      PollingLocation.create!(title: "Test Title", address: "Test Address", city: "Test", postal_code: "K1A 0A6", riding_id: riding_a.id)

      polling_location = described_class.create(title: "Test Title", address: "Test Address", city: "Test", postal_code: "K1A 0A6", riding_id: riding_b.id)

      expect(polling_location).not_to be_valid
      expect(polling_location.errors[:title]).to include("Polling location has already been taken")
    end
  end
end
