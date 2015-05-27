package de.itemis.xtend.auto.gwt

import com.google.gwt.place.shared.PlaceHistoryMapper
import com.google.gwt.place.shared.WithTokenizers
import org.eclipse.xtend.lib.macro.AbstractInterfaceProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableInterfaceDeclaration

@Active(typeof(AutoPlaceHistoryMapperProcessor))
annotation AutoPlaceHistoryMapper {
}

class AutoPlaceHistoryMapperProcessor extends AbstractInterfaceProcessor {

	override doTransform(extension MutableInterfaceDeclaration annotatedInterface,
		extension TransformationContext context) {

		val placeType = Place.findTypeGlobally

		extendedInterfaces = #[PlaceHistoryMapper.newTypeReference]
		addAnnotation(WithTokenizers.newAnnotationReference [
			setClassValue('value', annotatedInterface.compilationUnit.sourceTypeDeclarations.filter [
				findAnnotation(placeType) != null
			].map [
				findTypeGlobally(qualifiedName + ".Tokenizer")
			].map [
				newTypeReference
			])
		]);
	}

}
