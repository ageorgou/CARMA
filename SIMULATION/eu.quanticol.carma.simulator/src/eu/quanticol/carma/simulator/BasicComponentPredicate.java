/**
 * 
 */
package eu.quanticol.carma.simulator;

import java.util.LinkedList;

/**
 * @author loreti
 *
 */
public class BasicComponentPredicate implements ComponentPredicate {

	private final CarmaProcessPredicate[] states;
	private final CarmaPredicate guard;
	
	public BasicComponentPredicate( CarmaPredicate guard , CarmaProcessPredicate ... states  ) {
		this.states = states;
		this.guard = guard;
	}
	
	@Override
	public boolean eval(CarmaComponent c) {
		if (this.guard.satisfy(c.store)) {
			boolean[] foo = new boolean[c.processes.size()];
			for( int i=0 ; i<states.length ; i++ ) {
				boolean flag = false;
				for( int j=0 ; (j<c.processes.size())&&!flag ; j++ ) {
					if ((!foo[j])&&
						states[j].eval( c.processes.get(j) )) {
							foo[j] = true;
							flag = true;
					}
				}
				if (!flag) {
					return false;
				}
			}
			return true;
		}
		return false;
	}

}