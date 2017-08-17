package eu.quanticol.carma.core.tests

import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.InjectWith
import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import eu.quanticol.carma.core.carma.Model
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import static extension org.junit.Assert.*
import eu.quanticol.carma.simulator.CarmaModel
import org.eclipse.xtext.xbase.lib.util.ReflectExtensions
import eu.quanticol.carma.core.validation.CARMAValidator
import eu.quanticol.carma.core.carma.CarmaPackage

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(CARMAInjectorProviderCustom))

class Test_WeightedRandom {
	@Inject extension CompilationTestHelper
	@Inject extension ParseHelper<Model>
	@Inject extension ValidationTestHelper
	
	@Test
	def void test_WeightedRandom_Parser(){
		class.classLoader.setJavaCompilerClassPath
		'''
		fun int testSelectFrom() {
			int x = selectFrom(1 : 0.5, 2 : 0.2, 3 : 0.3);
			return x;
		}
		'''.parse.assertNoErrors
	}
	
	@Test
	def void test_WeightedRandom_Compiler(){
		class.classLoader.setJavaCompilerClassPath
		'''
		fun int testSelectFrom() {
			int x = selectFrom(1 : 0.5, 2 : 0.2, 3 : 0.3);
			return x;
		}
		'''.compile[ 
					var o = getCompiledClass.newInstance 
			assertNotNull( o )
			assertTrue( o instanceof CarmaModel )
		]
	}
	
	@Test
	def void test_WeightedRandom_SingleArg_Parser(){
		class.classLoader.setJavaCompilerClassPath
		'''
		fun int testSelectFrom() {
			int x = selectFrom(1 : 0.5);
			return x;
		}
		'''.parse.assertNoErrors
	}
	
	@Test
	def void test_WeightedRandom_SingleArg_Compiler(){
		class.classLoader.setJavaCompilerClassPath
		'''
		fun int testSelectFrom() {
			int x = selectFrom(1 : 0.5);
			return x;
		}
		'''.compile[ 
					var o = getCompiledClass.newInstance 
			assertNotNull( o )
			assertTrue( o instanceof CarmaModel )
		]
	}
	
	// Need to check what error is produced with the following 
//	@Test
//	def void test_WeightedRandom_WeightsNotDouble_Parser(){
//		class.classLoader.setJavaCompilerClassPath
//		'''
//		component Receiver() {
//			store {int z = U(1,2,3);}
//			behaviour {B = b*[false]<>{my.z = selectFrom(1 : 0.1, 2.0 : 1.0);}.B;}
//			init {B}
//		}
//		'''.parse.assertError(CarmaPackage::eINSTANCE.eClass,
//				CARMAValidator::ERROR_Expression_type_error,
//				CARMAValidator::ERROR_MSG_Different_Types)
//	}

//	
//	@Test
//	def void test_WeightedRandom_DifferentTypes_Parser(){
//		class.classLoader.setJavaCompilerClassPath
//		'''
//		fun int testSelectFrom() {
//			int x = selectFrom(1 : 0.5, 0.2 : 0.5);
//			return x;
//		}
//		'''.parse.assertNoErrors
//	}
	
}