/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import javax.servlet.http.Part;

/**
 *
 * @author Daniel Castillo
 */
public class Utilities {
    public static String saveFile(Part data, String folder, String prefix, String suffix){
        String rutaimagen = "";
        try{
            InputStream isimagen = data.getInputStream();
            Utilities u = new Utilities();
            String absolute = u.getClass().getProtectionDomain().getCodeSource().getLocation().toString(); // traigo dirreccion
            absolute = absolute.substring(5,absolute.indexOf("/web")+4).replace("%20"," ");

            File destinoimagen = new File(absolute + "/" + folder);
            if(!destinoimagen.exists()){
                destinoimagen.mkdirs();
            }
            File[] ficherosimagen = destinoimagen.listFiles();
            int num = ficherosimagen.length + 1;
            File fimagen = new File(destinoimagen +"/"+ prefix + num + suffix);
            System.out.println("Aqui!");
            System.out.println(fimagen);
            rutaimagen = "/Synth_BLOG/"+folder+"/" + prefix + num + suffix;
            System.out.println("rutaimagen");
            FileOutputStream outimagen = new FileOutputStream(fimagen);
            int dataimagen = isimagen.read();
            while(dataimagen != -1){
                outimagen.write(dataimagen);
                dataimagen = isimagen.read();
            }
            isimagen.close();
            outimagen.close();
        }catch(Exception e){
            rutaimagen = e.getMessage();
        }
        return rutaimagen;
    }
}
