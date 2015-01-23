/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package stubs.edu.cornell.mannlib.vitro.webapp.utils.developer;

import javax.servlet.ServletContext;

import edu.cornell.mannlib.vitro.webapp.utils.developer.DeveloperSettings;

/**
 * Do everything that a standard DeveloperSettings would do, except loading from
 * a properties file.
 * 
 * That way, we don't require ConfigurationProperties to find the Vitro home
 * directory, so we don't throw errors if there is no ConfigurationProperties.
 */
public class DeveloperSettingsStub {
}
