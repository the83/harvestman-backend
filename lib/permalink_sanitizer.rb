module PermalinkSanitizer
  def sanitize_permalink!
    self.permalink = self.permalink
      .gsub(/[^\sa-zA-Z0-9_-]+/, '')
      .strip
      .gsub(/\s+/, '-')
      .downcase
  end
end
