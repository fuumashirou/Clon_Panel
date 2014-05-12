# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Panel::Application.config.secret_key_base = '0cc1c4d79a886ef7d39f4fbadd333e1b5852dd2bd073a820de5322b25fb63d442c3adf80cd9dd8a6104ebc54ac4185e3a976f210a51ac37a924dd4c83cbaa854'
