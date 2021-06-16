module VGLib::SimpleExtension
  module SelectionModule
    def self.select_all
      model = Sketchup.active_model
      model.selection.add(model.entities.to_a)
    end
    def self.pushpull_faces
      model = Sketchup.active_model
      faces = model.selection.grep(Sketchup::Face)
      faces.each {|face|
        face.pushpull(-1000.mm)
      }
    end
  end
end