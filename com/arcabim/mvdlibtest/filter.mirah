import org.bimserver.models.ifc2x3tc1.*;

#make_query is macro
make_query("com.arcabim.mvdlibtest", "getFloorCoordinates") do
#  stories = model.getAll(IfcBuildingStorey.class)
#
#  lowestElevation = 0.0
#  lowestStorey = nil
#  stories.each do |storey: IfcBuildingStorey|
#    if (lowestStorey === nil || (lowestElevation > storey.getElevation()))
#      lowestElevation = storey.getElevation()
#      lowestStorey = storey
#    end
#  end
#  if (!(lowestStorey === nil))
#    lowestStorey.getContainsElements().each do |containment|
#      containment.getRelatedElements().each do |products|
#        modelHelper.copy(products, false)
#      end
#    end
#  end
#
#  modelHelper.getTargetModel()


  #modelHelper.copy(root, true)

  spaces = model.getAll(IfcSpace.class)
  spaces.each do |space|
    object_placement = space.getObjectPlacement()
    local_placements = object_placement.getReferencedByPlacements() # Gives us an EList<IfcLocalPlacement>
    local_placements.each do |local_placement|
      root = modelHelper.getTargetModel().createAndAdd(IfcProject.class)
      placement = IfcAxis2Placement3D.class.cast(local_placement.getRelativePlacement())
      point = placement.getLocation()
      translation = placement.getAxis()
      rotation = placement.getRefDirection()
      output = "Point: "
      point.getCoordinatesAsString().each do |coord|
        output = output + coord + ", "
      end
      #output = output + "Translation: "
      root.setName("Output")
      root.setDescription(output)
      #modelHelper.copy(text, false)
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