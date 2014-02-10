# Rspec Notes

## Controllers

#### Shared example authentication testing

	shared_examples 'an admin controller' do
	  controller do
		def test
		  render nothing: true
		end
	  end
	  
	  before do
	    routes.draw { get 'test' => 'anonymous#test' }
	  end
	
	  context 'user logged in but not admin'
	  context 'admin logged in'
	  context 'user not logged in'
	end
	
make sure you have this set in your spec helper

	config.infer_base_class_for_anonymous_controllers = true
	
then in your controller you can use the shared example

	it_behaves_like 'an admin controller'
	
	