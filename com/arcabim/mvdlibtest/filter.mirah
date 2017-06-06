import org.bimserver.models.ifc2x3tc1.*;
import org.bimserver.plugins.ModelHelper;
class Transform
    def initialize(modelHelper: ModelHelper)
      @modelHelper = modelHelper
    end
    def transformer(entity: IfcSpatialStructureElement, origin_point: IfcCartesianPoint, x_axis: IfcDirection, z_axis: IfcDirection)
      doublechildren = entity.getContainsElements()
      doublechildren.each do |children|
        children.getRelatedElements().each do |child|
          if child.kind_of?(IfcSpatialStructureElement)
            # Get placement information, defined by the object's IfcAxis2Placement3D
            child_placement = IfcAxis2Placement3D.class.cast(child.getObjectPlacement())
            old_origin_point = child_placement.getLocation()
            old_x_axis = child_placement.getRefDirection()
            old_z_axis = child_placement.getAxis()
            # Compute compound transformer
            # That is, there is a pair of inverses which we compute, one to transform the lcs, one to pass on to transform children
            # The transforms will both be translate-rotate-translate-translate, as they involve rotation around a point and then translation
            # translation and rotation computation for the children of the IfcSpatialStructureElement
            
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
    def translate(point: IfcCartesianPoint, x: Double, y: Double, z: Double)
      new_point = @modelHelper.getTargetModel().createAndAdd(IfcCartesianPoint.class)
      new_point.setDim(3)
      # We assume the points are stored x, y, z for now
      new_point.getCoordinates().set(0, point.getCoordinates().get(0) + x)
      new_point.getCoordinates().set(1, point.getCoordinates().get(1) + y)
      new_point.getCoordinates().set(2, point.getCoordinates().get(2) + z)
      new_point
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
  transform = Transform.new(modelHelper)
  sites.each do |site|
    transform.transformer(IfcSpatialStructureElement.class.cast(site), wcs_origin, wcs_x_axis, wcs_z_axis)
  end

  modelHelper.getTargetModel()
end