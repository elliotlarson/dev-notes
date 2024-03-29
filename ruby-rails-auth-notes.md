# Rails Authentication Notes

## Sessions and Cookies

The default approach to storing session data in Rails is with cookies.

Note: if you want to store more data in the session than a cookie allows, or if you want to be able to access session data with something like a background job (for example, you may want another system to be able to logout a user), then you can store your session data in a database.

When a user visits the app for the first time, Rails creates a session hash, encrypts it, and then stores it in a response header:

```text
Set-Cookie: _myapp_session=a3xFoNMmV0xRwhlPWzyweuHOcdYBqNWNKj0En35UBY4jirdNDYyy09hkdDxWnC2hgUUfhMPBs6bgN5klA6gsQbIg40wu%2FfO%2B1RkvXMco%2FlKYzaKtrUjArlL9%2FIoWJOgujt8QMfYLIjpzLeub6%2BveVQG2UJGHrDzRl2s7MjIm4qB7wxkBkeZREjJYyWSLhLCRnDHdZGMAJ1F72fVMP%2BOY58%2FW8vq5nU0BaG0RF6fmypmQP%2FlNg64AJbbpRhQZnySvEJ9yF6Wdw9YCiVEhQKzQ3CrSCs7qknIl3xgK--BwfZRz4840wi%2B48L--T1l6WkCBxPC5kC2w58ua9Q%3D%3D; path=/; HttpOnly; SameSite=Lax
```

The cookie generally has the name of the app and "session", e.g. `_myapp_session`

To decrypt the cookie:

```ruby
# Note: In Rails 7 I can't get this to work, and for purposes of these notes it's not important to really
# be able to do this.  This is more interesting from the perspective of understanding the basic flow:

# Launch the Rails console, add the following class, and call it with a copied cookie value from the header
class CookieDecryptor
  def self.call(cookie)
    secret_key_base = Rails.application.secret_key_base # This can be stored in `config/secrets.yml` or `config/credentials.yml.enc`
    config = Rails.application.config # 'encrypted cookie'
    encrypted_cookie_salt = config.action_dispatch.encrypted_cookie_salt # 'signed encrypted cookie'
    encrypted_signed_cookie_salt = config.action_dispatch.encrypted_signed_cookie_salt

    puts "Secret key base: #{secret_key_base}"
    puts "Encrypted cookie salt: #{encrypted_cookie_salt}"
    puts "Encrypted signed cookie salt: #{encrypted_signed_cookie_salt}"

    decoded_cookie = CGI.unescape(cookie)
    last_index = decoded_cookie.rindex('--')
    cookie_data = decoded_cookie[0...last_index]
    signature = decoded_cookie[last_index + 2..-1]

    puts "Cookie data: #{cookie_data}"
    puts "Signature: #{signature}"

    key_generator = ActiveSupport::KeyGenerator.new(secret_key_base, iterations: 1000)
    secret = key_generator.generate_key(encrypted_cookie_salt)
    sign_secret = key_generator.generate_key(encrypted_signed_cookie_salt)
    verifier = ActiveSupport::MessageVerifier.new(sign_secret)

    raise 'Invalid signature' unless verifier.verify(cookie_data + "--" + signature)
    encryptor = ActiveSupport::MessageEncryptor.new(secret)
    encryptor.decrypt_and_verify(cookie_data)
  end
end
```

## A look at Warden

Devise uses the Warden gem under the hood to handle authentication. Warden is Rack based middleware.

To provide some quick Rack context, Rack is a standardized API library for receiving and responding to web requests. A basic Rack app looks like:

```ruby
class Application
  def call(env)
    status  = 200
    headers = { "Content-Type" => "text/html" }
    body    = ["Yay, your first web application! <3"]

    [status, headers, body]
  end
end

run Application.new
```

An example of a Rails based Rack middleware is `ActionDispatch::Cookies`.

Note that Warden doesn't handle session storage. It runs after the Rails session middleware.

To get a full list of middleware used by your app, you can run a Rails command:

```bash
$ bin/rails middleware
# use Rack::Cors
# use ActionDispatch::HostAuthorization
# use Rack::Sendfile
# use ActionDispatch::Static
# use ActionDispatch::Executor
# use ActionDispatch::ServerTiming
# use ActiveSupport::Cache::Strategy::LocalCache::Middleware
# use Rack::Runtime
# use Rack::MethodOverride
# use ActionDispatch::RequestId
# use RequestStore::Middleware
# use ActionDispatch::RemoteIp
# use Sprockets::Rails::QuietAssets
# use Rails::Rack::Logger
# use ActionDispatch::ShowExceptions
# use Sentry::Rails::CaptureExceptions
# use WebConsole::Middleware
# use ActionDispatch::DebugExceptions
# use Sentry::Rails::RescuedExceptionInterceptor
# use ActionDispatch::ActionableExceptions
# use ActionDispatch::Reloader
# use ActionDispatch::Callbacks
# use ActiveRecord::Migration::CheckPending
# use ActionDispatch::Cookies
# use ActionDispatch::Session::CookieStore
# use ActionDispatch::Flash
# use ActionDispatch::ContentSecurityPolicy::Middleware
# use ActionDispatch::PermissionsPolicy::Middleware
# use Rack::Head
# use Rack::ConditionalGet
# use Rack::ETag
# use Rack::TempfileReaper
# use Warden::Manager
# use OmniAuth::Strategies::GoogleOauth2
# run MyApp::Application.routes
```

Note: that after the Cookie related middleware runs, the `Warden::Manager` runs, which picks up the session cookie (something like `env["rack.session"]`).

### What Warden is doing

You can intercept the `Warden::Manager` middleware by adding another piece of middleware before and after it.

Create a middleware inspector class `app/middleware/middleware_inspector.rb`

```ruby
class MiddlewareInspector
  def initialize(app)
    @app = app
  end

  def call(env)
    debugger
    status, headers, response = @app.call(env)
    [status, headers, response]
  end
end
```

Then create an initializer `config/initializers/middleware_inspector.rb`

```ruby
require_relative "../../app/middleware/middleware_inspector"

Rails.application.configure do |config|
  # Allows you to insert a middleware before or after another middleware
  # to inspect what's going on in the request/response cycle:

  config.middleware.insert_before Warden::Manager, MiddlewareInspector
  config.middleware.insert_after Warden::Manager, MiddlewareInspector
end
```

Then you need to restart the server and the debugger will stop in the middleware chain before and after `Warden::Manager` is called.

After it's called the manager adds an `env["warden"]` value with a `Warden::Proxy` object.

After you sign in, you'll notice that the session goes from being something like:

```ruby
puts env["rack.session"].to_h
# {"session_id"=>"6a11613b8c1290e7f18b8a7f48dc6112", "_csrf_token"=>"YGPGEZf3qxF78IGe-MO_RZjbqP_PPm3IipXeXjaxHl4"}
```

... to something like:

```ruby
puts env["rack.session"].to_h
# {"session_id"=>"6a11613b8c1290e7f18b8a7f48dc6112",
#  "warden.user.user.key"=>[[2], "$2a$11$LbLyyFhZSsutDSZe4.LKeO"],
#  "_csrf_token"=>"3uGzl8VQ3rxRvvTa2RvYNZ2cJ01kT1xfUPBO-Udf_f4"}
```

And, if you want to look at the logged in user, you can see them with:

```ruby
puts env["warden"].user
```

As a side note: when you sign in, Rack is grabbing the sign in credentials like so:

```ruby
puts env["rack.request.form_hash"]
# {"authenticity_token"=>"PzWCoNigyXhuauSAAhID386sFdZ3O2TXPffoeJXk4xvklihW-qtRX4UCcaor2NZM9SNRJodRWmSgZKTRdFVI7Q",
#  "user"=>{"email"=>"me@example.com", "password"=>"secret", "remember_me"=>"0"}}
```

It uses a default strategy of `:password` to take this info, and lookup the user with it.

## Devise Additions

Devise adds a method to get the warden object out of the request environment in the controller:

```ruby
def warden
  request.env['warden']
end
```

It also sets a current user that gets the user object out of the warden object:

```ruby
def current_user
  @current_user ||= warden.authenticate(scope: :user)
end
```

It implements the following method to tell if the user is signed in:

```ruby
def user_signed_in?
  !!current_user
end
```

And then it provides the following method used in before actions in controllers to guard actions:

```ruby
def authenticate_user!
  unless user_signed_in?
    redirect_to new_user_session_path, alert: "You must be signed in to view this page."
  end
end
```

Devise also handles encrypting the password and storing it in the database. Here is the method it uses as a part of its authentication strategy to figure out if the user supplied password is valid:

```ruby
def valid_password?(password)
  return false if encrypted_password.blank?
  bcrypt   = ::BCrypt::Password.new(encrypted_password)
  password = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt.salt)
  Devise.secure_compare(password, encrypted_password)
end
```

Note that Devise provides it's own Warden strategy for authenticating the user, `Devise::Strategies::DatabaseAuthenticatable`, and it's this strategy that ultimately calls the `valid_password?` method to authenticate the user with a password during the Warden middleware execution.

Devise initializes this strategy with Warden and then Warden calls it with:

```ruby
env['warden'].authenticate(:database_authenticatable)
```

## Omniauth OAuth2

Omniauth allows logging into to your app by authenticating through a third party, like Google.

To set this up you need to get an OAuth key and secret from your third party provider.

To handle the individual third party providers, Omniauth provides strategies. These are often separate gems like `omniauth-google-oauth2`.

Devise works with Omniauth and OAuth out of the box. You can configure an Omniauth strategy to work with Devise by adding lines to the `config/initializers/devise.rb` initializer:

```ruby
Devise.setup do |config|
  config.omniauth(
    :google_oauth2,
    ENV.fetch("GOOGLE_OAUTH_CLIENT_ID", nil),
    ENV.fetch("GOOGLE_OAUTH_CLIENT_SECRET", nil),
  )

  # ...
end
```

You add a new line to your Devise routes config:

```ruby
devise_for(
  :users,
  controllers: {
    # registrations: 'users/registrations',
    # sessions: 'users/sessions',
    # unlocks: 'users/unlocks',
    # passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks', # <- this line
  },
)
```

Under the hood this will map POST requests to `/users/auth/google_oauth2`, to your custom `users/omniauth_callbacks` controller:

```ruby
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # This does not support account creation with Google OAuth.  It requires logging in with your original system
    # account first, connecting Google, and then on subsequent logins you can use the login with Google approach.
    def google_oauth2
      email = auth["info"]["email"]
      provider = auth["provider"]
      uid = auth["uid"]
      provider_user = User.find_by(provider:, uid:)

      if provider_user.present?
        flash[:notice] = "Signed in successfully via Google."
        sign_out_all_scopes
        sign_in_and_redirect provider_user, event: :authentication
      elsif current_user.present? && provider_user.blank?
        current_user.update(provider: provider, uid: uid)
        flash[:notice] = "Your Google account has been connected."
        redirect_to edit_account_url
      elsif User.find_by(email: email).present?
        flash[:alert] = "You need to sign in first and then connect to your Google account on your \"edit information\" account page."
        redirect_to new_user_session_url
      else
        flash[:alert] = "Unable to sign in with Google. Please make sure you are using an authorized account."
        redirect_to new_user_session_url
      end
    end

    private

    def after_omniauth_failure_path_for(_scope)
      new_user_session_path
    end

    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || projects_path
    end

    def auth
      @auth ||= request.env['omniauth.auth']
    end
  end
end
```

You also need to configure Devise to be onmiauthable in your user model.

```ruby
devise(
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable, :lockable, :confirmable,
  :omniauthable, omniauth_providers: [:google_oauth2], # <- this line
)
```

This allows something like `User.from_omniauth(request.env["omniauth.auth"])` to be called on your `User` model.

Then you add a button form to your login page that posts to: `/users/auth/google_oauth2`.

When you post to this route, the `omniauth-google-oauth2` middleware builds a URL for Google's OAuth2 authorization endpoint, which looks like this:

> https://accounts.google.com/o/oauth2/auth?client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI&response_type=code&scope=REQUESTED_SCOPES&state=RANDOM_STRING

- `client_id`: This is your application's client ID, which you get from the Google Cloud Console.
- `redirect_uri`: This is the URL in your application that Google will redirect the user to after they log in. It must match one of the redirect URIs you specified in the Google Cloud Console.
- `response_type`: This is always code, because you want Google to respond with an authorization code.
- `scope`: This is a space-separated list of scopes that your application is requesting access to.
- `state`: This is a random string that your application generates to prevent CSRF attacks. Google will include this string in the redirect back to your application, and your application should check that it matches the original string.

Here's a real-ish example:

> https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=2342342342342423234.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fusers%2Fauth%2Fgoogle_oauth2%2Fcallback&response_type=code&scope=email+profile&state=b0befa4f0c6f9806d230309c63696874431840a965bba852

Notice that the `redirect_uri` is set to `/users/auth/google_oauth2/callback`.

After you've logged in at `accounts.google.com`, Google posts back to `/users/auth/google_oauth2/callback`. The request looks like:

> Started GET "/users/auth/google_oauth2/callback?state=d177530061589ba7fd9c6d037f855b3136bf49d9fbf10dd7&code=4/0AbUR2VN5oqlojMIu4HhedGHxAvduq2inN70WERRAm97ltKrDHr3tdLlQnv_NJcTdDq_7TQ&scope=email%20profile%20https://www.googleapis.com/auth/userinfo.email%20https://www.googleapis.com/auth/userinfo.profile%20openid&authuser=0&hd=elliot.la&prompt=none" for 127.0.0.1 at 2023-06-20 16:57:21 -0700

This carries the state CSRF token ensuring that the request is coming from Google:

```ruby
{ "state"=>"d177530061589ba7fd9c6d037f855b3136bf49d9fbf10dd7",
  "code"=>"4/0AbUR2VN5oqlojMIu4HhedGHxAvduq2inN70WERRAm97ltKrDHr3tdLlQnv_NJcTdDq_7TQ",
  "scope"=>"email profile https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid",
  "authuser"=>"0", "hd"=>"elliot.la", "prompt"=>"none" }
```

### Where the Google uid comes from

After authorizing an account with Google for the first time, you generally save the uid for the user to your app's database. The provider uid comes from Google and is decoded from a JWT token:

### Basic process of getting the JWT and decoding it

1. **Your Application Sends a Request to Google's Token Endpoint**: After receiving the authorization code from Google, your application (more specifically, the `omniauth-google-oauth2` gem) sends a POST request to Google's token endpoint (`https://oauth2.googleapis.com/token`). This request includes the authorization code, your application's client ID and client secret, the redirect URI, and a grant type parameter (`grant_type=authorization_code`).
2. **Google Validates the Request**: Google validates the authorization code, the client ID and secret, and the redirect URI against the original values. If everything checks out, Google responds with a JSON object that includes an access token, an ID token, and a refresh token.
3. **The Access Token and ID Token Are Extracted**: The `omniauth-google-oauth2` gem parses the JSON response and extracts the access token and ID token. The access token can be used to make authenticated requests on behalf of the user, and the ID token contains user profile information (including the user's Google ID) encoded in a JWT (JSON Web Token).

OAuth2 uses a two-step process for exchanging an authorization code for an access token for several reasons, largely related to security:

1. **Redirection-based flow**: OAuth2 was designed with a redirection-based flow in mind. This means the user agent (e.g., a web browser) is redirected to the authorization server for user authentication and to obtain an authorization code. This code is then exchanged for an access token in a separate, server-to-server request. By separating these steps, the access token (which grants access to resources) is never exposed in the user agent or URL, making it less likely to be compromised.
2. **Client Authentication**: The second step also allows the client (the application requesting access) to authenticate itself to the authorization server. This is typically done using a client ID and secret, which is provided when the client is registered with the authorization server. By requiring client authentication, the authorization server can ensure that the access token is only provided to legitimate, registered applications.
3. **Short-lived authorization code**: The authorization code is short-lived and single-use. This means even if it was intercepted during the redirection step, it can't be used again to obtain an access token. This mitigates the risk of access token leakage.
4. **Binding of redirection URI**: During the exchange of the authorization code for the access token, the client needs to supply the same `redirect_uri` (if it was included in the initial authorization request). This means even if an attacker steals the authorization code, they won't be able to use it unless they also control the redirection endpoint.

## Creating a user account from the OAuth response

In the `Users::OmniauthCallbacksController#google_oauth2` method, you would just update the conditional flow to handle the case where the provider user is not found and the user email address is not found:

```ruby
  if !provider_user && !User.find_by(email: auth["info"]["email"])
    new_user = User.create!(
      first_name: auth["info"]["first_name"],
      last_name: auth["info"]["first_name"],
      email: auth["info"]["email"],
      password: SecureRandom.hex(10),
      confirmed_at: Time.zone.now,
      # ... etc.
    )
    flash[:notice] = "Signed in successfully via Google."
    sign_out_all_scopes
    sign_in_and_redirect new_user, event: :authentication
  # ... rest of conditional statement
```

Note that this needs to be updated to potentially handle any validation errors on user, like the `auth["info"]["first_name"]` is empty. Also, there may be data required by the app that the OAuth provider doesn't have. You may in this case want to redirect to a special account registration page created for the purpose of providing the additional needed info.

## Authenticated links from a logged in app to another app

Let's say you have two apps: a LoginApp, where users can login, manage their user account details, and view a list of project names for projects held in a second app; and then a ProjectsApp where users view and carry out project related CRUD actions. Let's imagine a workflow where a user logs in at LoginApp (https://loginapp.com), views a list of projects in ProjectsApp (https://projectsapp.com), and clicks a link to one of the projects, which takes them over to the project, authenticates them, and then allows the user to view/edit the project.

We can accomplish this with JWT tokens and we'll assume that both applications have access to a shared secret key, `my$ecretK3`, for token authentication.

1. **User Login:** When a user logs into the LoginApp it will verify the credentials and generate a JWT token that includes the user's id. The token will be stored in a secure HTTP-only cookie.

**LoginApp**

In `app/controllers/sessions_controller.rb`:

```ruby
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      payload = { user_id: user.id }
      hmac_secret = "my$ecretK3y"  # Stored in an environment variable
      token = JWT.encode payload, hmac_secret, "HS256"

      # Set JWT as a secure HttpOnly cookie
      cookies.signed[:jwt] = { value:  token, httponly: true, secure: Rails.env.production? }

      redirect_to projects_path
    else
      # handle login failure
    end
  end
end
```

2. **Project List:** The LoginApp shows the list of project names as links. The links point to the ProjectsApp's project detail pages and includes the user's JWT as a query parameter (there's a more secure way of doing this by storing the JWT in the header, discussed below).

In `app/controllers/projects_controller.rb`:

```ruby
class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    @jwt = cookies.signed[:jwt]
  end
end
```

In `app/views/projects/index.html.erb`:

```erb
<% @projects.each do |project| %>
  <%= link_to project.name, "https://projectsapp.com/projects/#{project.id}?jwt=#{@jwt}" %>
<% end %>
```

3. **Project Details:** When the user clicks one of the links, they are directed to the ProjectsApp. The ProjectsApp retrieves the JWT from the URL parameters, verifies it, and uses it to authenticate the user. If the JWT is valid, the user is allowed to view and edit the project.

**ProjectsApp**

In `app/controllers/application_controller.rb`:

```ruby
class ApplicationController < ActionController::Base
  private

  # Overridden method from Devise
  def authenticate_user!
    if params[:jwt]
      jwt = params[:jwt]
      hmac_secret = "my$ecretK3y" # Stored in an environment variable
      begin
        decoded_token = JWT.decode jwt, hmac_secret, true, { algorithm: "HS256" }
        user = User.find(decoded_token[0]["user_id"])
        sign_in(user) # programmatically sign in the user with Devise
      rescue
        # handle JWT validation failure
      end
    else
      super # call to Devise's version of the method
    end
  end
end
```

In `app/controllers/projects_controller.rb`:

```ruby
class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = Project.find(params[:id])
  end
end
```

Note that JWTs are typically stored in HTTP-only cookies to prevent access from JavaScript and mitigate the risk of XSS attacks.

### JWT in the header

There are several reasons why passing a JWT (or any sensitive data) in an HTTP header is generally more secure than passing it in a query string parameter:

1. **Logging**: Web servers often log URLs, including the query string, by default. If your JWT is in the query string, it could be accidentally recorded in these logs, creating a security risk if these logs are not properly protected.
2. **Browser History**: URLs, including the query string, are stored in the user's browser history. If a JWT is part of the URL, it could be accidentally exposed or reused by anyone with access to the user's browser history.
3. **Referer Header**: When navigating from one page to another, browsers often send the URL of the originating page in the Referer HTTP header. If a JWT is part of the URL, it could be accidentally exposed in the Referer header.
4. **Caching**: URLs, including query parameters, may be cached in various parts of the system (browser, server, intermediate proxies, CDNs). If sensitive data like JWT tokens are included in URLs, there is a risk of the tokens being accidentally stored in these caches.
5. **Sharing**: Users may unknowingly share URLs that contain sensitive data. For example, a user might copy a URL from the address bar and email it to someone, inadvertently sharing their JWT.

The hurdle to using JWT tokens in the header is that a straightforward navigation link in HTML doesn't allow the setting of headers, so you can't directly include the JWT token as a header when the user clicks a link to navigate to the ProjectsApp. However, you can use JavaScript and AJAX/fetch requests, which allow setting of headers. Alternatively, the handshake method I described above could also be used.

For the AJAX/fetch approach, here's how you can implement it:

**LoginApp**

1. Keep the same login process where a JWT is generated upon successful login and stored in a secure HttpOnly cookie.
2. When the user clicks a project link, instead of directly navigating to the ProjectsApp, make an AJAX/fetch request to the ProjectsApp, including the JWT token as a header. On successful authentication, you can then navigate to the project page in the ProjectsApp. Here's how the JavaScript code could look:

```javascript
document.querySelectorAll(".project-link").forEach((link) => {
  link.addEventListener("click", function (event) {
    event.preventDefault();

    const url = this.href;
    const jwt = getCookie("jwt"); // Implement a method to get the JWT cookie

    fetch(url, {
      headers: { Authorization: `Bearer ${jwt}` },
    }).then((response) => {
      if (response.ok) {
        window.location.href = url;
      } else {
        // Handle failure
      }
    });
  });
});
```

**ProjectsApp**

3. In the ProjectsApp, the `authenticate_user!` method could be updated to grab the token from the header:

```ruby
def authenticate_user!
  auth_header = request.headers['Authorization']
  if auth_header
    token = auth_header.split(' ').last
    begin
      @decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
      @current_user = User.find(@decoded[0]["user_id"])
    rescue JWT::DecodeError
      # Handle invalid token
    end
  else
    super # call to Devise's version of the method
  end
end
```

## Logging out on LoginApp causes Logout on ProjectsApp

Let's say a user has authenticated with the LoginApp, clicked the a link to ProjectsApp for a project, has been authenticated via a JWT token in the header, logged in programmatically with Devise, and shown a project details page. Then the user navigates back to the LoginApp and logs out. This is roughly how you would handle logging out the user automatically on ProjectsApp after logging out on LoginApp.

1. **Logout Process on LoginApp**: When the user clicks logout on the LoginApp, you will not only need to clear the user's session in the LoginApp, but also need to make an HTTP request to ProjectsApp signaling that the user has been logged out. This could be done with an HTTP GET or POST request carrying the user's JWT, or by setting a flag in a shared database or a shared session store.

```ruby
class SessionsController < ApplicationController
  def destroy
    user = current_user
    logout_user(user)
    clear_user_session
    # This could be a GET or POST request as per your preference
    notify_logout_to_projects_app(user)
    redirect_to root_path
  end

  private

  def logout_user(user)
    # Logic to logout user from LoginApp
  end

  def clear_user_session
    # Logic to clear user's session
  end

  def notify_logout_to_projects_app(user)
    # Replace with actual ProjectsApp logout URL and appropriate http method
    uri = URI("http://projectsapp.com/logout")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = { jwt: generate_jwt(user) }.to_json
    response = http.request(request)
  end
end
```

2. **Logout Endpoint on ProjectsApp**: Create a new endpoint in the ProjectsApp that will accept the logout request from the LoginApp. When this endpoint is hit, it should clear the user's session in ProjectsApp.

```ruby
class SessionsController < ApplicationController
  def destroy_from_login_app
    jwt = params[:jwt]
    user = get_user_from_jwt(jwt)
    logout_user(user)
    render status: :ok
  end

  private

  def get_user_from_jwt(jwt)
    # Logic to decode JWT and find user
  end

  def logout_user(user)
    # Logic to logout user from ProjectsApp
  end
end
```
