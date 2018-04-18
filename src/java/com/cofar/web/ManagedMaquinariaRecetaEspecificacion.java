/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.Maquinaria;
import com.cofar.bean.MaquinariaRecetaDetalleEspecificacionProceso;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;
/**
 *
 * @author DASISAQ
 */
public class ManagedMaquinariaRecetaEspecificacion extends ManagedBean
{
    private Connection con=null;
    private String mensaje="";
    private List<Maquinaria> maquinariaList;
    private HtmlDataTable maquinariaDataTable=new HtmlDataTable();
    private Maquinaria maquinariaBean=new Maquinaria();
    private List<MaquinariaRecetaDetalleEspecificacionProceso> maquinariaRecetaDetalleEspecificacionProcesoList;
    private List<MaquinariaRecetaDetalleEspecificacionProceso> maquinariaRecetaDetalleEspecificacionProcesosAgregarList;
    public String guardarAgregarMaquinariaRecetaEspecificacionProceso_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO MAQUINARIA_RECETA_DETALLE_ESPECIFICACION_PROCESO(COD_MAQUINARIA,COD_ESPECIFICACION_PROCESO)");
                                        consulta.append(" VALUES (");
                                            consulta.append(maquinariaBean.getCodMaquina()).append(",");
                                            consulta.append("?");//cod Especificacion
                                        consulta.append(")");
            LOGGER.debug("consulta registrar receta detalle especificacion " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            for(MaquinariaRecetaDetalleEspecificacionProceso bean:maquinariaRecetaDetalleEspecificacionProcesosAgregarList)
            {
                if(bean.getChecked())
                {
                    pst.setInt(1, bean.getEspecificacionProceso().getCodEspecificacionProceso());LOGGER.info("p1: "+bean.getEspecificacionProceso().getCodEspecificacionProceso());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro la receta detalle especificacion");
                }
            }
            con.commit();
            mensaje = "1";
        } catch (SQLException ex) {
            mensaje = "Ocurrio un error al momento de guardar el registro";
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } catch (Exception ex) {
            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return null;
    }
    public String eliminarMaquinariaRecetaEspecificacionProceso_action()throws SQLException
    {
        mensaje="";
        for(MaquinariaRecetaDetalleEspecificacionProceso bean:maquinariaRecetaDetalleEspecificacionProcesoList)
        {
            if(bean.getChecked())
            {
                try 
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    StringBuilder consulta = new StringBuilder("delete MAQUINARIA_RECETA_DETALLE_ESPECIFICACION_PROCESO");
                                                consulta.append(" where COD_MAQUINARIA=").append(maquinariaBean.getCodMaquina());
                                                    consulta.append(" and COD_ESPECIFICACION_PROCESO=").append(bean.getEspecificacionProceso().getCodEspecificacionProceso());
                    LOGGER.debug("consulta eliminar receta maquinaria especificacion " + consulta.toString());
                    PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                    if (pst.executeUpdate() > 0) LOGGER.info("se elimino la maquinaria especifcacion");
                    con.commit();
                    mensaje = "1";
                }
                catch (SQLException ex) 
                {
                    mensaje = "Ocurrio un error al momento de guardar el registro";
                    LOGGER.warn(ex.getMessage());
                    con.rollback();
                }
                catch (Exception ex) 
                {
                    mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
                    LOGGER.warn(ex.getMessage());
                }
                finally 
                {
                    this.cerrarConexion(con);
                }
                break;
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarMaquinariaRecetaEspecificacion();
        }
        return null;
    }
    public String getCargarAgregarMaquinariaRecetaEspecificacionProceso()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ep.NOMBRE_ESPECIFICACIONES_PROCESO,ep.COD_ESPECIFICACION_PROCESO,");
                                            consulta.append(" ep.PORCIENTO_TOLERANCIA,ep.COD_UNIDAD_MEDIDA,ep.COD_TIPO_DESCRIPCION");
                                            consulta.append(" ,td.NOMBRE_TIPO_DESCRIPCION,isnull(um.NOMBRE_UNIDAD_MEDIDA,'') as NOMBRE_UNIDAD_MEDIDA");
                                    consulta.append(" from ESPECIFICACIONES_PROCESOS ep");
                                            consulta.append(" inner join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=ep.COD_TIPO_DESCRIPCION");
                                            consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ep.COD_UNIDAD_MEDIDA");
                                    consulta.append(" where ep.COD_TIPO_ESPECIFICACION_PROCESO = 1 and");
                                            consulta.append(" ep.COD_FORMA = 0");
                                            consulta.append(" and ep.COD_ESPECIFICACION_PROCESO not in (");
                                                    consulta.append(" select mrd.COD_ESPECIFICACION_PROCESO");
                                                    consulta.append(" from MAQUINARIA_RECETA_DETALLE_ESPECIFICACION_PROCESO mrd");
                                                    consulta.append(" where  mrd.COD_MAQUINARIA=").append(maquinariaBean.getCodMaquina());
                                            consulta.append(")");
                                    consulta.append(" order by ep.NOMBRE_ESPECIFICACIONES_PROCESO");
            LOGGER.debug("consulta cargar agregar receta maquinaria " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            maquinariaRecetaDetalleEspecificacionProcesosAgregarList=new ArrayList<MaquinariaRecetaDetalleEspecificacionProceso>();
            while (res.next()) 
            {
                MaquinariaRecetaDetalleEspecificacionProceso bean=new MaquinariaRecetaDetalleEspecificacionProceso();
                bean.getEspecificacionProceso().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                bean.getEspecificacionProceso().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                bean.getEspecificacionProceso().getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                bean.getEspecificacionProceso().getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                bean.setPorcientoTolerancia(res.getDouble("PORCIENTO_TOLERANCIA"));
                bean.getUnidadesMedida().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA"));
                bean.getTiposDescripcion().setCodTipoDescripcion(res.getInt("COD_TIPO_DESCRIPCION"));
                maquinariaRecetaDetalleEspecificacionProcesosAgregarList.add(bean);
                
            }
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    
    public ManagedMaquinariaRecetaEspecificacion() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
        maquinariaBean.setCodMaquina("0");
    }
    public String seleccionarMaquinariaAreaEmpresa_action()
    {
        maquinariaBean=(Maquinaria)maquinariaDataTable.getRowData();
        this.cargarMaquinariaRecetaEspecificacion();
        return null;
    }
    private void cargarMaquinariasAreaEmpresa()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO,ae.NOMBRE_AREA_EMPRESA");
                                        consulta.append(" from MAQUINARIAS m ");
                                                consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=m.COD_AREA_EMPRESA");
                                        consulta.append(" where ae.COD_AREA_EMPRESA in (80,81,82,95)");
                                                consulta.append(" and m.COD_TIPO_EQUIPO=2");
                                        consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            maquinariaList=new ArrayList<Maquinaria>();
            while (res.next()) 
            {
                Maquinaria nuevo=new Maquinaria();
                nuevo.setCodMaquina(res.getString("COD_MAQUINA"));
                nuevo.setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                nuevo.setCodigo(res.getString("CODIGO"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                maquinariaList.add(nuevo);
            }
            res.close();
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex)
        {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    public String getCargarMaquinariaRecetaEspecificacion()
    {
        this.cargarMaquinariasAreaEmpresa();
        this.cargarMaquinariaRecetaEspecificacion();
        return null;
    }
    private void cargarMaquinariaRecetaEspecificacion()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ep.COD_ESPECIFICACION_PROCESO,ep.NOMBRE_ESPECIFICACIONES_PROCESO");
                                                consulta.append(" ,isnull(um.NOMBRE_UNIDAD_MEDIDA,'') as NOMBRE_UNIDAD_MEDIDA,td.NOMBRE_TIPO_DESCRIPCION");
                                        consulta.append(" from MAQUINARIA_RECETA_DETALLE_ESPECIFICACION_PROCESO mrcd");
                                                consulta.append(" inner join ESPECIFICACIONES_PROCESOS ep on ep.COD_ESPECIFICACION_PROCESO=mrcd.COD_ESPECIFICACION_PROCESO");
                                                consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ep.COD_UNIDAD_MEDIDA");
                                                consulta.append(" inner join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=ep.COD_TIPO_DESCRIPCION");
                                        consulta.append(" where mrcd.COD_MAQUINARIA=").append(maquinariaBean.getCodMaquina());
                                        consulta.append(" order by ep.NOMBRE_ESPECIFICACIONES_PROCESO    ");
            LOGGER.debug(" consulta cargar maquinaria receta " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            maquinariaRecetaDetalleEspecificacionProcesoList=new ArrayList<MaquinariaRecetaDetalleEspecificacionProceso>();
            while (res.next()) 
            {
                MaquinariaRecetaDetalleEspecificacionProceso nuevo=new MaquinariaRecetaDetalleEspecificacionProceso();
                nuevo.getEspecificacionProceso().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                nuevo.getEspecificacionProceso().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                nuevo.getEspecificacionProceso().getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                nuevo.getEspecificacionProceso().getTiposDescripcion().setNombreTipoDescripcion(res.getString("NOMBRE_TIPO_DESCRIPCION"));
                maquinariaRecetaDetalleEspecificacionProcesoList.add(nuevo);
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    
    
    //<editor-fold desc="getter and setter" defaultstate="collapsed">
        
    
    
        public List<Maquinaria> getMaquinariaList() {
            return maquinariaList;
        }

        public void setMaquinariaList(List<Maquinaria> maquinariaList) {
            this.maquinariaList = maquinariaList;
        }
        
        public HtmlDataTable getMaquinariaDataTable() {
            return maquinariaDataTable;
        }

        public void setMaquinariaDataTable(HtmlDataTable maquinariaDataTable) {
            this.maquinariaDataTable = maquinariaDataTable;
        }

        public Maquinaria getMaquinariaBean() {
            return maquinariaBean;
        }

        public void setMaquinariaBean(Maquinaria maquinariaBean) {
            this.maquinariaBean = maquinariaBean;
        }
        
        public List<MaquinariaRecetaDetalleEspecificacionProceso> getMaquinariaRecetaDetalleEspecificacionProcesoList() {
            return maquinariaRecetaDetalleEspecificacionProcesoList;
        }

        public void setMaquinariaRecetaDetalleEspecificacionProcesoList(List<MaquinariaRecetaDetalleEspecificacionProceso> maquinariaRecetaDetalleEspecificacionProcesoList) {
            this.maquinariaRecetaDetalleEspecificacionProcesoList = maquinariaRecetaDetalleEspecificacionProcesoList;
        }
        
        public List<MaquinariaRecetaDetalleEspecificacionProceso> getMaquinariaRecetaDetalleEspecificacionProcesosAgregarList() {
            return maquinariaRecetaDetalleEspecificacionProcesosAgregarList;
        }

        public void setMaquinariaRecetaDetalleEspecificacionProcesosAgregarList(List<MaquinariaRecetaDetalleEspecificacionProceso> maquinariaRecetaDetalleEspecificacionProcesosAgregarList) {
            this.maquinariaRecetaDetalleEspecificacionProcesosAgregarList = maquinariaRecetaDetalleEspecificacionProcesosAgregarList;
        }
        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }
    
    //</editor-fold>

    
}
