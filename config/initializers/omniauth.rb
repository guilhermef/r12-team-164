Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook, '411973878869082', 'ed5b297c305d205d01a93cf6d16ffd3a', {:scope => 'email, read_stream, read_friendlists, friends_likes, friends_status, offline_access'}

  # If you want to also configure for additional login services, they would be configured here.
end