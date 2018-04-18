/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.RendimientoEstandarComponentesProd;
import com.cofar.bean.RendimientoEstandarFormaFarmaceutica;
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
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ
 */
public class ManagedRendimientoEstandarProductos  extends ManagedBean{

    private List<RendimientoEstandarComponentesProd> rendimientoEstandarComponentesProdList;
    private List<RendimientoEstandarFormaFarmaceutica> rendimientoEstandarFormaFarmaceuticaList;
    private RendimientoEstandarComponentesProd rendimientoEstandarComponentesProdAgregar;
    private RendimientoEstandarFormaFarmaceutica rendimientoEstandarFormaFarmaceuticaAgregar;
    private RendimientoEstandarComponentesProd rendimientoEstandarComponentesProdEditar;
    private RendimientoEstandarFormaFarmaceutica rendimientoEstandarFormaFarmaceuticaEditar;
    private HtmlDataTable rendimientoEstandarProductoDataTable=new HtmlDataTable();
    private HtmlDataTable rendimientoEstandarFormaDataTable=new HtmlDataTable();
    
    private List<SelectItem> formasFarmaceuticasSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> componentesProdSelectList=new ArrayList<SelectItem>();
    private Connection con=null;
    private String mensaje="";
    /**
     * Creates a new instance of ManagedRendimientoEstandarProductos
     */
    public String seleccionarEditarRendimientoEstandarComponentesProd()
    {
        rendimientoEstandarComponentesProdEditar=(RendimientoEstandarComponentesProd) rendimientoEstandarProductoDataTable.getRowData();
        return null;
    }
    public String seleccionarEditarRendimientoEstandarForma()
    {
        rendimientoEstandarFormaFarmaceuticaEditar=(RendimientoEstandarFormaFarmaceutica) rendimientoEstandarFormaDataTable.getRowData();
        return null;
    }
    public String guardarEditarRendimientoEstandarComponentesProd_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" update RENDIMIENTO_ESTANDAR_COMPONENTES_PROD ");
                                        consulta.append(" set COD_ESTADO_REGISTRO=2,");
                                                consulta.append(" FECHA_FINAL=GETDATE()");
                                        consulta.append(" where COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and COD_COMPPROD=").append(rendimientoEstandarComponentesProdEditar.getComponentesProd().getCodCompprod());
            LOGGER.debug("consulta actualiza estado" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) {
                LOGGER.info("se registro");
            }
            consulta = new StringBuilder(" INSERT INTO RENDIMIENTO_ESTANDAR_COMPONENTES_PROD(COD_COMPPROD, FECHA_INICIO,");
                                consulta.append("COD_ESTADO_REGISTRO, PORCIENTO_RENDIMIENTO_MINIMO, PORCIENTO_RENDIMIENTO_MAXIMO)");
                        consulta.append("VALUES (");
                            consulta.append(rendimientoEstandarComponentesProdEditar.getComponentesProd().getCodCompprod()).append(",");
                            consulta.append("getdate(),");
                            consulta.append("1,");
                            consulta.append(rendimientoEstandarComponentesProdEditar.getPorcientoRendimientoMinimo()).append(",");
                            consulta.append(rendimientoEstandarComponentesProdEditar.getPorcientoRendimientoMaximo());
                        consulta.append(")");
            LOGGER.debug(" consulta registrar rendimiento estandar " + consulta.toString());
             pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) {
                LOGGER.info("se registro");
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
        if(mensaje.equals("1"))
        {
            this.cargarRendimientoEstandarComponentesProd();
        }
        return null;
    }
    public String guardarAgregarRendimientoEstandarComponentesProd_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" INSERT INTO RENDIMIENTO_ESTANDAR_COMPONENTES_PROD(COD_COMPPROD, FECHA_INICIO,");
                                        consulta.append("COD_ESTADO_REGISTRO, PORCIENTO_RENDIMIENTO_MINIMO, PORCIENTO_RENDIMIENTO_MAXIMO)");
                                        consulta.append("VALUES (");
                                            consulta.append(rendimientoEstandarComponentesProdAgregar.getComponentesProd().getCodCompprod()).append(",");
                                            consulta.append("getdate(),");
                                            consulta.append("1,");
                                            consulta.append(rendimientoEstandarComponentesProdAgregar.getPorcientoRendimientoMinimo()).append(",");
                                            consulta.append(rendimientoEstandarComponentesProdAgregar.getPorcientoRendimientoMaximo());
                                        consulta.append(")");
            LOGGER.debug(" consulta registrar rendimiento estandar " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) {
                LOGGER.info("se registro");
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
        if(mensaje.equals("1"))
        {
            this.cargarRendimientoEstandarComponentesProd();
        }
        return null;
    }
    public String guardarEditarRendimientoEstandarFormaFarmaceutica_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("update RENDIMIENTO_ESTANDAR_FORMA_FARMACEUTICA set");
                                    consulta.append(" fecha_final=getdate(),");
                                            consulta.append(" COD_ESTADO_REGISTRO=2");
                                    consulta.append(" where cod_forma=").append(rendimientoEstandarFormaFarmaceuticaEditar.getFormasFarmaceuticas().getCodForma());
                                            consulta.append(" and COD_ESTADO_REGISTRO=1");
            LOGGER.debug("consulta" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) {
                LOGGER.info("se registro");
            }
            consulta = new StringBuilder("INSERT INTO RENDIMIENTO_ESTANDAR_FORMA_FARMACEUTICA(COD_FORMA, FECHA_INICIO,");
                            consulta.append(" COD_ESTADO_REGISTRO,PORCIENTO_RENDIMIENTO_MINIMO,PORCIENTO_RENDIMIENTO_MAXIMO)");
                        consulta.append(" VALUES (");
                                consulta.append(rendimientoEstandarFormaFarmaceuticaEditar.getFormasFarmaceuticas().getCodForma()).append(",");
                                consulta.append("GETDATE(),");
                                consulta.append("1,");
                                consulta.append(rendimientoEstandarFormaFarmaceuticaEditar.getPorcientoRendimientoMinimo()).append(",");
                                consulta.append(rendimientoEstandarFormaFarmaceuticaEditar.getPorcientoRendimientoMaximo());
                        consulta.append(")");
            LOGGER.debug("consulta registrar rendimiento forma farmaceutica " + consulta.toString());
            pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) {
                LOGGER.info("se registro");
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
        if(mensaje.equals("1"))
        {this.cargarRendimientoEstandarFormaFarmaceutica();}
        return null;
    }
    public String guardarAgregarRendimientoEstandarFormaFarmaceutica_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO RENDIMIENTO_ESTANDAR_FORMA_FARMACEUTICA(COD_FORMA, FECHA_INICIO,");
                                            consulta.append(" COD_ESTADO_REGISTRO,PORCIENTO_RENDIMIENTO_MINIMO,PORCIENTO_RENDIMIENTO_MAXIMO)");
                                        consulta.append(" VALUES (");
                                                consulta.append(rendimientoEstandarFormaFarmaceuticaAgregar.getFormasFarmaceuticas().getCodForma()).append(",");
                                                consulta.append("GETDATE(),");
                                                consulta.append("1,");
                                                consulta.append(rendimientoEstandarFormaFarmaceuticaAgregar.getPorcientoRendimientoMinimo()).append(",");
                                                consulta.append(rendimientoEstandarFormaFarmaceuticaAgregar.getPorcientoRendimientoMaximo());
                                        consulta.append(")");
            LOGGER.debug("consulta registrar rendimiento forma farmaceutica " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) {
                LOGGER.info("se registro");
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
        if(mensaje.equals("1"))
        {
            this.cargarRendimientoEstandarFormaFarmaceutica();
        }
        return null;
    }
    
    public String cargarAgregarFormaFarmaceuticaAgregar()
    {
        rendimientoEstandarFormaFarmaceuticaAgregar=new RendimientoEstandarFormaFarmaceutica();
        this.cargarFormasFarmaceuticasAgregarSelectList();
        return null;
    }
    public String cargarAgregarComponentesProdAgregar()
    {
        rendimientoEstandarComponentesProdAgregar=new RendimientoEstandarComponentesProd();
        this.cargarComponentesProdAgregarSelectList();
        return null;
    }
    public ManagedRendimientoEstandarProductos() {
        LOGGER=LogManager.getRootLogger();
    }
    
    private void cargarComponentesProdAgregarSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,cp.TAMANIO_LOTE_PRODUCCION");
                                        consulta.append(" from COMPONENTES_PROD cp ");
                                        consulta.append(" where cp.COD_ESTADO_COMPPROD=1");
                                                        consulta.append(" and cp.COD_TIPO_PRODUCCION in (1,3)");
                                                consulta.append(" and cp.COD_COMPPROD not in");
                                                consulta.append(" (");
                                                        consulta.append(" select rec.COD_COMPPROD");
                                                        consulta.append(" from RENDIMIENTO_ESTANDAR_COMPONENTES_PROD rec ");
                                                        consulta.append(" where rec.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" )");
                                        consulta.append(" order by cp.nombre_prod_semiterminado,cp.TAMANIO_LOTE_PRODUCCION");
            LOGGER.debug("consulta cargar rendimiento componentes prod " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            componentesProdSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                componentesProdSelectList.add(new SelectItem(res.getString("COD_COMPPROD"),res.getString("nombre_prod_semiterminado")+"("+res.getInt("TAMANIO_LOTE_PRODUCCION")+")"));
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
    private void cargarFormasFarmaceuticasAgregarSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ff.cod_forma,ff.nombre_forma");
                                        consulta.append(" from FORMAS_FARMACEUTICAS ff");
                                        consulta.append(" where ff.cod_estado_registro=1");
                                        consulta.append(" and ff.cod_forma not in ");
                                        consulta.append(" (");
                                        consulta.append(" select re.COD_FORMA from RENDIMIENTO_ESTANDAR_FORMA_FARMACEUTICA RE");
                                        consulta.append(" where re.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" )");
                                        consulta.append(" order by ff.nombre_forma");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            formasFarmaceuticasSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                formasFarmaceuticasSelectList.add(new SelectItem(res.getString("cod_forma"),res.getString("nombre_forma")));
                
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
    public String getCargarRendimientoEstandar()
    {
        this.cargarRendimientoEstandarComponentesProd();
        this.cargarRendimientoEstandarFormaFarmaceutica();
        return null;
    }
    private void cargarRendimientoEstandarFormaFarmaceutica()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ff.cod_forma,ff.nombre_forma,re.PORCIENTO_RENDIMIENTO_MINIMO,re.PORCIENTO_RENDIMIENTO_MAXIMO,re.FECHA_INICIO");
                                    consulta.append(" from RENDIMIENTO_ESTANDAR_FORMA_FARMACEUTICA re");
                                            consulta.append(" inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=re.COD_FORMA");
                                    consulta.append(" where re.COD_ESTADO_REGISTRO=1");
                                    consulta.append(" order by ff.nombre_forma");
            LOGGER.debug("consulta cargar rendimiento estandar ff " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            rendimientoEstandarFormaFarmaceuticaList=new ArrayList<RendimientoEstandarFormaFarmaceutica>();
            while (res.next()) 
            {
                RendimientoEstandarFormaFarmaceutica nuevo=new RendimientoEstandarFormaFarmaceutica();
                nuevo.getFormasFarmaceuticas().setCodForma(res.getString("cod_forma"));
                nuevo.getFormasFarmaceuticas().setNombreForma(res.getString("nombre_forma"));
                nuevo.setPorcientoRendimientoMinimo(res.getDouble("PORCIENTO_RENDIMIENTO_MINIMO"));
                nuevo.setPorcientoRendimientoMaximo(res.getDouble("PORCIENTO_RENDIMIENTO_MAXIMO"));
                nuevo.setFechaInicio(res.getTimestamp("FECHA_INICIO"));
                rendimientoEstandarFormaFarmaceuticaList.add(nuevo);
                
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
    private void cargarRendimientoEstandarComponentesProd()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cp.nombre_prod_semiterminado,cp.TAMANIO_LOTE_PRODUCCION,re.PORCIENTO_RENDIMIENTO_MINIMO,re.PORCIENTO_RENDIMIENTO_MAXIMO,re.FECHA_INICIO");
                                                consulta.append(" ,cp.COD_COMPPROD");
                                        consulta.append(" from RENDIMIENTO_ESTANDAR_COMPONENTES_PROD re");
                                                consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=re.COD_COMPPROD");
                                        consulta.append(" where re.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by cp.nombre_prod_semiterminado");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            rendimientoEstandarComponentesProdList=new ArrayList<RendimientoEstandarComponentesProd>();
            while (res.next()) 
            {
                RendimientoEstandarComponentesProd nuevo=new RendimientoEstandarComponentesProd();
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getComponentesProd().setTamanioLoteProduccion(res.getInt("TAMANIO_LOTE_PRODUCCION"));
                nuevo.setPorcientoRendimientoMinimo(res.getDouble("PORCIENTO_RENDIMIENTO_MINIMO"));
                nuevo.setPorcientoRendimientoMaximo(res.getDouble("PORCIENTO_RENDIMIENTO_MAXIMO"));
                nuevo.setFechaInicio(res.getTimestamp("FECHA_INICIO"));
                rendimientoEstandarComponentesProdList.add(nuevo);
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

        public RendimientoEstandarComponentesProd getRendimientoEstandarComponentesProdAgregar() {
            return rendimientoEstandarComponentesProdAgregar;
        }

        public void setRendimientoEstandarComponentesProdAgregar(RendimientoEstandarComponentesProd rendimientoEstandarComponentesProdAgregar) {
            this.rendimientoEstandarComponentesProdAgregar = rendimientoEstandarComponentesProdAgregar;
        }

        public HtmlDataTable getRendimientoEstandarProductoDataTable() {
            return rendimientoEstandarProductoDataTable;
        }

        public void setRendimientoEstandarProductoDataTable(HtmlDataTable rendimientoEstandarProductoDataTable) {
            this.rendimientoEstandarProductoDataTable = rendimientoEstandarProductoDataTable;
        }

        public HtmlDataTable getRendimientoEstandarFormaDataTable() {
            return rendimientoEstandarFormaDataTable;
        }

        public void setRendimientoEstandarFormaDataTable(HtmlDataTable rendimientoEstandarFormaDataTable) {
            this.rendimientoEstandarFormaDataTable = rendimientoEstandarFormaDataTable;
        }


        public RendimientoEstandarFormaFarmaceutica getRendimientoEstandarFormaFarmaceuticaAgregar() {
            return rendimientoEstandarFormaFarmaceuticaAgregar;
        }

        public void setRendimientoEstandarFormaFarmaceuticaAgregar(RendimientoEstandarFormaFarmaceutica rendimientoEstandarFormaFarmaceuticaAgregar) {
            this.rendimientoEstandarFormaFarmaceuticaAgregar = rendimientoEstandarFormaFarmaceuticaAgregar;
        }

        public List<SelectItem> getFormasFarmaceuticasSelectList() {
            return formasFarmaceuticasSelectList;
        }

        public void setFormasFarmaceuticasSelectList(List<SelectItem> formasFarmaceuticasSelectList) {
            this.formasFarmaceuticasSelectList = formasFarmaceuticasSelectList;
        }

        public List<SelectItem> getComponentesProdSelectList() {
            return componentesProdSelectList;
        }

        public void setComponentesProdSelectList(List<SelectItem> componentesProdSelectList) {
            this.componentesProdSelectList = componentesProdSelectList;
        }

        public RendimientoEstandarComponentesProd getRendimientoEstandarComponentesProdEditar() {
            return rendimientoEstandarComponentesProdEditar;
        }

        public void setRendimientoEstandarComponentesProdEditar(RendimientoEstandarComponentesProd rendimientoEstandarComponentesProdEditar) {
            this.rendimientoEstandarComponentesProdEditar = rendimientoEstandarComponentesProdEditar;
        }

        public RendimientoEstandarFormaFarmaceutica getRendimientoEstandarFormaFarmaceuticaEditar() {
            return rendimientoEstandarFormaFarmaceuticaEditar;
        }

        public void setRendimientoEstandarFormaFarmaceuticaEditar(RendimientoEstandarFormaFarmaceutica rendimientoEstandarFormaFarmaceuticaEditar) {
            this.rendimientoEstandarFormaFarmaceuticaEditar = rendimientoEstandarFormaFarmaceuticaEditar;
        }




    
        

        public List<RendimientoEstandarComponentesProd> getRendimientoEstandarComponentesProdList() {
            return rendimientoEstandarComponentesProdList;
        }

        public void setRendimientoEstandarComponentesProdList(List<RendimientoEstandarComponentesProd> rendimientoEstandarComponentesProdList) {
            this.rendimientoEstandarComponentesProdList = rendimientoEstandarComponentesProdList;
        }

        public List<RendimientoEstandarFormaFarmaceutica> getRendimientoEstandarFormaFarmaceuticaList() {
            return rendimientoEstandarFormaFarmaceuticaList;
        }

        public void setRendimientoEstandarFormaFarmaceuticaList(List<RendimientoEstandarFormaFarmaceutica> rendimientoEstandarFormaFarmaceuticaList) {
            this.rendimientoEstandarFormaFarmaceuticaList = rendimientoEstandarFormaFarmaceuticaList;
        }

        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }
    
    //</editor-fold>
    
    
    
}
