package eu.quanticol.carma.core.utils

import eu.quanticol.carma.core.carma.Addition
import eu.quanticol.carma.core.carma.And
import eu.quanticol.carma.core.carma.AtomicCalls
import eu.quanticol.carma.core.carma.AtomicMeasure
import eu.quanticol.carma.core.carma.AtomicNow
import eu.quanticol.carma.core.carma.AtomicOutcome
import eu.quanticol.carma.core.carma.AtomicPrimitive
import eu.quanticol.carma.core.carma.AtomicProcessComposition
import eu.quanticol.carma.core.carma.AtomicRecord
import eu.quanticol.carma.core.carma.AtomicVariable
import eu.quanticol.carma.core.carma.AttribType
import eu.quanticol.carma.core.carma.BooleanExpression
import eu.quanticol.carma.core.carma.Calls
import eu.quanticol.carma.core.carma.CarmaBoolean
import eu.quanticol.carma.core.carma.CarmaDouble
import eu.quanticol.carma.core.carma.CarmaExponent
import eu.quanticol.carma.core.carma.CarmaInteger
import eu.quanticol.carma.core.carma.CeilingFunction
import eu.quanticol.carma.core.carma.Comparison
import eu.quanticol.carma.core.carma.Division
import eu.quanticol.carma.core.carma.DoubleType
import eu.quanticol.carma.core.carma.Equality
import eu.quanticol.carma.core.carma.Expressions
import eu.quanticol.carma.core.carma.FloorFunction
import eu.quanticol.carma.core.carma.FunctionArgument
import eu.quanticol.carma.core.carma.FunctionCall
import eu.quanticol.carma.core.carma.FunctionCallArguments
import eu.quanticol.carma.core.carma.FunctionExpression
import eu.quanticol.carma.core.carma.FunctionReferenceMan
import eu.quanticol.carma.core.carma.FunctionReferencePre
import eu.quanticol.carma.core.carma.InstantiateRecord
import eu.quanticol.carma.core.carma.IntgerType
import eu.quanticol.carma.core.carma.MaxFunction
import eu.quanticol.carma.core.carma.MinFunction
import eu.quanticol.carma.core.carma.Modulo
import eu.quanticol.carma.core.carma.Multiplication
import eu.quanticol.carma.core.carma.Name
import eu.quanticol.carma.core.carma.Not
import eu.quanticol.carma.core.carma.Or
import eu.quanticol.carma.core.carma.PDFunction
import eu.quanticol.carma.core.carma.PreArgument
import eu.quanticol.carma.core.carma.PreFunctionCall
import eu.quanticol.carma.core.carma.PredFunctionCallArguments
import eu.quanticol.carma.core.carma.PrimitiveTypes
import eu.quanticol.carma.core.carma.Range
import eu.quanticol.carma.core.carma.RecordArgument
import eu.quanticol.carma.core.carma.RecordArguments
import eu.quanticol.carma.core.carma.RecordReferenceGlobal
import eu.quanticol.carma.core.carma.RecordReferenceMy
import eu.quanticol.carma.core.carma.RecordReferencePure
import eu.quanticol.carma.core.carma.RecordReferenceReceiver
import eu.quanticol.carma.core.carma.RecordReferenceSender
import eu.quanticol.carma.core.carma.RecordType
import eu.quanticol.carma.core.carma.SetComp
import eu.quanticol.carma.core.carma.Subtraction
import eu.quanticol.carma.core.carma.Type
import eu.quanticol.carma.core.carma.Types
import eu.quanticol.carma.core.carma.UniformFunction
import eu.quanticol.carma.core.carma.VariableName
import eu.quanticol.carma.core.carma.VariableReference
import eu.quanticol.carma.core.carma.VariableReferenceGlobal
import eu.quanticol.carma.core.carma.VariableReferenceMy
import eu.quanticol.carma.core.carma.VariableReferencePure
import eu.quanticol.carma.core.carma.VariableReferenceReceiver
import eu.quanticol.carma.core.carma.VariableReferenceSender
import eu.quanticol.carma.core.typing.BaseType
import java.util.ArrayList

import static extension org.eclipse.xtext.EcoreUtil2.*
import com.google.inject.Inject
import eu.quanticol.carma.core.typing.TypeProvider
import eu.quanticol.carma.core.carma.UpdateExpression

class Express {
	
	def String storeExpress(BaseType bt){
		if(bt.me.equals("int")){
			'''Integer.class'''
		} else {
			'''«bt.me».class'''
		}
	}
	
	def String express(BaseType bt){
		if(bt.me.equals("int")){
			'''int'''
		} else {
			'''«bt.me»'''
		}
	}

	
	def String express(Types types){
		types.type.express
	}
	
	def String express(Type type){
		switch(type){
			DoubleType: "double"
			IntgerType: "int"
			AttribType: "int"
			RecordType: type.name.name
		}
	}

	def String express(FunctionExpression functionExpression) {
		functionExpression.expression.express
	}
	
	def String express(BooleanExpression functionExpression) {
		functionExpression.expression.express
	}
	
	def String express(UpdateExpression functionExpression) {
		functionExpression.expression.express
	}

	def String express(Expressions e) {
		switch (e) {
			Or: 						{e.express}
			And:						{e.express}
			Equality: 					{e.express}
			Comparison: 				{e.express}
			Subtraction: 				{e.express}
			Addition: 					{e.express}
			Multiplication: 			{e.express}
			Modulo: 					{e.express}
			Division: 					{e.express}
			Not: 						{e.express}
			AtomicPrimitive: 			{e.express}
			AtomicVariable: 			{e.express}
			AtomicCalls: 				{e.express}
			AtomicNow: 					{e.express}
			AtomicMeasure: 				{e.express}
			AtomicRecord: 				{e.express}
			AtomicOutcome: 				{"//eu.quanticol.carma.core.generator.ms.function.express.AtomicOutcome"}
			AtomicProcessComposition:	{"//eu.quanticol.carma.core.generator.ms.function.express.AtomicProcessComposition"}
		}

	}

	def String express(Or e) {
		'''(«e.left.express» || «e.right.express»)'''
	}

	def String express(And e) {
		'''(«e.left.express» && «e.right.express»)'''
	}

	def String express(Equality e) {
		'''(«e.left.express» «e.op» «e.right.express»)'''
	}

	def String express(Comparison e) {
		'''(«e.left.express» «e.op» «e.right.express»)'''
	}

	def String express(Subtraction e) {
		'''(«e.left.express» - «e.right.express»)'''
	}

	def String express(Addition e) {
		'''(«e.left.express» - «e.right.express»)'''
	}

	def String express(Multiplication e) {
		'''(«e.left.express» * «e.right.express»)'''
	}

	def String express(Modulo e) {
		'''(«e.left.express» % «e.right.express»)'''
	}

	def String express(Division e) {
		'''(«e.left.express» / «e.right.express»)'''
	}

	def String express(Not e) {
		'''!(«e.expression.express»)'''
	}

	def String express(AtomicPrimitive e) {
		e.value.express
	}

	def String express(PrimitiveTypes pts) {
		switch (pts) {
			CarmaDouble: pts.express
			CarmaInteger: pts.express
			CarmaBoolean: pts.express
			Range: "//eu.quanticol.carma.core.generator.ms.function.express.Range"
		}
	}

	def String express(CarmaDouble pt) {
		var String toReturn = ""
		if (pt.negative != null)
			toReturn = toReturn + "-"
		toReturn = toReturn + pt.left + "." + pt.right
		if (pt.exponent != null)
			toReturn = toReturn + pt.exponent.express
		return toReturn
	}

	def String express(CarmaExponent exp) {
		var String negative = ""
		if (exp.negative != null)
			negative = "-"
		''' * «negative» Math.pow(«exp.base»,«exp.exponent»)'''
	}

	def String express(CarmaInteger pt) {
		if (pt.negative != null)
			return "-" + pt.value
		else
			return "" + pt.value
	}

	def String express(CarmaBoolean pt) {
		'''«pt.value»'''
	}

	def String express(AtomicVariable expression) {
		expression.value.express
	}

	def String express(VariableReference vr) {
		switch (vr) {
			VariableReferencePure: 		vr.name.name
			VariableReferenceMy: 		vr.name.name
			VariableReferenceReceiver: 	vr.name.name
			VariableReferenceSender: 	vr.name.name
			VariableReferenceGlobal: 	vr.name.name
			RecordReferencePure: 		vr.name.name + "." + vr.feild.name
			RecordReferenceMy: 			vr.name.name + "." + vr.feild.name
			RecordReferenceReceiver: 	vr.name.name + "." + vr.feild.name
			RecordReferenceSender: 		vr.name.name + "." + vr.feild.name
			RecordReferenceGlobal: 		vr.name.name + "." + vr.feild.name
		}
	}

	def String express(AtomicCalls expression) {
		expression.value.express
	}

	def String express(Calls calls) {
		switch (calls) {
			FunctionReferenceMan: calls.ref.express
			FunctionReferencePre: calls.ref.express
		}
	}

	def String express(FunctionCall functionCall) {
		'''«(functionCall.name as Name).name.toFirstLower»(«(functionCall.arguments as FunctionCallArguments).express»)'''
	}
	
	def String express(FunctionCallArguments arguments){
			var ArrayList<FunctionArgument> args = new ArrayList<FunctionArgument>(arguments.eAllOfType(FunctionArgument))
			var toReturn = ""
			if(args.size > 0){
				toReturn = toReturn + args.get(0).express
				for(var i = 1; i < args.size; i++){
					toReturn = toReturn + ", " + args.get(i).express
				}
			}
			return toReturn
	}
	
	def String express(FunctionArgument argument){
		argument.value.express
	}
	
	def String express(PreFunctionCall preFunctionCall) {
		switch (preFunctionCall) {
			PDFunction:			{'''pdf(«(preFunctionCall.arguments as PredFunctionCallArguments).express»)'''}
			UniformFunction:	{'''uniform(«(preFunctionCall.arguments as PredFunctionCallArguments).express»)'''}
			CeilingFunction:	{'''ceil(«(preFunctionCall.arguments as PredFunctionCallArguments).express»)'''}
			FloorFunction:		{'''floor(«(preFunctionCall.arguments as PredFunctionCallArguments).express»)'''}
			MaxFunction:		{'''max(«(preFunctionCall.arguments as PredFunctionCallArguments).express»)'''}
			MinFunction:		{'''min(«(preFunctionCall.arguments as PredFunctionCallArguments).express»)'''}		
		}
	}
	
	def String express(PredFunctionCallArguments arguments){
			var ArrayList<PreArgument> args = new ArrayList<PreArgument>(arguments.eAllOfType(PreArgument))
			var toReturn = '''new ArrayList<Object>(Arrays.asList('''
			if(args.size > 0){
				toReturn = toReturn + '''«args.get(0).express»'''
				for(var i = 1; i < args.size; i++){
					toReturn = toReturn + ''', «args.get(i).express»'''
				}
			}
			return toReturn + "))"
	}
	
	def String express(PreArgument argument){
		argument.value.express
	}
	
	def String express(AtomicNow expression){
		'''now()'''
	}
	
	def String express(AtomicMeasure expression){
		'''getMeasure«expression.value.express»().measure(this)'''
	}
	
	def String express(SetComp setComp){
		((setComp.hashCode*setComp.hashCode)*1000 + "").substring(0,3)
	}
	
	def String express(AtomicRecord expression){
		var instance = (expression.value as InstantiateRecord)
		'''new «(instance.type as Type).express» ( «(instance.arguments as RecordArguments).express» )'''
	}
	
	def String express(RecordArguments arguments){
			var ArrayList<RecordArgument> args = new ArrayList<RecordArgument>(arguments.eAllOfType(RecordArgument))
			var toReturn = ""
			if(args.size > 0){
				toReturn = toReturn + args.get(0).express
				for(var i = 1; i < args.size; i++){
					toReturn = toReturn + ", " + args.get(i).express
				}
			}
			return toReturn
	}
	
	def String express(RecordArgument argument){
		argument.value.express
	}	

}