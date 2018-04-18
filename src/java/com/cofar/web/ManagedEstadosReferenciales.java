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
public class ManagedEstadosReferenciales {
    
    /** Creates a new instance of ManagedEstadosReferenciales */
    private String nombreEstadoRegistro="";
    private String codEstadoRegistro="";
    private List estadosReferenciales=new ArrayList();
    private Connection con;
    public ManagedEstadosReferenciales() {
       
    }

    public String getCodEstadoRegistro() {
        return codEstadoRegistro;
    }

    public void setCodEstadoRegistro(String codEstadoRegistro) {
        this.codEstadoRegistro = codEstadoRegistro;
    }
    
    public List getEstadosReferenciales() {
        
        try {
            con=Util.openConnection(con);
            String sql="select cod_estado_registro,nombre_estado_registro from  estados_referenciales ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            estadosReferenciales.clear();
            while (rs.next()){
                String codigo=rs.getString(1);
                String nombre=rs.getString(2);
                estadosReferenciales.add(new SelectItem(codigo,nombre));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return estadosReferenciales;
    }

    public void setEstadosReferenciales(List estadosReferenciales) {
        this.estadosReferenciales = estadosReferenciales;
    }
    
}
