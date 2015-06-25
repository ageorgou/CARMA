package eu.quanticol.carma.core.typing

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.AttribParameter
import eu.quanticol.carma.core.carma.AttribVariableDeclaration
import eu.quanticol.carma.core.carma.CompParameters
import eu.quanticol.carma.core.carma.Component
import eu.quanticol.carma.core.carma.ComponentBlockForStatement
import eu.quanticol.carma.core.carma.ComponentLineForStatement
import eu.quanticol.carma.core.carma.EnvironmentOperation
import eu.quanticol.carma.core.carma.EnvironmentUpdate
import eu.quanticol.carma.core.carma.GlobalStoreBlock
import eu.quanticol.carma.core.carma.InputAction
import eu.quanticol.carma.core.carma.InputActionArguments
import eu.quanticol.carma.core.carma.Measure
import eu.quanticol.carma.core.carma.MeasureVariableDeclaration
import eu.quanticol.carma.core.carma.MethodDeclaration
import eu.quanticol.carma.core.carma.MethodDefinition
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.carma.Name
import eu.quanticol.carma.core.carma.Parameters
import eu.quanticol.carma.core.carma.Probability
import eu.quanticol.carma.core.carma.Process
import eu.quanticol.carma.core.carma.Rate
import eu.quanticol.carma.core.carma.RecordDefinition
import eu.quanticol.carma.core.carma.RecordReferenceGlobal
import eu.quanticol.carma.core.carma.RecordReferencePure
import eu.quanticol.carma.core.carma.RecordReferenceReceiver
import eu.quanticol.carma.core.carma.RecordReferenceSender
import eu.quanticol.carma.core.carma.SetComp
import eu.quanticol.carma.core.carma.StoreBlock
import eu.quanticol.carma.core.carma.StoreDeclaration
import eu.quanticol.carma.core.carma.StoreLine
import eu.quanticol.carma.core.carma.VariableReference
import eu.quanticol.carma.core.carma.VariableReferenceGlobal
import eu.quanticol.carma.core.carma.VariableReferencePure
import eu.quanticol.carma.core.carma.VariableReferenceReceiver
import eu.quanticol.carma.core.carma.VariableReferenceSender
import eu.quanticol.carma.core.generator.carmavariable.VariableReferenceTool
import eu.quanticol.carma.core.generator.carmavariable.VariableReferenceTypeSingleton
import eu.quanticol.carma.core.utils.LabelUtil
import eu.quanticol.carma.core.utils.Util
import java.util.ArrayList

import static extension org.eclipse.xtext.EcoreUtil2.*

class VariableTypeProvider {
	
	@Inject extension LabelUtil
	@Inject extension Util
	@Inject extension TypeProvider
	
	def void initialiseVariableReferenceTypeSingleton(Model model){
		for(variableReference : model.eAllOfType(VariableReference))
			variableReference.initialiseVariableReferenceTypeSingleton
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr){
		
		if(vr.getContainerOfType(MethodDefinition) != null){
		 	vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(MethodDefinition))
		}
		
		if(vr.getContainerOfType(RecordDefinition) != null){
		 	vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(RecordDefinition))
		}
		
		if(vr.getContainerOfType(StoreBlock) != null){
		 	vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(Component))
		}
		
		if(vr.getContainerOfType(StoreLine) != null){
		 	vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(Component))
		}
		
		if(vr.getContainerOfType(Process) != null){
		 	vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(Process))
		}
		
		if(vr.getContainerOfType(ComponentBlockForStatement) != null){
			vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(ComponentBlockForStatement))
		}
		
		if(vr.getContainerOfType(ComponentLineForStatement) != null){
			vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(ComponentLineForStatement))
		}
		
		//measure on its own
		if(vr.getContainerOfType(Measure) != null && vr.getContainerOfType(EnvironmentOperation) == null){
			vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(Measure))
		}
		
		//prob
		if(vr.getContainerOfType(Probability) != null){
			vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(EnvironmentOperation))
		}
		
		//rate
		if(vr.getContainerOfType(Rate) != null){
			vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(EnvironmentOperation))
		}
		
		//update
		if(vr.getContainerOfType(EnvironmentUpdate) != null){
			vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(EnvironmentOperation))
		}
		
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, MethodDefinition md){
		var fqn = vr.disarm
		var Name rootName 	= vr.rootName
		var parameters  	= md.eAllOfType(Parameters)
		var declarations	= md.eAllOfType(MethodDeclaration)
		
		for(p:parameters){
			if(rootName.sameName(p.name)){
				var type = p.type
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,p.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
		
		for(d:declarations){
			if(rootName.sameName(d.name)){
				var type = d.type
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,d.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
		
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, RecordDefinition rd){
		var fqn = vr.disarm
		var Name rootName 	= vr.rootName
		var parameters  	= rd.eAllOfType(AttribParameter)
		var declarations	= rd.eAllOfType(AttribVariableDeclaration)
		
		for(p:parameters){
			if(rootName.sameName(p.name)){
				var type = p.getBaseType
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,p.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
		
		for(d:declarations){
			if(rootName.sameName(d.name)){
				var type = d.getBaseType
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,d.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
		
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, Component c){
		var fqn = vr.disarm
		var Name rootName 	= vr.rootName
		var parameters  	= c.eAllOfType(CompParameters)
		var declarations	= c.eAllOfType(StoreDeclaration)
		
		for(p:parameters){
			if(rootName.sameName(p.name)){
				var type = p.type
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,p.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
		
		for(d:declarations){
			if(rootName.sameName(d.name)){
				var type = d.type
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,d.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, Process process){
		var processes = new ArrayList<Process>()
		
		//if an input argument, get sender processes
		if(vr.getContainerOfType(InputActionArguments) != null){
			var ia = vr.getContainerOfType(InputAction)
			var oas = ia.sender
			for(oa : oas){
				processes.add(oa.getContainerOfType(Process))
			}
		} else {
			processes.add(process)
		}
		
		//get all components that use this Process
		var components = new ArrayList<Component>()
		
		for(p:processes){
			components.addAll(p.components)
		}
		
		for(c:components){
			vr.initialiseVariableReferenceTypeSingleton(c)
		}
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, Measure measure){
		var fqn = vr.disarm
		var Name rootName 	= vr.rootName
		var declarations	= measure.eAllOfType(MeasureVariableDeclaration)
		
		for(d:declarations){
			if(rootName.sameName(d.name)){
				var type = d.getBaseType
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,d.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
		
		var components = new ArrayList<Component>()
		var envMacro = (measure.measure as SetComp).componentReference
		envMacro.getComponents(components)
		
		for(c:components){
			vr.initialiseVariableReferenceTypeSingleton(c)
		}
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, ComponentBlockForStatement cbfs){
		var fqn = vr.disarm
		var Name rootName 	= vr.rootName
		var declarations	= cbfs.eAllOfType(AttribVariableDeclaration)
		
		for(d:declarations){
			if(rootName.sameName(d.name)){
				var type = d.getBaseType
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,d.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
		
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, ComponentLineForStatement clfs){
		var fqn = vr.disarm
		var Name rootName 	= vr.rootName
		var declarations	= clfs.eAllOfType(AttribVariableDeclaration)

		for(d:declarations){
			if(rootName.sameName(d.name)){
				var type = d.getBaseType
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,d.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, EnvironmentOperation operation){
		var processes = new ArrayList<Process>()
		var components = new ArrayList<Component>()
		switch(vr){
			VariableReferencePure: 		{
				if(vr.getContainerOfType(Measure) != null){
					vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(Measure))
				} 
			}
			RecordReferencePure: 		{
				if(vr.getContainerOfType(Measure) != null){
					vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(Measure))
				}
			}
			VariableReferenceReceiver:	processes.addAll(operation.stub.getProcesses(false))
			RecordReferenceReceiver: 	processes.addAll(operation.stub.getProcesses(false))
			VariableReferenceSender: 	processes.addAll(operation.stub.getProcesses(true))
			RecordReferenceSender:		processes.addAll(operation.stub.getProcesses(true))
			VariableReferenceGlobal:	vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(Model).eAllOfType(GlobalStoreBlock).get(0))
			RecordReferenceGlobal:		vr.initialiseVariableReferenceTypeSingleton(vr.getContainerOfType(Model).eAllOfType(GlobalStoreBlock).get(0))
		}
		
		for(p:processes){
			components.addAll(p.components)
		}
		
		for(c:components){
			vr.initialiseVariableReferenceTypeSingleton(c)
		}

	}
	
	def void initialiseVariableReferenceTypeSingleton(VariableReference vr, GlobalStoreBlock gsb){
		var fqn = vr.disarm
		var Name rootName 	= vr.rootName
		var declarations	= gsb.eAllOfType(StoreDeclaration)
		
		for(d:declarations){
			if(rootName.sameName(d.name)){
				var type = d.type
				var VariableReferenceTool vrt = new VariableReferenceTool()
				vrt.add(fqn,d.name,type)
				VariableReferenceTypeSingleton.getInstance.setTool(vrt)
			}
		}
	}
	
}