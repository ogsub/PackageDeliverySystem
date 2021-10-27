package rs.etf.sab;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DB {
    
    private static final String username="sa";
    private static final String password="123";
    private static final String database="TransportPaketa";
    private static final int port=1433;
    private static final String server="localhost";

    private static final String connectionUrl = 
        "jdbc:sqlserver://" + server + ":" + port + ";databaseName=" + database; //+ ";integratedSecurity=true";
    //private static final String url ="jdbc:sqlserver://PC01\inst01;databaseName=DB01;integratedSecurity=true";

    private Connection connection;

    public Connection getConnection(){
        return connection;
    }
    

    private DB(){
        try {
            connection=DriverManager.getConnection(connectionUrl, username, password);
        	//connection=DriverManager.getConnection(connectionUrl);
        } catch (SQLException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    

    private static DB db=null;
    public static DB getInstance(){
        if(db==null)
            db=new DB();
        return db;
    }
}