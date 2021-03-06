package eu.quanticol.carma.core.tests

import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.InjectWith
import eu.quanticol.carma.core.CARMAInjectorProvider
import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import eu.quanticol.carma.core.carma.Model
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import static extension org.junit.Assert.*
import eu.quanticol.carma.simulator.CarmaModel

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(CARMAInjectorProviderCustom))
class Test_SIRS2 {
	@Inject extension ParseHelper<Model>
	@Inject extension ValidationTestHelper	
	@Inject extension CompilationTestHelper

	CharSequence code = 	'''
fun int Mover(int zone) {
	if (zone == 4 || zone == 1) {
		return U(2,zone,3); 
	} else {
		return U(1,zone,4);
	}
}


component Agent(int a, int b){

    store{
        attrib zone := a;
        attrib state := b;
    }

    behaviour{
        A = contact*[z == my.zone && state == 1](z){state := 2;}.A +
        	contact*<zone>.A +
			recovery*{state := 3;}.A +
			susceptible*{state := 1;}.A +
			move*{zone := Mover(zone);}.A;
    }

    init{
        A
    }
}

measure Susceptibles = #{*| my.state == 1 };


system Simple{

    collective{
    	new Agent(1:4,1);
    	new Agent(1:4,2);
    	new Agent(1:4,3);
    }

    environment{

        store{
        }

        prob{
			default { return 1.0; }
        }

        rate{
        	move* 		{ return 1.0; }
			contact* 	{ return 0.03; }
			recovery*	{ return 0.2; }
			susceptible* { return 0.2; }
			default { return 1.0; }
        }

        update{
        }
    }
}
	'''
	
	@Test
	def void test_Parser(){
		code.parse.assertNoErrors
	}

	@Test
	def void test_Compiler(){
		class.classLoader.setJavaCompilerClassPath
		code.compile[
					var o = getCompiledClass.newInstance 
			assertNotNull( o )
			assertTrue( o instanceof CarmaModel )
			var m = o as CarmaModel
			assertEquals( 1 , m.systems.length )
			assertEquals( 1 , m.measures.length )					

	]
	}
	
}