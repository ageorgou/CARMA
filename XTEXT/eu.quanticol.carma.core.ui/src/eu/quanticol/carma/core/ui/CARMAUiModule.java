/*
 * generated by Xtext
 */
package eu.quanticol.carma.core.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.ui.wizard.IProjectCreator;

import eu.quanticol.carma.core.ui.wizard.CustomCARMAProjectCreator;

/**
 * Use this class to register components to be used within the IDE.
 */
public class CARMAUiModule extends eu.quanticol.carma.core.ui.AbstractCARMAUiModule {
	public CARMAUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}	
	
	@Override
	public Class<? extends IProjectCreator> bindIProjectCreator() {
		return CustomCARMAProjectCreator.class;
	}
	
	
}
