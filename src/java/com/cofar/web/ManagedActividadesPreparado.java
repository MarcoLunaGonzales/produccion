/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.ActividadesPreparado;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;

/**
 *
 * @author DASISAQ-
 */
public class ManagedActividadesPreparado extends ManagedBean
{
    private Connection con;
    private String mensaje;
    private List<ActividadesPreparado> actividadesPreparadoList;
    private ActividadesPreparado actividadesPreparadoAgregar;
    private ActividadesPreparado actividadesPreparadoEditar;
    public String agregarActividadPreparado_action()
    {
       this.actividadesPreparadoAgregar=new ActividadesPreparado();
       return null;
    }
    public String editarActividadPreparado_action()
    {
        for(ActividadesPreparado bean:actividadesPreparadoList)
        {
            if(bean.getChecked())
            {
                actividadesPreparadoEditar=bean;
                actividadesPreparadoEditar.setCantidadVersiones(this.cantidadVersionesProducto(actividadesPreparadoEditar.getCodActividadPreparado()));
                break;
            }
        }
        return null;
    }
    public String guardarEdicionActividadPreparado_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE ACTIVIDADES_PREPARADO");
                            consulta.append(" SET  NOMBRE_ACTIVIDAD_PREPARADO =?");
                            consulta.append(" ,DESCRIPCION = ?");
                            consulta.append(" WHERE COD_ACTIVIDAD_PREPARADO = ").append(actividadesPreparadoEditar.getCodActividadPreparado());
            LOGGER.debug("consulta " + consulta.toString()+" nombre "+actividadesPreparadoEditar.getNombreActividadPreparado());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1, actividadesPreparadoEditar.getNombreActividadPreparado());
            pst.setString(2, actividadesPreparadoEditar.getDescripcion());
            if (pst.executeUpdate() > 0) LOGGER.info("Se actualizo la actividad");
            con.commit();
            mensaje="1";
            pst.close();
        } 
        catch (SQLException ex) 
        {
            mensaje="Ocurrio un error al momento de guardar la modificación, intente de nuevo";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje="Ocurrio un error al momento de guardar la modificacion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarActividadesPreparado();
        }
        return null;
    }
    public String eliminarActividadPreparado_action()throws SQLException
    {
        mensaje="1";
        for(ActividadesPreparado bean:actividadesPreparadoList)
        {
            if(bean.getChecked())
            {
                if(this.cantidadVersionesProducto(bean.getCodActividadPreparado())==0)
                {
                    try 
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder("DELETE ACTIVIDADES_PREPARADO ");
                                                 consulta.append(" WHERE COD_ACTIVIDAD_PREPARADO=").append(bean.getCodActividadPreparado());
                        LOGGER.debug("consulta " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("Se elimino la actividad de preparado");
                        con.commit();
                        mensaje = "1";
                        pst.close();
                    } 
                    catch (SQLException ex) 
                    {
                        mensaje = "Ocurrio un error al momento de eliminar la actividad de preparado,intente de nuevo";
                        con.rollback();
                        LOGGER.warn(ex.getMessage());
                    }
                    catch (Exception ex) 
                    {
                        mensaje = "Ocurrio un error al momento de guardar la actividad de preparado,verifique los datos introducidos";
                        LOGGER.warn(ex.getMessage());
                    }
                    finally 
                    {
                        this.cerrarConexion(con);
                    }
                }
                else
                {
                    mensaje="No se puede eliminar la actividad ya que la misma se esta utilizando en varias versiones activas";
                }
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarActividadesPreparado();
        }
        return null;
    }
    public String guardarAgregarActividadPreparado_action()throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
             StringBuilder consulta=new StringBuilder("INSERT INTO ACTIVIDADES_PREPARADO(NOMBRE_ACTIVIDAD_PREPARADO, DESCRIPCION)");
                                    consulta.append(" VALUES (?,?)");
            LOGGER.debug("consulta " + consulta.toString()+" "+actividadesPreparadoAgregar.getNombreActividadPreparado());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,actividadesPreparadoAgregar.getNombreActividadPreparado());
            pst.setString(2,actividadesPreparadoAgregar.getDescripcion());
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la actividad");
            con.commit();
            mensaje="1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje="Ocurrio un error al momento de guardar la actividad,intente de nuevo";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) 
        {
            mensaje="Ocurrio un error al momento de guardar la actividad,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarActividadesPreparado();
        }
        return null;
    }
    //funcion para veriricar la cantidad de versiones que utilizan una actividad de preparado
    private int cantidadVersionesProducto(int codActividadPreparado)
    {
        int cantidadVersiones=0;
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select count(DISTINCT cpv.COD_VERSION) as cantidadRegistros");
                                    consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp");
                                    consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=ppp.COD_VERSION");
                                    consulta.append(" where ppp.COD_ACTIVIDAD_PREPARADO=").append(codActividadPreparado);
                                    consulta.append(" and cpv.COD_ESTADO_VERSION  in (2,3,4,6)");
            LOGGER.debug("consulta verificar cantidad de fracciones "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                cantidadVersiones=res.getInt("cantidadRegistros");
            }
            st.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally {
            this.cerrarConexion(con);
        }
        return cantidadVersiones;
    }
    public String getCargarActividadesPreparado()
    {
        this.cargarActividadesPreparado();
        return null;
    }
    private void cargarActividadesPreparado()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta=new StringBuilder("select ap.COD_ACTIVIDAD_PREPARADO,ap.NOMBRE_ACTIVIDAD_PREPARADO,ap.DESCRIPCION");
                                       consulta.append(" from ACTIVIDADES_PREPARADO ap");
                                       consulta.append(" where  ap.COD_FORMA=0");
                                       consulta.append(" order by ap.NOMBRE_ACTIVIDAD_PREPARADO");
            LOGGER.debug("consulta cargar actividades preparado "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            actividadesPreparadoList=new ArrayList<ActividadesPreparado>();
            while(res.next())
            {
                ActividadesPreparado nuevo=new ActividadesPreparado();
                nuevo.setCodActividadPreparado(res.getInt("COD_ACTIVIDAD_PREPARADO"));
                nuevo.setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                nuevo.setDescripcion(res.getString("DESCRIPCION"));
                actividadesPreparadoList.add(nuevo);

            }
            res.close();
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
    public ManagedActividadesPreparado() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<ActividadesPreparado> getActividadesPreparadoList() {
        return actividadesPreparadoList;
    }

    public void setActividadesPreparadoList(List<ActividadesPreparado> actividadesPreparadoList) {
        this.actividadesPreparadoList = actividadesPreparadoList;
    }

    public ActividadesPreparado getActividadesPreparadoAgregar() {
        return actividadesPreparadoAgregar;
    }

    public void setActividadesPreparadoAgregar(ActividadesPreparado actividadesPreparadoAgregar) {
        this.actividadesPreparadoAgregar = actividadesPreparadoAgregar;
    }

    public ActividadesPreparado getActividadesPreparadoEditar() {
        return actividadesPreparadoEditar;
    }

    public void setActividadesPreparadoEditar(ActividadesPreparado actividadesPreparadoEditar) {
        this.actividadesPreparadoEditar = actividadesPreparadoEditar;
    }
    
    
    
}
