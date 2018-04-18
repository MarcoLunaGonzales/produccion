/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ComponentesProd;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author aquispe
 */

public class ManagedRendimientoProducto extends ManagedBean {
    
    private List<ComponentesProd > componentesProdList=new ArrayList<ComponentesProd>();
    private Connection con=null;
    private ComponentesProd componentesProdEditar=new ComponentesProd();
    /** Creates a new instance of ManagedRendimientoProducto */
    public ManagedRendimientoProducto() {
    }

    public String getCargarRendimientosProductosSemiterminados()
    {
        this.cargarRendimientoProductosSemiterminados();
        return null;
    }
    private void cargarRendimientoProductosSemiterminados()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,cp.RENDIMIENTO_PRODUCTO,"+
                            " ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA"+
                            " from componentes_prod cp inner join AREAS_EMPRESA ae "+
                            " on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                            " where cp.COD_ESTADO_COMPPROD=1 order by cp.nombre_prod_semiterminado";
            ResultSet res=st.executeQuery(consulta);
            componentesProdList.clear();
            while(res.next())
            {
                ComponentesProd nuevo= new ComponentesProd();
                nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.setRendimientoProducto(res.getDouble("RENDIMIENTO_PRODUCTO")*100d);
                componentesProdList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarEdicionRendimientoComponenteProd_action()
    {
        try
        {
            String consulta="UPDATE COMPONENTES_PROD SET   RENDIMIENTO_PRODUCTO ='"+(componentesProdEditar.getRendimientoProducto()/100d)+"'"+
                            " WHERE COD_COMPPROD = '"+componentesProdEditar.getCodCompprod()+"'";
            con=Util.openConnection(con);
            System.out.println("consulta update rendimiento producto "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se edito el rendimiento del producto");
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        this.cargarRendimientoProductosSemiterminados();
        return null;
    }
    public String editarRendimientoComponenteProd_action()
    {
        for(ComponentesProd bean:componentesProdList)
        {
            if(bean.getChecked())
            {
                componentesProdEditar=bean;
            }
        }
        return null;
    }

    public ComponentesProd getComponentesProdEditar() {
        return componentesProdEditar;
    }

    public void setComponentesProdEditar(ComponentesProd componentesProdEditar) {
        this.componentesProdEditar = componentesProdEditar;
    }

    public List<ComponentesProd> getComponentesProdList() {
        return componentesProdList;
    }

    public void setComponentesProdList(List<ComponentesProd> componentesProdList) {
        this.componentesProdList = componentesProdList;
    }
    
}
