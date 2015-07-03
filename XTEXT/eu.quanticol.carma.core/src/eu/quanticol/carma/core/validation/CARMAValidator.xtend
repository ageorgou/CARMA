/*
 * generated by Xtext
 */
package eu.quanticol.carma.core.validation

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.BooleanExpression
import eu.quanticol.carma.core.carma.CarmaPackage
import eu.quanticol.carma.core.carma.ComponentExpression
import eu.quanticol.carma.core.carma.EnvironmentProbExpression
import eu.quanticol.carma.core.carma.EnvironmentRateExpression
import eu.quanticol.carma.core.carma.EnvironmentUpdateExpression
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.carma.Process
import eu.quanticol.carma.core.carma.Processes
import eu.quanticol.carma.core.carma.ProcessesBlock
import eu.quanticol.carma.core.carma.UpdateExpression
import eu.quanticol.carma.core.carma.VariableName
import eu.quanticol.carma.core.typing.TypeProvider
import eu.quanticol.carma.core.utils.Util
import java.util.ArrayList
import org.eclipse.xtext.validation.Check

import static extension org.eclipse.xtext.EcoreUtil2.*
import eu.quanticol.carma.core.carma.ProcessName
import eu.quanticol.carma.core.carma.StoreBlock
import eu.quanticol.carma.core.carma.FunctionExpression
import eu.quanticol.carma.core.carma.FunctionName
import eu.quanticol.carma.core.carma.FunctionDefinition
import eu.quanticol.carma.core.carma.Functions

class CARMAValidator extends AbstractCARMAValidator {
	
	@Inject extension TypeProvider
	@Inject extension Util
	
	//VariableName - must have same type everywhere
	public static val ERROR_VariableName_unique_type 	= "ERROR_VariableName_unique_type"
	@Check
	def check_ERROR_VariableName_type(VariableName variableName){
		var test = true
		var message = "Error: Variable must be of the same type across the whole model."
		var type 	= variableName.type
		var names 	= variableName.getContainerOfType(Model).eAllOfType(VariableName)
		
		for(vn : names)
			if(variableName.sameName(vn)){
				test = test && type.sameType(vn.type)
			}

		if(!test){
			error(message,CarmaPackage::eINSTANCE.name_Name,ERROR_VariableName_unique_type)
		}
	}
	
	var public static ERROR_BooleanExpression_type 				= "ERROR_BooleanExpression_type"
	var public static ERROR_UpdateExpression_type 				= "ERROR_UpdateExpression_type"
	var public static ERROR_MethodExpression_type 				= "ERROR_MethodExpression_type"
	var public static ERROR_EnvironmentProbExpression_type 		= "ERROR_EnvironmentProbExpression_type"
	var public static ERROR_EnvironmentRateExpression_type 		= "ERROR_EnvironmentRateExpression_type"
	var public static ERROR_EnvironmentUpdateExpression_type 	= "ERROR_EnvironmentUpdateExpression_type"
	var public static ERROR_ComponentExpression_type 			= "ERROR_ComponentExpression_type"
	
	@Check
	def check_ERROR_expression_type(BooleanExpression expression){
		var test = true
		var message = "Error: must be of Boolean type."
		test = expression.type.isLogical
		if(!test){
			error(message,CarmaPackage::eINSTANCE.booleanExpression_Expression,ERROR_BooleanExpression_type)
		}
	}
	
	@Check
	def check_ERROR_expression_type(UpdateExpression expression){
		var test = true
		var message = "Error: this must evaluate to a natural number (attribute assignment)."
		test = expression.type.isArith
		if(!test){
			error(message,CarmaPackage::eINSTANCE.updateExpression_Expression,ERROR_UpdateExpression_type)
		}
	}
	
	@Check
	def check_ERROR_expression_type(FunctionExpression expression){
		var test = true
		var message = "Error: this must evaluate to a number."
		test = expression.type.isArith
		//TODO
		if(!test){
			error(message,CarmaPackage::eINSTANCE.functionExpression_Expression,ERROR_MethodExpression_type)
		}
	}
	
	@Check
	def check_ERROR_expression_type(EnvironmentProbExpression expression){
		var test = true
		var message = "Error: this must evaluate to a number between 0.0 and 1.0."
		//TODO
		if(!test){
			error(message,CarmaPackage::eINSTANCE.environmentProbExpression_Expression,ERROR_EnvironmentProbExpression_type)
		}
	}

	@Check
	def check_ERROR_expression_type(EnvironmentRateExpression expression){
		var test = true
		var message = "Error: this must evaluate to a real number (rate assignment)."
		//TODO
		if(!test){
			error(message,CarmaPackage::eINSTANCE.environmentRateExpression_Expression,ERROR_EnvironmentRateExpression_type)
		}
	}
	
	@Check
	def check_ERROR_expression_type(EnvironmentUpdateExpression expression){
		var test = true
		var message = "Error: this must evaluate to a natural number (attribute assignment)."
		//TODO
		if(!test){
			error(message,CarmaPackage::eINSTANCE.environmentUpdate_Expression,ERROR_EnvironmentUpdateExpression_type)
		}
	}
	
	@Check
	def check_ERROR_expression_type(ComponentExpression expression){
		var test = true
		var message = "Error: this must evaluate to an integer."
		//TODO
		if(!test){
			error(message,CarmaPackage::eINSTANCE.componentExpression_Expression,ERROR_ComponentExpression_type)
		}
	}
	
	public static val ERROR_Process_name_unique = "ERROR: Processes must have unique names."
	@Check
	def check_ERROR_ProcessBlock_name_unique(Process p){
		var String message = "ERROR: processes must have unique names."
		
		var pb = p.getContainerOfType(ProcessesBlock)
		var pl = p.getContainerOfType(Processes)
		
		var ArrayList<String> names = new ArrayList<String>
		
		if(pb != null)
			for(n : pb.eAllOfType(ProcessName))
				names.add(n.name)
		if(pl != null)
			for(n : pl.eAllOfType(ProcessName))
				names.add(n.name)
			
		names.remove(p.name.name)
		
		var boolean test = names.contains(p.name.name)
		
		if(test){
			error( message ,
					CarmaPackage::eINSTANCE.process_Name,
					ERROR_Process_name_unique
			)
		}
	}
	
	public static val ERROR_VariableDeclaration_Store_name_unique = "ERROR: Attributes must have unique names."
	@Check
	def check_ERROR_VariableDeclaration_Store_name_unique(VariableName variableName){
		var String message = "ERROR: Attributes must have unique names."
		
		var sb = variableName.getContainerOfType(StoreBlock)
		//var sl = variableName.getContainerOfType(StoreLine)
		
		var ArrayList<String> names = new ArrayList<String>
		
		if(sb != null)
			for(n : sb.eAllOfType(VariableName))
				names.add(n.name)
//		else
//			for(n : sl.eAllOfType(VariableName))
//				names.add(n.label)
			
		names.remove(variableName.name)
		var boolean test = names.contains(variableName.name)
		
		if(test){
			error( message ,
					CarmaPackage::eINSTANCE.name_Name,
					ERROR_VariableDeclaration_Store_name_unique
			)
		}
	}
	
	public static val ERROR_MethodDefinition_name_unique = "ERROR: Functions must have a unique name."
	@Check
	def check_ERROR_MethodDefinition_name_unique(FunctionDefinition md){
		var String message = "ERROR: Functions must have a unique name."
		var ms = md.getContainerOfType(Functions)
		
		
		var ArrayList<String> names = new ArrayList<String>
		
		for(n : ms.eAllOfType(FunctionName))
			names.add(n.name)
			
		names.remove(md.name)
		
		var boolean test = names.contains(md.name)
		
		if(test){
			error( message ,
					CarmaPackage::eINSTANCE.functionDefinition_Name,
					ERROR_MethodDefinition_name_unique
			)
		}
	}
	

//	public static val ERROR_VariableReference_ProcessExpression_type = "ERROR: '"
//	@Check
//	def check_ERROR_VariableReference_ProcessExpression_type(VariableReference vr){
//		if(vr.getContainerOfType(ProcessExpression) != null){
//			var message = ERROR_VariableReference_ProcessExpression_type + vr.label + "' has no type found in owning Component, or sending/receiving Component."
//			var test = true
//		
//			test = vr.type.toString.equals("null")
//		
//			if(test){
//				error(message,CarmaPackage::eINSTANCE.variableReference_Name,ERROR_VariableReference_ProcessExpression_type)
//			}
//		}
//	}
//	
//	public static val ERROR_VariableReference_VariableReference_type = "ERROR: '"
//	@Check
//	def check_ERROR_VariableReference_VariableReference_type(VariableReference vr){
//		if(vr.getContainerOfType(Environment) != null){
//			var message = ERROR_VariableReference_VariableReference_type + vr.label + "' has no type. Cannot find variable in Environment, or related Components."
//			var test = true
//		
//			test = vr.type.toString.equals("null")
//		
//			if(test){
//				error(message,CarmaPackage::eINSTANCE.variableReference_Name,ERROR_VariableReference_VariableReference_type)
//			}
//		}
//	}
//
//	public static val ERROR_VariableReference_ComponentBlockForStatement_ComponentLineForStatement_type = "ERROR: '"
//	@Check
//	def check_ERROR_VariableReference_ComponentBlockForStatement_ComponentLineForStatement_type(VariableReference vr){
//		if(vr.getContainerOfType(ComponentBlockForStatement) != null || vr.getContainerOfType(ComponentLineForStatement) != null ){
//			var message = ERROR_VariableReference_ComponentBlockForStatement_ComponentLineForStatement_type + vr.label + "' has no type. Cannot find variable in For Statement."
//			var test = true
//		
//			test = vr.type.toString.equals("null")
//		
//			if(test){
//				error(message,CarmaPackage::eINSTANCE.variableReference_Name,ERROR_VariableReference_ComponentBlockForStatement_ComponentLineForStatement_type)
//			}
//		}
//	}
//	
//	public static val ERROR_VariableReference_MethodDefinition_type = "ERROR: '"
//	@Check
//	def check_ERROR_VariableReference_MethodDefinition_type(VariableReference vr){
//		if(vr.getContainerOfType(MethodDefinition) != null ){
//			var message = ERROR_VariableReference_MethodDefinition_type + vr.label + "' has no type. Cannot find variable in Method definition."
//			var test = true
//		
//			test = vr.type.toString.equals("null")
//		
//			if(test){
//				error(message,CarmaPackage::eINSTANCE.variableReference_Name,ERROR_VariableReference_MethodDefinition_type)
//			}
//		}
//	}
//	
//	public static val ERROR_VariableReference_Measure_type = "ERROR: '"
//	@Check
//	def check_ERROR_VariableReference_Measure_type(VariableReference vr){
//		if(vr.getContainerOfType(Measure) != null){
//			var message = ERROR_VariableReference_Measure_type + vr.label + "' has no type. Cannot find variable in Measure definition."
//			var test = true
//		
//			test = vr.type.toString.equals("null")
//		
//			if(test){
//				error(message,CarmaPackage::eINSTANCE.variableReference_Name,ERROR_VariableReference_Measure_type)
//			}
//		}
//	}
//	
//	public static val ERROR_VariableReference_StoreBlock_type = "ERROR: '"
//	@Check
//	def check_ERROR_VariableReference_StoreBlock_type(VariableReference vr){
//		if(vr.getContainerOfType(StoreBlock) != null){
//			var message = ERROR_VariableReference_StoreBlock_type + vr.label + "' has no type. Cannot find variable in Component block arguments."
//			var test = true
//		
//			test = vr.type.toString.equals("null")
//		
//			if(test){
//				error(message,CarmaPackage::eINSTANCE.variableReference_Name,ERROR_VariableReference_StoreBlock_type)
//			}
//		}
//	}
//
//	public static val ERROR_VariableName_InputArgument_ref = "ERROR: no matching argument at output action."
//	@Check
//	def check_ERROR_VariableName_InputArgument_ref(VariableName vn){
//		if(vn.getContainerOfType(InputActionArguments) != null){
//			if(vn.type.toString.equals("null")){
//				error(ERROR_VariableName_InputArgument_ref,CarmaPackage::eINSTANCE.variableName_Name,ERROR_VariableName_InputArgument_ref)
//			}
//		}
//	}
//	
//	public static val WARN_VariableName_InputArgument_unused = "ERROR: argument unused."
//	@Check
//	def check_WARN_VariableName_InputArgument_unused(VariableName vn){
//		if(vn.getContainerOfType(InputActionArguments) != null){
//			var test = false
//			var vrs = vn.getContainerOfType(Action).eAllOfType(VariableReference)
//			for (vr : vrs){
//				test = test || vr.name.sameName(vn)
//			}
//			
//			if(!test){
//				warning(WARN_VariableName_InputArgument_unused,CarmaPackage::eINSTANCE.variableName_Name,WARN_VariableName_InputArgument_unused)
//			}
//		}
//	}
//
//	
//	public static val ERROR_Process_name_unique = "ERROR: Processes must have unique names."
//	/**
//	 * Process
//	 * <p>
//	 * ERROR_Process_name_unique
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_ProcessBlock_name_unique(Process p){
//		var String message = "ERROR: processes must have unique names."
//		
//		var pb = p.getContainerOfType(ProcessesBlock)
//		var pl = p.getContainerOfType(Processes)
//		
//		var ArrayList<String> names = new ArrayList<String>
//		
//		if(pb != null)
//			for(n : pb.getNames)
//				names.add(n.label)
//		else
//			for(n : pl.getNames)
//				names.add(n.label)
//			
//		names.remove(p.name.label)
//		
//		var boolean test = names.contains(p.name.label)
//		
//		if(test){
//			error( message ,
//					CarmaPackage::eINSTANCE.process_Name,
//					ERROR_Process_name_unique
//			)
//		}
//	}
//	
//	public static val ERROR_VariableDeclaration_Store_name_unique = "ERROR: Attributes must have unique names."
//	/**
//	 * VariableDeclaration
//	 * <p>
//	 * ERROR_VariableDeclaration_name_unique
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_VariableDeclaration_Store_name_unique(VariableDeclaration vd){
//		var String message = "ERROR: Attributes must have unique names."
//		
//		var sb = vd.getContainerOfType(StoreBlock)
//		var sl = vd.getContainerOfType(StoreLine)
//		
//		var ArrayList<String> names = new ArrayList<String>
//		
//		if(sb != null)
//			for(n : sb.getNames)
//				names.add(n.label)
//		else
//			for(n : sl.getNames)
//				names.add(n.label)
//			
//		names.remove(vd.name.label)
//		var boolean test = names.contains(vd.name.label)
//		
//		if(test){
//			error( message ,
//					CarmaPackage::eINSTANCE.variableDeclaration_Name,
//					ERROR_VariableDeclaration_Store_name_unique
//			)
//		}
//	}
//	
//	public static val ERROR_VariableDeclaration_Store_enum_or_record = "ERROR: Attributes can only be of type enum or record."
//	/**
//	 * VariableDeclaration
//	 * <p>
//	 * ERROR_VariableDeclaration_Store_enum_or_record
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_VariableDeclaration_Store_enum_or_record(VariableDeclaration vd){
//		var String message = "ERROR: Attributes can only be of type enum or record."
//		var boolean test = true
//		var sb = vd.getContainerOfType(StoreBlock)
//		var sl  = vd.getContainerOfType(StoreLine)
//		
//		
//		if(sb != null || sl != null)
//			test = (vd.type.equals("enum") || vd.type.equals("record"))
//		
//		if(!test){
//			error( message ,
//					CarmaPackage::eINSTANCE.variableDeclaration_Type,
//					ERROR_VariableDeclaration_Store_name_unique
//			)
//		}
//	}
//	
//	public static val ERROR_MethodDefinition_name_unique = "ERROR: Functions must have a unique name."
//	/**
//	 * MethodDefinition
//	 * <p>
//	 * ERROR_MethodDefinition_name_unique
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_MethodDefinition_name_unique(MethodDefinition md){
//		var String message = "ERROR: Functions must have a unique name."
//		var ms = md.getContainerOfType(Methods)
//		
//		
//		var ArrayList<String> names = new ArrayList<String>
//		
//		for(n : ms.getNames)
//			names.add(n.label)
//			
//		names.remove(md.name.label)
//		
//		var boolean test = names.contains(md.name.label)
//		
//		if(test){
//			error( message ,
//					CarmaPackage::eINSTANCE.methodDefinition_Name,
//					ERROR_MethodDefinition_name_unique
//			)
//		}
//	}
//	
//	public static val ERROR_VariableDeclaration_InputActionArguments_notStore = "ERROR: Input arguments cannot have the same name as a Store attribute."
//	/**
//	 * VariableDeclaration
//	 * <p>
//	 * ERROR_VariableDeclaration_Store_enum_or_record
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_VariableDeclaration_InputActionArguments_notStore(VariableName vn){
//		var String message = ERROR_VariableDeclaration_InputActionArguments_notStore
//		var boolean test = false
//		var ia 	= vn.getContainerOfType(InputAction)
//		
//		if(ia != null){
//			var cad = vn.getContainerOfType(Process).getComponentAndDeclarations
//			for(key : cad.keySet)
//				for(dec : cad.get(key))
//					test = test || dec.name.sameName(vn)
//					
//			if(vn.getContainerOfType(ComponentBlockDefinition) != null){
//				for(vt : vn.getContainerOfType(ComponentBlockDefinition).eAllOfType(VariableType))
//					test = test || vt.name.sameName(vn)
//			}
//		}
//		
//		if(test){
//			error( message ,
//					CarmaPackage::eINSTANCE.variableName_Name,
//					ERROR_VariableDeclaration_InputActionArguments_notStore
//			)
//		}
//	}
//	
//	public static val ERROR_ActionStub_reference = "ERROR: This must reference a declared action."
//	/**
//	 * ActionStub
//	 * <p>
//	 * ERROR_ActionStub_reference
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	 @Check
//	 def check_ERROR_ActionStub_reference(ActionStub actionStub){
//	 	var String message = ERROR_ActionStub_reference
//	 	var boolean test = false
//	 	
//	 	for(action : actionStub.getContainerOfType(Model).eAllOfType(ActionName)){
//	 		test = test || actionStub.label.equals(action.labelFull)
//	 	}
//	 	
//	 	if(!test){
//			error( message ,
//					CarmaPackage::eINSTANCE.actionStub_Name,
//					ERROR_ActionStub_reference
//			)
//		}
//	 	
//	 }
//	 
//	public static val ERROR_VariableDeclaration_type = "ERROR: Variables must have the same type across the model."
//	/**
//	 * VariableDeclaration
//	 * <p>
//	 * ERROR_VariableDeclaration_type
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_VariableDeclaration_type(VariableDeclaration vd){
//	 	var String message = ERROR_VariableDeclaration_type
//	 	var boolean test = !vd.sameType
//	 	
//	 	if(test){
//			error( message ,
//					CarmaPackage::eINSTANCE.variableDeclaration_Type,
//					ERROR_VariableDeclaration_type
//			)
//		}
//	}
//	
//	public static val ERROR_VariableType_type = "ERROR: Variables must have the same type across the model."
//	/**
//	 * VariableType
//	 * <p>
//	 * ERROR_VariableType_type
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_VariableDeclaration_type(VariableType vt){
//	 	var String message = ERROR_VariableDeclaration_type
//	 	var boolean test = !vt.sameType
//	 	
//	 	if(test){
//			error( message ,
//					CarmaPackage::eINSTANCE.variableType_Type,
//					ERROR_VariableType_type
//			)
//		}
//	}
//	
//	public static val ERROR_RecordDeclarations_Ref = "ERROR: Must reference a variable inside this component."
//	/**
//	 * RecordDeclarations
//	 * <p>
//	 * ERROR_RecordDeclarations_Ref
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_RecordDeclarations_Ref(RecordDeclarations rds){
//	 	var String message = ERROR_RecordDeclarations_Ref
//	 	var boolean test = true
//	 	
//	 	
//	 	if(rds.ref != null){
//	 		var name = rds.ref
//	 		if(rds.getContainerOfType(StoreBlock) != null){
//	 			
//	 			test = false
//	 			
//	 			var ArrayList<VariableType> vts = new ArrayList<VariableType>(rds.getContainerOfType(ComponentBlockDefinition).eAllOfType(VariableType))
//	 			var ArrayList<VariableDeclaration> vds = new ArrayList<VariableDeclaration>(rds.getContainerOfType(ComponentBlockDefinition).eAllOfType(VariableDeclaration))
//	 			
//	 			for(vt : vts){
//	 				test = test || vt.name.sameName(name)
//	 			}
//	 			
//	 			for(vd : vds){
//	 				test = test || vd.name.sameName(name)
//	 			}
//	 			
//	 		}
//	 		
//	 	}
//	 	
//	 	if(!test){
//			error( message ,
//					CarmaPackage::eINSTANCE.recordDeclarations_Ref,
//					ERROR_RecordDeclarations_Ref
//			)
//		}
//	}
//	
//	
//	public static val WARN_ComponentBlockDefinition_unused = "WARN: This component has not been declared in a collective or environment."
//	/**
//	 * ComponentBlockDefinition
//	 * <p>
//	 * WARN_ComponentBlockDefinition_unused
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_WARN_ComponentBlockDefinition_unused(ComponentBlockDefinition cbd){
//		var String message = WARN_ComponentBlockDefinition_unused
//		var boolean test = !(cbd.getComponentBlockDeclarations.size > 0)
//		
//		if(test){
//			warning( message ,
//					CarmaPackage::eINSTANCE.componentBlockDefinition_Name,
//					WARN_ComponentBlockDefinition_unused
//			)
//		}
//	}
//
//	public static val ERROR_MacroExpressionReference_noAccess = "ERROR: No access to this process."
//	/**
//	 * MacroExpressionReference
//	 * <p>
//	 * ERROR_MacroExpressionReference
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_MacroExpressionReference_noAccess(MacroExpressionReference mer){
//		var String message = ERROR_MacroExpressionReference_noAccess
//		var boolean test = true
//		
//		if(mer.getContainerOfType(ComponentBlockDefinition) != null){
//			//get process names
//			//get argument names
//			for(pn : mer.getContainerOfType(ComponentBlockDefinition).eAllOfType(ProcessName)){
//				if(pn.getContainerOfType(ProcessesBlock) != null)
//					test = test && !pn.sameName((mer.name as MacroName).name)
//			}
//			for(mt : mer.getContainerOfType(ComponentBlockDefinition).eAllOfType(MacroType)){
//				for(pn : mt.eAllOfType(ProcessName)){
//					test = test && !pn.sameName((mer.name as MacroName).name)
//				}
//			}
//			
//		} 
//		
//		if(mer.getContainerOfType(CBND) != null){
//			
//			for(pn : mer.getContainerOfType(CBND).component.eAllOfType(ProcessName)){
//				if(pn.getContainerOfType(ProcessesBlock) != null){
//					test = test && !pn.sameName((mer.name as MacroName).name)
//				}
//			}
//			
//			for(processes : mer.getContainerOfType(Model).eAllOfType(Processes))
//				for(pn : processes.eAllOfType(ProcessName))
//					test = test && !pn.sameName((mer.name as MacroName).name)
//		}
//		
//		if(mer.getContainerOfType(EnvironmentMacroExpressionComponentAllStates) != null){
//			var component = mer.getContainerOfType(EnvironmentMacroExpressionComponentAllStates).comp.getContainerOfType(ComponentBlockDefinition)
//			for(pn : component.eAllOfType(ProcessName)){
//				if(pn.getContainerOfType(ProcessesBlock) != null)
//					test = test && !pn.sameName((mer.name as MacroName).name)
//			}
//			for(mt : component.eAllOfType(MacroType)){
//				for(pn : mt.eAllOfType(ProcessName)){
//					test = test && !pn.sameName((mer.name as MacroName).name)
//				}
//			}
//		} 
//		
//		if(mer.getContainerOfType(EnvironmentMacroExpressionComponentAState) != null){
//			var component = mer.getContainerOfType(EnvironmentMacroExpressionComponentAllStates).comp.getContainerOfType(ComponentBlockDefinition)
//			for(pn : component.eAllOfType(ProcessName)){
//				if(pn.getContainerOfType(ProcessesBlock) != null)
//					test = test && !pn.sameName((mer.name as MacroName).name)
//			}
//			for(mt : component.eAllOfType(MacroType)){
//				for(pn : mt.eAllOfType(ProcessName)){
//					test = test && !pn.sameName((mer.name as MacroName).name)
//				}
//			}	
//		}
//		
//		if(test){
//			error( message ,
//					CarmaPackage::eINSTANCE.macroExpressionReference_Name,
//					ERROR_MacroExpressionReference_noAccess
//			)
//		}
//	}
//	
//	public static val ERROR_ActionName_type_unique = "ERROR: Action names must be unique across the types of action (Spontaneous, Multicast, or Unicast)."
//	/**
//	 * ActionName
//	 * <p>
//	 * ERROR_ActionName_type_unique
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_ActionName_type_unique(ActionName actionName){
//		var String message = ERROR_ActionName_type_unique
//		var test = true
//		var actionType = actionName.type
//		
//		for(an : actionName.getContainerOfType(Model).eAllOfType(ActionName)){
//			if(actionName.sameName(an)){
//				test = test && an.type.toString.equals(actionType.toString)
//			}
//			
//		}
//		
//		if(!test){
//			error( message ,
//					CarmaPackage::eINSTANCE.actionName_Name,
//					ERROR_ActionName_type_unique
//			)
//		}
//	}
//	
//	public static val ERROR_CBND_reference = "ERROR: Component not found in this model."
//	/**
//	 * CBND
//	 * <p>
//	 * ERROR_CBND_reference = "ERROR: Component not found in this model."
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_CBND_reference(CBND cbnd){
//		var String message = ERROR_CBND_reference
//		
//		if(!cbnd.getContainerOfType(Model).isNameInModel(cbnd.name)){
//			error( message ,
//					CarmaPackage::eINSTANCE.CBND_Name,
//					ERROR_CBND_reference
//			)
//		}
//	}
//	
//	public static val ERROR_CBND_matching = "ERROR: Component with matching arguments not found in this model."
//	/**
//	 * CBND
//	 * <p>
//	 * ERROR_CBND_matching = "ERROR: Component with matching arguments not found in this model."
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_CBND_matching(CBND cbnd){
//		var boolean test = true
//		var String message = ERROR_CBND_matching
//		
//		if(cbnd.getContainerOfType(Model).isNameInModel(cbnd.name)){
//			test = cbnd.hasMatchingArguments
//		}
//		
//		if(!test){
//			error( message ,
//					CarmaPackage::eINSTANCE.CBND_Name,
//					ERROR_CBND_matching
//			)
//		}
//	}
//	
//	public static val WARN_ComponentBlockDefinition_matching = "WARN: This Component is never declared."
//	/**
//	 * ComponentBlockDefinition
//	 * <p>
//	 * WARN_ComponentBlockDefinition_matching = "WARN: This component is never declared."
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_WARN_ComponentBlockDefinition_matching(ComponentBlockDefinition cbd){
//		var String message = WARN_ComponentBlockDefinition_matching
//		
//		if(cbd.getComponentToCBNDs.size == 0){
//			warning( message ,
//					CarmaPackage::eINSTANCE.componentBlockDefinition_Name,
//					WARN_ComponentBlockDefinition_matching
//			)
//		}
//	}
//	
//	
//	public static val ERROR_VariableReference_declared_type = "Error: VariableReference does not match declared type."
//	/**
//	 * VariableReference
//	 * <p>
//	 * ERROR_VariableReference_declared_type
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_VariableReference_declared_type(VariableReference vr){
//		var String message = ERROR_VariableReference_declared_type
//		var test = true
//		
//		if(vr.getContainerOfType(VariableDeclaration) != null){
//			if(vr.getContainerOfType(RecordDeclaration) != null){
//				test = vr.type.toString.equals("enum")
//			} else {
//				test = vr.getContainerOfType(VariableDeclaration).type.toString.equals(vr.type.toString)
//			}
//			
//		}
//			
//		if(!test){
//			error( message ,
//					CarmaPackage::eINSTANCE.variableReference_Name,
//					ERROR_VariableReference_declared_type
//			)
//		}
//	}
//	
//	public static val ERROR_ProcessExpressionGuard_following_action = "Error: Guards must be immediately followed by an Action."
//	/**
//	 * ProcessExpressionGuard
//	 * <p>
//	 * ERROR_ProcessExpressionGuard_following_action
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_ProcessExpressionGuard_following_action(ProcessExpressionGuard peg){
//		var String message = ERROR_ProcessExpressionGuard_following_action
//		var test = true
//		
//		switch(peg.reference){
//			ProcessExpressionAction: {test = false}
//			default: {test = true}
//		}
//		
//		if(test){
//			error( message ,
//					CarmaPackage::eINSTANCE.processExpressionGuard_Reference,
//					ERROR_ProcessExpressionGuard_following_action
//			)
//		}
//	}
//	
//	public static val ERROR_Rate_Unique = "Error: Rate assignment must be unique."
//	/**
//	 * Rate
//	 * <p>
//	 * ERROR_Rate_Unique
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_Rate_Unique(Rate rate){
//		var String message = ERROR_Rate_Unique
//		
//		var rates = new ArrayList<Rate>(rate.getContainerOfType(RateBlock).eAllOfType(Rate))
//		var ratesString = new ArrayList<String>()
//
//		
//
//		for(r : rates){
//			ratesString.add(r.getLabel)
//		}
//		
//		ratesString.remove(rate.getLabel)
//		
//		if(ratesString.remove(rate.getLabel)){
//			error( message ,
//					CarmaPackage::eINSTANCE.rate_Expression,
//					ERROR_Rate_Unique
//			)
//		}
//	}
//	
//	public static val ERROR_EnvironmentUpdate_Unique = "Error: Environment update assignment must be unique."
//	/**
//	 * Rate
//	 * <p>
//	 * ERROR_Rate_Unique
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_EnvironmentUpdate_Unique(EnvironmentUpdate eu){
//		var String message = ERROR_EnvironmentUpdate_Unique
//		
//		var environmentUpdates = new ArrayList<EnvironmentUpdate>(eu.getContainerOfType(UpdateBlock).eAllOfType(EnvironmentUpdate))
//		var environmentUpdateString = new ArrayList<String>()
//
//		
//
//		for(e : environmentUpdates){
//			environmentUpdateString.add(e.getLabel)
//		}
//		
//		environmentUpdateString.remove(eu.getLabel)
//		
//		if(environmentUpdateString.remove(eu.getLabel)){
//			error( message ,
//					CarmaPackage::eINSTANCE.environmentUpdate_Expression,
//					ERROR_EnvironmentUpdate_Unique
//			)
//		}
//	}
//	
//	public static val ERROR_Probability_Unique = "Error: Environment probability assignment must be unique."
//	/**
//	 * Rate
//	 * <p>
//	 * ERROR_Rate_Unique
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_Probability_Unique(Probability eu){
//		var String message = ERROR_EnvironmentUpdate_Unique
//		
//		var environmentUpdates = new ArrayList<Probability>(eu.getContainerOfType(ProbabilityBlock).eAllOfType(Probability))
//		var environmentUpdateString = new ArrayList<String>()
//
//		
//
//		for(e : environmentUpdates){
//			environmentUpdateString.add(e.getLabel)
//		}
//		
//		environmentUpdateString.remove(eu.getLabel)
//		
//		if(environmentUpdateString.remove(eu.getLabel)){
//			error( message ,
//					CarmaPackage::eINSTANCE.probability_Expression,
//					ERROR_EnvironmentUpdate_Unique
//			)
//		}
//	}
//	
//	public static val ERROR_ActionStub_input = "Error: Environment probability determines the probability of a message being received. There cannot be Spontaneous actions here."
//	/**
//	 * Probability
//	 * <p>
//	 * ERROR_ActionStub_input
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_ActionStub_input(ActionStub actionStub){
//		var String message = ERROR_ActionStub_input
//		var test = true
//		
//		if(actionStub.getContainerOfType(Probability) != null)
//			for(action : actionStub.actions)
//				test = test && !action.spont			
//
//		
//		if(!test){
//			error( message ,
//					CarmaPackage::eINSTANCE.actionStub_Name,
//					ERROR_ActionStub_input
//			)
//		}
//	}
//	
//	public static val ERROR_EnvironmentMacroExpressionComponentAllStates_ref = "Error: Must reference a Component in this model."
//	/**
//	 * EnvironmentMacroExpressionComponentAllStates
//	 * <p>
//	 * ERROR_EnvironmentMacroExpressionComponentAllStates_ref
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_EnvironmentMacroExpressionComponentAllStates_ref(EnvironmentMacroExpressionComponentAllStates emecas){
//		var String message = ERROR_EnvironmentMacroExpressionComponentAllStates_ref
//		
//		var name = emecas.comp
//		var model = emecas.getContainerOfType(Model)
//		
//		if(!model.isNameInModel(name)){
//			error( message ,
//					CarmaPackage::eINSTANCE.environmentMacroExpressionComponentAllStates_Comp,
//					ERROR_Rate_Unique
//			)
//		}
//	}
//	
//	public static val ERROR_EnvironmentMacroExpressionComponentAState_ref = "Error: Must reference a Component in this model."
//	/**
//	 * EnvironmentMacroExpressionComponentAState
//	 * <p>
//	 * ERROR_EnvironmentMacroExpressionComponentAState_ref
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_EnvironmentMacroExpressionComponentAState_ref(EnvironmentMacroExpressionComponentAState emecas){
//		var String message = ERROR_EnvironmentMacroExpressionComponentAllStates_ref
//		
//		var name = emecas.comp
//		var model = emecas.getContainerOfType(Model)
//		
//		if(!model.isNameInModel(name)){
//			error( message ,
//					CarmaPackage::eINSTANCE.environmentMacroExpressionComponentAllStates_Comp,
//					ERROR_Rate_Unique
//			)
//		}
//	}
//	
//	public static val ERROR_VariableDeclarationRecord = "Error: Must have the same number and same name of enums as the declared record."
//	
//	/**
//	 * VariableDeclarationRecord / Records
//	 * <p>
//	 * ERROR_VariableDeclarationRecord / ERROR_Records
//	 * <p>	
//	 * @author 	CDW <br>
//	 */
//	@Check
//	def check_ERROR_VariableDeclarationRecord(VariableDeclarationRecord vdr){
//		
//		var HashSet<String> flat = new HashSet<String>()
//		var records = vdr.getAllRecords
//		
//		for(r : records)
//			flat.add(r.flatten)
//		
//		if(flat.size > 1){
//			error( 	ERROR_VariableDeclarationRecord,
//					CarmaPackage::eINSTANCE.variableDeclaration_Name,
//					ERROR_VariableDeclarationRecord)
//		}
//	}
//	
//	public static val ERROR_Records = "Error: Must have the same number and same name of enums as the declared record."
//	@Check
//	def check_ERROR_Records(Records r){
//		
//		if(r.getContainerOfType(NCA) != null){
//			var position = r.getPosition
//			var vt = (r.getContainerOfType(CBND).name.getContainerOfType(ComponentBlockDefinition).componentArguments.inputArguments.get(position) as ComponentBlockDefinitionArgumentVariable).value
//			var rds = r.getContainerOfType(CBND).name.getContainerOfType(ComponentBlockDefinition).eAllOfType(RecordDeclarations)
//			var VariableDeclarationRecord vdr = null
//			for(rd : rds){
//				if(vt.name.sameName(rd.ref))
//					vdr = rd.getContainerOfType(VariableDeclarationRecord)
//			}
//			
//			if(vdr != null){
//				var HashSet<String> flat = new HashSet<String>()
//				var records = vdr.getAllRecords
//				
//				for(rec : records)
//					flat.add(rec.flatten)
//					
//				flat.add(r.flatten)
//				
//				if(flat.size > 1){
//					error( 	ERROR_Records,
//					CarmaPackage::eINSTANCE.records_RecordDeclarations,
//					ERROR_Records)
//				}
//			}
//				
//		}
//			
//
//	}
//	
//	public static val ERROR_Range_in_component = "Error: This may only be an integer or a reference to a variable, not a range."
//	@Check
//	def check_ERROR_Range_in_component(Range r){
//		if(r.getContainerOfType(ComponentBlockDefinition) != null){
//				error(ERROR_Range_in_component,
//					CarmaPackage::eINSTANCE.range_Min,
//					ERROR_Range_in_component)
//		}
//		
//	}
//	
//	public static val ERROR_VariableType_already_declared = "Error: This variable has already been declared elsewhere, name must be unique."
//	@Check
//	def check_ERROR_VariableType_already_declared(VariableType vt){
//		var test = false
//		var ArrayList<VariableDeclaration> vds = new ArrayList<VariableDeclaration>(vt.getContainerOfType(Model).eAllOfType(VariableDeclaration))
//		
//		for(vd : vds){
//			test = test || vd.name.sameName(vt.name)
//		}
//		
//		if(test){
//			error( 	ERROR_VariableType_already_declared,
//					CarmaPackage::eINSTANCE.variableType_Name,
//					ERROR_VariableType_already_declared
//			)
//		}
//	}
//	
//	/**
//	 * CarmaSystem
//	 * 
//	 * public abstract double broadcastProbability( CarmaStore sender , CarmaStore receiver , int action );
//	 * public abstract double unicastProbability( CarmaStore sender , CarmaStore receiver , int action );
//	 * public abstract double broadcastRate( CarmaStore sender , int action );
//	 * public abstract double unicastRate( CarmaStore sender , int action );
//	 * public abstract void broadcastUpdate( RandomGenerator random , CarmaStore sender , int action );
//	 * public abstract void unicastUpdate( RandomGenerator random , CarmaStore sender , CarmaStore receiver, int action );
//	 * 
//	 */
//	
//	public static val ERROR_VariableReference_prefix = "Error: Cannot use '"
//	@Check
//	def check_ERROR_VariableReference_prefix(VariableReference vr){
//		var message = ERROR_VariableReference_prefix
//		var test = true
//		switch(vr){
//			VariableReferencePure		: 	{test = true}
//			VariableReferenceMy			: 	{test = vr.getContainerOfType(Process) != null message = message + "my.' outside of a Process context"}
//			VariableReferenceThis		: 	{test = vr.getContainerOfType(Process) != null message = message + "this.' outside of a Process context"}
//			VariableReferenceReceiver	: 	{test = (vr.inEnvironmentUpdateWithUnicast || vr.getContainerOfType(Probability) != null || vr.getContainerOfType(Rate) != null) 
//				message = message 
//				+ "receiver.' outside of a Unicast-action Update, Rate, or Probability context"
//			}
//			VariableReferenceSender		:	{test = vr.getContainerOfType(Environment) != null message = message + "sender.' outside of an Environment context"}
//			VariableReferenceGlobal		:	{test = vr.getContainerOfType(Environment) != null message = message + "global.' outside of an Environment context"}
//			RecordReferencePure			: 	{test = true}
//			RecordReferenceMy			: 	{test = vr.getContainerOfType(Process) != null message = message + "my.' outside of a Process context"}
//			RecordReferenceThis			: 	{test = vr.getContainerOfType(Process) != null message = message + "this.' outside of a Process context"}
//			RecordReferenceReceiver		: 	{test = (vr.inEnvironmentUpdateWithUnicast || vr.getContainerOfType(Probability) != null) 
//				message = message 
//				+ "receiver.' outside of a Unicast-action Update, Rate, or Probability context"
//			}
//			RecordReferenceSender		:	{test = vr.getContainerOfType(Environment) != null message = message + "sender.' outside of an Environment context"}
//			RecordReferenceGlobal		:	{test = vr.getContainerOfType(Environment) != null message = message + "global.' outside of an Environment context"}
//		}
//		
//		if(!test){
//			error( 	message,
//					CarmaPackage::eINSTANCE.variableReference_Name,
//					ERROR_VariableReference_prefix
//			)
//		}
//		
//	}
//	
//	def boolean inEnvironmentUpdateWithUnicast(VariableReference vr){
//		var test = false
//		
//		if(vr.getContainerOfType(EnvironmentUpdate) != null){
//			test = !vr.getContainerOfType(EnvironmentUpdate).eAllOfType(ActionStub).get(0).isBroadcast
//		}
//		
//		return test
//	}
//	
//	/**
//	 * CarmaSystem
//	 * 
//	 * public abstract double broadcastProbability( CarmaStore sender , CarmaStore receiver , int action );
//	 * public abstract double unicastProbability( CarmaStore sender , CarmaStore receiver , int action );
//	 * public abstract double broadcastRate( CarmaStore sender , int action );
//	 * public abstract double unicastRate( CarmaStore sender , int action );
//	 * public abstract void broadcastUpdate( RandomGenerator random , CarmaStore sender , int action );
//	 * public abstract void unicastUpdate( RandomGenerator random , CarmaStore sender , CarmaStore receiver, int action );
//	 * 
//	 */
//	
//	public static val ERROR_VariableReference_prefix_reference = "Error: Variable not found"
//	@Check
//	def check_ERROR_VariableReferencePure_ref(VariableReference vr){
//		var message = ERROR_VariableReference_prefix_reference
//		message = vr.satisfiesPrefix(message)
//		if(message.length > 0){
//			error( 	message,
//					CarmaPackage::eINSTANCE.variableReference_Name,
//					ERROR_VariableReference_prefix_reference
//			)
//		}
//	}
//	
//	public static val ERROR_VariableReference_Receiver_not_in_Rate = "Error: cannot use receivers in rate calculations."
//	@Check
//	def check_ERROR_VariableReference_Receiver_not_in_Rate(VariableReference vr){
//		var test = false
//		switch(vr){
//			VariableReferenceReceiver:	test = true
//			RecordReferenceReceiver:	test = true
//		}
//		if(test){
//			if(vr.getContainerOfType(RateBlock) != null)
//				error( 	ERROR_VariableReference_Receiver_not_in_Rate,
//					CarmaPackage::eINSTANCE.variableReference_Name,
//					ERROR_VariableReference_Receiver_not_in_Rate
//			)
//		}
//	}
//	
//	public static val ERROR_EnvironmentMacroExpressionComponentAState = "Error: does not have access to this Process/State."
//	@Check
//	def check_ERROR_EnvironmentMacroExpressionComponentAState(EnvironmentMacroExpressionComponentAState eme){
//		if(!eme.comp.getContainerOfType(Component).hasAccess(eme.state)){
//			error(ERROR_EnvironmentMacroExpressionComponentAState,
//				CarmaPackage::eINSTANCE.environmentMacroExpressionComponentAState_State,
//				ERROR_EnvironmentMacroExpressionComponentAState
//			)
//		}
//	}
	
}
