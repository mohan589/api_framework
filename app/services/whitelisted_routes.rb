module WhitelistedRoutes
  WHITE_LISTED_ROUTES = ['/resources/new'].freeze

  def self.whitelisted?(path)
    WHITE_LISTED_ROUTES.include?(path)
  end
end
