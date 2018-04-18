/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ActividadesFormulaMaestra;
import com.cofar.bean.ActividadesProduccion;
import com.cofar.bean.ActividadesProgramaProduccionIndirecto;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
/**
 *
 * @author hvaldivia
 */

public class ManagedActividadesProgramaProduccionIndirecto extends ManagedBean
{
    Connection con;
    public String codAreaEmpresa = "";
    List actividadesProgramaProduccionIndirectoList = new ArrayList();
    private List areasEmpresaActividadSelectList;
    List actividadesProgramaProduccionIndirectoAdicionarList = new ArrayList();
    List actividadesProgramaProduccionIndirectoEditarList = new ArrayList();
    private String mensaje="";

    public List getActividadesProgramaProduccionIndirectoList() {
        return actividadesProgramaProduccionIndirectoList;
    }

    public void setActividadesProgramaProduccionIndirectoList(List actividadesProgramaProduccionIndirectoList) {
        this.actividadesProgramaProduccionIndirectoList = actividadesProgramaProduccionIndirectoList;
    }

    

    public String getCodAreaEmpresa() {
        return codAreaEmpresa;
    }

    public void setCodAreaEmpresa(String codAreaEmpresa) {
        this.codAreaEmpresa = codAreaEmpresa;
    }

    public List getAreasEmpresaActividadSelectList() {
        return areasEmpresaActividadSelectList;
    }

    public void setAreasEmpresaActividadSelectList(List areasEmpresaActividadSelectList) {
        this.areasEmpresaActividadSelectList = areasEmpresaActividadSelectList;
    }

    

    public List getActividadesProgramaProduccionIndirectoAdicionarList() {
        return actividadesProgramaProduccionIndirectoAdicionarList;
    }

    public void setActividadesProgramaProduccionIndirectoAdicionarList(List actividadesProgramaProduccionIndirectoAdicionarList) {
        this.actividadesProgramaProduccionIndirectoAdicionarList = actividadesProgramaProduccionIndirectoAdicionarList;
    }

    public List getActividadesProgramaProduccionIndirectoEditarList() {
        return actividadesProgramaProduccionIndirectoEditarList;
    }

    public void setActividadesProgramaProduccionIndirectoEditarList(List actividadesProgramaProduccionIndirectoEditarList) {
        this.actividadesProgramaProduccionIndirectoEditarList = actividadesProgramaProduccionIndirectoEditarList;
    }
    
    /** Creates a new instance of ManagedActividadesProgramaProduccionIndirecto */
    public ManagedActividadesProgramaProduccionIndirecto() 
    {
        LOGGER=LogManager.getRootLogger();
    }
    // <editor-fold defaultstate="collapsed" desc="listas seleect">
    private void cargarAreasEmpresaActividadSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select a.COD_AREA_EMPRESA,a.NOMBRE_AREA_EMPRESA");
                                            consulta.append(" from areas_empresa a");
                                                    consulta.append(" inner join AREAS_ACTIVIDAD_PRODUCCION aap on aap.COD_AREA_EMPRESA=a.COD_AREA_EMPRESA");
                                            consulta.append(" order by a.NOMBRE_AREA_EMPRESA asc");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            areasEmpresaActividadSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                areasEmpresaActividadSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            st.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
    }
//</editor-fold>
    public String getCargarContenidoActividadesProgramaProduccionIndirecto()
    {
        this.cargarAreasEmpresaActividadSelectList();
        try 
        {            
            
            actividadesProgramaProduccionIndirectoList = this.cargarActividadesProgramaProduccionIndirecto();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public List cargarActividadesProgramaProduccionIndirecto(){
        List actividadesProgramaProduccionList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = "  select a.ORDEN,a.COD_ACTIVIDAD,a.COD_ESTADO_REGISTRO,ap.NOMBRE_ACTIVIDAD,a.COD_AREA_EMPRESA,e.NOMBRE_ESTADO_REGISTRO,a.HORAS_HOMBRE " +
                    " from ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO a  " +
                    " inner join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = a.COD_ESTADO_REGISTRO " +
                    " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = a.COD_ACTIVIDAD and ap.COD_TIPO_ACTIVIDAD = 2 " +
                    " where ap.COD_ESTADO_REGISTRO = 1 and a.COD_AREA_EMPRESA = '"+codAreaEmpresa+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                ActividadesProgramaProduccionIndirecto actividadesProgramaProduccionIndirecto = new ActividadesProgramaProduccionIndirecto();
                actividadesProgramaProduccionIndirecto.setOrden(rs.getInt("orden"));
                actividadesProgramaProduccionIndirecto.getActividadesProduccion().setCodActividad(rs.getInt("cod_actividad"));
                actividadesProgramaProduccionIndirecto.getActividadesProduccion().setNombreActividad(rs.getString("nombre_actividad"));
                actividadesProgramaProduccionIndirecto.getAreasEmpresa().setCodAreaEmpresa(rs.getString("cod_area_empresa"));
                actividadesProgramaProduccionIndirecto.getEstadoReferencial().setNombreEstadoRegistro(rs.getString("nombre_estado_registro"));
                actividadesProgramaProduccionIndirecto.setHorasHombre(rs.getFloat("horas_hombre"));
                actividadesProgramaProduccionIndirecto.getEstadoReferencial().setCodEstadoRegistro(rs.getString("COD_ESTADO_REGISTRO"));
                actividadesProgramaProduccionList.add(actividadesProgramaProduccionIndirecto);
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
        }
        return actividadesProgramaProduccionList;
    }
    public String areasEmpresa_change(){
        try {
            actividadesProgramaProduccionIndirectoList = this.cargarActividadesProgramaProduccionIndirecto();
        } catch (Exception e) {
        }
        return null;
    }
    public String getCargarContenidoAgregarActividades(){
        this.cargarActividades();
        return null;
    }
    public void cargarActividades(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            String sql="select cod_actividad,nombre_actividad from actividades_produccion where cod_estado_registro=1 and cod_tipo_actividad = 2 ";
            sql+=" and cod_actividad <> all (select a.cod_actividad from ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO a where a.cod_area_empresa='"+codAreaEmpresa+"')" ;
            System.out.println("sql_actividades:"+sql);            
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            actividadesProgramaProduccionIndirectoAdicionarList.clear();
            while (rs.next()){
                ActividadesProduccion actividadesProduccion = new ActividadesProduccion();
                actividadesProduccion.setCodActividad(rs.getInt("cod_actividad"));
                actividadesProduccion.setNombreActividad(rs.getString("nombre_actividad"));
                ActividadesProgramaProduccionIndirecto actividadesProgramaProduccionIndirecto = new ActividadesProgramaProduccionIndirecto();
                actividadesProgramaProduccionIndirecto.setActividadesProduccion(actividadesProduccion);
                actividadesProgramaProduccionIndirectoAdicionarList.add(actividadesProgramaProduccionIndirecto);
            }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
                con.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String guardarActividadIndirectaProduccion_action()
    {
        mensaje="";
        try {
            Iterator i=actividadesProgramaProduccionIndirectoAdicionarList.iterator();
            while (i.hasNext()){
                ActividadesProgramaProduccionIndirecto actividadesProgramaProduccionIndirecto = (ActividadesProgramaProduccionIndirecto)i.next();
                actividadesProgramaProduccionIndirecto.getAreasEmpresa().setCodAreaEmpresa(codAreaEmpresa);
                actividadesProgramaProduccionIndirecto.getEstadoReferencial().setCodEstadoRegistro("1");
                if(actividadesProgramaProduccionIndirecto.getChecked().booleanValue()){
                    String sql="INSERT INTO ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO ( COD_ACTIVIDAD, ORDEN, HORAS_HOMBRE, COD_AREA_EMPRESA, " +
                            "  COD_ESTADO_REGISTRO) VALUES ( '"+actividadesProgramaProduccionIndirecto.getActividadesProduccion().getCodActividad()+"'," +
                            "'"+actividadesProgramaProduccionIndirecto.getOrden()+"','"+actividadesProgramaProduccionIndirecto.getHorasHombre()+"'," +
                            "'"+actividadesProgramaProduccionIndirecto.getAreasEmpresa().getCodAreaEmpresa()+"','"+actividadesProgramaProduccionIndirecto.getEstadoReferencial().getCodEstadoRegistro()+"');";
                    System.out.println("inset:"+sql);
                    Connection con = null;
                    con = Util.openConnection(con);
                    Statement st=con.createStatement();
                    st.executeUpdate(sql);
                }
            }
            mensaje="1";
        } catch (Exception e) {
            mensaje="Ocurrio un error al momento de guardar las actividad";
            e.printStackTrace();
        }

        return null;
    }
    public String actionEditar(){
        //cargarMaquinaria("",null);
        actividadesProgramaProduccionIndirectoEditarList.clear();
        Iterator i=actividadesProgramaProduccionIndirectoList.iterator();
        while (i.hasNext()){
            ActividadesProgramaProduccionIndirecto bean=(ActividadesProgramaProduccionIndirecto)i.next();
            if(bean.getChecked().booleanValue()){
                System.out.println("valor del estado registro "+bean.getEstadoReferencial().getCodEstadoRegistro());

                actividadesProgramaProduccionIndirectoEditarList.add(bean);
            }
        }
        return null;
    }
    public String guardarEdicion()
    {
        mensaje="";
        Iterator i =actividadesProgramaProduccionIndirectoEditarList.iterator();
        while(i.hasNext())
        {
            ActividadesProgramaProduccionIndirecto bean=(ActividadesProgramaProduccionIndirecto)i.next();
            if(bean.getChecked().booleanValue())
            {
                String consulta="UPDATE ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO"+
                                " SET ORDEN ='"+bean.getOrden()+"',"+
                                " COD_ESTADO_REGISTRO = '"+bean.getEstadoReferencial().getCodEstadoRegistro()+"'"+
                                " WHERE COD_ACTIVIDAD = '"+bean.getActividadesProduccion().getCodActividad()+"'"+
                                " AND COD_AREA_EMPRESA = '"+bean.getAreasEmpresa().getCodAreaEmpresa()+"'";
                System.out.println("consulta de registro detalle"+consulta);
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se edito el registro");
                    pst.close();
                    con.close();
                    mensaje="1";
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de editar el registro";
                    ex.printStackTrace();
                }
            }


        }
        
        actividadesProgramaProduccionIndirectoList= this.cargarActividadesProgramaProduccionIndirecto();
        return null;
    }
    public String cancelarAction()
    {
        return "";
    }
    public String eliminarRegistroAction()
    {
        setMensaje("");
        Iterator i=actividadesProgramaProduccionIndirectoList.iterator();
        while(i.hasNext())
        {
           ActividadesProgramaProduccionIndirecto bean=(ActividadesProgramaProduccionIndirecto)i.next();
           if(bean.getChecked().booleanValue())
           {
               String consulta="select top 1 * from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO sppi where "+
                                "sppi.COD_AREA_EMPRESA='"+bean.getActividadesProduccion().getCodActividad()+"' and sppi.COD_ACTIVIDAD='"+bean.getAreasEmpresa().getCodAreaEmpresa()+"'";
               System.out.println("consulta verificar en seguimiento programa "+consulta);
               Connection con=null;
               try
               {

                   con=Util.openConnection(con);
                   Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                   ResultSet res=st.executeQuery(consulta);
                   if(res.next())
                   {
                        setMensaje("No se puede elminar el registro porque un seguimiento de programa producción lo esta utilizando");

                   }
                   consulta="select top 1 * from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppip"+
                            " where sppip.COD_ACTVIDAD='"+bean.getActividadesProduccion().getCodActividad()+"' and sppip.COD_AREA_EMPRESA='"+bean.getAreasEmpresa().getCodAreaEmpresa()+"'";
                   System.out.println("verificar seguimiento personal indirecto "+consulta);
                   res=st.executeQuery(consulta);
                   if(res.next())
                   {
                       setMensaje("No se puede eliminar el registro porque un seguimiento de personal lo esta utilizando");

                   }
                   
                  
                   if(mensaje.equals(""))
                   {
                       consulta="DELETE FROM ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO "+
                             " WHERE COD_AREA_EMPRESA='"+bean.getAreasEmpresa().getCodAreaEmpresa()+"' and COD_ACTIVIDAD='"+bean.getActividadesProduccion().getCodActividad()+"'";
                   System.out.println("consulta delete "+consulta);
                        PreparedStatement pst=con.prepareStatement(consulta);
                   if(pst.executeUpdate()>0)
                   {
                       System.out.println("se elimino el registro");
                       mensaje="1";
                   }
                         pst.close();
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
        }
        if(mensaje.equals("1"))
        {
            actividadesProgramaProduccionIndirectoList= this.cargarActividadesProgramaProduccionIndirecto();
        }
        return null;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

}
