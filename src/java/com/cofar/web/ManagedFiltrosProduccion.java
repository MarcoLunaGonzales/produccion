/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.FiltrosProduccion;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;

/**
 *
 * @author DASISAQ-
 */
public class ManagedFiltrosProduccion extends ManagedBean
{
    private Connection con=null;
    private List<SelectItem> mediosFiltracionSelectList;
    private List<SelectItem> unidadesMedidaSelectList;
    private List<FiltrosProduccion> filtrosProduccionList;
    private FiltrosProduccion filtrosProduccionAgregar;
    private FiltrosProduccion filtrosProduccionEditar;
    private String mensaje="";
    /**
     * Creates a new instance of ManagedFiltrosProduccion
     */
    public ManagedFiltrosProduccion() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    public String agregarFiltroProduccion_action()
    {
        this.filtrosProduccionAgregar=new FiltrosProduccion();
        return null;
    }
    public String editarFiltroProduccion_action()
    {
        for(FiltrosProduccion bean:filtrosProduccionList)
        {
            if(bean.getChecked())
            {
                filtrosProduccionEditar=bean;
                filtrosProduccionEditar.setCantidadVersiones(this.cantidadVersionesFiltro(bean));
            }
        }
        return null;
    }
    
    //cantidad de filtros que utilizan la version
    private int cantidadVersionesFiltro(FiltrosProduccion filtrosProduccion)
    {
        int cantidadVersiones=0;
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select count(DISTINCT cpv.COD_VERSION) as cantidadRegistros");
                                        consulta.append(" from COMPONENTES_PROD_VERSION_FILTRO_PRODUCCION cpvf ");
                                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=cpvf.COD_VERSION");
                                        consulta.append(" where cpv.COD_ESTADO_VERSION in (2, 3, 4, 6)");
                                            consulta.append(" and cpvf.COD_FILTRO_PRODUCCION=").append(filtrosProduccion.getCodFiltroProduccion());
            LOGGER.debug("consulta verificar cantidad de versiones que utilizan "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            if(res.next())cantidadVersiones=res.getInt("cantidadRegistros");
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
        return cantidadVersiones;
    }
    public String guardarAgregarFiltroProduccion_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO FILTROS_PRODUCCION(CODIGO_FILTRO_PRODUCCION, PRESION_DE_APROBACION, COD_MEDIO_FILTRACION,");
                                        consulta.append(" CANTIDAD_FILTRO, COD_UNIDAD_MEDIDA, COD_ESTADO_REGISTRO,COD_UNIDAD_MEDIDA_PRESION)");
                                        consulta.append(" VALUES(");
                                            consulta.append(filtrosProduccionAgregar.getCodigoFiltroProduccion()).append(",");
                                            consulta.append("?,");
                                            consulta.append(filtrosProduccionAgregar.getMediosFiltracion().getCodMedioFiltracion()).append(",");
                                            consulta.append("?,");
                                            consulta.append(filtrosProduccionAgregar.getUnidadesMedida().getCodUnidadMedida()).append(",");
                                            consulta.append("1,");
                                            consulta.append(filtrosProduccionAgregar.getUnidadesMedidaPresion().getCodUnidadMedida());
                                        consulta.append(")");
            LOGGER.debug("consulta registrar filtro produccion " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,filtrosProduccionAgregar.getPresionAprobación());
            pst.setString(2,filtrosProduccionAgregar.getCantidadFiltro());
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro el fitro de produccion");
            con.commit();
            mensaje = "1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarFiltrosProduccion();
        }
        return null;
    }
    public String guardarEdicionFiltroProduccion_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE FILTROS_PRODUCCION");
                                        consulta.append(" SET CODIGO_FILTRO_PRODUCCION=").append(filtrosProduccionEditar.getCodigoFiltroProduccion()).append(",");
                                            consulta.append(" PRESION_DE_APROBACION=?,");
                                            consulta.append(" COD_MEDIO_FILTRACION =").append(filtrosProduccionEditar.getMediosFiltracion().getCodMedioFiltracion()).append(",");
                                            consulta.append(" CANTIDAD_FILTRO=?,");
                                            consulta.append(" COD_UNIDAD_MEDIDA=").append(filtrosProduccionEditar.getUnidadesMedida().getCodUnidadMedida()).append(",");
                                            consulta.append(" COD_ESTADO_REGISTRO=").append(filtrosProduccionEditar.getEstadoRegistro().getCodEstadoRegistro()).append(",");
                                            consulta.append(" COD_UNIDAD_MEDIDA_PRESION=").append(filtrosProduccionEditar.getUnidadesMedidaPresion().getCodUnidadMedida());
                                        consulta.append("where COD_FILTRO_PRODUCCION=").append(filtrosProduccionEditar.getCodFiltroProduccion());
            LOGGER.debug("consulta editar filtro produccion " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,filtrosProduccionEditar.getPresionAprobación());
            pst.setString(2,filtrosProduccionEditar.getCantidadFiltro());
            if (pst.executeUpdate() > 0) LOGGER.info("Se registro la edicion del filtro de produccion");
            con.commit();
            mensaje = "1";
            pst.close();
        }
        catch (SQLException ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion";
            con.rollback();
            LOGGER.warn(ex.getMessage());
        } 
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarFiltrosProduccion();
        }
        return null;
    }
    
    public String eliminarFiltroProduccion_action()throws SQLException
    {
        mensaje="";
        for(FiltrosProduccion bean:filtrosProduccionList)
        {
            if(bean.getChecked())
            {
                if(this.cantidadVersionesFiltro(bean)==0)
                {
                    mensaje = "";
                    try 
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder("delete FILTROS_PRODUCCION");
                                                consulta.append(" where COD_FILTRO_PRODUCCION=").append(bean.getCodFiltroProduccion());
                        LOGGER.debug("consulta eliminar filtro de produccion" + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("Se elimino el filtro de produccion");
                        con.commit();
                        mensaje = "1";
                        pst.close();
                    } 
                    catch (SQLException ex) 
                    {
                        mensaje = "Ocurrio un error al momento de guardar la transaccion";
                        con.rollback();
                        LOGGER.warn(ex.getMessage());
                    }
                    catch (Exception ex) 
                    {
                        mensaje = "Ocurrio un error al momento de guardar la transaccion,verifique los datos introducidos";
                        LOGGER.warn(ex.getMessage());
                    }
                    finally 
                    {
                        this.cerrarConexion(con);
                    }
                }
                else
                {
                    mensaje="No se puede eliminar la version ya que se encuentra asociada a versionas aprobadas u obsoletas";
                }
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarFiltrosProduccion();
        }
        return null;
    }
    private void cargarUnidadesMedidaSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA+'  ('+um.ABREVIATURA+')' as nombreUnidadMedida");
                                        consulta.append(" from UNIDADES_MEDIDA um ");
                                        consulta.append(" where um.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by um.NOMBRE_UNIDAD_MEDIDA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            unidadesMedidaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                unidadesMedidaSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("nombreUnidadMedida")));
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
    private void cargarMediosFiltracion()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder(" select mf.COD_MEDIO_FILTRACION,mf.NOMBRE_MEDIO_FILTRACION");
                                        consulta.append(" from MEDIOS_FILTRACION mf ");
                                        consulta.append(" where mf.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by mf.NOMBRE_MEDIO_FILTRACION");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            mediosFiltracionSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                mediosFiltracionSelectList.add(new SelectItem(res.getInt("COD_MEDIO_FILTRACION"),res.getString("NOMBRE_MEDIO_FILTRACION")));
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
    public String getCargarFiltrosProduccion()
    {
        this.cargarMediosFiltracion();
        this.cargarFiltrosProduccion();
        this.cargarUnidadesMedidaSelectList();
        return null;
    }
    private void cargarFiltrosProduccion()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ef.CANTIDAD_FILTRO,ef.COD_FILTRO_PRODUCCION,ef.COD_ESTADO_REGISTRO,");
                                            consulta.append(" er.NOMBRE_ESTADO_REGISTRO,ef.COD_MEDIO_FILTRACION,mf.NOMBRE_MEDIO_FILTRACION,ef.COD_UNIDAD_MEDIDA,");
                                            consulta.append(" um.NOMBRE_UNIDAD_MEDIDA,ef.CODIGO_FILTRO_PRODUCCION,ef.PRESION_DE_APROBACION,um1.COD_UNIDAD_MEDIDA as cod_unidad_medida_presion,");
                                            consulta.append(" um1.NOMBRE_UNIDAD_MEDIDA as nombre_unidad_medida_presion");
                                    consulta.append(" from FILTROS_PRODUCCION ef");
                                            consulta.append(" inner join UNIDADES_MEDIDA um on ef.COD_UNIDAD_MEDIDA =um.COD_UNIDAD_MEDIDA");
                                            consulta.append(" inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION =ef.COD_MEDIO_FILTRACION");
                                            consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO =ef.COD_ESTADO_REGISTRO");
                                            consulta.append(" inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA =ef.COD_UNIDAD_MEDIDA_PRESION");
                                    consulta.append(" order by ef.CANTIDAD_FILTRO");
            LOGGER.debug("consulta cargar filtros "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            filtrosProduccionList=new ArrayList<FiltrosProduccion>();
            while (res.next()) 
            {
                FiltrosProduccion nuevo=new FiltrosProduccion();
                nuevo.setCantidadFiltro(res.getString("CANTIDAD_FILTRO"));
                nuevo.setCodFiltroProduccion(res.getInt("COD_FILTRO_PRODUCCION"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                nuevo.getMediosFiltracion().setCodMedioFiltracion(res.getInt("COD_MEDIO_FILTRACION"));
                nuevo.getMediosFiltracion().setNombreMedioFiltracion(res.getString("NOMBRE_MEDIO_FILTRACION"));
                nuevo.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                nuevo.getUnidadesMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                nuevo.setCodigoFiltroProduccion(res.getInt("CODIGO_FILTRO_PRODUCCION"));
                nuevo.setPresionAprobación(res.getString("PRESION_DE_APROBACION"));
                nuevo.getUnidadesMedidaPresion().setCodUnidadMedida(res.getString("cod_unidad_medida_presion"));
                nuevo.getUnidadesMedidaPresion().setNombreUnidadMedida(res.getString("nombre_unidad_medida_presion"));
                filtrosProduccionList.add(nuevo);
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

    public List<SelectItem> getMediosFiltracionSelectList() {
        return mediosFiltracionSelectList;
    }

    public void setMediosFiltracionSelectList(List<SelectItem> mediosFiltracionSelectList) {
        this.mediosFiltracionSelectList = mediosFiltracionSelectList;
    }

    public List<SelectItem> getUnidadesMedidaSelectList() {
        return unidadesMedidaSelectList;
    }

    public void setUnidadesMedidaSelectList(List<SelectItem> unidadesMedidaSelectList) {
        this.unidadesMedidaSelectList = unidadesMedidaSelectList;
    }

    public List<FiltrosProduccion> getFiltrosProduccionList() {
        return filtrosProduccionList;
    }

    public void setFiltrosProduccionList(List<FiltrosProduccion> filtrosProduccionList) {
        this.filtrosProduccionList = filtrosProduccionList;
    }

    public FiltrosProduccion getFiltrosProduccionAgregar() {
        return filtrosProduccionAgregar;
    }

    public void setFiltrosProduccionAgregar(FiltrosProduccion filtrosProduccionAgregar) {
        this.filtrosProduccionAgregar = filtrosProduccionAgregar;
    }

    public FiltrosProduccion getFiltrosProduccionEditar() {
        return filtrosProduccionEditar;
    }

    public void setFiltrosProduccionEditar(FiltrosProduccion filtrosProduccionEditar) {
        this.filtrosProduccionEditar = filtrosProduccionEditar;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
    
    
}
