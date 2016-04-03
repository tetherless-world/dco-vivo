package edu.rpi.twc.dcods.vivo;

import edu.cornell.mannlib.vitro.webapp.config.ConfigurationProperties;
import javax.servlet.ServletContext;

public class ServerInfo {

	private static ServerInfo instance = null;
	private String baseURL  = "DCO.baseURL";
	private String handleURL = "DCO.handleURL";
	private String ckanURL = "DCO.ckanURL";
	private String ckanApiKey = "DCO.ckanApiKey";
	private String dcoURI = "DCO.URI";
	private String defaultNamespace = "Vitro.defaultNamespace";
	private String baseNamespace = "DCO.baseNamespace";
	private String rootName = "DCO.rootName";
	private String rootPassword = "DCO.rootPassword";
	private String endpoint = "DCO.endpoint";
	private String sparqlEndpointAPI = "DCO.sparqlUpdateAPI";
	private String sparqlQueryAPI = "DCO.sparqlQueryAPI";

	private void ServerInfo()
	{
	}
	
	public static ServerInfo getInstance()
	{
		if( instance==null )
		{
			return new ServerInfo() ;
		} else {
			return instance ;
		}
	}

	private String getProperty( String property, ServletContext ctx )
	{
        if( ctx != null )
            return ConfigurationProperties.getBean(ctx).getProperty(property);
        return "" ;
	}

    /* vivo root email */
	public String getRootName( ServletContext ctx )
	{
		return getProperty( this.rootName, ctx ) ;
	}
	
    /* vivo root password */
	public String getRootPassword( ServletContext ctx )
	{
		return getProperty( this.rootPassword, ctx ) ;
	}
	
    /* DCO Handle Service URL */
	public String getHandleURL( ServletContext ctx )
	{
		return getProperty( this.handleURL, ctx ) ;
	}
	
    /* DCO CKAN base URL. The API URL is appended to this */
	public String getCkanURL( ServletContext ctx ){
		return getProperty( this.ckanURL, ctx ) ;
	}
	
    /* DCO CKAN API Key used to create and modify packages */
	public String getCkanApiKey( ServletContext ctx ){
		return getProperty( this.ckanApiKey, ctx ) ;
	}
	
    /* DCO schema URI */
	public String getDCOURI( ServletContext ctx )
	{
		return getProperty( this.dcoURI, ctx ) ;
	}
	
    /* DCO instance namespace */
	public String getDefaultNamespace( ServletContext ctx )
	{
		return getProperty( this.defaultNamespace, ctx ) ;
	}

    /* in some cases want to replace the default namespace with this namespace when going to profile pages */
	public String getBaseNamespace( ServletContext ctx )
	{
		return getProperty( this.baseNamespace, ctx ) ;
	}

    /* Base URL for VIVO */
	public String getBaseURL( ServletContext ctx )
	{
		return getProperty( this.baseURL, ctx ) ;
	}

    /* Fuseki endpoint */
	public String getEndpoint( ServletContext ctx )
	{
		return getProperty( this.endpoint, ctx ) ;
	}

    /* VIVO SPARQL update URL */
	public String getSparqlUpdateAPI( ServletContext ctx )
	{
		return getProperty( this.sparqlEndpointAPI, ctx ) ;
	}

    /* VIVO SPARQL query URL */
	public String getSparqlQueryAPI( ServletContext ctx )
	{
		return getProperty( this.sparqlQueryAPI, ctx ) ;
	}
}
