class LoginManager < Sinatra::Base
  Warden::Manager.serialize_into_session{|id| id }
  Warden::Manager.serialize_from_session{|id| id }

  def call(env)
    puts 'manager: ' + env['REQUEST_METHOD'] + ' ' + env['REQUEST_URI']
    super
  end

  Warden::Strategies.add(:password) do
    def valid?
      puts 'password strategy valid?'
      username = params["username"]
      username and username != ''
    end

    def authenticate!
      puts 'password strategy authenticate'
      username = params["username"]
      if ['tim', 'rach'].include?(username)
        success!(username)
      else
        fail!('could not login')
      end
    end
  end

  get "/" do
      login_greeting = if env['warden'].authenticated?
                  "welcome #{env['warden'].user}!"
              else
                  "not logged in"
              end

    <<eof
#{login_greeting}
<ul>
<li><a href="/login">login</a></li>
<li><a href="/logout">logout</a></li>
<li><a href="/protected">protected</a></li>
</ul>
eof
  end

  post '/unauthenticated/?' do
    status 401
    login
  end

  def login(failure = false)
      error_style = if failure
                        'style="background: red"'
                    else
                        ''
                    end

    <<eof
    <html>
    <body>
    <form action=/login method=post>
      username <input name=username type=text #{error_style}/>
    </form>
    </body>
    </html>
eof
  end

  get '/login/?' do
    login
  end

  get '/protected' do
      env['warden'].authenticate!
      'this is protected'
  end

  post '/login/?' do
    if env['warden'].authenticate
        redirect "/"
    else
        login(true)
    end
  end

  get '/logout/?' do
    env['warden'].logout
    redirect '/'
  end

  get '/error' do
      uri = params['uri']
      %$login error trying to access <a href="#{uri}">#{uri}</a>. Go <a href="/">home</a> instead.$
  end

  use Rack::Session::Cookie
  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = FailureApp.new
  end
end

class FailureApp
  def call(env)
      uri = env['REQUEST_URI']
    puts 'failure: ' + env['REQUEST_METHOD'] + ' ' + uri
    [302, {'Location' => '/error?uri=' + CGI::escape(uri)}, '']
  end
end
