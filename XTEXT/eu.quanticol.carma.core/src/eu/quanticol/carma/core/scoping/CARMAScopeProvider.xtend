/*
 * generated by Xtext
 */
package eu.quanticol.carma.core.scoping

import eu.quanticol.carma.core.carma.ComponentDefinition
import eu.quanticol.carma.core.carma.AttributeDeclaration
import static extension org.eclipse.xtext.EcoreUtil2.*
import org.eclipse.xtext.scoping.Scopes
import static extension eu.quanticol.carma.core.utils.Util.*
import org.eclipse.emf.ecore.EObject
import eu.quanticol.carma.core.carma.FunctionDefinition
import org.eclipse.emf.ecore.EReference
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.carma.RecordAccess
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

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#scoping
 * on how and when to use it 
 *
 */
class CARMAScopeProvider extends org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider {



	def scope_Reference_reference( AttributeDeclaration a , EReference r) {
		var parentScope = a.getContainerOfType(typeof(Element)).referenceableElementScopeForElement
		var block = a.getContainerOfType(typeof(StoreBlock))
		if (block != null) {
			var idx = block.attributes.indexOf(a)
			if (idx > 0) {
				Scopes::scopeFor( block.attributes.subList(0,idx) , parentScope )
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
			var parentScope = comp.referenceableElementScopeForElement
			if (comp.store != null) {
				Scopes::scopeFor( comp.store.attributes , parentScope )
			} else {
				parentScope
			}			
		} else {
			IScope::NULLSCOPE		
		}
	}

	def scope_Reference_reference( Processes a , EReference r) {
		var m = a.getContainerOfType(typeof(Model))
		if (m != null) {
			var parentScope = a.referenceableElementScopeForElement
			Scopes::scopeFor( m.attributes , parentScope )
		} else {
			IScope::NULLSCOPE		
		}
	}
	
	def scope_Reference_reference( MyContext a , EReference r ) {
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

	def scope_Reference_reference( GlobalContext a , EReference r ) {
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

	def scope_Reference_reference( SenderContext a , EReference r ) {
		var env = a.getContainerOfType(typeof(Environment))
		if (env != null) { //This is an access to the global store performed in the environment
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

	def scope_Reference_reference( ReceiverContext a , EReference r ) {
		var env = a.getContainerOfType(typeof(Environment))
		if (env != null) { //This is an access to the global store performed in the environment
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

	def scope_FieldDefinition( RecordAccess record , EReference r ) {
		if (record.source==null) {
			IScope::NULLSCOPE
		} else {
			var type = record.source.typeOf
			if (type.isRecord) {
				Scopes::scopeFor( (type.reference as RecordDefinition).fields )
			} else {
				IScope::NULLSCOPE
			}
		}
	}

	def scope_Reference_reference( Element e , EReference r) {
		e.referenceableElementScopeForElement
	}
	
	def scope_FieldAssignment_field( AtomicRecord record , EReference r ) {
		var model = record.getContainerOfType(typeof(Model))
		if (model != null) {
			Scopes::scopeFor( model.fields )
		} else {
			IScope::NULLSCOPE
		}
	}
	
	def scope_UpdateAssignment_reference( Processes p , EReference r ) {
		var model = p.getContainerOfType(typeof(Model)) 
		if (model != null) {
			Scopes::scopeFor( model.attributes )
		} else {
			IScope::NULLSCOPE
		}		
	}
	
	def scope_ProcessReference_expression( Processes p ,EReference r ) {
		Scopes::scopeFor( p.processes )
	}

	def scope_ProcessReference_expression( ComponentDefinition c ,EReference r ) {
		Scopes::scopeFor( c.processes.processes , Scopes::scopeFor( c.parameters.filter[ it.typeOf.process ]) )
	}

	def dispatch getReferenceableElementScopeForElement( FunctionDefinition f ) {
		if ( f != null ) {
			Scopes::scopeFor( f.parameters , f.referenceableElementsBefore )
		} else {
			IScope::NULLSCOPE
		}
	}

	def dispatch getReferenceableElementScopeForElement( ComponentDefinition c ) {
		if ( c != null ) {
			Scopes::scopeFor( c.parameters.filter[ !it.typeOf.process ] , c.referenceableElementsBefore )
		} else {
			IScope::NULLSCOPE
		}
	}
	
	def dispatch getReferenceableElementScopeForElement( MeasureDefinition m ) {
		if ( m != null ) {
			var parentScope = m.referenceableElementsBefore
			var model = m.getContainerOfType(typeof(Model))
			if (model != null) {
				parentScope = Scopes::scopeFor( model.attributes , parentScope )
			}			
			if (m.ranges != null) {
				Scopes::scopeFor( m.ranges.variables , parentScope )
			} else {
				parentScope
			}
		} else {
			IScope::NULLSCOPE
		}
	}
	
	
	def getReferenceableElementsBefore( Element e ) {
		var model = e.getContainerOfType(typeof(Model))
		if (model != null) {
			var idx = model.elements.indexOf(e)
			if (idx < 0) {
				IScope::NULLSCOPE
			} else {
				Scopes::scopeFor( model.elements.subList(0,idx) )
			}
		} else {
			IScope::NULLSCOPE
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

}
