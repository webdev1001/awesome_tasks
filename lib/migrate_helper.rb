class MigrateHelper
  def self.assign(data_orig, model, transactioner, assign_data)
    assign_data.each do |orig_key, new_key|
      raise "Unknown data on original data: '#{orig_key}' on model '#{model.class.name}'." unless data_orig.key?(orig_key)
      method_name = "#{new_key}="
      raise "Model doesnt respond to new key: '#{new_key}' on model '#{model.class.name}'." unless model.respond_to?(method_name)

      begin
        model[new_key] = data_orig[orig_key]
        # model.__send__(method_name, data_orig[orig_key])
      rescue ArgumentError
        puts "Could not set #{new_key} to '#{data_orig[orig_key]}' because of range error"
      end
    end

    transactioner.queue(model)
    #model.save! validate: false
  end
end
