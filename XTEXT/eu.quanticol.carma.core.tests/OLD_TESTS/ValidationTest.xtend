package eu.quanticol.carma.core.tests
//
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import eu.quanticol.carma.core.CARMAInjectorProvider
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.validation.CARMAValidator
import eu.quanticol.carma.core.carma.CarmaPackage

//
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(CARMAInjectorProvider))
class ValidationTest {
	
	@Inject extension ParseHelper<Model>
	@Inject extension ValidationTestHelper
	
	
	@Test
	def void test_ERROR_VariableName_unique_type(){
		'''
/**
 * The roving function: moves our rovers around the grid, wraps east-west, north-south
 */
fun Position Roving(Position p){
    attrib pos_x := Uniform(p.x + 1,p.x,p.x + 1) % 3;
    attrib pos_y := Uniform(p.y - 1,p.y,p.y + 1) % 3;
    Position q := new Position(pos_x,pos_y);
    return j;
}

records {
	record Position(){ 
		attrib x := 0;
		attrib y := 2;
	}
}

/**
 * The Rover component: 'Roves' about the grid sensing and attempting to send data to the above satellites
 */
component Rover(attrib a, attrib b, attrib c,  Z){

    store{
        attrib data := a;
        attrib type := 4;
        attrib fail := 2;
        Position myPosition := new Position(b,c);

    }

    behaviour{
        Sense     = [my.data > 0] sense*{data := data + 1}.Sense;
        Send     = [my.data > 0] send[type == 1]<>{data := data - 1}.Send;
    }

    init{
        Z;
    }
}

/**
 * The Satellite component: sits in geo-synchronous orbit, if it is not analysing data from a rover, 
 * it will do its own sensing. It sends analysed data as packages to earth.
 */
component Satelite(attrib a, Position d){

    store{
        attrib data := a;
        attrib package := 0;
        attrib type := 1;
        Position myPosition := d;

    }

    behaviour{

        Analyse = [my.data > 0] analyse*{data := data - 1, package := package + 1}.Transmit
        + [my.data == 0] sense*{data := data + 1}.Transmit;

        Transmit = transmit*{package := package - 1}.Analyse;

        Receive = [my.data >= 0] send[my.data < 10 && z == 1](z){data := data + z}.Receive;
    }

    init{
        Analyse|Receive;
    }
}

/**
 * The beacon component: Deployed when a send fails
 */
component Beacon(attrib a, attrib b){

    store{
        Position myPosition := new Position(a,b);
        attrib battery := 5;
    }

    behaviour{
        Signal = [my.battery > 0] signal*{battery := battery - 1}.Signal + [my.battery <= 0] die*.Die;
        Die = nil;
    }

    init{
        Signal;
    }
}

/**
 * Behaviours we might like to provide to more than one component
 */
abstract {
    Rove = rove*{myPosition := Roving(myPosition)}.Wait;
    Wait = wait*.Wait;
}

/**
 * Measures block: Count the number of X
 */
measures{
    measure Waiting[ attrib i := 0..2, attrib j := 0..2] = #{ *  | battery == i && myPosition.y == j };
}


/**
 * The system block
 */
system Simple{

	/**
	 * Starting with 3 Rovers, and 9 Satellites
	 */
    collective{
        new Rover(0,0,0,Rove);
        new Rover(1,1,1,Rove);
        new Rover(2,2,2,Rove);
        new Satelite(1, new Position(1,2));
    }

    environment{

        store{
            attrib reports  := 0;
            attrib type     := 2;
            Position center := new Position(1,1);
        }

        prob{
        	//depending on where the Rover is determines the chance of the satellite receiving the message
            [(receiver.myPosition.x - global.center.x < 0) && (receiver.myPosition.y - global.center.y == 0)]	send : 1;
            [(receiver.myPosition.x - global.center.x > 1)]	send : 0.75;
            [(receiver.myPosition.x - global.center.x < 0)]	send : 0.5;
            default : 0.25;
        }

        rate{
        	//different terrain effects roving rate
        	[(sender.myPosition.x == 0)]	rove* : 6;
        	[(sender.myPosition.x == 1)]	rove* : 4;
        	[(sender.myPosition.x == 2)]	rove* : 5;
        	//more rovers, faster sensing?
            [true]	sense* : 1/#{ *  | sender.myPosition.x == myPosition.x && sender.myPosition.y == myPosition.y };
            [true]	analyse* : 0.1;
            [true]	wait* : 3;
            [true]	signal* : 0.5;
            [true]	die* : 0.5;
        }

        update{
            [true] send : global.reports := global.reports + 1;
            //if the Rover has over 5 data then deploy a beacon. 
            [sender.data > 5] sense* : new Beacon(sender.myPosition.x,sender.myPosition.y);
        }
    }
}
		'''.parse.assertNoErrors //FIXME!!!
		
//		.parse.assertError(CarmaPackage::eINSTANCE.variableName,
//			CARMAValidator::ERROR_VariableName_unique_type,
//			CARMAValidator::ERROR_VariableName_unique_type)
	}

	
	
}