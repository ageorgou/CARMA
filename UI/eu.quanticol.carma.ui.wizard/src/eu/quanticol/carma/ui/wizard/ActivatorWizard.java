package eu.quanticol.carma.ui.wizard;

import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.util.Modules;

/**
 * The activator class controls the plug-in life cycle
 */
public class ActivatorWizard extends AbstractUIPlugin {
	
	Injector injector;
	
	public Injector getInjector() {
		return injector;  
	}  
		  
	@Override  
	public void start(BundleContext context) throws Exception {
		super.start(context);
		plugin = this;
		
		injector = Guice.createInjector(
		// Wizard:
		Modules.override(new CARMAUiModuleWizard(this))
		// Workspace etc.:  
	    .with(new org.eclipse.xtext.ui.shared.SharedStateModule()));
	}

	// The plug-in ID
	public static final String PLUGIN_ID = "eu.quanticol.carma.ui.wizard"; //$NON-NLS-1$

	// The shared instance
	private static ActivatorWizard plugin;
	
	/**
	 * The constructor
	 */
	public ActivatorWizard() {
	}

	/*
	 * (non-Javadoc)
	 * @see org.eclipse.ui.plugin.AbstractUIPlugin#start(org.osgi.framework.BundleContext)
	 */
//	public void start(BundleContext context) throws Exception {
//		super.start(context);
//		plugin = this;
//	}

	/*
	 * (non-Javadoc)
	 * @see org.eclipse.ui.plugin.AbstractUIPlugin#stop(org.osgi.framework.BundleContext)
	 */
	public void stop(BundleContext context) throws Exception {
		plugin = null;
		super.stop(context);
	}

	/**
	 * Returns the shared instance
	 *
	 * @return the shared instance
	 */
	public static ActivatorWizard getDefault() {
		return plugin;
	}

	/**
	 * Returns an image descriptor for the image file at the given
	 * plug-in relative path
	 *
	 * @param path the path
	 * @return the image descriptor
	 */
	public static ImageDescriptor getImageDescriptor(String path) {
		return imageDescriptorFromPlugin(PLUGIN_ID, path);
	}
}