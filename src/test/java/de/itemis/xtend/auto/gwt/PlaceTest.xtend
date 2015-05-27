package de.itemis.xtend.auto.gwt

import com.google.gwt.place.shared.PlaceTokenizer
import org.eclipse.xtend.core.compiler.batch.XtendCompilerTester
import org.eclipse.xtend.lib.macro.declaration.ClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility
import org.junit.Test

import static org.junit.Assert.assertEquals
import static org.junit.Assert.assertNotNull
import static org.junit.Assert.assertTrue

class PlaceTest {

	extension XtendCompilerTester compilerTester = XtendCompilerTester.newXtendCompilerTester(Place);

	@Test
	def void testPlace() {
		'''
			import de.itemis.xtend.auto.gwt.Place
			
			@Place
			class MyPlace {
			}
		'''.compile [
			val extension ctx = transformationContext

			val myPlace = findClass('MyPlace');

			assertEquals(com.google.gwt.place.shared.Place.newTypeReference, myPlace.extendedClass);

			assertNotNull(myPlace.findDeclaredType("Tokenizer") as ClassDeclaration => [
				assertEquals(simpleName, "Tokenizer");
				assertEquals(PlaceTokenizer.newTypeReference(myPlace.newTypeReference), implementedInterfaces.head);
				assertTrue(static);
				assertEquals(Visibility.PUBLIC, visibility);

				assertNotNull(findDeclaredMethod("getToken", myPlace.newTypeReference) => []);

				assertNotNull(findDeclaredMethod("getPlace", string) => []);
			]);
		]
	}

}
