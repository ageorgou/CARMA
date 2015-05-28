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

class GenerateSystemProbability {
	
	@Inject extension TypeProvider
	@Inject extension LabelUtil
	@Inject extension Util
	@Inject extension GeneratorUtils
	
	def String defineEnvironmentProbPredicates(System system){
		
		var updates = system.getContainerOfType(Model).eAllOfType(Probability)
		var unicasts = new ArrayList<Probability>()
		var broadcasts = new ArrayList<Probability>()
		
		for(eu : updates)
			if(eu.stub.isBroadcast)
				broadcasts.add(eu)
			else
				unicasts.add(eu)
		'''
		/*ENVIRONMENT PROBABILITY PREDICATES*/
		//BROADCAST ENVIRONMENT PROBABILITY PREDICATES
		«FOR broadcast : broadcasts»
		«defineBroadcastProbabilityPredicates(broadcast)»
		«ENDFOR»
		
		//UNICAST ENVIRONMENT PROBABILITY PREDICATES
		«FOR unicast : unicasts»
		«defineUnicastProbabilityPredicates(unicast)»
		«ENDFOR»
		'''
		
	}
	
	def String defineBroadcastProbabilityPredicates(Probability cast){
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
	
	def String defineUnicastProbabilityPredicates(Probability cast){
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
	

}