package edu.rpi.twc.dcods.vivo;

import edu.cornell.mannlib.vitro.webapp.config.ConfigurationProperties;
import javax.servlet.ServletContext;

public class ServerInfo {

	private static ServerInfo instance = null;
	private String baseURL  = "DCO.baseURL";
	private String handleURL = "DCO.handleURL";
	private String ckanURL = "DCO.ckanURL";
	private String dcoURI = "DCO.URI";
	private String defaultNamespace = "Vitro.defaultNamespace";
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

	public String getRootName( ServletContext ctx )
	{
		return getProperty( this.rootName, ctx ) ;
	}
	
	public String getRootPassword( ServletContext ctx )
	{
		return getProperty( this.rootPassword, ctx ) ;
	}
	
	public String getHandleURL( ServletContext ctx )
	{
		return getProperty( this.handleURL, ctx ) ;
	}
	
	public String getCkanURL( ServletContext ctx ){
		return getProperty( this.ckanURL, ctx ) ;
	}
	
	public String getDCOURI( ServletContext ctx )
	{
		return getProperty( this.dcoURI, ctx ) ;
	}
	
	public String getDefaultNamespace( ServletContext ctx )
	{
		return getProperty( this.defaultNamespace, ctx ) ;
	}

	public String getBaseURL( ServletContext ctx )
	{
		return getProperty( this.baseURL, ctx ) ;
	}

	public String getEndpoint( ServletContext ctx )
	{
		return getProperty( this.endpoint, ctx ) ;
	}

	public String getSparqlUpdateAPI( ServletContext ctx )
	{
		return getProperty( this.sparqlEndpointAPI, ctx ) ;
	}

	public String getSparqlQueryAPI( ServletContext ctx )
	{
		return getProperty( this.sparqlQueryAPI, ctx ) ;
	}
}
