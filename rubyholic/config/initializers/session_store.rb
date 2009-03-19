# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_railstest_session',
  :secret      => '5584f56f60092fd5de72f5506fc31bf6346dcace1703285cb53932f60fe50ed4ce0386f93aecb2fd5851f06142d0654b332a1d64526a1c6f59731cb3c39e14f3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
