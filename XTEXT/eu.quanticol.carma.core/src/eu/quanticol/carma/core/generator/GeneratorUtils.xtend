package eu.quanticol.carma.core.generator

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.RecordDeclaration
import eu.quanticol.carma.core.carma.RecordReferenceMy
import eu.quanticol.carma.core.carma.RecordReferencePure
import eu.quanticol.carma.core.carma.RecordReferenceReceiver
import eu.quanticol.carma.core.carma.RecordReferenceSender
import eu.quanticol.carma.core.carma.RecordReferenceThis
import eu.quanticol.carma.core.carma.VariableDeclaration
import eu.quanticol.carma.core.carma.VariableDeclarationEnum
import eu.quanticol.carma.core.carma.VariableDeclarationRecord
import eu.quanticol.carma.core.carma.VariableReference
import eu.quanticol.carma.core.carma.VariableReferenceMy
import eu.quanticol.carma.core.carma.VariableReferencePure
import eu.quanticol.carma.core.carma.VariableReferenceReceiver
import eu.quanticol.carma.core.carma.VariableReferenceSender
import eu.quanticol.carma.core.carma.VariableReferenceThis
import eu.quanticol.carma.core.typing.TypeProvider
import eu.quanticol.carma.core.utils.LabelUtil
import eu.quanticol.carma.core.utils.Util

import static extension org.eclipse.xtext.EcoreUtil2.*
import eu.quanticol.carma.core.carma.VariableReferenceGlobal
import eu.quanticol.carma.core.carma.RecordReferenceGlobal
import eu.quanticol.carma.core.carma.Environment

class GeneratorUtils {
	
	@Inject extension TypeProvider
	@Inject extension LabelUtil
	@Inject extension Util
	
	def String declareVariable(VariableReference vr){
		switch(vr){
			VariableReferencePure		: {vr.getStore}
			VariableReferenceMy			: {vr.getStore}
			VariableReferenceThis		: {vr.getStore}
			VariableReferenceReceiver	: {vr.getReceiver}
			VariableReferenceSender		: {vr.getSender}
			RecordReferencePure			: {vr.getStore}
			RecordReferenceMy			: {vr.getStore}
			RecordReferenceThis			: {vr.getStore}
			RecordReferenceReceiver		: {vr.getReceiver}
			RecordReferenceSender		: {vr.getSender}
			VariableReferenceGlobal		: {vr.getGlobal}
			RecordReferenceGlobal		: {vr.getGlobal}
		}
	}
	
	
	def String getStore(VariableReference vr){
		'''
		«var vd = vr.getVariableDeclaration»
		«switch(vd){
		VariableDeclarationEnum:	'''«vd.convertPrimitiveType» «vd.name.label» = store.get("«vd.name.label»" , «vd.convertType».class );'''
		VariableDeclarationRecord:	{
						var rds = vd.eAllOfType(RecordDeclaration)
						'''
						«FOR rd : rds»
						«vd.convertPrimitiveType» «vd.name.label»_«rd.name.label» = store.get("«vd.name.label»_«rd.name.label»" , «vd.convertType».class );
						«ENDFOR»
						'''
					}
				}»
		'''
	}
	
	def String getSender(VariableReference vr){
		'''
		«var vd = vr.getVariableDeclaration»
		«switch(vd){
		VariableDeclarationEnum:	'''«vd.convertPrimitiveType» «vd.name.label»_s = sender.get("«vd.name.label»" , «vd.convertType».class );'''
		VariableDeclarationRecord:	{
						var rds = vd.eAllOfType(RecordDeclaration)
						'''
						«FOR rd : rds»
						«vd.convertPrimitiveType» «vd.name.label»_«rd.name.label»_s = sender.get("«vd.name.label»_«rd.name.label»" , «vd.convertType».class );
						«ENDFOR»
						'''
					}
				}»
		'''
	}
	
	def String getReceiver(VariableReference vr){
		'''
		«var vd = vr.getVariableDeclaration»
		«switch(vd){
		VariableDeclarationEnum:	'''«vd.convertPrimitiveType» «vd.name.label»_r = receiver.get("«vd.name.label»" , «vd.convertType».class );'''
		VariableDeclarationRecord:	{
						var rds = vd.eAllOfType(RecordDeclaration)
						'''
						«FOR rd : rds»
						«vd.convertPrimitiveType» «vd.name.label»_«rd.name.label»_r = receiver.get("«vd.name.label»_«rd.name.label»" , «vd.convertType».class );
						«ENDFOR»
						'''
					}
				}»
		'''
	}
	
	def String getStore(VariableDeclaration vd){
		var output = ""
		switch(vd){
			VariableDeclarationEnum: {
				output = '''«vd.convertPrimitiveType» «vd.name.label» = store.get("«vd.name.label»" , «vd.convertType».class );'''+"\n"
					}
			VariableDeclarationRecord: {
				var rds = vd.eAllOfType(RecordDeclaration)
				for(rd : rds){
						output = output + '''«vd.convertPrimitiveType» «vd.name.label»_«rd.name.label» = store.get("«vd.name.label»_«rd.name.label»" , «vd.convertType».class );'''+"\n"
				}
			}
		}
		return output
	}
	
	def String getGlobal(VariableReference vr){
		'''
		«var vd = vr.getVariableDeclarationEnv»
		«switch(vd){
		VariableDeclarationEnum:	'''«vd.convertPrimitiveType» «vd.name.label» = global_store.get("«vd.name.label»" , «vd.convertType».class );'''
		VariableDeclarationRecord:	{
						var rds = vd.eAllOfType(RecordDeclaration)
						'''
						«FOR rd : rds»
						«vd.convertPrimitiveType» «vd.name.label»_«rd.name.label» = global_store.get("«vd.name.label»_«rd.name.label»" , «vd.convertType».class );
						«ENDFOR»
						'''
					}
				}»
		'''
	}
	
	def String setVariable(VariableReference vr, String variable, String expression){
		switch(vr){
			VariableReferencePure		: {vr.setStore(variable,expression)}
			VariableReferenceMy			: {vr.setStore(variable,expression)}
			VariableReferenceThis		: {vr.setStore(variable,expression)}
			VariableReferenceReceiver	: {vr.setReceiver(variable,expression)}
			VariableReferenceSender		: {vr.setSender(variable,expression)}
			RecordReferencePure			: {vr.setStore(variable,expression)}
			RecordReferenceMy			: {vr.setStore(variable,expression)}
			RecordReferenceThis			: {vr.setStore(variable,expression)}
			RecordReferenceReceiver		: {vr.setReceiver(variable,expression)}
			RecordReferenceSender		: {vr.setSender(variable,expression)}
			VariableReferenceGlobal		: {vr.setGlobal(variable,expression)}
			RecordReferenceGlobal		: {vr.setGlobal(variable,expression)}
		}
	}
	
	def String setStore(VariableDeclaration vd, String expression){
		var output = ""
		switch(vd){
			VariableDeclarationEnum: {
						output = '''store.set("«vd.name.label»",«expression»);'''
					}
					VariableDeclarationRecord: {
						var rds = vd.eAllOfType(RecordDeclaration)
						for(rd : rds){
							output = output + '''store.set("«vd.name.label»_«rd.name.label»",«expression»);'''
						}
					}
				}
		return output
	}
	
	def String setStore(VariableReference vr, String variable, String expression){
		if(vr.getContainerOfType(Environment) != null){
			'''global_store.set("«variable»",«expression»);'''
		} else {
			'''store.set("«variable»",«expression»);'''
		}
		
	}

	def String setReceiver(VariableReference vr, String variable, String expression){
		'''receiver.set("«variable»",«expression»);'''
	}
	
	def String setSender(VariableReference vr, String variable, String expression){
		'''sender.set("«variable»",«expression»);'''
	}
	
	def String setGlobal(VariableReference vr, String variable, String expression){
		'''global_store.set("«variable»",«expression»);'''
	}
	
}