def add_authentication_headers(path)
  unless @rest_app_client.nil?
    time_stamp = Time.now.utc.to_s
    header 'x-timestamp', time_stamp
    header 'x-signature', (Digest::SHA256.new << @rest_app_client.secret + path + time_stamp).to_s 
  end
end

def add_headers(headers_hash)
  headers_hash.each do |h,value|
    header h, value
  end
end

def create_factory_object(factory_name)
  eval("@#{factory_name} = FactoryGirl.create(:#{factory_name})")  
end

def replace_attributes(str, factory_name)
  replace_instance_attribute_strings str
  replace_attribute_strings str, factory_name
  return str
end

def replace_instance_attribute_strings(str)
  h = Hash[instance_variables.map { |name| [name, instance_variable_get(name)] }]
  h.each do |name, val|
    if val.respond_to? "attributes"
      n = name.to_s
      n.sub!("@", "")
      vars = val.attributes
      vars.each do |var_name, var_val|
        str.sub!("!!#{n}.#{var_name}!!", var_val.to_s) if str.include? "!!#{n}.#{var_name}!!"
      end
    end
  end
  return str
end

def replace_attribute_strings(str, factory_name)
  return nil if factory_name == "" || factory_name.nil?
  h = FactoryGirl.attributes_for factory_name
  h.each do |name, val|
    str.sub!("!!#{factory_name}.#{name}!!", val.to_s) if str.include? "!!#{factory_name}.#{name}!!"
  end
  return str
end

