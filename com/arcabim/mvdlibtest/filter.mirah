import org.bimserver.models.ifc2x3tc1.*;

#make_query is macro
make_query("com.arcabim.mvdlibtest", "getFloorCoordinates") do
  # Start by copying everything to the target model, so we can do all our changes in the target model
  model.getValues().each do |thing|
    modelHelper.copy(thing, false)
  end
  new_model = modelHelper.getTargetModel()
  spatial_structures = new_model.getAll(IfcSpatialStructureElement.class)
  spatial_structures.each do |container|
    local_placement = IfcLocalPlacement.class.cast(container.getObjectPlacement()) # We explode if this does not work
    placement = IfcAxis2Placement3D.class.cast(local_placement.getRelativePlacement()) # We also explode if this does not work
    origin = placement.getLocation()
    z_axis = placement.getAxis()
    x_axis = placement.getRefDirection()
    doublechildren = container.getContainsElements()
    doublechildren.each do |children|
      children.getRelatedElements().each do |child|
        # each child should be IFCPRODUCT
        child_placement = IfcAxis2Placement3D.class.cast(child.getObjectPlacement())
        child_origin = child_placement.getLocation()
        child_z_axis = child_placement.getAxis()
        child_x_axis = child_placement.getRefDirection()
        # Do computation later
        point = new_model.createAndAdd(IfcCartesianPoint.class)
        point.getCoordinates().add(double(0))
        point.getCoordinates().add(double(0))
        point.getCoordinates().add(double(0))
        child_placement.setLocation(point)
        direction_z = new_model.createAndAdd(IfcDirection.class)
        direction_z.getDirectionRatios().add(double(0))
        direction_z.getDirectionRatios().add(double(0))
        direction_z.getDirectionRatios().add(double(1))
        direction_x = new_model.createAndAdd(IfcDirection.class)
        direction_x.getDirectionRatios().add(double(1))
        direction_x.getDirectionRatios().add(double(0))
        direction_x.getDirectionRatios().add(double(0))
        child_placement.setRefDirection(direction_x)
      end
    end
  end

  modelHelper.getTargetModel()
end