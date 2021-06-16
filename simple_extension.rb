require "sketchup.rb"
require "extensions.rb"

module VGLib
  module SimpleExtension
    PLUGIN_ID = File.basename(__FILE__, ".rb")
    #PLUGIN_DIR = File.join(File.dirname(__FILE__), PLUGIN_ID)
    PLUGIN_DIR = "D:/extensions/simple"

    extension_name  = "VG Simple Extension"
    loader_file     = File.join(PLUGIN_DIR, "boot_loader.rb")

    EXTENSION       = SketchupExtension.new(extension_name, loader_file)
    EXTENSION.creator     = "Vivek G"
    EXTENSION.description = "Simple test extension."
    EXTENSION.version     = "1.0.1"
    EXTENSION.copyright   = "#{EXTENSION.creator} 2021"
    Sketchup.register_extension(EXTENSION, true)
  end
end
