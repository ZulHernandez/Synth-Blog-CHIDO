/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class cMD5 {

    //algoritmos
    public final String MD2="MD2";
    public final String MD5="MD5";
    public final String SHA1="SHA-1";
    public final String SHA256="SHA-256";
    public final String SHA384="SHA-384" ;
    public final String SHA512="SHA-512";
    
    public String toHexadecimal(byte[] digest){
        String hash = "";
        for(byte aux : digest) {
            int b = aux & 0xff;
            if (Integer.toHexString(b).length() == 1) hash += "0";
            hash += Integer.toHexString(b);
        }
        return hash; 
    }
    public  String getStringMessageDigest(String message, String algorithm){
        byte[] digest = null;
        byte[] buffer = message.getBytes();
        try {
            MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
            messageDigest.reset();
            messageDigest.update(buffer);
            digest = messageDigest.digest();
        } catch (NoSuchAlgorithmException ex) {
            System.out.println("Error creando Digest");
        }
        return toHexadecimal(digest);
    } 
    /*public static void main(String[] args) {
        String mensaje = "FelisaHF";
        System.out.println("Mensaje = " + mensaje);
        System.out.println("MD2 = " + StringMD.getStringMessageDigest(mensaje, StringMD.MD2));
        System.out.println("MD5 = " + StringMD.getStringMessageDigest(mensaje, StringMD.MD5));
        System.out.println("MD5 = " + StringMD.getStringMessageDigest("4IM7", StringMD.MD5));
        System.out.println("SHA-1 = " + StringMD.getStringMessageDigest(mensaje, StringMD.SHA1));
        System.out.println("SHA-256 = " + StringMD.getStringMessageDigest(mensaje, StringMD.SHA256));
        System.out.println("SHA-384 = " + StringMD.getStringMessageDigest(mensaje, StringMD.SHA384));
        System.out.println("SHA-512 = " + StringMD.getStringMessageDigest(mensaje, StringMD.SHA512));
    }*/
   
}