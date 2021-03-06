/**
 * 
 */
package eu.quanticol.carma.simulator2;

import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.Predicate;

import org.apache.commons.math3.random.RandomGenerator;

/**
 * @author loreti
 *
 */
public class OutputStepData {

	private final Predicate<Store> outputPredicate;
	
	private final Object outputValue;
	
	private final BiFunction<RandomGenerator,Store, Store> storeUpdate;
	
	private final int nextProcessId;
	
	/**
	 * @param outputPredicate
	 * @param outputValue
	 * @param storeUpdate
	 */
	public OutputStepData(Predicate<Store> outputPredicate, Object outputValue, BiFunction<RandomGenerator, Store, Store> storeUpdate, int nextProcessId) {
		super();
		this.outputPredicate = outputPredicate;
		this.outputValue = outputValue;
		this.storeUpdate = storeUpdate;
		this.nextProcessId = nextProcessId;
	}

	/**
	 * @return the outputPredicate
	 */
	public Predicate<Store> getOutputPredicate() {
		return outputPredicate;
	}

	/**
	 * @return the outputValue
	 */
	public Object getOutputValue() {
		return outputValue;
	}

	/**
	 * @return the storeUpdate
	 */
	public BiFunction<RandomGenerator, Store, Store> getStoreUpdate() {
		return storeUpdate;
	}

	/**
	 * @return the nextProcessId
	 */
	public int getNextProcessId() {
		return nextProcessId;
	}

	
}
