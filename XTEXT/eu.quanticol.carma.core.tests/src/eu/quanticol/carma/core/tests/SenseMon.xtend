package eu.quanticol.carma.core.tests

import org.junit.Test
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.InjectWith
import com.google.inject.Inject
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import eu.quanticol.carma.core.carma.Model
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

import static org.junit.Assert.*
import org.eclipse.xtext.generator.IFileSystemAccess

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(CARMAInjectorProviderCustom))
class sm {
	@Inject extension CompilationTestHelper
	@Inject ParseHelper<Model> parseHelper 
	@Inject IGenerator underTest
	
	@Test
	def void testGenerationCodeProducer(){
		val model = parseHelper.parse('''

fun Position Move(Position p){
	attrib a := 0;
	a := p.x + Uniform(-1, 0, 1) % 3;
	attrib b := 0;
	b := p.y + Uniform(-1, 0, 1) % 3;
	Position q := new Position(1,1);
	return q;
}

records {
	
	record Position(attrib a, attrib b){
		attrib x := a;
		attrib y := b;
	}
	
}

component Sensor(attrib a, attrib b, attrib c, state Z){
    
    store{
        attrib data := a;
        attrib type := 0;
        Position position := new Position(b,c);
    }

    behaviour{
        Sense 	= sense*{data := data + 1}.Sense;
        Send 	= [my.data > 0] send[type == 1]<1>{data := data - 1}.Send;
    }

    init{
        Sense|Send|Z;
    }
}

component Monitor(attrib a, Position d){
    
    store{
        attrib data := a;
        attrib type := 1;
        Position position := d;
        
    }

    behaviour{
        Analyse = [my.data > 0] analyse*{data := data - 1}.Analyse;
        Receive = send[my.data < 10 && z == 1](z){data := data + z}.Receive;
    }
    
    init{
        Analyse|Receive|Z;
    }
}

component Beacon(attrib a, attrib b){
	
	store{
        Position position := new Position(a,b);
        attrib battery := 0;
    }
    
    behaviour{
    	Broadcast = [battery > 0] broadcast*{battery := battery -1}.Broadcast + [battery <= 0] die*.nil;
    }
    
    init{
    	Broadcast;
    }
}

abstract{
	Move = move*{position := Move(my.position)}.Wait;
	Wait = wait*.Move;
}

measures{
	measure Waiting[ attrib i := 0..2, attrib j := 0..2] = #{ *  | data >= 0 };
}


system Simple{

    collective{
        new Sensor(1,0,0,Move);
        new Sensor(1,2,2,Move);
        new Monitor(1,new Position(0..2,0..2));
    }

    environment{
    	
    	store{
    		attrib reports 	:= 0;
    		attrib type 	:= 2;
    		Position center := new Position(1,1);
    	}
    	
    	prob{
    		[global.center == receiver.position] send : 1.0;
    		[receiver.position.x - global.center.x < 0] send : 0.75;
    		[receiver.position.x - global.center.x > 0] send : 0.5;
        	default : 0.25;
    	}
    	
        rate{
        	[sender.position.x == 0] move* : 10;
        	[sender.position.x == 1] move* : 5;
        	[sender.position.x == 2] move* : 2;
        	[true]	send 		: 0.5;
        	[true]	sense* 		: 1;
        	[true]	analyse* 	: 1;
        }
        
        update{
        	[true] send : global.reports := global.reports + 1;
        	[sender.data > 5] send : new Beacon(sender.position.x, sender.position.y);
        }
    }
}




		'''
		)
		val fsa = new InMemoryFileSystemAccess()
		underTest.doGenerate(model.eResource, fsa)
		println(fsa.files.get("DEFAULT_OUTPUTcarma/__synthetic0/__synthetic0Factory.java"))
		println(fsa.files)
		assertEquals(3,fsa.files.size)
		//DEFAULT_OUTPUT+"carma/__synthetic0/Simple.java"
		//DEFAULT_OUTPUTcarma/__synthetic0/__synthetic0Definition.java
		//DEFAULT_OUTPUTcarma/__synthetic0/__synthetic0Factory.java
		assertTrue(fsa.files.containsKey(IFileSystemAccess::DEFAULT_OUTPUT+"carma/__synthetic0/Simple.java"))
        assertEquals(
            '''package carma.__synthetic0;

import org.apache.commons.math3.random.RandomGenerator;
import org.cmg.ml.sam.carma.*;
import org.cmg.ml.sam.sim.SimulationEnvironment;
public class Simple extends CarmaSystem {
	
	//constructor
	public Simple(){
		addComponent(getProducer(1));
		addComponent(getProducer(2));
		addComponent(getProducer(3));
		addComponent(getProducer(4));
		addComponent(getProducer(5));
		addComponent(getProducer(6));
		addComponent(getConsumer(1));
		addComponent(getConsumer(2));
		addComponent(getConsumer(3));
		addComponent(getConsumer(4));
		addComponent(getConsumer(5));
		addComponent(getConsumer(6));
	}
	
	private CarmaComponent getProducer(int a) {
		CarmaComponent c4rm4 = new CarmaComponent();
		c4rm4.set( __synthetic0Definition.PRODUCT_ATTRIBUTE, a);
		c4rm4.set( __synthetic0Definition.POSITION_X_ATTRIBUTE, 0);
		c4rm4.set( __synthetic0Definition.POSITION_Y_ATTRIBUTE, 1);
		c4rm4.addAgent( new CarmaSequentialProcess(c4rm4, 
		__synthetic0Definition.ProducerProcess,
		__synthetic0Definition.ProducerProcess.getState("state_Produce" ) );
		c4rm4.addAgent( new CarmaSequentialProcess(c4rm4, 
		__synthetic0Definition.ProducerProcess,
		__synthetic0Definition.ProducerProcess.getState("state_Send" ) );
		return c4rm4;
	}
	private CarmaComponent getConsumer(int a) {
		CarmaComponent c4rm4 = new CarmaComponent();
		c4rm4.set( __synthetic0Definition.PRODUCT_ATTRIBUTE, a);
		c4rm4.addAgent( new CarmaSequentialProcess(c4rm4, 
		__synthetic0Definition.ConsumerProcess,
		__synthetic0Definition.ConsumerProcess.getState("state_Consume" ) );
		c4rm4.addAgent( new CarmaSequentialProcess(c4rm4, 
		__synthetic0Definition.ConsumerProcess,
		__synthetic0Definition.ConsumerProcess.getState("state_Receive" ) );
		return c4rm4;
	}
	
	/*ENVIRONMENT PROBABILITY*/
	@Override
	public double broadcastProbability(CarmaStore sender, CarmaStore receiver,
			int action) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public double unicastProbability(CarmaStore sender, CarmaStore receiver,
			int action) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	/*ENVIRONMENT RATE*/
	@Override
	public double broadcastRate(CarmaStore sender, int action) {
		/*needs action names, and then environment rate values*/
		if (action == __synthetic0Definition.PRODUCE) {
			return 1;
		}
		
		return 0;
	}

	@Override
	public double unicastRate(CarmaStore sender, int action) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	/*ENVIRONMENT UPDATE*/
	@Override
	public void broadcastUpdate(RandomGenerator random, CarmaStore sender,
			int action) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void unicastUpdate(RandomGenerator random, CarmaStore sender,
			int action) {
		// TODO Auto-generated method stub
		
	}
	
	/*MAIN*/
	public static void main( String[] argv ) {
		SimulationEnvironment<CarmaSystem> system = new SimulationEnvironment<CarmaSystem>(
			new __synthetic0Factory()
		);

		system.simulate(100,50);
	}
	
}
'''.toString, fsa.files.get(IFileSystemAccess::DEFAULT_OUTPUT+"carma/__synthetic0/Simple.java").toString
        )
    assertTrue(fsa.files.containsKey(IFileSystemAccess::DEFAULT_OUTPUT+"carma/__synthetic0/__synthetic0Definition.java"))
    assertEquals('''package carma.__synthetic0;

import org.apache.commons.math3.random.RandomGenerator;
import org.cmg.ml.sam.carma.*;
import org.cmg.ml.sam.sim.SimulationEnvironment;

public class __synthetic0Definition {
	
	/*METHOD VARIABLES*/
	/*COMPONENT ATTRIBUTES*/
	public static final String PRODUCT_ATTRIBUTE = "product";
	public static final Class<Integer> PRODUCT_ATTRIBUTE_TYPE = Integer.class;
	public static final String POSITION_X_ATTRIBUTE = "position_x";
	public static final Class<Integer> POSITION_X_ATTRIBUTE_TYPE = Integer.class;
	public static final String POSITION_Y_ATTRIBUTE = "position_y";
	public static final Class<Integer> POSITION_Y_ATTRIBUTE_TYPE = Integer.class;
	/*INPUT ARGUMENTS*/
	/*ENVIRONMENT ATTRIBUTES*/
	/*ACTION*/
	public static final int PRODUCE = 0;
	public static final int PRODUCEDOUBLE = 1;
	public static final int SEND = 2;
	public static final int CONSUME = 3;
	public static final int CONSUMEDOUBLE = 4;
	/*RATES*/
	public static final double PRODUCE_RATE = 1;
	public static final double SEND_RATE = ;
	public static final double SEND_RATE = ;
	/*PROCESS*/
	public static final CarmaProcessAutomaton ProducerProcess = createProducerProcess();
	
	private static CarmaProcessAutomaton createProducerProcess() {
		
		CarmaProcessAutomaton toReturn = new CarmaProcessAutomaton("Producer");
		
		
		//create the states in the automata 
		CarmaProcessAutomaton.State state_Send = toReturn.newState("state_Send");
		CarmaProcessAutomaton.State state_Produce = toReturn.newState("state_Produce");
		
		CarmaOutput produce_Action = new CarmaOutput( PRODUCE, true ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore store) {
				return CarmaPredicate.FALSE;
			}
		
			@Override
			protected CarmaStoreUpdate getUpdate() {
				return new CarmaStoreUpdate() {
					
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						int product = store.get("product" , Integer.class );
						store.set("product",product + 1);
					
					}
				};
			}
		
			@Override
			protected Object getValue(CarmaStore store) {
				return new Object();
			}
		};
		CarmaOutput send_Action = new CarmaOutput( SEND, false ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore store) {
				return CarmaPredicate.FALSE;
			}
		
			@Override
			protected CarmaStoreUpdate getUpdate() {
				return new CarmaStoreUpdate() {
					
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						int product = store.get("product" , Integer.class );
						store.set("product",product - 1);
					
					}
				};
			}
		
			@Override
			protected Object getValue(CarmaStore store) {
				int[] output = new int[1];
				output[0] = 1;
				return output;
			}
		};
		CarmaOutput produceDouble_Action = new CarmaOutput( PRODUCEDOUBLE, true ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore store) {
				return CarmaPredicate.FALSE;
			}
		
			@Override
			protected CarmaStoreUpdate getUpdate() {
				return new CarmaStoreUpdate() {
					
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						int product = store.get("product" , Integer.class );
						store.set("product",product + 2);
					
					}
				};
			}
		
			@Override
			protected Object getValue(CarmaStore store) {
				return new Object();
			}
		};
		
		CarmaPredicate Produce_Guard = new CarmaPredicate() {
			@Override
			public boolean satisfy(CarmaStore store) {
				int product = store.get("product" , Integer.class );
				return product > 0;
			}
		};
		CarmaPredicate Send_Guard = new CarmaPredicate() {
			@Override
			public boolean satisfy(CarmaStore store) {
				int product = store.get("product" , Integer.class );
				return product > 0;
			}
		};
		
		//create the transitions between states
		toReturn.addTransition(state_Produce,Produce_Guard,produceDouble_Action,state_Produce);
		toReturn.addTransition(state_Produce,Produce_Guard,produce_Action,state_Produce);
		toReturn.addTransition(state_Send,Send_Guard,send_Action,state_Send);
		
		return toReturn;
	}
	public static final CarmaProcessAutomaton ConsumerProcess = createConsumerProcess();
	
	private static CarmaProcessAutomaton createConsumerProcess() {
		
		CarmaProcessAutomaton toReturn = new CarmaProcessAutomaton("Consumer");
		
		
		//create the states in the automata 
		CarmaProcessAutomaton.State state_Receive = toReturn.newState("state_Receive");
		CarmaProcessAutomaton.State state_Consume = toReturn.newState("state_Consume");
		
		CarmaOutput consumeDouble_Action = new CarmaOutput( CONSUMEDOUBLE, true ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore store) {
				return CarmaPredicate.FALSE;
			}
		
			@Override
			protected CarmaStoreUpdate getUpdate() {
				return new CarmaStoreUpdate() {
					
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						int product = store.get("product" , Integer.class );
						store.set("product",product - 2);
					
					}
				};
			}
		
			@Override
			protected Object getValue(CarmaStore store) {
				return new Object();
			}
		};
		CarmaInput send_Action = new CarmaInput( SEND, false ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore store, Object value) {
				return CarmaPredicate.TRUE;
			}
			
			@Override
			protected CarmaStoreUpdate getUpdate(final Object value) {
				
				return new CarmaStoreUpdate() {
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						if (value instanceof int[]){
					
							int z = ((int[]) value)[0];
							int product = store.get("product" , Integer.class );
							store.set("product",product - z);
						
						};
					};
				
				};
			};
		};
		CarmaOutput consume_Action = new CarmaOutput( CONSUME, true ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore store) {
				return CarmaPredicate.FALSE;
			}
		
			@Override
			protected CarmaStoreUpdate getUpdate() {
				return new CarmaStoreUpdate() {
					
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						int product = store.get("product" , Integer.class );
						store.set("product",product - 1);
					
					}
				};
			}
		
			@Override
			protected Object getValue(CarmaStore store) {
				return new Object();
			}
		};
		
		CarmaPredicate Consume_Guard = new CarmaPredicate() {
			@Override
			public boolean satisfy(CarmaStore store) {
				int product = store.get("product" , Integer.class );
				return product > 2;
			}
		};
		CarmaPredicate Receive_Guard = new CarmaPredicate() {
			@Override
			public boolean satisfy(CarmaStore store) {
				int product = store.get("product" , Integer.class );
				return product > 0;
			}
		};
		
		//create the transitions between states
		toReturn.addTransition(state_Receive,Receive_Guard,send_Action,state_Receive);
		toReturn.addTransition(state_Consume,Consume_Guard,consume_Action,state_Consume);
		toReturn.addTransition(state_Consume,Consume_Guard,consumeDouble_Action,state_Consume);
		
		return toReturn;
	}
	/*MEASURES*/
}
'''.toString, fsa.files.get(IFileSystemAccess::DEFAULT_OUTPUT+"carma/__synthetic0/__synthetic0Definition.java").toString)
	assertTrue(fsa.files.containsKey(IFileSystemAccess::DEFAULT_OUTPUT+"carma/__synthetic0/__synthetic0Factory.java"))
    assertEquals('''package carma.__synthetic0;
import org.cmg.ml.sam.carma.CarmaSystem;
import org.cmg.ml.sam.sim.SimulationFactory;
public class __synthetic0Factory implements SimulationFactory<CarmaSystem> {

	public __synthetic0Factory() {
		
	}
	
	@Override
	public CarmaSystem getModel() {
		return new Simple();
	}

}
'''.toString, fsa.files.get(IFileSystemAccess::DEFAULT_OUTPUT+"carma/__synthetic0/__synthetic0Factory.java").toString)
	}
	


	
}