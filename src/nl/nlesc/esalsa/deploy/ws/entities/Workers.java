package nl.nlesc.esalsa.deploy.ws.entities;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;


@XmlRootElement
public class Workers {
    @XmlElement(name="rows")
    private List<Worker> workers;
    @XmlElement
    private int total = 0;

    public Workers() {
        workers = new ArrayList<Worker>();
    }

    public void add(Worker worker) {
        workers.add(worker);
        total++;
    }
}
