# frozen_string_literal: true

require "rails_helper"

RSpec.describe Poll, type: :model do
  let(:riding) { Riding.create(name: "MyString", riding_code: "MyString", province: "MyString") }

  it "requires a poll number" do
    poll = Poll.create(riding: riding)
    expect(poll.errors).to include(:number)
  end

  it "must belong to a riding" do
    poll = Poll.create(number: "1")
    expect(poll.errors).to include(:riding)
  end

  it "optionally has a polling location" do
    polling_location = PollingLocation.create(title: "Test Location", address: "Test Address", city: "Test", postal_code: "K1A 0A6", riding_id: riding.id)

    poll = Poll.create(number: "1", riding: riding, polling_location: polling_location)

    expect(poll).to be_valid
    expect(poll.polling_location).to eq polling_location
  end

  context "within a riding" do
    example "poll number must be unique" do
      Poll.create(riding: riding, number: "1")
      poll = Poll.create(riding: riding, number: "1")

      expect(poll).not_to be_valid
      expect(poll.errors).to include(:number)
    end

    example "polls can share a polling location" do
      polling_location = PollingLocation.create(title: "Test Location", address: "Test Address", city: "Test", postal_code: "K1A 0A6", riding_id: riding.id)
      poll_a = Poll.create(riding: riding, number: "1")
      poll_b = Poll.create(riding: riding, number: "2")

      polling_location.polls << [poll_a, poll_b]

      expect(poll_a).to be_valid
      expect(poll_a.polling_location).to eq polling_location
      expect(poll_b).to be_valid
      expect(poll_b.polling_location).to eq polling_location
    end
  end

  context "across ridings" do
    example "poll number can be reused" do
      riding_a = Riding.create(name: "MyString A", riding_code: "MyString A", province: "MyString A")
      riding_b = Riding.create(name: "MyString B", riding_code: "MyString B", province: "MyString B")

      poll_a = Poll.create(riding: riding_a, number: "1")
      poll_b = Poll.create(riding: riding_b, number: "1")

      expect(poll_a).to be_valid
      expect(poll_b).to be_valid
    end
  end
end
