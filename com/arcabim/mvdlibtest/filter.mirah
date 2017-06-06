import org.bimserver.models.ifc2x3tc1.*;
class Transform
    def transformer(entity: IfcSpatialStructureElement, origin_point: IfcCartesianPoint, x_axis: IfcDirection, z_axis: IfcDirection)
      doublechildren = entity.getContainsElements()
      doublechildren.each do |children|
        children.getRelatedElements().each do |child|
          if child.kind_of?(IfcSpatialStructureElement)
            # Get placement information
            child_placement = IfcAxis2Placement3D.class.cast(child.getObjectPlacement())
            # Compute compound transformer
            # ...
            # translation and rotation computation for the children of the IfcSpatialStructureElement
            # ...
            new_origin_point = origin_point
            new_x_axis = x_axis
            new_z_axis = z_axis
            transformer(IfcSpatialStructureElement.class.cast(child), new_origin_point, new_x_axis, new_z_axis)
            # Now we have moved all the children of the child into our coordinates, we can set the child to have our coordinates
            child_placement.setLocation(origin_point)
            child_placement.setAxis(z_axis)
            child_placement.setRefDirection(x_axis)
          elsif
            # Get placement information
            child_placement = IfcAxis2Placement3D.class.cast(child.getObjectPlacement())
            # Transform child placement by the base transform
            # ...translation and rotating this child's placement to the new coordinates system that has been passed in to the transformer
          end
        end
      end
    end
end

#make_query is macro
make_query("com.arcabim.mvdlibtest", "getFloorCoordinates") do
  # Start by copying everything to the target model, so we can do all our changes in the target model
  model.getValues().each do |thing|
    modelHelper.copy(thing, false)
  end
  new_model = modelHelper.getTargetModel()
  project = IfcProject.class.cast(new_model.getAll(IfcProject.class).get(0))
  sites = new_model.getAll(IfcSite.class)

  #Get the wcs as the base to transform from IfcProject, IfcRepresentationContext, IfcGeometricRepresentationContext
  # wcs is defined as an IfcAxis2Placement3D instance
  wcs = IfcAxis2Placement3D.class.cast(IfcGeometricRepresentationContext.class.cast(project.getRepresentationContexts().get(0)).getWorldCoordinateSystem())
  wcs_origin = wcs.getLocation()
  wcs_x_axis = wcs.getRefDirection() 
  wcs_z_axis =  wcs.getAxis()
  transform = Transform.new
  sites.each do |site|
    transform.transformer(IfcSpatialStructureElement.class.cast(site), wcs_origin, wcs_x_axis, wcs_z_axis)
  end

  modelHelper.getTargetModel()
end