/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ConfiguracionSolicitudesMateriales;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;

/**
 *
 * @author aquispe
 */

public class ManagedConfiguracionSolicitudesMateriales extends  ManagedBean {

    private List<ConfiguracionSolicitudesMateriales> configuracionSolicitudesMaterialesList=new ArrayList<ConfiguracionSolicitudesMateriales>();
    private ConfiguracionSolicitudesMateriales  configuracionSolicitudesMaterialesEditar=new ConfiguracionSolicitudesMateriales();
    private Connection con=null;
    private List<SelectItem> areasEmpresaActividadList=new ArrayList<SelectItem>();
    private List<SelectItem> actividadesProduccionList=new ArrayList<SelectItem>();
    

    /** Creates a new instance of ManagedConfiguracionSolicitudesMateriales */
    public ManagedConfiguracionSolicitudesMateriales() {
    }
    public String getCargarConfiguracionSolicitudesMateriales()
    {
        this.cargarActividades();
        this.cargarAreasEmpresaActividad();
        this.cargarConfiguracionSolicitudesMateriales();
        return null;
    }
    private void cargarActividades()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select p.COD_ACTIVIDAD,p.NOMBRE_ACTIVIDAD  from ACTIVIDADES_PRODUCCION p where p.COD_ESTADO_REGISTRO=1 order by p.NOMBRE_ACTIVIDAD";
            actividadesProduccionList.clear();
            ResultSet res=st.executeQuery(consulta);
            while(res.next())
            {
                actividadesProduccionList.add(new SelectItem(res.getString("COD_ACTIVIDAD"),res.getString("NOMBRE_ACTIVIDAD")));
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
    private void cargarAreasEmpresaActividad()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA from AREAS_EMPRESA ae where ae.COD_AREA_EMPRESA in ("+
                            " select distinct afm.COD_AREA_EMPRESA "+
                            " from ACTIVIDADES_FORMULA_MAESTRA afm where afm.COD_ESTADO_REGISTRO=1) order by NOMBRE_AREA_EMPRESA";
            ResultSet res=st.executeQuery(consulta);
            areasEmpresaActividadList.clear();
            areasEmpresaActividadList.add(new SelectItem("0","--NINGUNO--"));
            while(res.next())
            {
                areasEmpresaActividadList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
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
    public String guardarEdicionConfiguracionSolicitudesMateriales_Action()
    {
        try
        {
            con=Util.openConnection(con);
            String consulta="UPDATE CONFIGURACION_SOLICITUDES_MATERIALES SET "+
                            " COD_ACTIVIDAD = '"+configuracionSolicitudesMaterialesEditar.getActividadProduccion().getCodActividad()+"',"+
                            " COD_AREA_EMPRESA_ACTIVIDAD = '"+configuracionSolicitudesMaterialesEditar.getAreaEmpresaActividad().getCodAreaEmpresa()+"'"+
                            " WHERE COD_AREA_EMPRESA_PRODUCTO = '"+configuracionSolicitudesMaterialesEditar.getAreaEmpresaProducto().getCodAreaEmpresa()+"'";
            System.out.println("consulta update configuracion "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo el registro");
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        this.cargarConfiguracionSolicitudesMateriales();
        return null;
    }
    public String editarConfiguracion_Action()
    {
        for(ConfiguracionSolicitudesMateriales bean:configuracionSolicitudesMaterialesList)
        {
            if(bean.getChecked())
            {
                configuracionSolicitudesMaterialesEditar=bean;
            }
        }
        return null;
    }
    private void cargarConfiguracionSolicitudesMateriales()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ISNULL(csm.COD_ACTIVIDAD,0) AS COD_ACTIVIDAD,ISNULL(csm.COD_AREA_EMPRESA_ACTIVIDAD,0) AS COD_AREA_EMPRESA_ACTIVIDAD,csm.COD_AREA_EMPRESA_PRODUCTO,"+
                            " ISNULL(ae.NOMBRE_AREA_EMPRESA,'--NINGUNO--') as areaEmpresaProducto, ISNULL(ae1.NOMBRE_AREA_EMPRESA,'--NINGUNO--') as areaEmpresaActividad,"+
                            " ISNULL(ap.NOMBRE_ACTIVIDAD,'--NINGUNO--')AS NOMBRE_ACTIVIDAD"+
                            " from CONFIGURACION_SOLICITUDES_MATERIALES csm inner join AREAS_EMPRESA ae "+
                            " on ae.COD_AREA_EMPRESA=csm.COD_AREA_EMPRESA_PRODUCTO LEFT OUTER JOIN AREAS_EMPRESA ae1"+
                            " on ae1.COD_AREA_EMPRESA=csm.COD_AREA_EMPRESA_ACTIVIDAD LEFT OUTER JOIN "+
                            " ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=csm.COD_ACTIVIDAD";

            ResultSet res=st.executeQuery(consulta);
            configuracionSolicitudesMaterialesList.clear();
            while(res.next())
            {
                ConfiguracionSolicitudesMateriales nuevo=new ConfiguracionSolicitudesMateriales();
                nuevo.getActividadProduccion().setCodActividad(res.getInt("COD_ACTIVIDAD"));
                nuevo.getActividadProduccion().setNombreActividad(res.getString("NOMBRE_ACTIVIDAD"));
                nuevo.getAreaEmpresaActividad().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA_ACTIVIDAD"));
                nuevo.getAreaEmpresaActividad().setNombreAreaEmpresa(res.getString("areaEmpresaActividad"));
                nuevo.getAreaEmpresaProducto().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA_PRODUCTO"));
                nuevo.getAreaEmpresaProducto().setNombreAreaEmpresa(res.getString("areaEmpresaProducto"));
                configuracionSolicitudesMaterialesList.add(nuevo);
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

    public ConfiguracionSolicitudesMateriales getConfiguracionSolicitudesMaterialesEditar() {
        return configuracionSolicitudesMaterialesEditar;
    }

    public void setConfiguracionSolicitudesMaterialesEditar(ConfiguracionSolicitudesMateriales configuracionSolicitudesMaterialesEditar) {
        this.configuracionSolicitudesMaterialesEditar = configuracionSolicitudesMaterialesEditar;
    }

    public List<ConfiguracionSolicitudesMateriales> getConfiguracionSolicitudesMaterialesList() {
        return configuracionSolicitudesMaterialesList;
    }

    public void setConfiguracionSolicitudesMaterialesList(List<ConfiguracionSolicitudesMateriales> configuracionSolicitudesMaterialesList) {
        this.configuracionSolicitudesMaterialesList = configuracionSolicitudesMaterialesList;
    }

    public List<SelectItem> getActividadesProduccionList() {
        return actividadesProduccionList;
    }

    public void setActividadesProduccionList(List<SelectItem> actividadesProduccionList) {
        this.actividadesProduccionList = actividadesProduccionList;
    }

  
    public List<SelectItem> getAreasEmpresaActividadList() {
        return areasEmpresaActividadList;
    }

    public void setAreasEmpresaActividadList(List<SelectItem> areasEmpresaActividadList) {
        this.areasEmpresaActividadList = areasEmpresaActividadList;
    }

    
}
