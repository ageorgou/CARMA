package eu.quanticol.carma.core.generator

import org.eclipse.emf.ecore.resource.Resource
import java.util.HashMap

interface Compiler {
	
	def HashMap<String,String> extractJava(Resource resource);
	
}