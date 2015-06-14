/*
* generated by Xtext
*/
package eu.quanticol.carma.core.ui.labeling

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.Model
import eu.quanticol.carma.core.utils.LabelUtil
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider
import eu.quanticol.carma.core.carma.MethodDefinition
import eu.quanticol.carma.core.carma.Methods
import eu.quanticol.carma.core.carma.ComponentStyle
import eu.quanticol.carma.core.carma.ComponentBlockDefinition
import eu.quanticol.carma.core.carma.MeasureBlock
import eu.quanticol.carma.core.carma.BlockSystem
import eu.quanticol.carma.core.carma.Name
import eu.quanticol.carma.core.carma.BooleanExpression
import eu.quanticol.carma.core.carma.Measure
import eu.quanticol.carma.core.generator.ExpressionHandler

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 */
class CARMALabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}
	
	@Inject extension LabelUtil
	@Inject extension ExpressionHandler

	// Labels and icons can be computed like this:
	
	def text(Model x) {
		x.label
	}
	
	def text(Methods x){
		x.label
	}
	
	def text(MethodDefinition x){
		x.label 
	}
	
	def text(ComponentStyle x){
		x.label
	}
	
	def text(ComponentBlockDefinition x){
		x.label
	}
	
	def text(MeasureBlock x){
		x.label
	}
	
	def text(BlockSystem x){
		x.label
	}

	def text(Name x){
		x.label
	}
	
	def text(BooleanExpression x){
		x.disarmExpression
	}
	
}
