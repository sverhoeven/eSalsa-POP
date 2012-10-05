package nl.nlesc.esalsa.deploy.ws;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

public class EmbeddedServer {

	static Server server;
	static int port = 8088;

	public static void main(String args[]) throws Exception {
		server = new Server(port);
		server.setHandler(new WebAppContext("webapp", "/"));
		server.start();
	}
}
