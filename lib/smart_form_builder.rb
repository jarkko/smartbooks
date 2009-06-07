class SmartFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers - %w(hidden_field)
            
  helpers.each do |helper|
    define_method(helper) do |field, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}      
      
      options[:index] = @object.id if @object && @object.id && options[:auto_index]
      
      if @object.errors.on(field)
        errors = @template.content_tag(:span, @object.errors.on(field), :class => "errors")
        html_class = "has_errors"
      end
      
      if options[:hint]
        hint = @template.content_tag(:span, options[:hint], :class => "hint")
      end
      
      if required_field?(field) && helper !~ /_select$/
        options[:class] ||= ""
        options[:class] += " mandatory"
        options[:class].strip!
      end
      
      @template.content_tag(:li, "
    #{label_for(field, label_text(field, options), {:index => options[:index]})}
    #{super(field, options)}
    #{hint}
    #{errors.to_s}
  ", :class => html_class, :id => id_for(field, options) + "_item")
    end
  end
  
  select_helpers = %w(date_select datetime_select 
               time_select calendar_date_select
               country_select select)
  
  select_helpers.each do |helper|
    define_method(helper) do |field, *args|
      html_options = (args.last.is_a?(Hash) && args.size == 3) ? args.pop : {}      
      options = (args.last.is_a?(Hash) && args.size == 2) ? args.pop : {}      
      choices = args.last
      
      title = options[:title] || field.to_s.humanize

      options[:index] = @object.id if @object.id && options[:auto_index]

      if @object.errors.on(field)
        errors = @template.content_tag(:span, @object.errors.on(field), :class => "errors")
        html_class = "has_errors"
      end

      if options[:hint]
        hint = @template.content_tag(:span, options[:hint], :class => "hint")
      end

      @template.content_tag(:li,
        label_for(field, label_text(field, options), {:index => options[:index]}) +
        super(field, choices, options, html_options) + 
        hint.to_s + errors.to_s, :class => html_class,
        :id => id_for(field, options) + "_item")
    end
  end
  
  def display_value(field, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    
    title = options[:title] || field.to_s.humanize
    
    @template.content_tag(:li,
      "<label>#{title}:</label> " +
      @object.send(field) + 
      hint)
  end
  
  def label_for(method, value = nil, options = {}) 
 	  @template.label_for(@object_name, method, value, options.merge(:object => @object)) 
 	end
 	
 	def id_for(method, options)
 	  @template.id_for(@object_name, method, options.merge(:object => @object)) 
 	end
 	
 	def submit(value = "Submit", options = {})
 	  @template.content_tag(:li,
   	  @template.submit_tag(value, options),
   	  :id => "submit")
 	end
 	
 	
  def collection_check_boxes(method, collection, value_method = :id, text_method = :name, options = {})
    collection.collect do |c|
      @template.content_tag(:li,
        @template.check_box_tag(collection_name(method), 
                                c.send(value_method), 
                                @object.send(method).include?(c), 
                                :id => "#{@object.class.to_s.underscore}_#{c.send(value_method)}_#{method.to_s}",
                                :class => "#{@object.class.to_s.underscore}_#{method.to_s}") + 
        " #{label_for(method, c.send(text_method), :index => c.send(value_method))}" +
        (options[:default] ? default_radio_button(c, method, options[:default]) : ""))
    end.join "\n"
  end
  
  private
  
  def label_text(field, options = {})
    title = options[:title] || field.to_s.humanize
    
    "#{title} #{required_mark(field)}" 
  end
  
  def required_mark(field)
    required_field?(field) ? 
        @template.content_tag(:span, "*", :class => 'required_mark') : ''
  end
  
  def required_field?(field)
    klass = @object.class || @object_name.to_s.camelize.constantize
    klass.reflect_on_validations_for(field).
          map(&:macro).include?(:validates_presence_of)
  end 

  
  def collection_name(method)
    "#{@object.class.to_s.underscore}[#{method.to_s.singularize}_ids][]"
  end
  
  def default_radio_button(item, method, options = {})
    options = {} if options && !options.is_a?(Hash)
    
    options = {:id => "default_#{method.to_s.singularize}_id",
               :name => item.class.to_s.humanize.downcase,
               :value_method => :id}.merge(options)

    default_id = options[:id]
    
    default = @object.send(default_id) == item.send(options[:value_method])
    
    " " + 
    @template.radio_button_tag("#{@object.class.to_s.underscore}[#{default_id}]", 
                               item.send(options[:value_method]), 
                               default, 
                               :title => "Mark as default #{options[:name]}",
                               :id => "default_#{item.class.to_s.underscore}_#{item.id}",
                               :class => "default_#{item.class.to_s.underscore}") +
    (default ? "<span id=\"default_#{item.class.to_s.underscore}_text\">default #{options[:name]}</span>" : "")
  end
  
  def hint
    if options[:hint]
      @template.content_tag(:span, options[:hint], :class => "hint")
    else
      ""
    end
  end
end

module ActionView
  module Helpers
    module FormHelper
      # Returns a label tag tailored for labeling a form field for a  
     	# specified attribute (identified by +method+) on an object 
     	# assigned to the template (identified by +object+). Additional  
     	# options on the label tag can be passed as a 
     	# hash with +options+. 
     	# 
     	# Examples (call, result): 
     	#   label_for("post", "title") 
     	#     <label for="post_title">Post Title</label> 
     	#      
     	#   label_for("post", "title", "Funky Title") 
     	#     <label for="post_title">Funky Title</label> 
     	# 
     	#   label_for("post", "title", "Funky Title", :id => "funky") 
     	#     <label for="post_title" id="funky">Funky Title</label> 
     	def label_for(object_name, method, value = nil, options = {}) 
     	  InstanceTag.new(object_name, method, self, options.delete(:object)).to_label_tag(value, options) 
     	end
     	
     	def id_for(object_name, method, options = {})
     	  InstanceTag.new(object_name, method, self, options.delete(:object)).to_id_field(options)
     	end
     	
      #def country_select(name, selected='')
      #    priority_countries = %w(CH FR DE)
      #    first = Country.find(:all , :conditions => [ "code in (?)",priority_countries ])
      #    empty = '<option value=""></option>'
      #    first_options = options_for_select(first.to_select('english_name','code'), selected)
      #    divider = '<option value="">-------------</option>'
      #    selected = '' if priority_countries.include? selected
      #    all_countries = options_for_select(Country.find(:all,:order=>'english_name').to_select('english_name','code'), selected)
      #    select_tag(name, empty + first_options + divider + all_countries)
      #end
    end
    
    class InstanceTag
      def to_label_tag(value = nil, options = {}) 
     	  options = options.stringify_keys 
     	  value ||= "#{@object_name.humanize} #{@method_name.gsub("_", " ").capitalize}" 
     	  add_default_for(options) 
     	  content_tag_without_error_wrapping("label", value, options) 
     	end
     	
     	def to_id_field(options)
     	  options = options.stringify_keys
     	  get_id(options)
     	end
     	
     	private
     	
     	def add_default_for(options) 
     	  if options.has_key?("index") && !options["index"].blank?
     	    options["for"]   ||= tag_id_with_index(options["index"]) 
     	    options.delete("index") 
     	  elsif defined?(@auto_index) 
     	    options["for"]   ||= tag_id_with_index(@auto_index) 
     	  else 
     	    options["for"]   ||= tag_id 
     	  end 
     	end
     	
     	def get_id(options)
     	  if options.has_key?("index") && !options["index"].blank?
     	    tag_id_with_index(options["index"]) 
     	  elsif defined?(@auto_index) 
     	    tag_id_with_index(@auto_index) 
     	  else 
     	    tag_id 
     	  end     	
     	end
    end
    
    module FormOptionsHelper
      def country_options_for_select(selected = nil, priority_countries = nil)
        country_options = ""

        priority_countries ||= PRIORITY_COUNTRIES        

        if priority_countries          
          country_options += options_for_select(priority_countries, selected)
          country_options += "<option value=\"\">-------------</option>\n"
        end

        countries = Country.to_select('english_name')

        if priority_countries && priority_countries.include?(selected)
          country_options += options_for_select(countries - priority_countries, selected)
        else
          country_options += options_for_select(countries, selected)
        end

        return country_options
      end
      
      def options_for_select(container, selected = nil)        
        container = container.to_a if Hash === container

        options_for_select = container.inject([]) do |options, element|
          text, value = option_text_and_value(element)
          value = value.to_s if selected.is_a?(String)          
          
          selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
          options << %(<option value="#{html_escape(value.to_s)}"#{selected_attribute}>#{html_escape(text.to_s)}</option>)
        end

        options_for_select.join("\n")
      end
    end
  end
end