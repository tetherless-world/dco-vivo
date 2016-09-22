package edu.rpi.twc.dcods.vivo;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.servlet.ServletContext;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

public class DCOId {

	static final Log log = LogFactory.getLog(DCOId.class );

	private String dcoId;
	public final String createCommand = "create";
	public final String updateCommand = "update";
	public final String modifyUrlCommand = "modifyurl";
	
	public DCOId() {}
	
	/** generate dco id with the url as the target 
	 *  @param url the target url of dco id
	 * */
	public void generateDCOId( String url, ServletContext ctx )
	{
		this.operate( url, "URL", this.createCommand, ctx );
	}
	
	/** generate dco id with empty target */
	public void generateDCOId( ServletContext ctx ){
		this.operate("", "URL", this.createCommand, ctx );
	}

	public void modifyDCOId( String URL, ServletContext ctx )
	{
		operate( URL, "URL", this.modifyUrlCommand, ctx ) ;
	}
	
	/** return dcoId */
	public String getDCOId() {
		return this.dcoId;
	}
    
	/** In case dcoId starts with http://dx.deepcarbon.../ while updating the record, we need to remove the string before 11121 */
	public String cleanDCOID(String dcoid){
		String cleanID = null;

		if(dcoid!=null){
			String prefix = "11121";
			cleanID = "";
			if(dcoid.contains(prefix)){	
				String[] allParts = dcoid.split(prefix);
				if(allParts.length>1){
					cleanID = prefix + allParts[1];
				}else{
					cleanID = dcoid;
				}
			}else{
				cleanID = dcoid;
			}
		}
		return cleanID;
	}

	/** update the dcoid by three operations: create, modify, update. 
	 * 
	 * @param urlParameters target url of dco id
	 * @param type type of target
	 * @param command command indicates to create, modify or update
	 */
	private void operate( String urlParameters, String type, String command, ServletContext ctx )
	{
        log.debug("DCOId operate command = " + command);
        log.debug("parameters = " + urlParameters);
        log.debug("type = " + type);
		log.debug("the current id is "+this.dcoId);

		urlParameters = "<handle><id>" + this.cleanDCOID(this.dcoId)+ "</id><type>" + type + "</type><value>" + urlParameters + "</value></handle>";
		log.debug("request string = " + urlParameters);

		String handleURL = ServerInfo.getInstance().getHandleURL( ctx ) ;
		String requestUrl = handleURL + command;
		log.debug("request url: " + requestUrl);

		URL url;
	    HttpURLConnection connection = null;  
	    try {
	    	//Create connection
	    	url = new URL(requestUrl);
	    	connection = (HttpURLConnection)url.openConnection();
			if(connection == null) {
				throw new Exception("Unable to create the connection");
			}

	    	connection.setRequestMethod("POST");
	    	connection.setRequestProperty("Content-Type", "application/xml");
	    	connection.setRequestProperty("Content-Length", ""
	    		+ Integer.toString(urlParameters.getBytes().length));
	    	connection.setRequestProperty("Content-Language", "en-US");	
	    	connection.setUseCaches (false);
	    	connection.setDoInput(true);
	    	connection.setDoOutput(true);

	    	//Send request
	    	DataOutputStream wr = new DataOutputStream (connection.getOutputStream ());
			if(wr == null) {
				throw new Exception("Unable to get the output stream for the connection");
			}

	    	wr.writeBytes (urlParameters);
	    	wr.flush ();
	    	wr.close ();

			log.info("handle connection returned code " + connection.getResponseCode() + " " + connection.getResponseMessage());

	    	//Get Response
	    	InputStream is = connection.getInputStream();
			if(is == null) {
				throw new Exception("Unable to get the input stream from the connection");
			}

	    	BufferedReader rd = new BufferedReader(new InputStreamReader(is));

	    	String line;
	    	StringBuffer response = new StringBuffer(); 
	    	while((line = rd.readLine()) != null) {
	    		response.append(line);
	    		response.append('\r');
	    	}
	    	rd.close();

	    	//Parse xml to get the <id> property
	    	String xmlString = response.toString();
			log.debug("response from dco handle service is " + xmlString);

	    	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    	DocumentBuilder builder;

            /*july 25, 2013, boliang
             * add condition statement to avoid parse xml string not starint with "<?xml ....".
             */
            if (xmlString != null && xmlString.startsWith("<?xml")) {
                try {
                    builder = factory.newDocumentBuilder();
                    Document document = builder.parse(new InputSource(new StringReader( xmlString ) ) );
                    Element handleElement = (Element) document.getElementsByTagName("handle").item(0);
                    this.dcoId = handleElement.getElementsByTagName("id").item(0).getTextContent();
                    log.info("New dcoId " + this.dcoId);
                } catch (Exception e) {
                    e.printStackTrace();
                    this.dcoId = null;
                }
            } else {
				throw new Exception("Response from handle service is not xml");
			}
	    } catch (Exception e) {
			log.error("Failed to generate a DCOId " + e.getMessage());
	    	e.printStackTrace();
	    } finally {
	    	if(connection != null) {
	    		connection.disconnect(); 
	    	}
	    }    
	}
}
