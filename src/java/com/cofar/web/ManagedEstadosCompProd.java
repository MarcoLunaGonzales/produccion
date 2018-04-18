/*
 * ManagedEstadosReferenciales.java
 *
 * Created on 9 de abril de 2008, 10:37
 */

package com.cofar.web;

import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;

/**
 *
 * @author Wilmer Manzaneda Chavez
 * @company COFAR
 */
public class ManagedEstadosCompProd {
    
    /** Creates a new instance of ManagedEstadosReferenciales */
    private String nombreEstadoCompProd="";
    private String codEstadoCompProd="";
    private List estadosCompProd=new ArrayList();
    private Connection con;
    public ManagedEstadosCompProd() {
       
    }

    public String getNombreEstadoCompProd() {
        return nombreEstadoCompProd;
    }

    public void setNombreEstadoCompProd(String nombreEstadoCompProd) {
        this.nombreEstadoCompProd = nombreEstadoCompProd;
    }

    public String getCodEstadoCompProd() {
        return codEstadoCompProd;
    }

    public void setCodEstadoCompProd(String codEstadoCompProd) {
        this.codEstadoCompProd = codEstadoCompProd;
    }

    public List getEstadosCompProd() {
         try {
            con=Util.openConnection(con);
            String sql="select e.COD_ESTADO_COMPPROD,e.NOMBRE_ESTADO_COMPPROD  from ESTADOS_COMPPROD e";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            estadosCompProd.clear();
            while (rs.next()){
                String codigo=rs.getString(1);
                String nombre=rs.getString(2);
                estadosCompProd.add(new SelectItem(codigo,nombre));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return estadosCompProd;
    }

    public void setEstadosCompProd(List estadosCompProd) {
        this.estadosCompProd = estadosCompProd;
    }

    public Connection getCon() {
        return con;
    }

    public void setCon(Connection con) {
        this.con = con;
    }

   
}
