/*
 * generated by Xtext
 */
package eu.quanticol.carma.core.scoping

import eu.quanticol.carma.core.carma.ComponentDefinition
import eu.quanticol.carma.core.carma.AttributeDeclaration
import static extension org.eclipse.xtext.EcoreUtil2.*
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.emf.ecore.EObject
import eu.quanticol.carma.core.carma.FunctionDefinition
import org.eclipse.emf.ecore.EReference
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.carma.FieldAccess
import eu.quanticol.carma.core.carma.ConstantDefinition
import org.eclipse.xtext.scoping.IScope
import eu.quanticol.carma.core.carma.SystemDefinition
import eu.quanticol.carma.core.carma.ReferenceableElement
import eu.quanticol.carma.core.carma.Element
import eu.quanticol.carma.core.carma.StoreBlock
import eu.quanticol.carma.core.carma.MeasureDefinition
import static extension eu.quanticol.carma.core.typing.TypeSystem.*
import eu.quanticol.carma.core.carma.RecordDefinition
import eu.quanticol.carma.core.carma.ProcessesBlock
import eu.quanticol.carma.core.carma.MyContext
import eu.quanticol.carma.core.carma.GlobalContext
import eu.quanticol.carma.core.carma.Environment
import eu.quanticol.carma.core.carma.SenderContext
import eu.quanticol.carma.core.carma.ReceiverContext
import eu.quanticol.carma.core.carma.InputAction
import eu.quanticol.carma.core.carma.Processes
import eu.quanticol.carma.core.carma.AtomicRecord
import eu.quanticol.carma.core.utils.Util
import com.google.inject.Inject
import eu.quanticol.carma.core.typing.TypeSystem
import eu.quanticol.carma.core.carma.AllComponents
import eu.quanticol.carma.core.carma.AComponentAState
import eu.quanticol.carma.core.carma.ComponentBlockInstantiation
import eu.quanticol.carma.core.carma.ComponentBlockForStatement
import java.util.LinkedList
import eu.quanticol.carma.core.carma.EnumDefinition
import eu.quanticol.carma.core.carma.BlockCommand
import eu.quanticol.carma.core.carma.FunctionCommand
import eu.quanticol.carma.core.carma.IfThenElseCommand
import eu.quanticol.carma.core.carma.ForCommand
import eu.quanticol.carma.core.carma.VariableDeclarationCommand
import eu.quanticol.carma.core.carma.AssignmentCommand
import eu.quanticol.carma.core.carma.ProcessState
import eu.quanticol.carma.core.carma.TargetAssignmentField
import eu.quanticol.carma.core.carma.LambdaExpression
import eu.quanticol.carma.core.carma.LocationExpression
import eu.quanticol.carma.core.carma.LocationVariable
import eu.quanticol.carma.core.carma.SpaceDefinition
import eu.quanticol.carma.core.carma.Probability
import eu.quanticol.carma.core.carma.Rate
import eu.quanticol.carma.core.carma.Weight
import eu.quanticol.carma.core.carma.ComponentBlockIteratorStatement
import eu.quanticol.carma.core.carma.ComponentBlockFor
import eu.quanticol.carma.core.carma.LocationFeature
import eu.quanticol.carma.core.carma.CollectiveDefinition
import eu.quanticol.carma.core.carma.ConnectionExpression

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#scoping
 * on how and when to use it 
 *
 */
class CARMAScopeProvider extends org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider {

	@Inject extension Util
	@Inject extension TypeSystem



	def dispatch IScope getScopeFor( BlockCommand container , FunctionCommand command ) {
		var idx = container.commands.indexOf(command)	
		if (idx<=0) {
			container.parentScope
		} else {
			var localVariables = container.commands.subList(0,idx).filter(typeof(VariableDeclarationCommand)).map[it.variable]					
			if (localVariables.size > 0) {
				Scopes::scopeFor( localVariables , container.parentScope )
			} else {
				container.parentScope
			}
		}
	}

	def dispatch getScopeFor( IfThenElseCommand container , FunctionCommand command ) {
		container.parentScope	
	}

	def dispatch getScopeFor( ForCommand container , FunctionCommand command ) {
		Scopes::scopeFor( newLinkedList( container.variable ) , container.parentScope )
	}
	
	def IScope parentScope( FunctionCommand c ) {
		var parent = c.eContainer
		switch( parent ) {
			FunctionCommand: parent.getScopeFor(c)
			LambdaExpression: Scopes::scopeFor(
				parent.variables
			)
			FunctionDefinition: Scopes::scopeFor( 
				parent.parameters , 
				Scopes::scopeFor( 
					parent.globalReferenceableElements.filter[
						it.isValidInExpressions
					]	  				
				)
			)
			LocationFeature: {
				var lf = parent.getContainerOfType(typeof(SpaceDefinition))
				if (lf != null) {
					Scopes::scopeFor(
						parent.parameters ,
						Scopes::scopeFor(
							lf.parameters ,
							Scopes::scopeFor( 
								lf.globalReferenceableElements.filter[
									it.isValidInExpressions
								]	  				
							)	
						)												
					)
				} else {
					IScope::NULLSCOPE
				}
				
			}
			Probability: {
				var sys = parent.getContainerOfType(typeof(SystemDefinition))
				if (sys != null) {
					var store = sys.environment ?. store
					var scope = Scopes::scopeFor( 
						sys.globalReferenceableElements.filter[
							it.isValidInEnvironmentExpressions
						]	  				
					)	
					if (store != null) {
						Scopes::scopeFor( store.attributes , scope )
					} else {
						scope
					}
				} else {
					IScope::NULLSCOPE
				}
			}
			Weight: {
				var sys = parent.getContainerOfType(typeof(SystemDefinition))
				if (sys != null) {
					var store = sys.environment ?. store
					var scope = Scopes::scopeFor( 
						sys.globalReferenceableElements.filter[
							it.isValidInEnvironmentExpressions
						]	  				
					)	
					if (store != null) {
						Scopes::scopeFor( store.attributes , scope )
					} else {
						scope
					}
				} else {
					IScope::NULLSCOPE
				}
			}
			Rate: {
				var sys = parent.getContainerOfType(typeof(SystemDefinition))
				if (sys != null) {
					var store = sys.environment ?. store
					var scope = Scopes::scopeFor( 
						sys.globalReferenceableElements.filter[
							it.isValidInEnvironmentExpressions
						]	  				
					)	
					if (store != null) {
						Scopes::scopeFor( store.attributes , scope )
					} else {
						scope
					}
				} else {
					IScope::NULLSCOPE
				}
			}
			default: IScope::NULLSCOPE
		}
	}
	
	def isValidInExpressions( ReferenceableElement r ) {
		!((r instanceof AttributeDeclaration)||(r instanceof ProcessState)||(r instanceof MeasureDefinition))
	}

	def isValidInEnvironmentExpressions( ReferenceableElement r ) {
		!((r instanceof AttributeDeclaration)||(r instanceof ProcessState))
	}

	def scope_AssignmentTargetVariable_variable( AssignmentCommand c , EReference r ) {
		c.parentScope
	}

	def scope_Reference_reference( FunctionCommand c , EReference r ) {
		if (c instanceof ForCommand) {
			Scopes::scopeFor( newLinkedList( c.variable ) , c.parentScope )
		} else {
			c.parentScope
		}
	}
	
	def scope_Reference_reference( MeasureDefinition d , EReference r ) {
		Scopes::scopeFor( 
			d.variables , 
			Scopes::scopeFor( 
				d.globalReferenceableElements.filter[
					it.isValidInExpressions
				]	  				
			)
		)
	}

	def scope_Reference_reference( ConstantDefinition d , EReference r ) {
		var model = d.getContainerOfType(typeof(Model))
		if (model == null) {
			IScope::NULLSCOPE
		} else {
			var elements = model.elements
			var idx = elements.indexOf(d)
			if (idx != -1) {
				Scopes::scopeFor( 
					elements.subList(0,idx).filter(typeof(ConstantDefinition)) ,
					Scopes::scopeFor(
						model.elements
							.filter[ !(it instanceof ConstantDefinition) ]
							.map[it.globalReferenceableElementsProvided].flatten.filter[ it.isValidInExpressions ] 									
					)
				)
			} else {
				Scopes::scopeFor(
					model.elements.map[it.globalReferenceableElementsProvided].flatten.filter[ it.isValidInExpressions ]			
				)
			}
		}
		
	}

	def scope_Reference_reference( ConnectionExpression a , EReference r ) {
		var space = a.getContainerOfType(SpaceDefinition)
		if (space != null) {
			Scopes::scopeFor( a.source ?. elements ?. filter(typeof(LocationVariable)) ?: newLinkedList() ,
				Scopes::scopeFor( space ?. parameters ?: newLinkedList() )
			)			
		} else {
			IScope::NULLSCOPE
		}
	}

	def scope_Reference_reference( AttributeDeclaration a , EReference r) {
		var element = a.getContainerOfType(typeof(Element))
		var globalReferences = element.globalReferenceableElements.filter[ it.isValidInExpressions ]
		var parentScope = Scopes::scopeFor( globalReferences )
		if (element instanceof ComponentDefinition) {
			parentScope = Scopes::scopeFor( element.parameters , parentScope )			
		}
		var block = a.getContainerOfType(typeof(StoreBlock))
		if (block != null) {
			var idx = block.attributes.indexOf(a)
			if (idx > 0) {
				Scopes::scopeFor( block.attributes.subList(0,idx) , 
					parentScope )
			} else {
				parentScope
			}						
		} else {
				parentScope
		}
	}
	
	def scope_Reference_reference( ProcessesBlock a , EReference r) {
		var comp = a.getContainerOfType(typeof(ComponentDefinition))
		if (comp != null) {
			var globalReferences = comp.globalReferenceableElements.filter[it.validInExpressions]
			if (comp.store != null) {
				Scopes::scopeFor( 
					comp.store.attributes , 
					Scopes::scopeFor( globalReferences)
				)
			} else {
				Scopes::scopeFor( globalReferences )
			}			
		} else {
			IScope::NULLSCOPE		
		}
	}
	
	def scope_Reference_reference( Environment env , EReference r ) {
		var sys = env.getContainerOfType(typeof(SystemDefinition))
		if (sys != null) {
			if (env.store != null) {
				Scopes::scopeFor( env.store.attributes , Scopes::scopeFor( sys.globalReferenceableElements.filter[it.isValidInEnvironmentExpressions] ) )			
			} else {
				Scopes::scopeFor( sys.globalReferenceableElements.filter[it.isValidInEnvironmentExpressions] )
			}
		} else {
			IScope::NULLSCOPE
		}
	}

	def scope_Reference_reference( Processes a , EReference r) {
		var m = a.getContainerOfType(typeof(Model))
		if (m != null) {
			var parentScope = a.globalReferenceableElements.filter[ !(it instanceof ProcessState) ]
			Scopes::scopeFor( m.attributes  , Scopes::scopeFor( parentScope ) )
		} else {
			IScope::NULLSCOPE		
		}
	}
	
	def scope_AttributeDeclaration( MyContext a , EReference r ) {
		var comp = a.getContainerOfType(typeof(ComponentDefinition))
		if (comp != null) {
			Scopes::scopeFor( comp.store.attributes )
		} else {
			var model = a. getContainerOfType(typeof(Model))
			if (model != null) {
				Scopes::scopeFor( model.attributes )
			} else {
				IScope::NULLSCOPE			
			}
		}
	}
	
	def scope_Reference_reference( InputAction a , EReference r ) {
		var comp = a.getContainerOfType(typeof(ComponentDefinition))
		if (comp != null) {
			Scopes::scopeFor( a.parameters , scope_Reference_reference(comp.processes,r) )
		} else {
			var prcs = a.getContainerOfType(typeof(Processes))
			if (prcs != null) {
				Scopes::scopeFor( a.parameters , scope_Reference_reference(prcs,r) )
			} else {
				IScope::NULLSCOPE
			}
		}
	}

	def scope_AttributeDeclaration( GlobalContext a , EReference r ) {
		var env = a.getContainerOfType(typeof(Environment))
		if (env != null) { //This is an access to the global store performed in the environment
			if (env.store != null) {
				Scopes::scopeFor( env.store.attributes )
			} else {
				IScope::NULLSCOPE
			}
		} else {
			var mes = a.getContainerOfType(typeof(MeasureDefinition))
			if (mes != null) {//This is an access to the global store performed in a measure
				Scopes::scopeFor( a.getContainerOfType(typeof(Model)).globalAttributes)			
			} else {
				IScope::NULLSCOPE			
			}
		}
	}

	def scope_AttributeDeclaration( SenderContext a , EReference r ) {
		var env = a.getContainerOfType(typeof(Environment))
		if (env != null) { 
			var model = env.getContainerOfType(typeof(Model))
			if (model != null) {
				Scopes::scopeFor( model.attributes )
			} else {
				IScope::NULLSCOPE
			}
		} else {
			IScope::NULLSCOPE			
		}
	}

	def scope_AttributeDeclaration( ReceiverContext a , EReference r ) {
		var env = a.getContainerOfType(typeof(Environment))
		if (env != null) { 
			var model = env.getContainerOfType(typeof(Model))
			if (model != null) {
				Scopes::scopeFor( model.attributes )
			} else {
				IScope::NULLSCOPE
			}
		} else {
			IScope::NULLSCOPE			
		}
	}

	def scope_FieldDefinition( TargetAssignmentField record , EReference r ) {
		if (record.target == null) {
			IScope::NULLSCOPE
		} else {
			var type = record.target.typeOf
			if (type.isRecord) {
				Scopes::scopeFor( type.asRecord.getReference.fields )
			} else {
				IScope::NULLSCOPE					
			}
		}
	}

	def scope_ReferenceableElement( FieldAccess record , EReference r ) {
		if (record.source==null) {
			IScope::NULLSCOPE
		} else {
			var type = record.source.typeOf
			if (type.isRecord) {
				Scopes::scopeFor( type.asRecord.getReference.fields )
			} else {
				if (type.isLocation) {
					var m = record.getContainerOfType(typeof(Model))
					Scopes::scopeFor( m ?. getLabelsAndFeatures	?: newLinkedList() )			
				} else {
					IScope::NULLSCOPE
				}
			}
		}
	}
	

//	def scope_Reference_reference( Element e , EReference r) {
//		e.referenceableElementScopeForElement
//	}
	
	def scope_FieldAssignment_field( AtomicRecord record , EReference r ) {
		var model = record.getContainerOfType(typeof(Model))
		if (model != null) {
			Scopes::scopeFor( model.fields )
		} else {
			IScope::NULLSCOPE
		}
	}
	
	def scope_StoreAttribute_reference( Processes p , EReference r ) {
		var model = p.getContainerOfType(typeof(Model)) 
		if (model != null) {
			Scopes::scopeFor( model.attributes )
		} else {
			IScope::NULLSCOPE
		}		
	}
	

	def scope_ProcessExpressionReference_expression( Processes p ,EReference r ) {
		Scopes::scopeFor( p.processes )
	}

	def scope_ProcessReference_expression( AllComponents all ,EReference r ) {
		var model = all.getContainerOfType(typeof(Model))
		Scopes::scopeFor(model.allProcesses)
	}

	def scope_ProcessReference_expression( AComponentAState acas ,EReference r ) {
		var model = acas.getContainerOfType(typeof(Model))
		var procs = model.globalProcesses
		if (acas.comp != null) {
			procs = acas.comp.processes.processes+procs 
		} 
		Scopes::scopeFor(procs)
	}

	def scope_ProcessReference_expression( ComponentDefinition c ,EReference r ) {
		var outer = c.parameters.filter[ it.typeOf.process ]
		var processes = c.processes.processes 
		Scopes::scopeFor( processes , Scopes::scopeFor( outer ) )
	}

//	def dispatch getReferenceableElementScopeForElement( FunctionDefinition f ) {
//		if ( f != null ) {
//			Scopes::scopeFor( f.parameters , f.referenceableElements )
//		} else {
//			IScope::NULLSCOPE
//		}
//	}
//
//	def dispatch getReferenceableElementScopeForElement( ComponentDefinition c ) {
//		if ( c != null ) {
//			Scopes::scopeFor( c.parameters.filter[ !it.typeOf.process ] , c.referenceableElements )
//		} else {
//			IScope::NULLSCOPE
//		}
//	}
//	
//	def dispatch getReferenceableElementScopeForElement( MeasureDefinition m ) {
//		if ( m != null ) {
//			var parentScope = m.referenceableElements
//			var model = m.getContainerOfType(typeof(Model))
//			if (model != null) {
//				parentScope = Scopes::scopeFor( model.attributes , parentScope )
//			}			
//			Scopes::scopeFor( m.variables , parentScope )
//		} else {
//			IScope::NULLSCOPE
//		}
//	}
//
//	def dispatch getReferenceableElementScopeForElement( SystemDefinition m ) {
//		if ( m != null ) {
//			m.referenceableElements 
//		} else {
//			IScope::NULLSCOPE
//		}
//	}
	
	
	def Iterable<? extends ReferenceableElement> getGlobalReferenceableElementsProvided( Element e ) {
		switch e {
			FunctionDefinition:  newLinkedList( e )
			Processes: e.processes 
			ConstantDefinition: newLinkedList( e )			
			EnumDefinition: e.values
			SystemDefinition: e.environment ?. store ?. attributes ?: newLinkedList()
			MeasureDefinition: newLinkedList( e )
			default: newLinkedList()			
		}
	}
	
	def getGlobalReferenceableElements( Element e ) {
		var model = e.getContainerOfType(typeof(Model))
		if (model != null) {			
			model.elements.map[it.globalReferenceableElementsProvided].flatten
		} else {
			newLinkedList()
		}
	}
	
	def scope_ActionStub_activity( SystemDefinition sys ,EReference r ) {
		var model = sys.getContainerOfType(typeof(Model))
		if (model != null) {
			Scopes::scopeFor( model.activities )
		} else {
			IScope::NULLSCOPE
		}
	}

	def scope_Weight_activity( SystemDefinition sys ,EReference r ) {
		var model = sys.getContainerOfType(typeof(Model))
		if (model != null) {
			Scopes::scopeFor( model.activities )
		} else {
			IScope::NULLSCOPE
		}
	}

	def scope_Probability_activity( SystemDefinition sys ,EReference r ) {
		var model = sys.getContainerOfType(typeof(Model))
		if (model != null) {
			Scopes::scopeFor( model.activities )
		} else {
			IScope::NULLSCOPE
		}
	}
	
	def getContainerScope( EObject cbi ) {
		var forVariables = newLinkedList()
		var parent = cbi.getContainerOfType(typeof(ComponentBlockFor))
		while ( parent != null ) {
			if (parent instanceof ComponentBlockForStatement) {
				forVariables.add( parent.variable )
			}
			if (parent instanceof ComponentBlockIteratorStatement) {
				forVariables.add( parent.iteration)
			}
			parent = parent.eContainer ?. getContainerOfType(typeof(ComponentBlockForStatement))
		}
		var sys = cbi.getContainerOfType(typeof(SystemDefinition)) ?. globalReferenceableElements ?. filter[ 
			!( it instanceof AttributeDeclaration)
		] ?: cbi.getContainerOfType(typeof(CollectiveDefinition)) ?. globalReferenceableElements ?. filter[ 
			!( it instanceof AttributeDeclaration)
		] ?: newLinkedList()
		Scopes::scopeFor( forVariables , Scopes::scopeFor( sys ) )
	}
	
	def scope_Reference_reference( ComponentBlockInstantiation cbi , EReference r ) {
		var parentScope = cbi.containerScope
		var comp = cbi.name
		if (comp != null) {
			Scopes::scopeFor( comp.processes.processes , parentScope )
		} else {
			parentScope
		}
	}

	
	def scope_Reference_reference( ComponentBlockForStatement forBlock , EReference r ) {
		var parentScope = forBlock.containerScope
		Scopes::scopeFor( newLinkedList( forBlock.variable ) , parentScope )
	}
	
	def scope_Reference_reference( ComponentBlockIteratorStatement forBlock , EReference r ) {
		var parentScope = forBlock.containerScope
		Scopes::scopeFor( newLinkedList( forBlock.iteration ) , parentScope )
	}

}
