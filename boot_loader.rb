module VGLib::SimpleExtension
  
  @@dialog = nil
  @@modules = {
    "select" => "SelectionModule"
  }

  def self.create_dialog
    options = {
      dialog_title: EXTENSION.name,
      preferences_key: PLUGIN_ID,
      style: UI::HtmlDialog::STYLE_DIALOG,
      height: 300,
      width: 400
    }
    dialog = UI::HtmlDialog.new(options)
    dialog.set_size(options[:width], options[:height])
    dialog.set_file(File.join(PLUGIN_DIR, "dialog.html"))
    dialog.center

    dialog
  end

  def self.get_local_key map_key
    @@modules[map_key]
  end

  def self.call_function map_key, func_name, inputs
    module_key = get_local_key map_key
    func_str = "VGLib::SimpleExtension::%s.%s(" % [module_key, func_name] 
    if !inputs.empty?
      inputs.each { |val|
        case val.class.to_s
        when "String"
          val_str = "'#{val}',"
        else  
          val_str = "#{val},"
        end
        func_str += val_str
      }
    end
    
    func_str = func_str.chomp(",")+")"
    puts "func_str : #{func_str}" 
    begin
      eval(func_str)
    rescue Exception => e
      puts "VGLibErr : Error evaluation the function string : #{func_str}"
      puts e
    end
  end

  def self.display_dialog
    if @@dialog && @@dialog.visible?
      @@dialog.bring_to_front
    else
      @@dialog ||= create_dialog
      @@dialog.add_action_callback("execute") { |web_dialog, params| 
        puts "+------ Ruby Execute called : #{web_dialog} : #{params} -----+"
        split_arr = params.split("@");
        map_key = split_arr[0]
        func_name = split_arr[1]
        
        inputs = []
        unless split_arr[2].nil?
          inputs = split_arr[2].split(":")
        end

        call_function(map_key, func_name, inputs)
      }
      @@dialog.show
    end

    nil
  end

  unless(file_loaded?(__FILE__))
    file_loaded(__FILE__)
    menu = UI.menu("Plugins")
    menu.add_item(EXTENSION.name) { display_dialog }
  end

end