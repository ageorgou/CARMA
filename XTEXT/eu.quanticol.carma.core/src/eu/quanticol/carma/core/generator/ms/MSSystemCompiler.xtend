package eu.quanticol.carma.core.generator.ms

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.BlockStyle
import eu.quanticol.carma.core.carma.BlockSystem
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.carma.SetComp
import eu.quanticol.carma.core.carma.System
import eu.quanticol.carma.core.generator.ms.collective.CollectiveHandler
import eu.quanticol.carma.core.generator.ms.environment.EnvironmentHandler
import eu.quanticol.carma.core.generator.ms.function.FunctionHandler
import eu.quanticol.carma.core.generator.ms.main.MainHandler
import eu.quanticol.carma.core.generator.ms.measure.MeasureHandler
import eu.quanticol.carma.core.generator.ms.record.RecordHandler
import java.util.ArrayList
import java.util.HashMap

import static extension org.eclipse.xtext.EcoreUtil2.*

class MSSystemCompiler {
	
	
	@Inject extension FunctionHandler
	@Inject extension RecordHandler
	@Inject extension CollectiveHandler
	@Inject extension PredefinedFunctions
	@Inject extension MeasureHandler
	@Inject extension EnvironmentHandler
	@Inject extension MainHandler
	
	public static var SYSTEMNAME = ""
	
	def void extractSystem(System system, Model model, HashMap<String,String> output){
		MSSystemCompiler.SYSTEMNAME = (system as BlockSystem).name.name
		var toReturn = 
			'''
			import org.apache.commons.math3.random.RandomGenerator;
			import org.cmg.ml.sam.sim.SimulationEnvironment;
			import org.cmg.ml.sam.sim.sampling.*;
			import eu.quanticol.carma.simulator.*;
			import java.util.ArrayList;
			import java.util.Arrays;
			import java.util.HashMap;
			import org.cmg.ml.sam.sim.sampling.Measure;
			import org.cmg.ml.sam.sim.sampling.SamplingCollection;
			import org.cmg.ml.sam.sim.sampling.StatisticSampling;
			import org.cmg.ml.sam.sim.DefaultRandomGenerator;
			
			public class «MSSystemCompiler.SYSTEMNAME» extends CarmaSystem {
				
				«getUniform»
				
				«model.functions.printFunctions»
				«model.records.records»
				«(system as BlockSystem).collective.constructor((system as BlockSystem).environment.stores)»
				«(model.components as BlockStyle).components»
				«(model.components as BlockStyle).createProcesses»
				«new ArrayList<SetComp>(model.eAllOfType(SetComp)).getMeasures»
			
				@Override
				public double broadcastProbability(CarmaStore sender, CarmaStore receiver,
						int action) {
					// TODO Auto-generated method stub
					return 0;
				}
				@Override
				public double unicastProbability(CarmaStore sender, CarmaStore receiver,
						int action) {
					// TODO Auto-generated method stub
					return 0;
				}
				@Override
				public double broadcastRate(CarmaStore sender, int action) {
					// TODO Auto-generated method stub
					return 0;
				}
				@Override
				public double unicastRate(CarmaStore sender, int action) {
					// TODO Auto-generated method stub
					return 0;
				}
				@Override
				public void broadcastUpdate(RandomGenerator random, CarmaStore sender,
						int action, Object value) {
					// TODO Auto-generated method stub
					
				}
				@Override
				public void unicastUpdate(RandomGenerator random, CarmaStore sender,
						CarmaStore receiver, int action, Object value) {
					// TODO Auto-generated method stub
					
				}
				«model.getMain(system)»
			}
			'''
		output.put(MSSystemCompiler.SYSTEMNAME+".java",toReturn)
	}
	
}