import org.bimserver.models.ifc2x3tc1.*;

#make_query is macro
make_query("com.arcabim.mvdlibtest", "getFloorCoordinates") do
  spaces = model.getAll(IfcSpace.class)
  spaces.each do |space|
    object_placement = space.getObjectPlacement()
    local_placements = object_placement.getReferencedByPlacements() # Gives us an EList<IfcLocalPlacement>
    local_placements.each do |local_placement|
      root = modelHelper.getTargetModel().createAndAdd(IfcProject.class)
      placement = IfcAxis2Placement3D.class.cast(local_placement.getRelativePlacement())
      origin = placement.getLocation()
      z_axis = placement.getAxis()
      x_axis = placement.getRefDirection()
      output = "Origin: "
      origin.getCoordinatesAsString().each do |coord|
        output = output + coord + ", "
      end
      output = output + "Z Axis: "
      if z_axis != nil 
        z_axis.getDirectionRatiosAsString().each do |ratio|
          output = output + ratio + ", "
        end
      else
        output = output + "null, "
      end
      output = output + "X Axis: "
      if x_axis != nil
        x_axis.getDirectionRatiosAsString().each do |ratio|
          output = output + ratio + ", "
        end
      else
        output = output + "null"
      end
      root.setName("Output")
      root.setDescription(output)
    end
  end

  #model.getAll(IfcSpace.class).each do |sentinel|
  #  modelHelper.copy(sentinel, false)
  #end
  #model.getValues().each do |thing|
  #  modelHelper.copy(thing, false)
  #end
  modelHelper.getTargetModel()
end