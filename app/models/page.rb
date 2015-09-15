class Page < ActiveRecord::Base
  validates :permalink, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :content, presence: true
  validates :title, presence: true
  before_save { sanitize_permalink! }

  private

  def sanitize_permalink!
    self.permalink = self.permalink
      .gsub(/[^\sa-zA-Z0-9_-]+/, '')
      .strip
      .gsub(/\s+/, '-')
      .downcase
  end
end
