/*
 * generated by Xtext
 */
package eu.quanticol.carma.core.validation

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.Addition
import eu.quanticol.carma.core.carma.And
import eu.quanticol.carma.core.carma.AtomicRecord
import eu.quanticol.carma.core.carma.AttributeDeclaration
import eu.quanticol.carma.core.carma.CarmaPackage
import eu.quanticol.carma.core.carma.ComponentDefinition
import eu.quanticol.carma.core.carma.ConstantDefinition
import eu.quanticol.carma.core.carma.DisEquality
import eu.quanticol.carma.core.carma.Division
import eu.quanticol.carma.core.carma.EnumDefinition
import eu.quanticol.carma.core.carma.Equality
import eu.quanticol.carma.core.carma.FieldAssignment
import eu.quanticol.carma.core.carma.FieldDefinition
import eu.quanticol.carma.core.carma.FunctionDefinition
import eu.quanticol.carma.core.carma.Greater
import eu.quanticol.carma.core.carma.GreaterOrEqual
import eu.quanticol.carma.core.carma.IfThenElseExpression
import eu.quanticol.carma.core.carma.Less
import eu.quanticol.carma.core.carma.LessOrEqual
import eu.quanticol.carma.core.carma.MeasureDefinition
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.carma.Modulo
import eu.quanticol.carma.core.carma.Multiplication
import eu.quanticol.carma.core.carma.Not
import eu.quanticol.carma.core.carma.Or
import eu.quanticol.carma.core.carma.ProcessState
import eu.quanticol.carma.core.carma.Range
import eu.quanticol.carma.core.carma.RecordDefinition
import eu.quanticol.carma.core.carma.StoreBlock
import eu.quanticol.carma.core.carma.Subtraction
import eu.quanticol.carma.core.carma.UnaryMinus
import eu.quanticol.carma.core.carma.UnaryPlus
import eu.quanticol.carma.core.carma.UpdateAssignment
import eu.quanticol.carma.core.carma.Variable
import eu.quanticol.carma.core.typing.CarmaType
import eu.quanticol.carma.core.typing.TypeSystem
import eu.quanticol.carma.core.utils.Util
import org.eclipse.xtext.validation.Check

import static extension org.eclipse.xtext.EcoreUtil2.*
import eu.quanticol.carma.core.carma.ReturnCommand
import eu.quanticol.carma.core.carma.AssignmentCommand
import eu.quanticol.carma.core.carma.VariableDeclarationCommand
import eu.quanticol.carma.core.carma.Reference
import eu.quanticol.carma.core.carma.ComponentBlockInstantiation

class CARMAValidator extends AbstractCARMAValidator {
	
	@Inject extension TypeSystem
	@Inject extension Util


	public static val ERROR_FunctionDefinition_wrong_name 	= "ERROR_FunctionDefinition_wong_name"

	@Check
	def check_ERROR_FunctionDefinition_wrong_name(FunctionDefinition f){
		if ((f.name != null)&&(!f.name.empty)&&(!Character::isUpperCase( f.name.charAt(0) ) )) {
			error("Name error: function names have to start with a capitalised letter!",CarmaPackage::eINSTANCE.referenceableElement_Name,ERROR_FunctionDefinition_wrong_name);
		}
	}

	public static val ERROR_RecordDefinition_wong_name 	= "ERROR_RecordDefinition_wong_name"

	@Check
	def check_ERROR_RecordDefinition_wrong_name(RecordDefinition f){
		if ((f.name != null)&&(!f.name.empty)&&(!Character::isUpperCase( f.name.charAt(0) ) )) {
			error("Name error: record names have to start with a capitalised letter!",CarmaPackage::eINSTANCE.recordDefinition_Name,ERROR_RecordDefinition_wong_name);
		}
	}

	public static val ERROR_EnumDefinition_wong_name 	= "ERROR_EnumDefinition_wong_name"

	@Check
	def check_ERROR_EnumDefinition_wong_name(EnumDefinition f){
		if ((f.name != null)&&(!f.name.empty)&&(!Character::isUpperCase( f.name.charAt(0) ) )) {
			error("Name error: enumeration names have to start with a capitalised letter!",CarmaPackage::eINSTANCE.enumDefinition_Name,ERROR_EnumDefinition_wong_name);
		}
	}

	//TODO: ADD SIMILAR APPROPRIATE VALIDATORS FOR THE OTHER SYNTACTIC CATEGORIES.	
	
	//FunctionDefinition - must have same type of its body
	public static val ERROR_FunctionDefinition_coherent_type 	= "ERROR_FunctionDefinition_coherent_type"
	
	@Check
	def check_ERROR_FunctionDefinition_coherent_type( ReturnCommand c ){
		var f = c.getContainerOfType(typeof(FunctionDefinition))
		if ((f != null)&&(f.type != null)&&(c.expression != null)) {
			var declaredType  = f.type.toCarmaType
			var inferredType = c.expression.typeOf
			var generalType = declaredType.mostGeneral(inferredType)
					
			if (!inferredType.isError()&&(!declaredType.equals(generalType))) {
				error("Type Error: Expected "+declaredType+" is "+inferredType,CarmaPackage::eINSTANCE.returnCommand_Expression,ERROR_FunctionDefinition_coherent_type);
			}
		}
	}

	//FunctionDefinition - must have same type of its body
	public static val ERROR_FunctionDefinition_return_statement = "ERROR_FunctionDefinition_coherent_type"

	@Check
	def check_ERROR_FunctionDefinition_return_statement( FunctionDefinition f ){
		if ((f.body != null)&&(!f.body.doReturn)) {
			error("Error: This function must return a value!",CarmaPackage::eINSTANCE.functionDefinition_Body,ERROR_FunctionDefinition_return_statement);
		}
	}
	
	
	//FunctionDefinition - duplicated function name
	public static val ERROR_FunctionDefinition_multiple_definition 	= "ERROR_FunctionDefinition_multiple_definition"
	
	@Check
	def check_ERROR_FunctionDefinition_multiple_definition(FunctionDefinition f) {
		
		var model = f.getContainerOfType(typeof(Model))
		if (model != null) {

			var functions = model.functions.filter[ it.name == f.name ]
			if (functions.length > 1) {
				error("Error: duplicated function declaration",CarmaPackage::eINSTANCE.referenceableElement_Name, ERROR_FunctionDefinition_multiple_definition);				
			}
			
		}

	}
	
	//RecordDefinition - duplicated record name
	public static val ERROR_RecordDefinition_multiple_definition 	= "ERROR_RecordDefinition_multiple_definition"
	
	@Check
	def check_ERROR_RecordDefinition_multiple_definition(RecordDefinition r) {
		
		var model = r.getContainerOfType(typeof(Model))
		if (model != null) {

			var functions = model.records.filter[ it.name == r.name ]
			if (functions.length > 1) {
				error("Error: duplicated record declaration",CarmaPackage::eINSTANCE.recordDefinition_Name, ERROR_RecordDefinition_multiple_definition);				
			}
			
		}

	}
	
	//FunctionDefinition - duplicated function name
	public static val ERROR_FieldDefinition_multiple_definition 	= "ERROR_FieldDefinition_multiple_definition"
	
	@Check
	def check_ERROR_FieldDefinition_multiple_definition(FieldDefinition f) {
		
		var model = f.getContainerOfType(typeof(Model))
		if (model != null) {

			var functions = model.fields.filter[ it.name == f.name ]
			if (functions.length > 1) {
				error("Error: duplicated field declaration",CarmaPackage::eINSTANCE.fieldDefinition_Name, ERROR_FieldDefinition_multiple_definition);				
			}
			
		}

	}
	
	//Process - duplicated process name
	public static val ERROR_Process_multiple_definition 	= "ERROR_Process_multiple_definition"
	
	@Check
	def check_ERROR_Process_multiple_definition(ProcessState p) {
		
		var model = p.getContainerOfType(typeof(Model))
		if (model != null) {

			var functions = model.globalProcesses.filter[ it.name == p.name ]
			if (functions.length > 1) {
				error("Error: duplicated process declaration",CarmaPackage::eINSTANCE.referenceableElement_Name, ERROR_Process_multiple_definition);				
			}
			
		}

	}

	//ConstantDefinition - duplicated constant name
	public static val ERROR_ConstantDefinition_multiple_definition 	= "ERROR_ConstantDefinition_multiple_definition"
	
	@Check
	def check_ERROR_Process_multiple_definition(ConstantDefinition c) {
		
		var model = c.getContainerOfType(typeof(Model))
		if (model != null) {

			var functions = model.globalProcesses.filter[ it.name == c.name ]
			if (functions.length > 1) {
				error("Error: duplicated constant declaration",CarmaPackage::eINSTANCE.referenceableElement_Name, ERROR_ConstantDefinition_multiple_definition);				
			}
			
		}

	}

	//Component - duplicated component name
	public static val ERROR_ComponentDefinition_multiple_definition 	= "ERROR_ComponentDefinition_multiple_definition"
	
	@Check
	def check_ERROR_ComponentDefinition_multiple_definition(ComponentDefinition c) {
		
		var model = c.getContainerOfType(typeof(Model))
		if (model != null) {

			var functions = model.globalProcesses.filter[ it.name == c.name ]
			if (functions.length > 1) {
				error("Error: duplicated component declaration",CarmaPackage::eINSTANCE.componentDefinition_Name, ERROR_ComponentDefinition_multiple_definition);				
			}
			
		}

	}

	//Variable - duplicated variable name
	public static val ERROR_Variable_multiple_definition 	= "ERROR_Variable_multiple_definition"
	
	@Check
	def check_ERROR_Variable_multiple_definition(Variable v) {

		var vars = null as Iterable<Variable>;	
		var f = v.getContainerOfType(typeof(FunctionDefinition))
		if (f != null) {
			vars = f.parameters.filter[ it.name == v.name ]			
		}
		var c = v.getContainerOfType(typeof(ComponentDefinition))
		if (c != null) {
			vars = c.parameters.filter[ it.name == v.name ]			
		}
		if ((vars != null)&&(vars.length > 1)) {
			error("Error: duplicated variable declaration",CarmaPackage::eINSTANCE.referenceableElement_Name, ERROR_Variable_multiple_definition);				
		}
			
	}
	
	//AttributeDeclaration - duplicated variable name
	public static val ERROR_AttributeDeclaration_multiple_definition 	= "ERROR_AttributeDeclaration_multiple_definition"
	
	@Check
	def check_ERROR_AttributeDeclaration_multiple_definition(AttributeDeclaration a) {

		var block = a.getContainerOfType(typeof(StoreBlock))
		if (block != null) {
			var attrs = block.attributes.filter[ it.name == a.name ]			
			if (attrs.length > 1) {
				error("Error: duplicated attribute declaration",CarmaPackage::eINSTANCE.referenceableElement_Name, ERROR_AttributeDeclaration_multiple_definition);				
			}
		}
			
	}

	//MeasureDefinition - duplicated measure name
	public static val ERROR_MeasureDefinition_multiple_definition 	= "ERROR_MeasureDefinition_multiple_definition"
	
	@Check
	def check_ERROR_MeasureDefinition_multiple_definition(MeasureDefinition m) {

		var model = m.getContainerOfType(typeof(Model))
		if (model != null) {

			var functions = model.globalProcesses.filter[ it.name == m.name ]
			if (functions.length > 1) {
				error("Error: duplicated measure declaration",CarmaPackage::eINSTANCE.measureDefinition_Name, ERROR_MeasureDefinition_multiple_definition);				
			}
			
		}
			
	}
	
	//FunctionDefinition - duplicated function name
	public static val ERROR_UpdateAssignment_type_error 	= "ERROR_UpdateAssignment_type_error"
	
	@Check
	def check_ERROR_AttributeAssignment_type_error( UpdateAssignment assignment ) {
		
		var expectedType = assignment ?. reference ?. typeOf
		var actualType = assignment ?. expression ?. typeOf
		if ((expectedType != null)&&(actualType !=null)&&(!expectedType.mostGeneral(actualType).equals(expectedType))) {
			error("Type Error: Expected "+expectedType+" is "+actualType,CarmaPackage::eINSTANCE.updateAssignment_Expression,ERROR_FunctionDefinition_coherent_type);			
		}

	}
	
	public static val ERROR_Expression_type_error = "ERROR_Expression_type_error"
	
	@Check
	def check_ERROR_Expression_type_error_Or_left( Or e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.isBoolean)) {
				error("Type Error: Expected "+CarmaType::BOOLEAN_TYPE+" is "+type,CarmaPackage::eINSTANCE.or_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Or_right( Or e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.isBoolean)) {
				error("Type Error: Expected "+CarmaType::BOOLEAN_TYPE+" is "+type,CarmaPackage::eINSTANCE.or_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_And_left( And e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.isBoolean)) {
				error("Type Error: Expected "+CarmaType::BOOLEAN_TYPE+" is "+type,CarmaPackage::eINSTANCE.and_Left,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_IfThenElse_guard( IfThenElseExpression e ) {
		if (e.guard != null) {
			var type = e.guard.typeOf
			if ((type!=null)&&(!type.error)&&(!type.isBoolean)) {
				error("Type Error: Expected "+CarmaType::BOOLEAN_TYPE+" is "+type,CarmaPackage::eINSTANCE.ifThenElseExpression_Guard,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_IfThenElse_elseBranch( IfThenElseExpression e ) {
		if ((e.thenBranch != null)&&(e.elseBranch != null)) {
			var thenBranchType = e.thenBranch.typeOf
			var elseBranchType = e.elseBranch.typeOf 
			if ((!thenBranchType.error)&&(!elseBranchType.error)&&(!thenBranchType.isCompatibleWith(elseBranchType))) {
				error("Type Error: Expected "+thenBranchType+" is "+elseBranchType,CarmaPackage::eINSTANCE.ifThenElseExpression_ElseBranch,ERROR_Expression_type_error);			
			}
		}
	}
	
	
	@Check
	def check_ERROR_Expression_type_error_And_right( And e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.isBoolean)) {
				error("Type Error: Expected "+CarmaType::BOOLEAN_TYPE+" is "+type,CarmaPackage::eINSTANCE.and_Right,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Relations_left( Equality e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.equality_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Relations_right( Equality e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.equality_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Relations_left( DisEquality e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.disEquality_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Relations_right( DisEquality e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.disEquality_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Relations_left( Less e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.less_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Relations_right( Less e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.less_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Relations_left( LessOrEqual e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.lessOrEqual_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Relations_right( LessOrEqual e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.lessOrEqual_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Relations_left( Greater e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.greater_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Relations_right( Greater e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.greater_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Relations_left( GreaterOrEqual e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.greaterOrEqual_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Relations_right( GreaterOrEqual e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.greaterOrEqual_Right,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Arithmetic_left( Addition e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.addition_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Arithmetic_right( Addition e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.addition_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Arithmetic_left( Subtraction e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.subtraction_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Arithmetic_right( Subtraction e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.subtraction_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Arithmetic_left( Multiplication e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.multiplication_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Arithmetic_right( Multiplication e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.multiplication_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Arithmetic_left( Division e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.division_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Arithmetic_right( Division e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.division_Right,ERROR_Expression_type_error);			
			}
		}
	}


	@Check
	def check_ERROR_Expression_type_error_Arithmetic_left( Modulo e ) {
		if (e.left != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.integer)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" is "+type,CarmaPackage::eINSTANCE.modulo_Left,ERROR_Expression_type_error);			
			}
		}
	}
	
	@Check
	def check_ERROR_Expression_type_error_Arithmetic_right( Modulo e ) {
		if (e.right != null) {
			var type = e.left.typeOf
			if ((type!=null)&&(!type.error)&&(!type.integer)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" is "+type,CarmaPackage::eINSTANCE.modulo_Right,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Not( Not e ) {
		if (e.expression != null) {
			var type = e.expression.typeOf
			if ((type!=null)&&(!type.error)&&(!type.isBoolean)) {
				error("Type Error: Expected "+CarmaType::BOOLEAN_TYPE+" is "+type,CarmaPackage::eINSTANCE.not_Expression,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Unary( UnaryMinus e ) {
		if (e.expression != null) {
			var type = e.expression.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.unaryMinus_Expression,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Unary( UnaryPlus e ) {
		if (e.expression != null) {
			var type = e.expression.typeOf
			if ((type!=null)&&(!type.error)&&(!type.number)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" or "+CarmaType::REAL_TYPE+" is "+type,CarmaPackage::eINSTANCE.unaryPlus_Expression,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Range_min( Range e ) {
		if (e.min != null) {
			var type = e.min.typeOf
			if ((type!=null)&&(!type.error)&&(!type.integer)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" is "+type,CarmaPackage::eINSTANCE.range_Min,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Range_max( Range e ) {
		if (e.max != null) {
			var type = e.max.typeOf
			if ((type!=null)&&(!type.error)&&(!type.integer)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" is "+type,CarmaPackage::eINSTANCE.range_Min,ERROR_Expression_type_error);			
			}
		}
	}

	@Check
	def check_ERROR_Expression_type_error_Range_step( Range e ) {
		if (e.step != null) {
			var type = e.step.typeOf
			if ((type!=null)&&(!type.error)&&(!type.integer)) {
				error("Type Error: Expected "+CarmaType::INTEGER_TYPE+" is "+type,CarmaPackage::eINSTANCE.range_Step,ERROR_Expression_type_error);			
			}
		}
	}

	//Component - duplicated component name
	public static val ERROR_FieldAssignment_incompatible_field 	= "ERROR_FieldAssignment_incompatible_field"
	
	@Check
	def check_ERROR_AtomicRecord_wrong_field( FieldAssignment f ) {
		var t1 = f.field ?. recordType
		var ar = f.getContainerOfType(typeof(AtomicRecord)) 
		if ((ar != null)&&(t1 != null)&&(!t1.error)) {
			var f2 = ar.fields.head
			if ((f2 != null)&&(f != f2)) {
				var t2 = f2.field ?. recordType
				if ((t2 != null)&&(!t2.error)&&(t1.reference != t2.reference)) {
					error("Field "+f.field.name+" is not valid for type "+(t2.reference as RecordDefinition).name,
						CarmaPackage::eINSTANCE.fieldAssignment_Field , 
						ERROR_FieldAssignment_incompatible_field												
					)
				}
			}
		}
	}

	//Component - duplicated component name
	public static val ERROR_AtomicRecord_missing_field 	= "ERROR_AtomicRecord_missing_field"

	@Check
	def check_ERROR_AtomicRecord_missing_field( AtomicRecord r ) {
		var f = r.fields.head
		if (f != null) {
			var t = f.field ?.recordType
			if ((t!=null)&&(!t.error)&&(t.record)) {
				var rt = t.reference as RecordDefinition
				var missing =  rt.fields.filter[ df | r.fields.forall[ it.field != df ] ].map[it.name]
				if (!missing.empty) {
					error("Missing fields: "+missing.join(", "),
						CarmaPackage::eINSTANCE.atomicRecord_Fields , 
						ERROR_AtomicRecord_missing_field												
					)
				}
			}
		}
	}
	
	public static val ERROR_FieldAssignment_type_error = "ERROR_FieldAssignment_type_error"
	
	@Check
	def check_ERROR_FieldAssignment_type_error( FieldAssignment f ) {
		var tf = f.field.fieldType.toCarmaType
		var tv = f.value.typeOf
		if (!tf.equals(tv)) {
			error("Type Error: Expected "+tf+" is "+tv,CarmaPackage::eINSTANCE.fieldAssignment_Value,ERROR_FieldAssignment_type_error);
		}
	}

	public static val ERROR_VariableAssignment_type_error = "ERROR_VariableAssignment_type_error"
	
	@Check
	def check_ERROR_VariableAssignment_type_error( AssignmentCommand f ) {
		var tf = f.target.typeOf
		var tv = f.value.typeOf
		if (!tf.equals(tv)) {
			error("Type Error: Expected "+tf+" is "+tv,CarmaPackage::eINSTANCE.assignmentCommand_Value,ERROR_VariableAssignment_type_error);
		}
	}

	public static val ERROR_VariableDeclarationCommand_type_error = "ERROR_VariableDeclarationCommand_type_error"
	
	@Check
	def check_ERROR_VariableAssignment_type_error( VariableDeclarationCommand f ) {
		var tf = f.variable.type.toCarmaType
		var tv = f.value.typeOf
		if (!tf.equals(tv)) {
			error("Type Error: Expected "+tf+" is "+tv,CarmaPackage::eINSTANCE.variableDeclarationCommand_Value,ERROR_VariableDeclarationCommand_type_error);
		}
	}
	
	public static val ERROR_Reference_call_error = "ERROR_Reference_call_error"

	@Check
	def check_ERROR_Reference_call_error_1( Reference r ) {
		if ((r.reference instanceof FunctionDefinition)&&(!r.isIsCall)) {
			error("Error: missing parameters!",CarmaPackage::eINSTANCE.reference_Reference,ERROR_Reference_call_error);
		}
	}

	@Check
	def check_ERROR_Reference_call_error_2( Reference r ) {
		if (!(r.reference instanceof FunctionDefinition)&&(r.isIsCall)) {
			error("Error: "+r.reference.name+" is not a function!",CarmaPackage::eINSTANCE.reference_Reference,ERROR_Reference_call_error);
		}
	}
	
	public static val ERROR_Reference_wrong_number_of_parameters = "ERROR_Reference_wrong_number_of_parameters"
	
	@Check
	def check_ERROR_Reference_wrong_number_of_parameters( Reference r ) {
		var ref = r.reference
		if (ref instanceof FunctionDefinition) {
			if ((r.isIsCall)&&(r.args.size != ref.parameters.size)) {
				error("Error: wrong number of parameters!",CarmaPackage::eINSTANCE.reference_Args,ERROR_Reference_wrong_number_of_parameters);			
			}
		}
	}

	public static val ERROR_Reference_wrong_parameter_type = "ERROR_Reference_wrong_parameter_type"
	
	@Check
	def check_ERROR_Reference_wrong_parameter_type( Reference r ) {
		var ref = r.reference
		if (ref instanceof FunctionDefinition) {
			if ((r.isIsCall)&&(r.args.size == ref.parameters.size)) {
				for( var i=0 ; i<r.args.size ; i++ ) {
					var dt = ref.parameters.get(i).type.toCarmaType
					var at = r.args.get(i).typeOf
					if (dt != at) {
						error("Type Error: Expected "+dt+" is "+at,CarmaPackage::eINSTANCE.reference_Args,i,ERROR_Reference_wrong_number_of_parameters);													
					}
				}
			}
		}
	}
	
	public static val ERROR_ComponentBlockInstantiation_wrong_number_of_parameters = "ERROR_ComponentBlockInstantiation_wrong_number_of_parameters"
	
	@Check
	def check_ERROR_ComponentBlockInstantiation_wrong_number_of_parameters( ComponentBlockInstantiation cbi ) {
		if ((cbi.name.parameters.size != cbi.arguments.size)) {
			error("Error: wrong number of parameters!",CarmaPackage::eINSTANCE.componentBlockInstantiation_Arguments,ERROR_ComponentBlockInstantiation_wrong_number_of_parameters);			
		}
	}
	
	public static val ERROR_ComponentBlockInstantiation_wrong_parameter_type = "ERROR_ComponentBlockInstantiation_wrong_parameter_type"
	
	@Check
	def check_ERROR_ERROR_ComponentBlockInstantiation_wrong_parameter_type( ComponentBlockInstantiation cbi ) {
		if ((cbi.name.parameters.size == cbi.arguments.size)) {
			for( var i=0 ; i<cbi.name.parameters.size ; i++ ) {
				var dt = cbi.name.parameters.get(i).type.toCarmaType
				var at = cbi.arguments.get(i).typeOf
				if (dt != at) {
					error("Type Error: Expected "+dt+" is "+at,CarmaPackage::eINSTANCE.componentBlockInstantiation_Arguments,i,ERROR_ComponentBlockInstantiation_wrong_parameter_type);													
				}
			}
		}
	}
}	
	

