package de.itemis.xtend.auto.gwt

import com.google.gwt.place.shared.PlaceTokenizer
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.ClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration

@Active(typeof(PlaceProcessor))
annotation Place {
}

class PlaceProcessor extends AbstractClassProcessor {

	override doRegisterGlobals(ClassDeclaration it, extension RegisterGlobalsContext context) {
		registerClass(tokenizerTypeName)
	}

	override doTransform(MutableClassDeclaration classDeclaration, extension TransformationContext context) {
		val dynamicPlace = classDeclaration.findDeclaredConstructor(string) != null

		classDeclaration.extendedClass = newTypeReference(typeof(com.google.gwt.place.shared.Place))

		val tokenizerType = findClass(classDeclaration.tokenizerTypeName)
		tokenizerType.implementedInterfaces = #[
			newTypeReference(typeof(PlaceTokenizer), newTypeReference(classDeclaration))]
		tokenizerType.addMethod("getPlace") [
			addParameter("token", string)
			returnType = newTypeReference(classDeclaration)
			body = '''
				«IF dynamicPlace»
					return new «newTypeReference(classDeclaration)»(token);
				«ELSE»
					return null;
				«ENDIF»
			'''
		]

		tokenizerType.addMethod("getToken") [
			addParameter("place", newTypeReference(classDeclaration))
			returnType = string
			body = '''return null;'''
		]
	}

	static def tokenizerTypeName(ClassDeclaration classDeclaration) {
		classDeclaration.qualifiedName + ".Tokenizer"
	}

}
