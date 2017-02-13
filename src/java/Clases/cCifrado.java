/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import java.io.IOException;
import java.io.PrintStream;
import java.net.Socket;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Scanner;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;

/**
 *
 * @author Alumno
 */
public class cCifrado {
    
    private final int puerto=9000;
    private final String receptor="127.0.0.1";
    
     public  String Encriptar(String texto) {
 
        String secretKey = "MARSOFT"; //llave para encriptar datos
        String base64EncryptedString = "";
 
        try {
 
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
            byte[] keyBytes = Arrays.copyOf(digestOfPassword, 24);
 
            SecretKey key = new SecretKeySpec(keyBytes, "DESede");
            Cipher cipher = Cipher.getInstance("DESede");
            cipher.init(Cipher.ENCRYPT_MODE, key);
 
            byte[] plainTextBytes = texto.getBytes("utf-8");
            byte[] buf = cipher.doFinal(plainTextBytes);
            byte[] base64Bytes = Base64.encodeBase64(buf);
            base64EncryptedString = new String(base64Bytes);
 
        } catch (Exception ex){
            
            return "Ha habido un problema enviando datos";
        }
        return base64EncryptedString;
    }
      public  String Desencriptar(String textoEncriptado) {
 
        String secretKey = "MARSOFT"; //llave para encriptar datos
        String base64EncryptedString = "";
 
        try {
            byte[] message = Base64.decodeBase64(textoEncriptado.getBytes("utf-8"));
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
            byte[] keyBytes = Arrays.copyOf(digestOfPassword, 24);
            SecretKey key = new SecretKeySpec(keyBytes,"DESede");
 
            Cipher decipher = Cipher.getInstance("DESede");
            decipher.init(Cipher.DECRYPT_MODE, key);
 
            byte[] plainText = decipher.doFinal(message);
 
            base64EncryptedString = new String(plainText, "UTF-8");
 
        } catch (Exception ex) {
        }
        return base64EncryptedString;
    }
      public  String pedirClave(String dato){
        
        String clave="";
        Scanner sc=new Scanner(System.in);
        Socket socket;
        try {
            String ipServidor =receptor;
            int pto=puerto;
            System.out.println("conectando con el servidor...");
                socket = new Socket(ipServidor,pto);
                Scanner entrada = new Scanner(socket.getInputStream());
                PrintStream salidaServer = new PrintStream(socket.getOutputStream());
                salidaServer.println(dato);            
                clave =entrada.nextLine();
                System.out.println("Dato recibido: " + clave);
                socket.close();
                
            
       } catch (IOException ex) {
         System.err.println("Cliente> " + ex.getMessage());
       }
        return clave;
    }
    
}
