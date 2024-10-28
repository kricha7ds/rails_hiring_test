class PollingLocation < ApplicationRecord
  belongs_to :riding
  has_many :polls

  validates :title, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :title, uniqueness: { scope: [:address, :city, :postal_code], message: "Polling location has already been taken" }

  validate :validate_postal_code

  after_validation :format_postal_code

  def format_postal_code
    self.postal_code = self.postal_code.upcase.scan(/[A-Z0-9]/).insert(3, ' ').join if self.postal_code.present?
  end

  def validate_postal_code
    unless self.postal_code.present? && /[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ ]?\d[ABCEGHJ-NPRSTV-Z]\d/.match?(self.postal_code.upcase)
      errors.add(:postal_code, "must be valid")
    end
  end
end
