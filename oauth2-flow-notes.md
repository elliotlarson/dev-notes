# OAuth2 Notes

## Resources

- https://www.youtube.com/watch?v=996OiexHze0
- https://oauthdebugger.com

OAuth is primarily used for two main use cases:

- Authorization: the ability to grab user approved (granted) access to data in a 3rd party system (what OAuth was originally created for)
- Authentication: the ability to authenticate a user account using a 3rd party system; this is referred to as OpenID Connect (a small bit of protocol on top of OAuth)

## OpenID Connect

- Uses an ID token (instead of an access token, like with standard OAuth authorization, also in JWT format)
- User info endpoint for gathering more user info
- A standard set of scopes
- Standard implementation

When making an initial request to the authorization provider, you pass the scopes "openid" and "profile".

## OpenID Connect Style Flow

Here's a general flow for OAuth2 when using an external authentication provider like Google.

### 1. Authorization Request:

The client (your app) directs the user's browser to the authorization server (Google). This is usually done by clicking on a button like "Log in with Google". The request will contain parameters such as `client_id`, `response_type`, `redirect_uri`, and `scope` which describes the level of access that your app is requesting from the user's Google account.

In a Rails app with Devise/omniauth, you post to a URL endpoint in your app like `/users/auth/google_oauth2`, which constructs this URL and redirects to it. The URL looks like: https://accounts.google.com/o/oauth2/auth?client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI&response_type=code&scope=REQUESTED_SCOPES&state=RANDOM_STRING

- **client_id**: This is your application's client ID, which you get from the Google Cloud Console.
- **redirect_uri**: This is the URL in your application that Google will redirect the user to after they log in, something like `/users/auth/google_oauth2/callback`. It must match one of the redirect URIs you specified in the Google Cloud Console.
- **response_type**: This is always code, because you want Google to respond with an authorization code.
- **scope**: This is a space-separated list of scopes that your application is requesting access to.
- **state**: This is a random string that your application generates to prevent CSRF attacks. Google will include this string in the redirect back to your application, and your application should check that it matches the original string.

### 2. User Consent:

The authorization server prompts the user to authenticate (if they are not already logged in) and asks for their consent to grant the requested permissions to your app. This is typically done with a screen that says something like "App X is requesting the following permissions..."

### 3. Authorization Grant:

If the user agrees to grant the permissions, Google's authorization server sends an authorization code to the redirect URI specified in the initial authorization request. This redirect is done via the user's browser.

The request looks like:

> Started GET "http://localhost:3000/users/auth/google_oauth2/callback?state=d177530061589ba7fd9c6d037f855b3136bf49d9fbf10dd7&code=4/0AbUR2VN5oqlojMIu4HhedGHxAvduq2inN70WERRAm97ltKrDHr3tdLlQnv_NJcTdDq_7TQ&scope=email%20profile%20https://www.googleapis.com/auth/userinfo.email%20https://www.googleapis.com/auth/userinfo.profile%20openid&authuser=0&hd=elliot.la&prompt=none" for 127.0.0.1 at 2023-06-20 16:57:21 -0700

This carries the state CSRF token ensuring that the request is coming from Google.

```ruby
{ "state"=>"d177530061589ba7fd9c6d037f855b3136bf49d9fbf10dd7",
  "code"=>"4/0AbUR2VN5oqlojMIu4HhedGHxAvduq2inN70WERRAm97ltKrDHr3tdLlQnv_NJcTdDq_7TQ",
  "scope"=>"email profile https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid",
  "authuser"=>"0",
  "hd"=>"elliot.la",
  "prompt"=>"none" }
```

### 4. Access Token Request:

The client (your app) extracts the authorization code from the response and sends it to the authorization server (Google) in exchange for an access token. This request is made server-to-server and contains parameters like `client_id`, `client_secret`, `grant_type`, `redirect_uri`, and `code` (the authorization code).

The endpoint URL is something like the following for Google: `https://oauth2.googleapis.com/token`

The body of the POST request would generally include these fields:

- **code**: The authorization code you received.
- **client_id**: The client ID you received from Google when you registered your application.
- **client_secret**: The client secret you received from Google when you registered your application.
- **redirect_uri**: The same redirect URI that you used in the initial authorization request.
- **grant_type**: This field must contain a value of `authorization_code`.

Here is an example of how you might structure this POST request using `curl`:

```bash
curl -d "code=AUTHORIZATION_CODE" \
     -d "client_id=YOUR_CLIENT_ID" \
     -d "client_secret=YOUR_CLIENT_SECRET" \
     -d "redirect_uri=YOUR_REDIRECT_URI" \
     -d "grant_type=authorization_code" \
     "https://oauth2.googleapis.com/token"
```

### 5. Access Token Response:

The authorization server (Google) validates the authorization code and other details, and if everything checks out, it issues an access token and sends it back to your app.

The response might look like this:

```json
{
  "access_token": "ya29.A0AfH6SMDTtB...",
  "expires_in": 3600,
  "refresh_token": "1//0gxa...",
  "scope": "https://www.googleapis.com/auth/userinfo.email",
  "token_type": "Bearer",
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6..."
}
```

- **access_token**: This is the token that can be used to authenticate API requests on behalf of the user. It's often a JWT, but that's not required by the OAuth2 spec.
- **expires_in**: This is the lifetime of the access token in seconds. In this case, the token will be valid for an hour (3600 seconds) from the time it was issued.
- **refresh_token**: This is a special token that can be used to get a new access token when the current one expires. Not all applications will receive a refresh token; it depends on the scopes and other parameters in the original authorization request.
- **scope**: This is the list of scopes that the user has granted to your application. It could be a space-separated list if multiple scopes were requested.
- **token_type**: This is the type of token that's been issued. "Bearer" is the most common type.
- **id_token**: This is an OpenID Connect ID token, which is a JWT that contains claims about the authenticated user, such as their email address, name, and so forth.

Let's say you have decoded a Google `id_token` using the `jwt` gem in Ruby as described in the previous message. The payload part of the decoded JWT might look like this:

```ruby
{
  "iss": "https://accounts.google.com",
  "azp": "123499581998-k3tbjo8jlv5...",
  "aud": "123499581998-k3tbjo8j...",
  "sub": "113774551322879413522",
  "email": "test.user@gmail.com",
  "email_verified": true,
  "at_hash": "HK6E_P6Dh8Y93mRNtsDB1Q",
  "name": "Test User",
  "picture": "https://lh4.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg",
  "given_name": "Test",
  "family_name": "User",
  "locale": "en",
  "iat": 1516239022,
  "exp": 1516242922,
  "jti": "b707875e4a3f3f84f64f4a48f9a9849b858b9dbb"
}
```

Here's what each of these fields means:

- **iss**: The issuer of the token, which will be `https://accounts.google.com` for Google.
- A JWT (JSON Web Token) issued by Google's OAuth2 service as an `id_token` generally contains claims (i.e., pieces of information) about the authenticated user.

Let's say you have decoded a Google `id_token` using the `jwt` gem in Ruby as described in the previous message. The payload part of the decoded JWT might look like this:

```ruby
{
  "iss": "https://accounts.google.com",
  "azp": "123499581998-k3tbjo8jlv5...",
  "aud": "123499581998-k3tbjo8j...",
  "sub": "113774551322879413522",
  "email": "test.user@gmail.com",
  "email_verified": true,
  "at_hash": "HK6E_P6Dh8Y93mRNtsDB1Q",
  "name": "Test User",
  "picture": "https://lh4.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg",
  "given_name": "Test",
  "family_name": "User",
  "locale": "en",
  "iat": 1516239022,
  "exp": 1516242922,
  "jti": "b707875e4a3f3f84f64f4a48f9a9849b858b9dbb"
}
```

Here's what each of these fields means:

- **iss**: The issuer of the token, which will be `https://accounts.google.com` for Google.
- **azp** and **aud**: The client ID of your app. `azp` is the authorized party to which this token was issued, and `aud` is the audience of this token. They are usually the same unless it's an ID token that has been delegated access.
- **sub**: The ID of the authenticated user, a unique identifier for that user.
- **email**: The user's email address.
- **email_verified**: A boolean indicating whether the user's email address has been verified.
- **name**: The user's full name.
- **picture**: The URL of the user's profile picture.
- **given_name** and **family_name**: The user's first and last name, respectively.
- **locale**: The user's locale setting.
- **iat** and **exp**: The issued at time and expiration time of the token, both in Unix time.
- **at_hash**: Access token hash, provides validation that the access token is tied to the identity token.
- **jti**: JWT ID claim provides a unique identifier for the token.

The exact claims present in the ID token can vary depending on the scopes that were requested, and some of these fields may not always be present. For example, if the 'profile' scope was not requested, the claims related to the user's profile information (such as `name`, `picture`, `given_name`, and `family_name`) might not be present.

When logging in with Google, after you've decoded the JWT and retrieved the user's info, you can look up the user record in your system:

1. Do a database lookup for a user using the Google uid (the `sub` from the JWT) for the user; if found, login user and redirect to the appropriate place
2. If not found, look up the user by email; if found, store the Google uid on the user's record, sign the user in, and then redirect to the appropriate place
3. If not found, create a new user with data from the JWT, sign the user in, and then redirect to the appropriate place

## Authorize code and access token

The reason we get an authorization code in order to get an access token is for security purposes. The authorization token is communicated on the "front channel", meaning it's visible to the user via network inspection tools. The authorization code is then sent back to OAuth provider from your app in what's called "back channel" communication. It's server to server and not visible to the user or someone else watching the network traffic.

## Single Sign On Links

**Generated with ChatGPT**

### Prompt>

Say you have an OAuth provider application called AccountsApp, and a client application called ProjectsApp. Is there a standard protocol for handling the following user interaction: User navigates directly to AccountsApp and logs in and stays on the AccountsApp, maybe they hit a dashboard page. Then the account app has links into the ProjectsApp. The user clicks one of the project details links and is automatically logged into the ProjectsApp as a part of this process.

### Answer>

Yes, there are standard protocols that handle such user interactions, notably OAuth 2.0 and OpenID Connect (OIDC).

However, your scenario sounds a little bit more specific and is somewhat akin to a Single Sign-On (SSO) system. In an SSO, a user logs in once and gains access to multiple systems without being prompted to log in again for each one. The OAuth 2.0 protocol, together with OpenID Connect, is often used for such scenarios.

The high-level process would look something like this:

1. The user navigates to the AccountsApp and logs in. The AccountsApp acts as the identity provider (IdP).

2. Upon successful login, the AccountsApp sets a session cookie in the user's browser.

3. The AccountsApp displays a dashboard with various links to the ProjectsApp. These URLs could contain special parameters indicating that the user should be automatically logged in when redirected to the ProjectsApp.

4. When the user clicks on a link to the ProjectsApp, the user's browser is redirected to the ProjectsApp, along with the special parameters.

5. The ProjectsApp, acting as the relying party (RP), detects these parameters and makes a backchannel request to the AccountsApp to verify the user's session.

6. The AccountsApp checks the user's session against the cookie in the browser, and if it is valid, it sends an assertion back to the ProjectsApp.

7. The ProjectsApp, upon receiving this assertion, logs the user in and the user can use the ProjectsApp without having to log in again.

Note: In a real-world scenario, more steps would be needed to ensure security. For instance, the initial login could involve two-factor authentication, and communication between the Apps would be over secure channels.

Remember that implementation of such protocols should be done very carefully, as mistakes can lead to security vulnerabilities. If you're not an expert in this area, it would be wise to use well-established libraries or services that handle most of the complexities for you.

### Prompt>

Can you show me a simple design for this in code where both the AccountsApp and ProjectsApp are developed with Rails?

### Answer>

Below is a high-level demonstration of how this could be accomplished using Ruby on Rails with Devise for user authentication in the AccountsApp and Doorkeeper as an OAuth provider.

**In the AccountsApp:**

1. Install Devise and set up User model for authentication.

2. Install Doorkeeper to act as OAuth provider.

Add Doorkeeper to your Gemfile and run `bundle install`:

```ruby
gem 'doorkeeper'
```

Run the Doorkeeper generator:

```bash
rails generate doorkeeper:install
rails generate doorkeeper:migration
rails db:migrate
```

Add Doorkeeper configuration to User model:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all
end
```

3. Enable the resource_owner_authenticator block in the doorkeeper initializer.

```ruby
# config/initializers/doorkeeper.rb
Doorkeeper.configure do
  resource_owner_authenticator do
    User.find_by_id(session[:current_user_id]) || redirect_to(new_user_session_url)
  end
  # other configuration
end
```

4. Generate the links with the OAuth authorization url. Assuming `client_id` is the OAuth client id of the ProjectsApp, and `redirect_uri` is the url in ProjectsApp that the user will be redirected to after successful authorization.

```ruby
<%= link_to 'Project 1', "https://ProjectsApp.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{redirect_uri}&response_type=code" %>
```

**In the ProjectsApp:**

1. Install OAuth2 gem in the Gemfile:

```ruby
gem 'oauth2'
```

2. Use OAuth2 client to request access token when user visits the link from AccountsApp:

```ruby
client = OAuth2::Client.new('client_id', 'client_secret', :site => "https://AccountsApp.com")

# Use the authorization code to get access token
token = client.auth_code.get_token(params[:code], :redirect_uri => 'redirect_uri')
```

3. Save the `access_token` in session or a HttpOnly secure cookie. The token will then be used to access the user's resources on AccountsApp.

Note: You need to replace `'client_id'`, `'client_secret'` and `'redirect_uri'` with the actual values. Also replace `"https://AccountsApp.com"` and `"https://ProjectsApp.com"` with the actual URLs of the apps.

This is a simple implementation and doesn't consider various security measures that would be necessary in a production setting, such as CSRF protection and ensuring secure communication. Make sure to implement those in a real-world application.
