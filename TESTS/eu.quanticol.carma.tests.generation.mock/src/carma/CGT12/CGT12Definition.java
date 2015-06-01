package carma.CGT12;

import org.apache.commons.math3.random.RandomGenerator;
import org.cmg.ml.sam.sim.SimulationEnvironment;
import org.cmg.ml.sam.sim.sampling.*;
import eu.quanticol.carma.simulator.*;

public class CGT12Definition {
	
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
	public static final String TRANSACTIONS_ATTRIBUTE = "transactions";
	public static final Class<Integer> TRANSACTIONS_ATTRIBUTE_TYPE = Integer.class;
	/*ACTION*/
	public static final int PRODUCE = 0;
	public static final int SEND = 1;
	public static final int CONSUME = 2;
	/*RATES*/
	public static final double TRUE_SEND_RATE = 1;
	public static final double TRUE_PRODUCE_RATE = 1;
	/*PROCESS*/
	public static final CarmaProcessAutomaton ProducerProcess = createProducerProcess();
	
	private static CarmaProcessAutomaton createProducerProcess() {
		
		CarmaProcessAutomaton toReturn = new CarmaProcessAutomaton("Producer");
		
		
		//create the states in the automata 
		CarmaProcessAutomaton.State state_Send = toReturn.newState("state_Send");
		CarmaProcessAutomaton.State state_Produce = toReturn.newState("state_Produce");
		
		CarmaOutput produce_Action = new CarmaOutput( PRODUCE, true ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore outputStore) {
				return CarmaPredicate.TRUE;
			}
		
			@Override
			protected CarmaStoreUpdate getUpdate() {
				return new CarmaStoreUpdate() {
					
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						boolean hasAttributes = true;
						int product = 0;
						if(store.get("product" , Integer.class) != null){
							product = store.get("product" , Integer.class); 
						} else { 
							hasAttributes = false;
						}
						if(hasAttributes){
							store.set("product",product + 1);
						}
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
			protected CarmaPredicate getPredicate(CarmaStore outputStore) {
				return CarmaPredicate.TRUE;
			}
		
			@Override
			protected CarmaStoreUpdate getUpdate() {
				return new CarmaStoreUpdate() {
					
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						boolean hasAttributes = true;
						int product = 0;
						if(store.get("product" , Integer.class) != null){
							product = store.get("product" , Integer.class); 
						} else { 
							hasAttributes = false;
						}
						if(hasAttributes){
							store.set("product",product - 1);
						}
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
		
		CarmaPredicate Send_Guard = new CarmaPredicate() {
			@Override
			public boolean satisfy(CarmaStore store) {
				boolean hasAttributes = true;
				int product = 0;
				if(store.get("product" , Integer.class) != null){
					product = store.get("product" , Integer.class); 
				} else { 
					hasAttributes = false;
				}
				if(hasAttributes)
					return product >= 0;
				else
					return false;
			}
		};
		CarmaPredicate Produce_Guard = new CarmaPredicate() {
			@Override
			public boolean satisfy(CarmaStore store) {
				boolean hasAttributes = true;
				int product = 0;
				if(store.get("product" , Integer.class) != null){
					product = store.get("product" , Integer.class); 
				} else { 
					hasAttributes = false;
				}
				if(hasAttributes)
					return product >= 0;
				else
					return false;
			}
		};
		
		//create the transitions between states
		toReturn.addTransition(state_Send,Send_Guard,send_Action,state_Send);
		toReturn.addTransition(state_Produce,Produce_Guard,produce_Action,state_Produce);
		
		return toReturn;
	}
	public static final CarmaProcessAutomaton ConsumerProcess = createConsumerProcess();
	
	private static CarmaProcessAutomaton createConsumerProcess() {
		
		CarmaProcessAutomaton toReturn = new CarmaProcessAutomaton("Consumer");
		
		
		//create the states in the automata 
		CarmaProcessAutomaton.State state_Receive = toReturn.newState("state_Receive");
		CarmaProcessAutomaton.State state_Consume = toReturn.newState("state_Consume");
		
		CarmaInput send_Action = new CarmaInput( SEND, false ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore outputStore, Object value) {
				return CarmaPredicate.TRUE;
			}
			
			@Override
			protected CarmaStoreUpdate getUpdate(final Object value) {
				
				return new CarmaStoreUpdate() {
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						if (value instanceof int[]){
							boolean hasAttributes = true;
							int z = ((int[]) value)[0];
							int product = 0;
							if(store.get("product" , Integer.class) != null){
								product = store.get("product" , Integer.class); 
							} else { 
								hasAttributes = false;
							}
							if(hasAttributes){
								store.set("product",product + z);
							}
						};
					};
				
				};
			};
		};
		CarmaOutput consume_Action = new CarmaOutput( CONSUME, true ) {
			
			@Override
			protected CarmaPredicate getPredicate(CarmaStore outputStore) {
				return CarmaPredicate.TRUE;
			}
		
			@Override
			protected CarmaStoreUpdate getUpdate() {
				return new CarmaStoreUpdate() {
					
					@Override
					public void update(RandomGenerator r, CarmaStore store) {
						boolean hasAttributes = true;
						int product = 0;
						if(store.get("product" , Integer.class) != null){
							product = store.get("product" , Integer.class); 
						} else { 
							hasAttributes = false;
						}
						if(hasAttributes){
							store.set("product",product - 1);
						}
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
				boolean hasAttributes = true;
				int product = 0;
				if(store.get("product" , Integer.class) != null){
					product = store.get("product" , Integer.class); 
				} else { 
					hasAttributes = false;
				}
				if(hasAttributes)
					return product > 0;
				else
					return false;
			}
		};
		CarmaPredicate Receive_Guard = new CarmaPredicate() {
			@Override
			public boolean satisfy(CarmaStore store) {
				boolean hasAttributes = true;
				int product = 0;
				if(store.get("product" , Integer.class) != null){
					product = store.get("product" , Integer.class); 
				} else { 
					hasAttributes = false;
				}
				if(hasAttributes)
					return product < 1;
				else
					return false;
			}
		};
		
		//create the transitions between states
		toReturn.addTransition(state_Receive,Receive_Guard,send_Action,state_Receive);
		toReturn.addTransition(state_Consume,Consume_Guard,consume_Action,state_Consume);
		
		return toReturn;
	}
	/*MEASURES*/
	//predicate states get_MeasureName_State(ProcessName_ProcessName... || All)Predicate()
	public static CarmaProcessPredicate getMeasureWaiting__All_State_Predicate(){
		return new CarmaProcessPredicate() {
			
			@Override
			public boolean eval(CarmaProcess p) {
				return ( 
				(((CarmaSequentialProcess) p).automaton() ==  ProducerProcess) && (
				(((CarmaSequentialProcess) p).automaton().getState("state_Send") != null ) ||
				(((CarmaSequentialProcess) p).automaton().getState("state_Produce") != null ) ||
				(((CarmaSequentialProcess) p).getState() !=  null))
				)
				||( 
				(((CarmaSequentialProcess) p).automaton() ==  ConsumerProcess) && (
				(((CarmaSequentialProcess) p).automaton().getState("state_Receive") != null ) ||
				(((CarmaSequentialProcess) p).automaton().getState("state_Consume") != null ) ||
				(((CarmaSequentialProcess) p).getState() !=  null))
				)
				;
			}
		};
	}
	//predicate for boolean expression get_MeasureName_BooleanExpression_Predicate()
	protected static CarmaPredicate getPredicateWaiting__All(final int i, final int j) {
		return new CarmaPredicate() {
			@Override
			public boolean satisfy(CarmaStore store) {
				boolean hasAttributes = true;
				if(hasAttributes)
					return true;
				else
					return false;
			}
		};
	}
	
	
	public static ComponentPredicate getMeasureWaiting__All_BooleanExpression_Predicate(final int i, final int j){
		return new ComponentPredicate() {
			
			@Override
			public boolean eval(CarmaComponent c){
				return getPredicateWaiting__All(i, j).satisfy(c.getStore()) && (c.isRunning(getMeasureWaiting__All_State_Predicate()));
			}
		};
	}
	//getMethod
	public static Measure<CarmaSystem> getMeasureWaiting__All(final int iMin, final int jMin){
		
		return new Measure<CarmaSystem>(){
		
			ComponentPredicate predicate = getMeasureWaiting__All_BooleanExpression_Predicate(iMin, jMin);
		
			@Override
			public double measure(CarmaSystem t){
				//TODO
			
				return t.measure(predicate);
		
			};
		
			@Override
			public String getName() {
				return "Waiting__All";
			}
		};
	}
}
