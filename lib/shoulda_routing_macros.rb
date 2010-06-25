class Test::Unit::TestCase
  class << self
    def should_map_resource(controller, options={})
      options.reverse_merge!({
        :except => []
      })
      
      controller_string = controller.to_s
      controller_as = options[:as] || controller_string
      controller_plural = options[:plural] || controller_string.pluralize

      unless Array(options[:except]).include?(:show)
        should "map GET show => #{controller}" do
          assert_routing controller_as, {:controller => controller_plural, :action => 'show'}
        end
      end
      
      unless Array(options[:except]).include?(:new)
        should "map GET new => #{controller}/new" do
          assert_routing "#{controller_as}/new", {:controller => controller_plural, :action => 'new'}
        end
      end
        
      unless Array(options[:except]).include?(:create)
        should "map POST create => #{controller}" do
          assert_routing({:path => controller_as, :method => :post}, {:controller => controller_plural, :action => 'create'})
        end
      end
      
      unless Array(options[:except]).include?(:edit)
        should "map GET edit => #{controller}/edit" do
          assert_routing "#{controller_as}/edit", {:controller => controller_plural, :action => 'edit'}
        end
      end
        
      unless Array(options[:except]).include?(:update)
        should "map PUT update => #{controller}" do
          assert_routing({:path => controller_as, :method => :put}, {:controller => controller_plural, :action => 'update'})
        end
      end
        
      unless Array(options[:except]).include?(:destroy)
        should "map DELETE destroy => #{controller}" do
          assert_routing({:path => controller_as, :method => :delete}, {:controller => controller_plural, :action => 'destroy'})
        end
      end
    end

    def should_map_resources(*controllers)
      options = controllers.extract_options!
      
      controllers.each {|controller| should_map_nested_resources(controller, options)}
    end

    def should_map_nested_resources(*controllers)
      options = controllers.extract_options!
      
      controller = controllers.pop.to_s
      controller_as = options[:as] || controller
      
      # build controller path
      real_path = ''
      test_path = ''
      controller_ids = {}
      controllers.each do |controller_part|
        controller_part = controller_part.to_s
        singular = options[:parent_singular] || controller_part.singularize
        
        real_path += "/#{controller_part}/1"
        test_path += "/#{controller_part}/:#{singular}_id"
        controller_ids["#{singular}_id".to_sym] = '1'
      end
        
      # Do seven basic restful actions
      unless Array(options[:except]).include?(:index)
        should "map GET index => #{test_path}/#{controller}" do
          assert_routing "#{real_path}/#{controller_as}", {:controller => controller, :action => 'index'}.merge(controller_ids)
        end
      end

      unless Array(options[:except]).include?(:show)
        should "map GET show => #{test_path}/#{controller}/:id" do
          assert_routing "#{real_path}/#{controller_as}/1", {:controller => controller, :action => 'show', :id => '1'}.merge(controller_ids)
        end
      end
      
      unless Array(options[:except]).include?(:new)
        should "map GET new => #{test_path}/#{controller}/new" do
          assert_routing "#{real_path}/#{controller_as}/new", {:controller => controller, :action => 'new'}.merge(controller_ids)
        end
      end
        
      unless Array(options[:except]).include?(:create)
        should "map POST create => #{test_path}/#{controller}" do
          assert_routing({:path => "#{real_path}/#{controller_as}", :method => :post}, {:controller => controller, :action => 'create'}.merge(controller_ids))
        end
      end
      
      unless Array(options[:except]).include?(:edit)
        should "map GET edit => #{test_path}/#{controller}/:id/edit" do
          assert_routing "#{real_path}/#{controller_as}/1/edit", {:controller => controller, :action => 'edit', :id => '1'}.merge(controller_ids)
        end
      end
        
      unless Array(options[:except]).include?(:update)
        should "map PUT update => #{test_path}/#{controller}/:id" do
          assert_routing({:path => "#{real_path}/#{controller_as}/1", :method => :put}, {:controller => controller, :action => 'update', :id => '1'}.merge(controller_ids))
        end
      end
        
      unless Array(options[:except]).include?(:destroy)
        should "map DELETE destroy => #{test_path}/#{controller}/:id" do
          assert_routing({:path => "#{real_path}/#{controller_as}/1", :method => :delete}, {:controller => controller, :action => 'destroy', :id => '1'}.merge(controller_ids))
        end
      end
        
      # Test collection routes, if any
      if options[:collection]
        options[:collection].each do |action, methods|
          action = action.to_s
          
          methods = [:get, :post, :put, :delete] if methods == :any
          methods = [methods] unless methods.is_a?(Array)
          
          methods.each do |method|
            should "map #{method.to_s.upcase} #{action} => #{test_path}/#{controller}/#{action}" do
              assert_routing({:path => "#{real_path}/#{controller_as}/#{action}", :method => method}, {:controller => controller, :action => action}.merge(controller_ids))
            end
          end
        end
      end
      
      # Test member routes, if any
      if options[:member]
        options[:member].each do |action, methods|
          action = action.to_s
          
          methods = [:get, :post, :put, :delete] if methods == :any
          methods = [methods] unless methods.is_a?(Array)
          
          methods.each do |method|
            should "map #{method.to_s.upcase} #{action} => #{test_path}/#{controller}/:id/#{action}" do
              assert_routing({:path => "#{real_path}/#{controller_as}/1/#{action}", :method => method}, {:controller => controller, :action => action, :id => '1'}.merge(controller_ids))
            end
          end
        end
      end
    end
  end
end
