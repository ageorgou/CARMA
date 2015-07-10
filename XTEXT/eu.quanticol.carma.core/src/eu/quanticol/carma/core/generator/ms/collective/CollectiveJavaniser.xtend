package eu.quanticol.carma.core.generator.ms.collective

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
import eu.quanticol.carma.core.carma.Calls
import eu.quanticol.carma.core.carma.CarmaBoolean
import eu.quanticol.carma.core.carma.CarmaDouble
import eu.quanticol.carma.core.carma.CarmaInteger
import eu.quanticol.carma.core.carma.CeilingFunction
import eu.quanticol.carma.core.carma.CompArgument
import eu.quanticol.carma.core.carma.Comparison
import eu.quanticol.carma.core.carma.ComponentBlockArguments
import eu.quanticol.carma.core.carma.Division
import eu.quanticol.carma.core.carma.DoubleType
import eu.quanticol.carma.core.carma.Equality
import eu.quanticol.carma.core.carma.Expressions
import eu.quanticol.carma.core.carma.FloorFunction
import eu.quanticol.carma.core.carma.FunctionArgument
import eu.quanticol.carma.core.carma.FunctionCall
import eu.quanticol.carma.core.carma.FunctionCallArguments
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
import eu.quanticol.carma.core.carma.Subtraction
import eu.quanticol.carma.core.carma.Type
import eu.quanticol.carma.core.carma.Types
import eu.quanticol.carma.core.carma.UniformFunction
import eu.quanticol.carma.core.carma.VariableReference
import eu.quanticol.carma.core.carma.VariableReferenceGlobal
import eu.quanticol.carma.core.carma.VariableReferenceMy
import eu.quanticol.carma.core.carma.VariableReferencePure
import eu.quanticol.carma.core.carma.VariableReferenceReceiver
import eu.quanticol.carma.core.carma.VariableReferenceSender
import java.util.ArrayList

import static extension org.eclipse.xtext.EcoreUtil2.*
import eu.quanticol.carma.core.carma.ComponentForVariableDeclaration
import eu.quanticol.carma.core.carma.BooleanExpression
import eu.quanticol.carma.core.carma.ComponentAssignment
import eu.quanticol.carma.core.carma.ComponentExpression
import eu.quanticol.carma.core.carma.Declaration
import eu.quanticol.carma.core.carma.AttribVariableDeclaration
import eu.quanticol.carma.core.carma.RecordDeclaration
import eu.quanticol.carma.core.carma.Parameter
import eu.quanticol.carma.core.carma.AttribParameter
import eu.quanticol.carma.core.carma.RecordParameter
import eu.quanticol.carma.core.carma.ProcessParameter
import eu.quanticol.carma.core.carma.ProcessComposition
import eu.quanticol.carma.core.carma.ParallelComposition
import eu.quanticol.carma.core.carma.ProcessReference
import eu.quanticol.carma.core.typing.BaseType
import eu.quanticol.carma.core.carma.OutputActionArgument
import eu.quanticol.carma.core.carma.Action

class CollectiveJavaniser {
	
	def int actionName(Action action){
		var toReturn = 10 * 13
		
		for(var i = 0 ; i < action.name.name.length; i++){
			toReturn = toReturn + action.name.name.charAt(i) * 13
		}
		
		return toReturn
	}
	
	def ArrayList<ArrayList<String>> product(ComponentBlockArguments arguments){
			var ArrayList<CompArgument> args = new ArrayList<CompArgument>(arguments.eAllOfType(CompArgument))
			var toReturn = new ArrayList<ArrayList<String>>();
			if(args.size > 0){
				toReturn.add(args.get(0).array)
				for(var i = 1; i < args.size; i++){
					toReturn.add(args.get(i).array)
				}
			}
			return toReturn
	}
	
	def ArrayList<String> array(CompArgument argument){
		var ArrayList<String> toReturn = new ArrayList<String>();
		argument.value.array(toReturn)
		return toReturn
	}
	
	def void array(Expressions e, ArrayList<String> array) {
		switch (e) {
			Or: 						{array.add("//eu.quanticol.carma.core.generator.ms.collective.array.Or")}
			And:						{array.add("//eu.quanticol.carma.core.generator.ms.collective.array.And")}
			Equality: 					{array.add("//eu.quanticol.carma.core.generator.ms.collective.array.Equality")}
			Comparison: 				{array.add("//eu.quanticol.carma.core.generator.ms.collective.array.Comparison")}
			Subtraction: 				{array.add(e.javanise)}
			Addition: 					{array.add(e.javanise)}
			Multiplication: 			{array.add(e.javanise)}
			Modulo: 					{array.add(e.javanise)}
			Division: 					{array.add(e.javanise)}
			Not: 						{array.add("//eu.quanticol.carma.core.generator.ms.collective.array.Not")}
			AtomicPrimitive: 			{e.array(array)}
			AtomicVariable: 			{array.add(e.javanise)}
			AtomicCalls: 				{array.add(e.javanise)}
			AtomicNow: 					{array.add("//eu.quanticol.carma.core.generator.ms.collective.array.Now")}
			AtomicMeasure: 				{array.add("//eu.quanticol.carma.core.generator.ms.collective.array.Measure")}
			AtomicRecord: 				{array.add(e.javanise)}
			AtomicOutcome: 				{array.add("//eu.quanticol.carma.core.generator.ms.collective.array.AtomicOutcome")}
			AtomicProcessComposition: 	{array.add(e.javanise)}
		}

	}
	
	def void array(AtomicPrimitive e, ArrayList<String> array) {
		e.value.array(array)
	}
	
	def void array(PrimitiveTypes pts, ArrayList<String> array) {
		switch (pts) {
			CarmaDouble: {array.add("//eu.quanticol.carma.core.generator.ms.function.javanise.CarmaDouble")}
			CarmaInteger: {array.add(pts.javanise)}
			CarmaBoolean: {array.add("//eu.quanticol.carma.core.generator.ms.function.javanise.CarmaBoolean")}
			Range: pts.array(array)
		}
	}
	
	def void array(Range pt, ArrayList<String> array) {
		for(var i = pt.min; i <= pt.max; i++){
			array.add(""+i)
		}
	}
	
	def String javanise(Expressions e) {
		switch (e) {
			Or: 						{e.javanise}
			And:						{e.javanise}
			Equality: 					{e.javanise}
			Comparison: 				{e.javanise}
			Subtraction: 				{e.javanise}
			Addition: 					{e.javanise}
			Multiplication: 			{e.javanise}
			Modulo: 					{e.javanise}
			Division: 					{e.javanise}
			Not: 						{e.javanise}
			AtomicPrimitive: 			{e.javanise}
			AtomicVariable: 			{e.javanise}
			AtomicCalls: 				{e.javanise}
			AtomicNow: 					{"//eu.quanticol.carma.core.generator.ms.collective.javanise.Now"}
			AtomicMeasure: 				{"//eu.quanticol.carma.core.generator.ms.collective.javanise.AtomicOutcome"}
			AtomicRecord: 				{e.javanise}
			AtomicOutcome: 				{"//eu.quanticol.carma.core.generator.ms.collective.javanise.AtomicOutcome"}
			AtomicProcessComposition:	{e.javanise}
		}
	}
	
	def String javanise(BaseType bt){
		if(bt.me.equals("int")){
			'''Integer.class'''
		} else {
			'''«bt.me».class'''
		}
	}
	
	def String javanise(OutputActionArgument oaa){
		switch (oaa.value) {
			VariableReferenceMy: 		(oaa.value as VariableReference).javanise
			RecordReferenceMy: 			(oaa.value as VariableReference).javanise
			CarmaInteger:				(oaa.value as CarmaInteger).javanise
		}
	}

	def String javanise(Or e) {
		'''(«e.left.javanise» || «e.right.javanise»)'''
	}

	def String javanise(And e) {
		'''(«e.left.javanise» && «e.right.javanise»)'''
	}

	def String javanise(Equality e) {
		'''(«e.left.javanise» «e.op» «e.right.javanise»)'''
	}

	def String javanise(Comparison e) {
		'''(«e.left.javanise» «e.op» «e.right.javanise»)'''
	}	

	def String javanise(Subtraction e) {
		'''(«e.left.javanise» - «e.right.javanise»)'''
	}

	def String javanise(Addition e) {
		'''(«e.left.javanise» - «e.right.javanise»)'''
	}

	def String javanise(Multiplication e) {
		'''(«e.left.javanise» * «e.right.javanise»)'''
	}

	def String javanise(Modulo e) {
		'''(«e.left.javanise» % «e.right.javanise»)'''
	}

	def String javanise(Division e) {
		'''(«e.left.javanise» / «e.right.javanise»)'''
	}
	
	def String javanise(Not e) {
		'''!(«e.expression.javanise»)'''
	}
	
	def String javanise(AtomicPrimitive e) {
		e.value.javanise
	}
	
	def String javanise(PrimitiveTypes pts) {
		switch (pts) {
			CarmaDouble: "//eu.quanticol.carma.core.generator.ms.function.javanise.CarmaDouble"
			CarmaInteger: pts.javanise
			CarmaBoolean: "//eu.quanticol.carma.core.generator.ms.function.javanise.CarmaBoolean"
			Range: "//eu.quanticol.carma.core.generator.ms.function.javanise.Range"
		}
	}
	
	def String javanise(CarmaInteger pt) {
		if (pt.negative != null)
			return "-" + pt.value
		else
			return "" + pt.value
	}
	
	def String javanise(AtomicVariable expression) {
		expression.value.javanise
	}
	
	def String javanise(VariableReference vr) {
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
	
	def String javanise(AtomicCalls expression) {
		expression.value.javanise
	}

	def String javanise(Calls calls) {
		switch (calls) {
			FunctionReferenceMan: calls.ref.javanise
			FunctionReferencePre: calls.ref.javanise
		}
	}

	def String javanise(FunctionCall functionCall) {
		'''
			«(functionCall.name as Name).name»(«(functionCall.arguments as FunctionCallArguments).javanise»);
		'''
	}
	
	def String javanise(FunctionCallArguments arguments){
			var ArrayList<FunctionArgument> args = new ArrayList<FunctionArgument>(arguments.eAllOfType(FunctionArgument))
			var toReturn = ""
			if(args.size > 0){
				toReturn = toReturn + args.get(0).javanise
				for(var i = 1; i < args.size; i++){
					toReturn = toReturn + ", " + args.get(i).javanise
				}
			}
			return toReturn
	}
	
	def String javanise(FunctionArgument argument){
		argument.value.javanise
	}
	
	def String javanise(PreFunctionCall preFunctionCall) {
		switch (preFunctionCall) {
			PDFunction:			{'''pdf(«(preFunctionCall.arguments as PredFunctionCallArguments).javanise»)'''}
			UniformFunction:	{'''uniform(«(preFunctionCall.arguments as PredFunctionCallArguments).javanise»)'''}
			CeilingFunction:	{'''ceil(«(preFunctionCall.arguments as PredFunctionCallArguments).javanise»)'''}
			FloorFunction:		{'''floor(«(preFunctionCall.arguments as PredFunctionCallArguments).javanise»)'''}
			MaxFunction:		{'''max(«(preFunctionCall.arguments as PredFunctionCallArguments).javanise»)'''}
			MinFunction:		{'''min(«(preFunctionCall.arguments as PredFunctionCallArguments).javanise»)'''}		
		}
	}
	
	def String javanise(PredFunctionCallArguments arguments){
			var ArrayList<PreArgument> args = new ArrayList<PreArgument>(arguments.eAllOfType(PreArgument))
			var toReturn = '''new ArrayList<Object>(Arrays.asList('''
			if(args.size > 0){
				toReturn = toReturn + '''«args.get(0).javanise»'''
				for(var i = 1; i < args.size; i++){
					toReturn = toReturn + ''', «args.get(i).javanise»'''
				}
			}
			return toReturn + "))"
	}
	
	def String javanise(PreArgument argument){
		argument.value.javanise
	}
	
	def String javanise(AtomicRecord expression){
		var instance = (expression.value as InstantiateRecord)
		'''new «(instance.type as Type).javanise» ( «(instance.arguments as RecordArguments).javanise» )'''
	}
	
	def String javanise(Types types){
		types.type.javanise
	}
	
	def String javanise(Type type){
		switch(type){
			DoubleType: "double"
			IntgerType: "int"
			AttribType: "int"
			RecordType: type.name.name
		}
	}
	
	def String javanise(RecordArguments arguments){
			var ArrayList<RecordArgument> args = new ArrayList<RecordArgument>(arguments.eAllOfType(RecordArgument))
			var toReturn = ""
			if(args.size > 0){
				toReturn = toReturn + args.get(0).javanise
				for(var i = 1; i < args.size; i++){
					toReturn = toReturn + ", " + args.get(i).javanise
				}
			}
			return toReturn
	}
	
	def String javanise(RecordArgument argument){
		argument.value.javanise
	}
	
	def String javanise(AtomicProcessComposition expression){
		'''new ArrayList<String>(Arrays.asList( «expression.value.javanise» ))'''
	}
	
	def String javanise(ProcessComposition processComposition){
		switch(processComposition){
			ParallelComposition	: 	'''«processComposition.left.javanise», «processComposition.right.javanise»'''
			ProcessReference	:	'''"«processComposition.expression.name»"'''
		}
	}
		
	def void cartesianProduct(ArrayList<ArrayList<String>> in, ArrayList<ArrayList<String>> out){
		if(in.size() > 1){
			var ArrayList<String> head = in.remove(0);
			var ArrayList<ArrayList<String>> exit = new ArrayList<ArrayList<String>>();
			cartesianProduct(in,out);
			for(var int i = 0; i < out.size(); i++){
				for(String item : head){
					var ArrayList<String> inter = new ArrayList<String>();
					inter.add(item);
					inter.addAll(out.get(i));
					exit.add(inter);
				}
			}
			out.clear();
			out.addAll(exit);
		} else {
			var ArrayList<String> head = in.remove(0);
			for(String item : head){
				var ArrayList<String> tail = new ArrayList<String>();
				tail.add(item);
				out.add(tail);
			}
		}
	}
	
	def String javanise(ComponentForVariableDeclaration componentForVariableDeclaration){
		'''«(componentForVariableDeclaration.type as Type).javanise» «componentForVariableDeclaration.name.name» = «componentForVariableDeclaration.assign.javanise»'''
	}
	
	def String javanise(BooleanExpression expression) {
		expression.expression.javanise
	}
	
	def String javanise(ComponentAssignment componentAssignment){
		'''«componentAssignment.reference.javanise» = «componentAssignment.expression.javanise»'''
	}
	
	def String javanise(ComponentExpression componentExpression){
		componentExpression.expression.javanise
	}
	
	def String setStore(Declaration declaration){
		switch(declaration){
			AttribVariableDeclaration	: declaration.setStore
			RecordDeclaration			: declaration.setStore
		}
	}
	
	def String setStore(AttribVariableDeclaration attribVariableDeclaration){
		'''"«attribVariableDeclaration.name.name»", «attribVariableDeclaration.assign.javanise»'''
	}
	
	def String setStore(RecordDeclaration recordDeclaration){
		'''"«recordDeclaration.name.name»", «recordDeclaration.assign.javanise»'''
	}
	
	def String getParameters(ArrayList<Parameter> parameters){
		var String toReturn = ""
		if(parameters.size > 0){
			toReturn = parameters.get(0).getParameter
			for(var i = 1; i < parameters.size; i++){
				toReturn = toReturn + ", " + parameters.get(i).getParameter
			}
		}
		return toReturn
	}
	
	def String getParameter(Parameter parameter){
		switch(parameter){
			AttribParameter: '''«(parameter.type as AttribType).javanise» «parameter.name.name»'''
			RecordParameter: '''«(parameter.type as RecordType).javanise» «parameter.name.name»'''
			ProcessParameter: '''ArrayList<String> behaviour'''
		}
	}
	
	def void array(ProcessComposition processComposition, ArrayList<String> array){
		switch(processComposition){
			ParallelComposition	: 	{processComposition.left.array(array) processComposition.right.array(array)}
			ProcessReference	:	array.add(processComposition.expression.name)
		}
	}
	
	def String javanise(ArrayList<String> behaviours){
		var String toReturn = ""
		if(behaviours.size > 0){
			toReturn = behaviours.get(0)
			for(var i = 1; i < behaviours.size; i++)
				toReturn = toReturn + ", " + behaviours.get(i)
		}
		return toReturn
	}

}