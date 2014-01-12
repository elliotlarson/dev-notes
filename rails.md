# Rails Notes

#### Roll back and then migrate, add step if you need more than one

	$ rake db:migrate:redo STEP=3

#### Execute the jasmine suite on the command line

	$ bundle exec guard-jasmine

#### Decrypting the encrypted session:

	Marshal.load(ActiveSupport::Base64.decode64('BAh7CEkiD3Nlc3Npb25faWQGOgZFRkkiJTk5ODlkYzhhODI1NDNiZDNlNjBjNzdhY2U2MTg3MGRkBjsAVEkiEF9jc3JmX3Rva2VuBjsARkkiMUhQUHlqZjV2dWZIOVBxL2tGKzJKQmp4K3hTLzhmV2pieDAwSFVQMnFwRGM9BjsARkkiEnByb2plY3RfdG9rZW4GOwBGSSILQVk3VDJIBjsAVA==--4f9e81ea1176b3a99318ccfe91224e99ccba23aa'))