/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package BD;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * MIA
 */
public class cDatos {private final int MYSQL = 0;
    private final int POSTGRESQL = 1;
    private final int MARIADB = 2;
    private final int SQLSERVER = 3;
    
    private String usrBD;
    private String passBD;
    private String urlBD;
    private String driverClassName;
    private Connection conn = null;
    private Statement estancia;
    private int suich;
 
    public cDatos(String usuarioBD, String passwordBD, String url, String driverClassName) {
        this.usrBD = usuarioBD;
        this.passBD = passwordBD;
        this.urlBD = url;
        this.driverClassName = driverClassName;
    }
    public cDatos(int suich) {
        this.suich = suich;
        if(suich == MYSQL){
            //MySQL
            this.usrBD = "root";
            this.passBD = "n0m3l0";
            this.urlBD = "jdbc:mysql://localhost:3306/snth";
            this.driverClassName = "com.mysql.jdbc.Driver";
        }else
        if(suich == POSTGRESQL){
            //PostgreSQL
            this.usrBD = "postgres";
            this.passBD = "n0m3l0";
            this.urlBD = "jdbc:postgresql://localhost:5432/synth";
            this.driverClassName = "org.postgresql.Driver";
        }else
        if(suich == MARIADB){
            //MariaDB
            this.usrBD = "root";
            this.passBD = "n0m3l0";
            this.urlBD = "jdbc:mariadb://192.168.1.114:3306/synth";
            this.driverClassName = "org.mariadb.jdbc.Driver";
        }else
        if(suich == SQLSERVER){
            //SQL server
            this.usrBD = "root";
            this.passBD = "n0m3l0";
            this.urlBD = "jdbc:sqlserver://127.0.0.1\\SQLEXPRESS;databaseName=synth;";
            this.driverClassName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        }
    }
    
    //metodos para establecer los valores de conexion a la BD
    public void setUsuarioBD(String usuario) throws SQLException {
        this.usrBD = usuario;
    }
    public void setPassBD(String pass) {
        this.passBD = pass;
    } 
    public void setUrlBD(String url) {
        this.urlBD = url;
    }
    public void setConn(Connection conn) {
        this.conn = conn;
    }
    public void setDriverClassName(String driverClassName) {
        this.driverClassName = driverClassName;
    }
    
    //Conexion a la BD
    public void conectar() throws SQLException {
        try {
            Class.forName(this.driverClassName).newInstance();
            this.conn = DriverManager.getConnection(this.urlBD, this.usrBD, this.passBD);
        } catch (Exception err) {
            System.out.println("Error " + err.getMessage());
        }
    }
    
    //Cerrar la conexion de BD
    public void cierraConexion(){
        try
        {
            this.conn.close();
        }catch(SQLException e)
        {
            System.out.println("Error al cerrar conexión: "+e.getMessage());
        }
    }
    
    //Metodos para ejecutar sentencias SQL
    public ResultSet consulta(String consulta) throws SQLException {
        this.estancia = (Statement) conn.createStatement();
        consulta=consulta.replace("<","&lt;").replace(">", "&gt;");
        
        //sql server no utiliza call por eso hacemos un replace para el call y ()
        if(this.suich == SQLSERVER){
            consulta = consulta.replace("call", "").replace("(", "").replace(")", "");
        }else
        if(this.suich == POSTGRESQL){
            consulta = consulta.replace("call ", "select * from ");
        }
        return this.estancia.executeQuery(consulta);
    } 
    public void actualizar(String actualiza) throws SQLException {
        this.estancia = (Statement) conn.createStatement();
        estancia.executeUpdate(actualiza);
    } 
    public ResultSet borrar(String borra) throws SQLException {
        Statement st = (Statement) this.conn.createStatement();
        return (ResultSet) st.executeQuery(borra);
    } 
    public int insertar(String inserta) throws SQLException {
        Statement st = (Statement) this.conn.createStatement();
        return st.executeUpdate(inserta);
    }
}