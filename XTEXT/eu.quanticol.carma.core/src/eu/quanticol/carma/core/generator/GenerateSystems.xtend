package eu.quanticol.carma.core.generator

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.ActionStub
import eu.quanticol.carma.core.carma.BlockSystem
import eu.quanticol.carma.core.carma.BooleanExpressions
import eu.quanticol.carma.core.carma.Component
import eu.quanticol.carma.core.carma.ComponentArgument
import eu.quanticol.carma.core.carma.ComponentBlockDefinition
import eu.quanticol.carma.core.carma.ComponentBlockForStatement
import eu.quanticol.carma.core.carma.ComponentBlockNewDeclaration
import eu.quanticol.carma.core.carma.EnvironmentGuard
import eu.quanticol.carma.core.carma.EnvironmentUpdate
import eu.quanticol.carma.core.carma.EnvironmentUpdateAssignment
import eu.quanticol.carma.core.carma.LineSystem
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.carma.NCA
import eu.quanticol.carma.core.carma.PrimitiveType
import eu.quanticol.carma.core.carma.Probability
import eu.quanticol.carma.core.carma.Range
import eu.quanticol.carma.core.carma.Rate
import eu.quanticol.carma.core.carma.RecordDeclaration
import eu.quanticol.carma.core.carma.RecordReferenceReceiver
import eu.quanticol.carma.core.carma.RecordReferenceSender
import eu.quanticol.carma.core.carma.Spawn
import eu.quanticol.carma.core.carma.System
import eu.quanticol.carma.core.carma.VariableDeclarationEnum
import eu.quanticol.carma.core.carma.VariableDeclarationRecord
import eu.quanticol.carma.core.carma.VariableReferenceReceiver
import eu.quanticol.carma.core.carma.VariableReferenceSender
import eu.quanticol.carma.core.typing.TypeProvider
import eu.quanticol.carma.core.utils.LabelUtil
import eu.quanticol.carma.core.utils.Util
import java.util.ArrayList

import static extension org.eclipse.xtext.EcoreUtil2.*
import java.util.HashSet
import eu.quanticol.carma.core.carma.VariableReference
import eu.quanticol.carma.core.carma.VariableReferencePure
import eu.quanticol.carma.core.carma.RecordReferencePure
import eu.quanticol.carma.core.carma.VariableReferenceGlobal
import eu.quanticol.carma.core.carma.RecordReferenceGlobal
import eu.quanticol.carma.core.carma.EnvironmentUpdateExpression
import eu.quanticol.carma.core.carma.EnvironmentUpdateExpressions

class GenerateSystems {
	
	@Inject extension TypeProvider
	@Inject extension LabelUtil
	@Inject extension Util
	@Inject extension GeneratorUtils
	
	def String compileSystem(System system, String packageName){
		'''
		«packageName»;
		
		import org.apache.commons.math3.random.RandomGenerator;
		import org.cmg.ml.sam.sim.SimulationEnvironment;
		import eu.quanticol.carma.simulator.*;
		public class «system.label» extends CarmaSystem {
			
			//constructor
			public «system.label»(){
				«system.declareComponents»
				«system.setGlobalStore»
			}
			
			«system.defineComponents»
			
			«system.defineEnvironmentProb»
			
			«system.defineEnvironmentRates»
			
			«system.defineEnvironmentUpdatesPredicates»
			
			«system.defineEnvironmentUpdates»
			
			«system.defineMain»
			
		}
		'''
	}
	
	def String defineComponents(System system){
		var components = new ArrayList<Component>(system.getContainerOfType(Model).eAllOfType(Component))
		var cat = system.getContainerOfType(Model).getComponentAttributeType
		'''
		«FOR component : components»
			private CarmaComponent get«component.label.toFirstUpper»(«component.getArgs») {
				CarmaComponent c4rm4 = new CarmaComponent();
				«var vds = cat.get(component)»
				«FOR vd : vds»
					«switch(vd){
						VariableDeclarationEnum: '''c4rm4.set( «system.getContainerOfType(Model).label»Definition.«vd.name.label.toUpperCase»_ATTRIBUTE, «system.getContainerOfType(Model).getValue(component.label,vd.name.label)»);'''
						VariableDeclarationRecord: {
							var rds = vd.eAllOfType(RecordDeclaration)
							if(rds.size > 0){
								'''
								«FOR rd : rds»
								c4rm4.set( «system.getContainerOfType(Model).label»Definition.«vd.name.label.toUpperCase»_«rd.name.label.toUpperCase»_ATTRIBUTE, «system.getContainerOfType(Model).getValue(component.label,vd.name.label,rd.name.label)»);
								«ENDFOR»
								'''
							} else {
								rds = vd.assign.ref.recordDeclarationsFromCBND
								'''
								«FOR rd : rds»
								c4rm4.set( «system.getContainerOfType(Model).label»Definition.«vd.name.label.toUpperCase»_«rd.name.label.toUpperCase»_ATTRIBUTE, «rd.name.label»);
								«ENDFOR»
								'''
							}
								
						}
					}»
				«ENDFOR»
				«FOR mer : component.getMacros»
				c4rm4.addAgent( new CarmaSequentialProcess(c4rm4, 
				«system.getContainerOfType(Model).label»Definition.«component.label»Process,
				«system.getContainerOfType(Model).label»Definition.«component.label»Process.getState("state_«mer.name.label»" ) );
				«ENDFOR»
				return c4rm4;
			}
			«ENDFOR»
		'''
	}
	
	def String setGlobalStore(System system){
		var envs = system.getContainerOfType(Model).environmentAttributes
		'''
		«FOR vd : envs»
		«switch(vd){
			VariableDeclarationEnum:	'''global_store.set(«system.getContainerOfType(Model).label»Definition.«vd.name.label.toUpperCase»_ATTRIBUTE,«system.getContainerOfType(Model).getValueEnv(vd.name.label)»)'''
			VariableDeclarationRecord:{
							var rds = vd.eAllOfType(RecordDeclaration)
							if(rds.size > 0){
								'''
								«FOR rd : rds»
								global_store.set( «system.getContainerOfType(Model).label»Definition.«vd.name.label.toUpperCase»_«rd.name.label.toUpperCase»_ATTRIBUTE, «system.getContainerOfType(Model).getValueEnv(vd.name.label,rd.name.label)»);
								«ENDFOR»
								'''
							} 
								
						}
		}»
		«ENDFOR»
		'''
			
	}
	
	def String declareComponents(System system){
		switch(system){
			BlockSystem: 	{
				var declaredComponents = system.getContainerOfType(Model).eAllOfType(ComponentBlockNewDeclaration)
				var output = ""
				for(dc : declaredComponents){
					if(dc.getContainerOfType(ComponentBlockForStatement) != null){
						output = output + dc.getContainerOfType(ComponentBlockForStatement).forBlock
					}else{
						if((dc.eAllOfType(Range).size > 0)){
							output = output + rangeDeclaration(dc)
						}else{
							output = output + singleDeclaration(dc)
					}
				}
		}
		return output}
			//TODO
			LineSystem:		{"//TODO"}
		}
		
	}
	
	def String forBlock(ComponentBlockForStatement cbfs){
		'''
		for(«cbfs.variable.convertToJava»;«cbfs.expression.label»;«cbfs.afterThought.nameValue»){
			«(cbfs.componentBlockForBlock.component as ComponentBlockNewDeclaration).singleDeclaration»
		};
		'''
		
	}
	
	def String rangeDeclaration(ComponentBlockNewDeclaration dc){
		var output = ""
		var arguments = dc.eAllOfType(NCA)
		var ArrayList<PrimitiveType> temp = new ArrayList<PrimitiveType>()
		
		//We don't want to pick up the Macro
		for(argument : arguments){
			if(argument.type.toString.equals("component"))
				for(pt : argument.eAllOfType(PrimitiveType))
					temp.add(pt)
		}
		
		var ArrayList<ArrayList<String>> array1 = new ArrayList<ArrayList<String>>()
		
		for(argument : temp){
			array1.add(argument.strip)
		}
		var array2 = new ArrayList<ArrayList<String>>()
		forBlock(array1,array2)
		for(list : array2){
			output = output + singleDeclaration(dc, list)
		}
		return output
	}
	
	def String singleDeclaration(ComponentBlockNewDeclaration dc, ArrayList<String> args){
		'''
		addComponent(get«dc.label.toFirstUpper»(«args.stripArguments»));
		'''
	}
	
	def String stripArguments(ArrayList<String> args){
		
		var output = ""
		
		//now create the string
		if(args.size > 0){
			output = args.get(0)
			for(var i = 1; i < args.size; i++)
				output = output + "," + args.get(i)
		}
		
		return output
	}
	
	def void forBlock(ArrayList<ArrayList<String>> array, ArrayList<ArrayList<String>> output){
		if(array.size > 1){
			var head = array.remove(0)
			var exit = new ArrayList<ArrayList<String>>()
			forBlock(array,output)
			for(var i = 0; i < output.size; i++){
				for(item : head){
					var inter = new ArrayList<String>()
					inter.add(item)
					inter.addAll(output.get(i))
					exit.add(inter)
				}
			}
			output.clear
			output.addAll(exit)
		} else {
			var head = array.remove(0)
			for(item : head){
				var tail = new ArrayList<String>()
				tail.add(item)
				output.add(tail)
			}
		}
	}
	
	
	
	def ArrayList<String> strip(PrimitiveType pt){
		var temp = new ArrayList<String>()
		
		if(pt.eAllOfType(Range).size > 0)
			for(r : pt.eAllOfType(Range))
				temp.addAll(r.range)
		else
			temp.add(pt.label)


		return temp
	}
	
	def ArrayList<String> getRange(Range r){
		var ArrayList<String> output = new ArrayList<String>()
		for(var i = r.min; i <= r.max; i++){
			output.add(""+i)	
		}
		return output
	}
	
	def String singleDeclaration(ComponentBlockNewDeclaration dc){
		'''
		addComponent(get«dc.label.toFirstUpper»(«dc.stripArguments»));
		'''
	}
	
	def String stripArguments(ComponentBlockNewDeclaration dc){
		
		var arguments = dc.eAllOfType(NCA)
		var output = ""
		var ArrayList<NCA> temp = new ArrayList<NCA>()
		
		//We don't want to pick up the Macro
		for(argument : arguments){
			if(argument.type.toString.equals("component"))
				temp.add(argument)
		}
		
		//now create the string
		if(temp.size > 0){
			output = arguments.get(0).getLabelForArgs
			for(var i = 1; i < temp.size; i++)
				output = output + "," + temp.get(i).getLabelForArgs
		}
		
		return output
	}
	
	def String getArgs(Component component){
		if(component.getContainerOfType(ComponentBlockDefinition) != null){
			
			var arguments = component.eAllOfType(ComponentArgument)
			var output = ""
			var ArrayList<ComponentArgument> temp = new ArrayList<ComponentArgument>()
			
			//We don't want to pick up the Macro
			for(argument : arguments){
				if(argument.type.toString.equals("component"))
					temp.add(argument)
			}
			
			//now create the string
			if(temp.size > 0){
				output = arguments.get(0).convertToJava
				for(var i = 1; i < temp.size; i++)
					output = output + "," + temp.get(i).convertToJava
			}
			
			return output
			
		} else {
			//TODO
			return "//TODO"
		}
	}
	
	def String defineEnvironmentProb(System system){
		
		var probs = system.getContainerOfType(Model).eAllOfType(Probability)
		var unicasts = new ArrayList<Probability>()
		var broadcasts = new ArrayList<Probability>()
		
		for(eu : probs)
			if(eu.stub.isBroadcast)
				broadcasts.add(eu)
			else
				unicasts.add(eu)
		'''
		/*ENVIRONMENT PROBABILITY*/
		@Override
		public double broadcastProbability(CarmaStore sender, CarmaStore receiver,
		int action) {
			«FOR broadcast : broadcasts»
			«defineProbActionStubs(broadcast.stub)»
			«ENDFOR»
			return 0;
		}
		
		@Override
		public double unicastProbability(CarmaStore sender, CarmaStore receiver,
		int action) {
			«FOR unicast : unicasts»
			«defineProbActionStubs(unicast.stub)»
			«ENDFOR»
			return 0;
		}
		'''
	}
	
	def String defineProbActionStubs(ActionStub actionStub){
		'''
		if («actionStub.predicateHandlerProbability» && action == «actionStub.getContainerOfType(Model).label»Definition.«actionStub.name.name.toUpperCase») {
				«actionStub.defineProbActionStub»
		}
		'''
	}
	
	def String predicateHandlerProbability(ActionStub actionStub){
		var booleanExpression = actionStub.getContainerOfType(Probability).eAllOfType(EnvironmentGuard).get(0)
		'''
		«booleanExpression.booleanExpression.label»
		'''
	}	
	
	def String defineProbActionStub(ActionStub actionStub){
		'''return «actionStub.getContainerOfType(Probability).expression.label»;'''
	}
	
	def String defineEnvironmentRates(System system){
		
		var rates = system.getContainerOfType(Model).eAllOfType(Rate)
		var unicasts = new ArrayList<Rate>()
		var broadcasts = new ArrayList<Rate>()
		
		for(eu : rates)
			if(eu.stub.isBroadcast)
				broadcasts.add(eu)
			else
				unicasts.add(eu)
		
			'''
		/*ENVIRONMENT RATE*/
		@Override
		public double broadcastRate(CarmaStore sender, int action) {
			«FOR broadcast : broadcasts»
			«defineRateActionStubs(broadcast.stub)»
			«ENDFOR»
			return 0;
		}
		@Override
		public double unicastRate(CarmaStore sender, int action) {
			«FOR unicast : unicasts»
			«defineRateActionStubs(unicast.stub)»
			«ENDFOR»
		}
		'''
	}
	
	def String defineRateActionStubs(ActionStub actionStub){
		'''
		if («actionStub.predicateHandlerRate» && action == «actionStub.getContainerOfType(Model).label»Definition.«actionStub.name.name.toUpperCase») {
				«actionStub.defineRateActionStub»
		}
		'''
	}
	
	def String predicateHandlerRate(ActionStub actionStub){
		var booleanExpression = actionStub.getContainerOfType(Rate).eAllOfType(EnvironmentGuard).get(0)
		'''
		«booleanExpression.booleanExpression.label»
		'''
	}
	
	def String defineRateActionStub(ActionStub actionStub){
		'''return «actionStub.getContainerOfType(Rate).expression.label»;'''
	}
	
	def String defineEnvironmentUpdatesPredicates(System system){
		
		var updates = system.getContainerOfType(Model).eAllOfType(EnvironmentUpdate)
		var unicasts = new ArrayList<EnvironmentUpdate>()
		var broadcasts = new ArrayList<EnvironmentUpdate>()
		
		for(eu : updates)
			if(eu.stub.isBroadcast)
				broadcasts.add(eu)
			else
				unicasts.add(eu)
		'''
		/*ENVIRONMENT UPDATE PREDICATES*/
		//BROADCAST ENVIRONMENT UPDATE PREDICATES
		«FOR broadcast : broadcasts»
		«defineBroadcastEnvironmentUpdatePredicates(broadcast)»
		«ENDFOR»
		
		//UNICAST ENVIRONMENT UPDATE PREDICATES
		«FOR unicast : unicasts»
		«defineUnicastEnvironmentUpdatePredicates(unicast)»
		«ENDFOR»
		'''
		
	}
	
	def String getAllVariables(BooleanExpressions bes){
		'''
		«FOR vr : bes.getGlobals»
		«vr.getGlobal»
		«ENDFOR»
		«FOR vr : bes.getReceivers»
		«vr.getReceiver»
		«ENDFOR»
		«FOR vr : bes.getSenders»
		«vr.getSender»
		«ENDFOR»
		'''
	}
	
	def String defineBroadcastEnvironmentUpdatePredicates(EnvironmentUpdate cast){
		//anything NOT receiver or sender is a global store access
		var senders 	= (cast.guard.eAllOfType(RecordReferenceSender).size + cast.guard.eAllOfType(VariableReferenceSender).size) > 0
		var receivers	= (cast.guard.eAllOfType(RecordReferenceReceiver).size + cast.guard.eAllOfType(VariableReferenceReceiver).size) > 0
		
		//no! global_store always accessible!
		
		//either single with no args
		if(senders && !receivers){ 
			'''
			public static CarmaPredicate get«cast.convertToJavaName»_BroadcastPredicate(){
				return new CarmaPredicate() {

					@Override
					public boolean satisfy(CarmaStore sender) {
						«cast.guard.booleanExpression.getAllVariables»
						return «cast.guard.convertToJava»
					}
					
				};
			}'''
		} else if (!senders && receivers){
			'''
			public static CarmaPredicate get«cast.convertToJavaName»_BroadcastPredicate(){
				return new CarmaPredicate() {

					@Override
					public boolean satisfy(CarmaStore receiver) {
						«cast.guard.booleanExpression.getAllVariables»
						return «cast.guard.convertToJava»
					}
					
				};
			}'''
		//or double with sender always given first, and receiver sent for evaluation?
		} else if (senders && receivers) {
			'''
			public static CarmaPredicate get«cast.convertToJavaName»_BroadcastPredicate(CarmaStore sender){
				return new CarmaPredicate() {

					@Override
					public boolean satisfy(CarmaStore receiver) {
						«cast.guard.booleanExpression.getAllVariables»
						return «cast.guard.convertToJava»
					}
					
				};
			}'''
		//or just global, no one cares about the store
		} else if (cast.guard.eAllOfType(VariableReference).size > 0){
			'''
			public static CarmaPredicate get«cast.convertToJavaName»_BroadcastPredicate(){
				return new CarmaPredicate() {

					@Override
					public boolean satisfy(CarmaStore store) {
						«cast.guard.booleanExpression.getAllVariables»
						return «cast.guard.convertToJava»
					}
					
				};
			}'''
		}
		
		
	}
	
	def String defineUnicastEnvironmentUpdatePredicates(EnvironmentUpdate cast){
		//anything NOT receiver or sender is a global store access
		var senders 	= (cast.guard.eAllOfType(RecordReferenceSender).size + cast.guard.eAllOfType(VariableReferenceSender).size) > 0
		var receivers	= (cast.guard.eAllOfType(RecordReferenceReceiver).size + cast.guard.eAllOfType(VariableReferenceReceiver).size) > 0
		//no! global_store always accessible!
		
		//either single with no args
		if(senders && !receivers){ 
			'''
			«cast.convertToPredicateName»(){
				return new CarmaPredicate() {

					@Override
					public boolean satisfy(CarmaStore sender) {
						«cast.guard.booleanExpression.getAllVariables»
						return «cast.guard.convertToJava»
					}
					
				};
			}'''
		} else if (!senders && receivers){
			'''
			«cast.convertToPredicateName»(){
				return new CarmaPredicate() {

					@Override
					public boolean satisfy(CarmaStore receiver) {
						«cast.guard.booleanExpression.getAllVariables»
						return «cast.guard.convertToJava»
					}
					
				};
			}'''
		//or double with sender always given first, and receiver sent for evaluation?
		} else if (senders && receivers) {
			'''
			«cast.convertToPredicateName»(CarmaStore sender){
				return new CarmaPredicate() {

					@Override
					public boolean satisfy(CarmaStore receiver) {
						«cast.guard.booleanExpression.getAllVariables»
						return «cast.guard.convertToJava»
					}
					
				};
			}'''
		//or just global, no one cares about the store
		} else if (cast.guard.eAllOfType(VariableReference).size > 0){
			'''
			«cast.convertToPredicateName»(){
				return new CarmaPredicate() {

					@Override
					public boolean satisfy(CarmaStore store) {
						«cast.guard.booleanExpression.getAllVariables»
						return «cast.guard.convertToJava»
					}
					
				};
			}'''
		}
		
		
	}
	
	def String defineEnvironmentUpdates(System system){
		
		var updates = system.getContainerOfType(Model).eAllOfType(EnvironmentUpdate)
		var unicasts = new ArrayList<EnvironmentUpdate>()
		var broadcasts = new ArrayList<EnvironmentUpdate>()
		
		for(eu : updates)
			if(eu.stub.isBroadcast)
				broadcasts.add(eu)
			else
				unicasts.add(eu)
		'''
		/*ENVIRONMENT UPDATE*/
		@Override
		public void broadcastUpdate(RandomGenerator random, CarmaStore sender, 
		int action, Object value) {
			«FOR broadcast : broadcasts»
			«defineEUpdateActionStubs(broadcast.stub)»
			«ENDFOR»
		}
		
		@Override
		public void unicastUpdate(RandomGenerator random, CarmaStore sender, CarmaStore receiver,
		int action, Object value) {
			«FOR unicast : unicasts»
			«defineEUpdateActionStubs(unicast.stub)»
			«ENDFOR»
		}
		'''
		
	}
	
	def String defineEUpdateActionStubs(ActionStub actionStub){
		'''
		if («actionStub.predicateHandlerEnvironmentUpdate» && action == «actionStub.getContainerOfType(Model).label»Definition.«actionStub.name.name.toUpperCase») {
				«actionStub.defineEUpdateActionStub»
		}
		'''
	}
	
	def String predicateHandlerEnvironmentUpdate(ActionStub actionStub){
		var booleanExpression = actionStub.getContainerOfType(EnvironmentUpdate).eAllOfType(EnvironmentGuard).get(0)
		'''
		«booleanToPredicate(booleanExpression.booleanExpression)»
		'''
	}
	
	def String booleanToPredicate(BooleanExpressions be){
		if(be.label.equals("True") || be.label.equals("true")){
			return '''(CarmaPredicate.TRUE.satisfy(sender)'''
		}
		else if(be.label.equals("False") || be.label.equals("false")){
			return '''(CarmaPredicate.FALSE.satisfy(sender)'''
		}
		else {
			var cast = be.getContainerOfType(EnvironmentUpdate) 
			var senders 	= (cast.eAllOfType(RecordReferenceSender).size + cast.eAllOfType(VariableReferenceSender).size) > 0
			var receivers	= (cast.eAllOfType(RecordReferenceReceiver).size + cast.eAllOfType(VariableReferenceReceiver).size) > 0
			if(senders && !receivers){
				'''«cast.convertToPredicateName»().satisfy(CarmaStore sender)'''
			} else if (!senders && receivers) {
				'''«cast.convertToPredicateName»().satisfy(CarmaStore receiver)'''
			} else if (senders && receivers) {
				'''«cast.convertToPredicateName»().satisfy(CarmaStore receiver)'''
			} else {
				'''«cast.convertToPredicateName»().satisfy(CarmaStore sender)'''
			}
		}
	}
	
	def String anAssignment(EnvironmentUpdateAssignment eua){
		'''
		«eua.expression.getAllVariables»
		«eua.storeReference.setVariable(eua.storeReference.convertToJava,eua.expression.label)»
		'''
	}
	
	def String getAllVariables(EnvironmentUpdateExpressions eues){
		'''
		«FOR vr : eues.getGlobals»
		«vr.getGlobal»
		«ENDFOR»
		«FOR vr : eues.getReceivers»
		«vr.getReceiver»
		«ENDFOR»
		«FOR vr : eues.getSenders»
		«vr.getSender»
		«ENDFOR»
		'''
	}
	
	def String defineEUpdateActionStub(ActionStub actionStub){
		if(actionStub.getContainerOfType(EnvironmentUpdate).eAllOfType(Spawn).size > 0){
			'''//spawns'''
		} else if (actionStub.getContainerOfType(EnvironmentUpdate).eAllOfType(EnvironmentUpdateAssignment).size > 0){
			'''
			«FOR e :actionStub.getContainerOfType(EnvironmentUpdate).expression»
			«e.anAssignment»
			«ENDFOR»
			'''
		} else {
			'''//«actionStub.label» invalid'''
		}
	}
	
	def String defineMain(System system){
		'''
		/*MAIN*/
		public static void main( String[] argv ) {
			SimulationEnvironment<CarmaSystem> system = new SimulationEnvironment<CarmaSystem>(
				new «system.getContainerOfType(Model).label»Factory()
			);
		
			system.simulate(100,50);
		}'''
	}
	
	
}