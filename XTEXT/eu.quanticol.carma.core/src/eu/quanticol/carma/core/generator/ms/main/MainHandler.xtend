package eu.quanticol.carma.core.generator.ms.main

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.carma.Range
import java.util.ArrayList

class MainHandler {
	
//	@Inject extension MeasureJavaniser
//	@Inject extension MainJavaniser
//	
//	def String getMain(Model model, System system){
//		var measureBlock = (model.components as BlockStyle).measures
//		'''
//		public static void main( String[] argv ) {
//			SimulationEnvironment<CarmaSystem> system = new SimulationEnvironment<CarmaSystem>(
//				new «(system as BlockSystem).name.name»ModelFactory()
//			);
//		
//			int deadline = 50; 
//			SamplingCollection<CarmaSystem> sc = new SamplingCollection<CarmaSystem>();
//
//			«measureBlock.printMeasures»
//			
//			system.setSampling(sc);
//			system.simulate(100,50);
//			for(int i = 0; i < sc.size(); i++){
//				((StatisticSampling<CarmaSystem>) sc.get(i)).printName(System.out);
//				System.out.println();
//				((StatisticSampling<CarmaSystem>) sc.get(i)).printTimeSeries(System.out);
//			}
//		}
//		'''
//	}
//	
//	def String printMeasures(MeasureBlock measureBlock){
//		'''
//		«IF measureBlock != null»
//		«FOR measure : measureBlock.measures»
//		«measure.printMeasure»
//		«ENDFOR»
//		«ENDIF»
//		'''
//	}
//	
//	def String printMeasure(Measure measure){
//		var products = new ArrayList<ArrayList<String>>()
//		(measure.ranges as MeasureVariableDeclarations).product.cartesianProduct(products)
//		'''
//		«measure.declare»
//		«FOR product : products»
//		«FOR arg : measure.ranges.asArguments(product,measure)»
//		«arg»
//		«ENDFOR»
//		«measure.addSamplingFunction»
//		«ENDFOR»
//		'''
//	}
//	
//	
//
//	def String addSamplingFunction(Measure measure){
//		'''sc.addSamplingFunction(new StatisticSampling<CarmaSystem>(deadline+1, 1.0, getMeasure«(Math.abs(measure.measure.hashCode*measure.measure.hashCode)+"").substring(0,3)»("«measure.name.name»",«measure.measure.predicate.disarmOut»)));'''	
//	}
//	
//	def String declare(Measure measure){
//		'''
//		«measure.measure.predicate.declare»
//		'''
//	}
//	
//	def ArrayList<String> asArguments(MeasureVariableDeclarations measureVariableDeclarations, ArrayList<String> args, Measure measure){
//		var ArrayList<String> toReturn = new ArrayList<String>()
//		var ArrayList<String> check = measure.measure.predicate.list
//		for(var i = 0; i < args.size; i++){
//			if(check.contains("input_"+(measureVariableDeclarations.variables.get(i) as MeasureVariableDeclaration).name.name))
//				toReturn.add('''input_«(measureVariableDeclarations.variables.get(i) as MeasureVariableDeclaration).name.name» = «args.get(i)»;''')
//		}
//		return toReturn
//	}

}