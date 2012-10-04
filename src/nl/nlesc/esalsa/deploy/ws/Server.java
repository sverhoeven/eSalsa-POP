package nl.nlesc.esalsa.deploy.ws;

import org.apache.cxf.jaxrs.JAXRSServerFactoryBean;
import org.apache.cxf.jaxrs.lifecycle.SingletonResourceProvider;

public class Server {
    protected Server() throws Exception {
        JAXRSServerFactoryBean sf = new JAXRSServerFactoryBean();
        sf.setResourceClasses(WorkerService.class);
        sf.setResourceProvider(WorkerService.class,
            new SingletonResourceProvider(new WorkerService()));
        sf.setAddress("http://0.0.0.0:9003/");

        sf.create();
    }

    /**
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        new Server();
        System.out.println("Server ready... on http://0.0.0.0:9003/");
    }

}
