/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author Ger
 */
public class cMail {
    private String _error = "";
    private String _para = "marsoftteam15@gmail.com";
    private String _cuerpoMsj = "";
    private String _de = "marsoftteam15@gmail.com";
    private String _titulo = "";

    public String getError() {
        return _error;
    }

    public void setError(String _error) {
        this._error = _error;
    }

    public String getPara() {
        return _para;
    }

    public void setPara(String _para) {
        this._para = _para;
    }

    public String getCueroMsj() {
        return _cuerpoMsj;
    }

    public void setCuerpoMsj(String _cuerpoMsj) {
        this._cuerpoMsj = _cuerpoMsj;
    }

    public String getDe() {
        return _de;
    }

    public void setDe(String _de) {
        this._de = _de;
    }

    public String getTitulo() {
        return _titulo;
    }

    public void setTitulo(String _titulo) {
        this._titulo = _titulo;
    }
    
    public cMail()
    {
        _error = "";
        _para = "marsoftteam15@gmail.com";
        _cuerpoMsj = "";
        _de = "marsoftteam15@gmail.com";
        _titulo = "";
    }
    public boolean mandaMail(String Titulo)
    {
        boolean envio = false;
        this._titulo = Titulo;
        //this._cuerpoMsj = Msj;
        
        try
        {
            
            // Configuracion de la cuenta de envio de mail
            Properties confMail = new Properties();
            confMail.setProperty("mail.smtp.host", "smtp.gmail.com");
            confMail.setProperty("mail.smtp.starttls.enable", "true");
            //confMail.setProperty("mail.smtps.starttls.enable","true");
            confMail.setProperty("mail.smtp.port", "587");
            confMail.setProperty("mail.smtp.user", "marsoftteam15@gmail.com");
            confMail.setProperty("mail.smtp.auth", "true");
            //confMail.setProperty("mail.smtp.ssl.enable","true");
            // Sesion
            Session session = Session.getDefaultInstance(confMail);
            // Creamos el Mail
            MimeMessage correo = new MimeMessage(session);
            correo.setFrom(new InternetAddress(this._de));
            correo.addRecipient(Message.RecipientType.TO, new InternetAddress(this._para));
            correo.setSubject(this._titulo);
            correo.setText(this._cuerpoMsj);

            // Enviamos MAil .
            Transport t = session.getTransport("smtp");
            t.connect("marsoftteam15@gmail.com","tugfaMarsopa");
            t.sendMessage(correo, correo.getAllRecipients());

            // Cerramos conexion.
            t.close();
            envio = true;
        }
        catch (Exception e)
        {
            this._error = e.getMessage();
            System.out.println(e);
        }
        return envio;
    }
    
}