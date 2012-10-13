OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :facebook, '411973878869082', 'ed5b297c305d205d01a93cf6d16ffd3a', {:scope => 'email, read_stream, read_friendlists, friends_likes, friends_status, offline_access'}

end
