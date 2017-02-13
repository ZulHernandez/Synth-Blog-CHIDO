/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ws;

import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.WebParam;

/**
 *
 * @author Daniel Castillo
 */
@WebService(serviceName = "wsLocal")
public class wsLocal {
    /**
     * This is a sample web service operation
     */
    @WebMethod(operationName = "hello")
    public String hello(@WebParam(name = "name") String txt) {
        return "Hello " + txt + " !";
    }
    @WebMethod(operationName = "getCuenta")
    public String getCuenta(@WebParam(name = "correo") String correo, @WebParam(name = "contra") String contra) {
        String resp = "";
        Clases.cCifrado des=new Clases.cCifrado();
        correo=des.Desencriptar(correo);
        contra=des.Desencriptar(contra);
        ldn.cLogica gatito = new ldn.cLogica();
        resp = Integer.toString(gatito.getLogin(correo, contra));
        if(!gatito.getError().equals("")){
            resp = gatito.getError();
        }
        return resp;
    }
}
