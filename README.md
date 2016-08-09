# Example for hook controller of [doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) 

Add the hook feature for [issue\#]472(https://github.com/doorkeeper-gem/doorkeeper/issues/472)


## Install the doorkeeper

    bundle install
    rails g doorkeeper:install
    rails g doorkeeper:migration
    rails g model User name:string
    rake db:migrate


## Config the doorkeeper

Using the resource owner credentials flow for example

``` ruby
resource_owner_from_credentials do |routes|
  User.find_by_name(params[:name])
end
```

## Run it

### Create the module for lazy load `app/controllers/concerns/doorkeeper_methods.rb`:


``` ruby
module DoorkeeperMethods
  extend ActiveSupport::Concern

  ENABLE_LOG = {
    :"doorkeeper/tokens" => [:create, :revoke]
  }

  included do
    after_action do
      ENABLE_LOG.has_key?(controller_path.to_sym) and
        ENABLE_LOG[controller_path.to_sym].include?(action_name.to_sym) and
        dummy_logger "Proccessed the action: #{action_name}"
    end

    def dummy_logger(a)
      # Do someting?
    end
  end
end
```

### Run on_load in `initializers/doorkeeper.rb`:

``` ruby
ActiveSupport.on_load(:doorkeeper_metal_controller) do
  include AbstractController::Callbacks
  include DoorkeeperMethods
end
```

### Testcase: `spec/controllers/tokens_controller_spec.rb`:

``` ruby
describe Doorkeeper::TokensController do
  it 'hits the dummy logger in action :create' do
    expect(controller).to receive(:dummy_logger)
    post :create
  end

  it 'hits the dummy logger in action :revoke' do
    expect(controller).to receive(:dummy_logger)
    post :revoke
  end
end
```

