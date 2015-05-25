/**
 * 
 */
package eu.quanticol.carma.simulator;

import java.util.HashMap;

/**
 * @author loreti
 *
 */
public class CarmaStore {
	
	private HashMap<String,Object> data;

	public CarmaStore() {
		this.data = new HashMap<String,Object>();
	}
	
	public void set( String attribute , Object value ) {
		data.put( attribute , value );
	}
	
	public <T> T get( String attribute , Class<T> clazz ) {
		Object o = data.get(attribute);
		if ((o != null)&&(clazz.isInstance(o))) {
			return clazz.cast(o);
		}
		return null;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return data.toString();
	}

	
}
