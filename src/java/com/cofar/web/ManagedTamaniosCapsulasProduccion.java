/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.TamaniosCapsulasProduccion;
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
 * @author DASISAQ-
 */

public class ManagedTamaniosCapsulasProduccion extends ManagedBean{

    private Connection con=null;
    String mensaje="";
    private List< TamaniosCapsulasProduccion> tamaniosCapsulasProduccionList=new ArrayList<TamaniosCapsulasProduccion>();
    private TamaniosCapsulasProduccion tamaniosCapsulasProduccionAgregar=null;
    private TamaniosCapsulasProduccion tamaniosCapsulasProduccionEditar=null;
    /** Creates a new instance of ManagedTamaniosCapsulasProduccion */
    public ManagedTamaniosCapsulasProduccion() {
    }
    public String getCargarTamaniosCapsulasProduccion()
    {
        this.cargarTamaniosCapsulasProduccion();
        return null;
    }
    private void cargarTamaniosCapsulasProduccion()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta ="select tc.COD_TAMANIO_CAPSULA_PRODUCCION,tc.NOMBRE_TAMANIO_CAPSULA_PRODUCCION,tc.DESCRIPCION_TAMANIO_CAPSULA,cantidadProducto.cantidadProducto" +
                             " from TAMANIOS_CAPSULAS_PRODUCCION tc outer apply(select isnull(count(*),0) as cantidadProducto from COMPONENTES_PROD_VERSION c " +
                             " where c.COD_TAMANIO_CAPSULA_PRODUCCION=tc.COD_TAMANIO_CAPSULA_PRODUCCION)cantidadProducto  order by tc.NOMBRE_TAMANIO_CAPSULA_PRODUCCION";
            System.out.println("consulta cargar tamnanios capsula "+consulta);
            ResultSet res = st.executeQuery(consulta);
            tamaniosCapsulasProduccionList.clear();
            while (res.next())
            {
                TamaniosCapsulasProduccion nuevo=new TamaniosCapsulasProduccion();
                nuevo.setCodTamanioCapsulaProduccion(res.getInt("COD_TAMANIO_CAPSULA_PRODUCCION"));
                nuevo.setNombreTamanioCapsulaProduccion(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION"));
                nuevo.setDescripcionTamanioCapsulaProduccion(res.getString("DESCRIPCION_TAMANIO_CAPSULA"));
                nuevo.setCantidadProductos(res.getInt("cantidadProducto"));
                tamaniosCapsulasProduccionList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String agregarTamanioCapsulaProduccion_action()
    {
        tamaniosCapsulasProduccionAgregar=new TamaniosCapsulasProduccion();
        return null;
    }
    public String editarTamanioCapsulaProduccion_action()
    {
        for(TamaniosCapsulasProduccion bean:tamaniosCapsulasProduccionList)
        {
            if(bean.getChecked())
            {
                tamaniosCapsulasProduccionEditar=bean;
                break;
            }
        }
        return null;
    }
    public String guardarAgregarTamanioCapsulaProduccion_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta ="select isnull(max(tc.COD_TAMANIO_CAPSULA_PRODUCCION),0)+1 as codTamanio"+
                             " from TAMANIOS_CAPSULAS_PRODUCCION tc ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codTamanioCapsula=0;
            if(res.next())codTamanioCapsula=res.getInt("codTamanio");
            consulta="INSERT INTO TAMANIOS_CAPSULAS_PRODUCCION(COD_TAMANIO_CAPSULA_PRODUCCION,"+
                     " NOMBRE_TAMANIO_CAPSULA_PRODUCCION, DESCRIPCION_TAMANIO_CAPSULA)"+
                     " VALUES ('"+codTamanioCapsula+"','"+tamaniosCapsulasProduccionAgregar.getNombreTamanioCapsulaProduccion()+"',"+
                     "'"+tamaniosCapsulasProduccionAgregar.getDescripcionTamanioCapsulaProduccion()+"')";
            System.out.println("consulta insertar nuevo tamanio capsula "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate()>0)System.out.println("Se registro el nuevo tamaño de capsula");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de registrar el tamaño de la capsula, intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarTamaniosCapsulasProduccion();
        }
        return null;
    }
    public String guardarEdicionTamanioCapsulaProduccion_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta = "UPDATE TAMANIOS_CAPSULAS_PRODUCCION  SET NOMBRE_TAMANIO_CAPSULA_PRODUCCION='"+tamaniosCapsulasProduccionEditar.getNombreTamanioCapsulaProduccion()+"'" +
                             ",DESCRIPCION_TAMANIO_CAPSULA='"+tamaniosCapsulasProduccionEditar.getDescripcionTamanioCapsulaProduccion()+"'" +
                             " WHERE COD_TAMANIO_CAPSULA_PRODUCCION='"+tamaniosCapsulasProduccionEditar.getCodTamanioCapsulaProduccion()+"'";
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0) System.out.println("Se realizo la edicion del tamanio");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch (SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion del tamaño de capsula,intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarTamaniosCapsulasProduccion();
        }
        return null;
    }
    public String eliminarTamanioCapsulaProduccion_action()throws SQLException
    {
        mensaje="";
        for(TamaniosCapsulasProduccion bean:tamaniosCapsulasProduccionList)
        {
            if(bean.getChecked())
            {
                try {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    String consulta = "select count(*) as cantidadregistrados from COMPONENTES_PROD_VERSION cpv where cpv.COD_TAMANIO_CAPSULA_PRODUCCION='"+bean.getCodTamanioCapsulaProduccion()+"'";
                    ResultSet res = st.executeQuery(consulta);
                    PreparedStatement pst=null;
                    res.next();
                    if(res.getInt("cantidadregistrados")==0)
                    {
                        consulta="DELETE TAMANIOS_CAPSULAS_PRODUCCION WHERE COD_TAMANIO_CAPSULA_PRODUCCION='"+bean.getCodTamanioCapsulaProduccion()+"'";
                        System.out.println("consulta delete tamanio capsula "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se elimino el tamanio de la capsula");
                    }
                    else
                    {
                        mensaje="No se puede eliminar el tamanio de capsula ya que "+res.getInt("cantidadregistrados")+" versiones utilizan el dato";
                    }
                    con.commit();
                    if(pst!=null)
                    {
                        pst.close();
                        mensaje="1";
                    }
                    res.close();
                    st.close();
                    con.close();
                }
                catch (SQLException ex)
                {
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarTamaniosCapsulasProduccion();
        }
        return null;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public TamaniosCapsulasProduccion getTamaniosCapsulasProduccionAgregar() {
        return tamaniosCapsulasProduccionAgregar;
    }

    public void setTamaniosCapsulasProduccionAgregar(TamaniosCapsulasProduccion tamaniosCapsulasProduccionAgregar) {
        this.tamaniosCapsulasProduccionAgregar = tamaniosCapsulasProduccionAgregar;
    }

    public TamaniosCapsulasProduccion getTamaniosCapsulasProduccionEditar() {
        return tamaniosCapsulasProduccionEditar;
    }

    public void setTamaniosCapsulasProduccionEditar(TamaniosCapsulasProduccion tamaniosCapsulasProduccionEditar) {
        this.tamaniosCapsulasProduccionEditar = tamaniosCapsulasProduccionEditar;
    }

    public List<TamaniosCapsulasProduccion> getTamaniosCapsulasProduccionList() {
        return tamaniosCapsulasProduccionList;
    }

    public void setTamaniosCapsulasProduccionList(List<TamaniosCapsulasProduccion> tamaniosCapsulasProduccionList) {
        this.tamaniosCapsulasProduccionList = tamaniosCapsulasProduccionList;
    }

    
}
