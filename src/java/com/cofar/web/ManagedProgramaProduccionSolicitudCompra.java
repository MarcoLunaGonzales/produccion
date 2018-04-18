/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.Materiales;
import com.cofar.bean.MaterialesCompraProveedor;
import com.cofar.bean.MesesStockGrupo;
import com.cofar.bean.ProgramaProduccionPeriodo;
import com.cofar.bean.ProgramaProduccionPeriodoSolicitudCompra;
import com.cofar.bean.ProgramaProduccionPeriodoSolicitudCompraDetalle;
import com.cofar.bean.ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion;
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
public class ManagedProgramaProduccionSolicitudCompra extends ManagedBean
{
    private Connection con=null;
    private String mensaje="";
    private List<ProgramaProduccionPeriodo> programaProduccionPeriodoList;
    private ProgramaProduccionPeriodo programaProduccionPeriodoBean;
    private HtmlDataTable programaProduccionPeriodoDataTable=new HtmlDataTable();
    private List<ProgramaProduccionPeriodoSolicitudCompra> programaProduccionPeriodoSolicitudCompraList;
    private ProgramaProduccionPeriodoSolicitudCompra programaProduccionPeriodoSolicitudCompraBean;
    private HtmlDataTable programaProduccionPeriodoSolicitudCompraDataTable=new HtmlDataTable();
    private List<ProgramaProduccionPeriodoSolicitudCompraDetalle> programaProduccionPeriodoSolicitudCompraDetalleList;
    private HtmlDataTable programaProduccionPeriodoSolicitudCompraDetalleDataTable=new HtmlDataTable();
    private List<SelectItem> unidadesMedidaSelectList;
    private List<SelectItem> estadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList;
    private List<SelectItem> tiposTransporteSelectList;
    private ProgramaProduccionPeriodoSolicitudCompraDetalle programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor;
    private ProgramaProduccionPeriodoSolicitudCompra programaProduccionPeriodoSolicitudCompraCambioProveedor;
    //variables para materiales compra proveedor
    private List<MaterialesCompraProveedor> materialesCompraProveedorList;
    private MaterialesCompraProveedor materialesCompraProveedorBuscar=new MaterialesCompraProveedor();
    private MaterialesCompraProveedor materialesCompraProveedorAgregar;
    private List<SelectItem> gruposSelectList;
    private List<SelectItem> capitulosSelectList;
    private List<SelectItem> proveedoresSelectList;
    //configuracion meses stock grupo
    private List<MesesStockGrupo> mesesStockGrupoList;
    private MesesStockGrupo mesesStockGrupoEditar;
    private MesesStockGrupo mesesStockGrupoBuscar=new MesesStockGrupo();
    private List<SelectItem> gruposCapitulosSelectList;
    private List<SelectItem> tiposCompraSelectList;
    private int[] codGrupoSelectBuscarList={};
    //buscar materiales agregar
    private Materiales materialesBuscarAgregar=new Materiales();
    private List<Materiales> materialesList;
    private HtmlDataTable materialesDataTable;
    
    /**
     * Creates a new instance of ManagedProgramaProduccionSolicitudCompra
     */
    public ManagedProgramaProduccionSolicitudCompra() {
        LOGGER=LogManager.getLogger("Compras");
    }
    //<editor-fold desc="buscar agregar material a OC" defaultstate="collapsed">
        public String seleccionarAgregarMaterialSolicitudOrdenCompra_action()
        {
            Materiales material=(Materiales)materialesDataTable.getRowData();
            ProgramaProduccionPeriodoSolicitudCompraDetalle agregar=new ProgramaProduccionPeriodoSolicitudCompraDetalle();
            agregar.setMateriales(material);
            ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion nuevo=new ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion();
            agregar.setProgramaProduccionPeriodoSolicitudCompraDetalleFraccionList(new ArrayList<ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion>());
            agregar.getProgramaProduccionPeriodoSolicitudCompraDetalleFraccionList().add(nuevo);
            programaProduccionPeriodoSolicitudCompraDetalleList.add(agregar);
            return null;
        }
        public String buscarMaterialAgregar_action()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO");
                                            consulta.append(" from MATERIALES m");
                                                    consulta.append(" inner join GRUPOS g on g.COD_GRUPO=m.COD_GRUPO");
                                                    consulta.append(" inner join CAPITULOS c on c.COD_CAPITULO=g.COD_CAPITULO");
                                            consulta.append(" where m.COD_ESTADO_REGISTRO=1");
                                                    consulta.append(" and g.COD_CAPITULO in (2,3,4,8) ");
                                                    if(materialesBuscarAgregar.getNombreMaterial().trim().length()>0)
                                                            consulta.append(" and m.NOMBRE_MATERIAL like '%").append(materialesBuscarAgregar.getNombreMaterial()).append("%'");
                                                    if(materialesBuscarAgregar.getGrupo().getCodGrupo()>0)
                                                            consulta.append(" and m.COD_GRUPO=").append(materialesBuscarAgregar.getGrupo().getCodGrupo());
                                                    if(materialesBuscarAgregar.getGrupo().getCapitulo().getCodCapitulo()>0)
                                                            consulta.append(" and g.COD_CAPITULO=").append(materialesBuscarAgregar.getGrupo().getCapitulo().getCodCapitulo());
                                            consulta.append(" order by m.NOMBRE_MATERIAL");
                LOGGER.debug("consulta cargar materiales " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                materialesList=new ArrayList<Materiales>();
                while (res.next()) 
                {
                    Materiales nuevo=new Materiales();
                    nuevo.setCodMaterial(res.getString("COD_MATERIAL"));
                    nuevo.setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    nuevo.getGrupo().setNombreGrupo(res.getString("NOMBRE_GRUPO"));
                    nuevo.getGrupo().getCapitulo().setNombreCapitulo(res.getString("NOMBRE_CAPITULO"));
                    materialesList.add(nuevo);
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
            return null;
        }
        public String agregarMaterialCompraProveedor_action()
        {
            LOGGER.debug("entreo agergar material comra");
            materialesBuscarAgregar=new Materiales();
            materialesList=new ArrayList<Materiales>();
            return null;
        }
        public String codCapituloMaterialBuscarAgregar_change()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select g.COD_GRUPO,g.NOMBRE_GRUPO");
                                        consulta.append(" from grupos g");
                                        consulta.append(" where g.COD_ESTADO_REGISTRO=1");
                                            if(Integer.valueOf(materialesBuscarAgregar.getGrupo().getCapitulo().getCodCapitulo())>0)
                                                consulta.append(" and g.COD_CAPITULO=").append(materialesBuscarAgregar.getGrupo().getCapitulo().getCodCapitulo());
                                            else
                                                consulta.append(" and g.COD_CAPITULO in (2,3,4,8)");
                                        consulta.append(" order by g.NOMBRE_GRUPO");
                LOGGER.debug("consulta cargar grupos" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                gruposSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    gruposSelectList.add(new SelectItem(res.getString("COD_GRUPO"),res.getString("NOMBRE_GRUPO")));
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
            return null;
        }
    //</editor-fold>
    //<editor-fold desc="meses stock grupo configuracion" defaultstate="collapsed">
        private void cargarTiposCompraSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tc.COD_TIPO_COMPRA,tc.NOMBRE_TIPO_COMPRA");
                                        consulta.append(" from TIPOS_COMPRA tc");
                                        consulta.append(" where tc.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by tc.NOMBRE_TIPO_COMPRA");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposCompraSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposCompraSelectList.add(new SelectItem(res.getInt("COD_TIPO_COMPRA"),res.getString("NOMBRE_TIPO_COMPRA")));
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
        
        private void cargarGruposCapitulosSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select '('+c.NOMBRE_CAPITULO+') '+g.NOMBRE_GRUPO as nombreGrupo,g.COD_GRUPO ");
                                            consulta.append(" from GRUPOS g");
                                                    consulta.append(" inner join CAPITULOS c on c.COD_CAPITULO=g.COD_CAPITULO");
                                            consulta.append(" where g.COD_ESTADO_REGISTRO=1");
                                                    consulta.append(" and c.COD_ESTADO_REGISTRO=1");
                                                    consulta.append(" and c.COD_CAPITULO in (2,3,4,8)");
                                            consulta.append(" order by c.NOMBRE_CAPITULO,g.NOMBRE_GRUPO");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                gruposCapitulosSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    gruposCapitulosSelectList.add(new SelectItem(res.getInt("COD_GRUPO"),res.getString("nombreGrupo")));
                    
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
        public String guardarEditarMesesStockGrupo_action()throws SQLException
        {
            mensaje = "";
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("UPDATE MESES_STOCK_GRUPO");
                                        consulta.append(" SET NRO_MESES_STOCK_MINIMO =").append(mesesStockGrupoEditar.getNroMesesStockMinimo());
                                                consulta.append(" ,NRO_MESES_STOCK_REPOSICION =").append(mesesStockGrupoEditar.getNroMesesStockReposicion());
                                                consulta.append(" ,NIVEL_MAXIMO_STOCK = ").append(mesesStockGrupoEditar.getNivelMaximoStock());
                                                consulta.append(" ,NIVEL_MINIMO_STOCK = ").append(mesesStockGrupoEditar.getNivelMinimoStock());
                                                consulta.append(" ,NUMERO_CICLOS = ").append(mesesStockGrupoEditar.getNroCiclos());
                                                consulta.append(" ,VERIFICAR_STOCK_HERMES =").append(mesesStockGrupoEditar.getVerificarStockHermes()?1:0);
                                                consulta.append(" ,VERIFICAR_CANTIDAD_LOTE =").append(mesesStockGrupoEditar.getVerificarCantidadLote()?1:0);
                                        consulta.append(" WHERE COD_GRUPO = ").append(mesesStockGrupoEditar.getGrupos().getCodGrupo());
                                                consulta.append(" and COD_TIPO_TRANSPORTE =").append(mesesStockGrupoEditar.getTiposTransporte().getCodTipoTransporte());
                                                consulta.append(" and COD_TIPO_COMPRA = ").append(mesesStockGrupoEditar.getTiposCompra().getCodTipoCompra());
                LOGGER.debug("consulta update meses stock " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0) LOGGER.info("se actualizo el mes stock grupo");
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
            if(mensaje.equals("1"))
            {
                this.cargarMesesStockGrupoList();
            }
            return null;
        }
        public String editarMesesStockGrupo_action()
        {
            for(MesesStockGrupo bean:mesesStockGrupoList)
            {
                if(bean.getChecked())
                {
                    mesesStockGrupoEditar=bean;
                    break;
                }
            }
            return null;
        }
        public String getCargarMesesStockGrupoList()
        {
            this.cargarGruposCapitulosSelectList();
            this.cargarTiposCompraSelectList();
            this.cargarTiposTransporteSelectList();
            this.cargarMesesStockGrupoList();
            return null;
        }
        public String buscarMesesStockGrupoList_action()
        {
            this.cargarMesesStockGrupoList();
            return null;
        }
        private void cargarMesesStockGrupoList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder codigosGrupo=new StringBuilder();
                for(Integer i:codGrupoSelectBuscarList)
                {
                    if(codigosGrupo.length()>0)codigosGrupo.append(",");
                    codigosGrupo.append(i);
                }
                StringBuilder consulta = new StringBuilder("select c.NOMBRE_CAPITULO,g.COD_GRUPO,g.NOMBRE_GRUPO,tc.COD_TIPO_COMPRA,tc.NOMBRE_TIPO_COMPRA,");
                                                    consulta.append(" tt.COD_TIPO_TRANSPORTE,tt.NOMBRE_TIPO_TRANSPORTE,msg.NIVEL_MAXIMO_STOCK,msg.NIVEL_MINIMO_STOCK,");
                                                    consulta.append(" msg.NRO_MESES_STOCK_MINIMO,msg.NRO_MESES_STOCK_REPOSICION,msg.NUMERO_CICLOS,msg.VERIFICAR_CANTIDAD_LOTE,");
                                                    consulta.append(" msg.VERIFICAR_STOCK_HERMES");
                                            consulta.append(" from MESES_STOCK_GRUPO msg ");
                                                    consulta.append(" inner join GRUPOS g on g.COD_GRUPO=msg.COD_GRUPO");
                                                    consulta.append(" inner join CAPITULOS c on c.COD_CAPITULO=g.COD_CAPITULO");
                                                    consulta.append(" inner join TIPOS_TRANSPORTE tt on tt.COD_TIPO_TRANSPORTE=msg.COD_TIPO_TRANSPORTE");
                                                    consulta.append(" inner join TIPOS_COMPRA tc on tc.COD_TIPO_COMPRA=msg.COD_TIPO_COMPRA");
                                            consulta.append(" where g.COD_ESTADO_REGISTRO=1");
                                                    if(codigosGrupo.length()>0)
                                                        consulta.append(" and g.COD_GRUPO in (").append(codigosGrupo.toString()).append(")");
                                                    if(mesesStockGrupoBuscar.getTiposCompra().getCodTipoCompra()>0)
                                                        consulta.append(" and msg.COD_TIPO_COMPRA=").append(mesesStockGrupoBuscar.getTiposCompra().getCodTipoCompra());
                                                    if(mesesStockGrupoBuscar.getTiposTransporte().getCodTipoTransporte()>0)
                                                        consulta.append(" and msg.COD_TIPO_TRANSPORTE=").append(mesesStockGrupoBuscar.getTiposTransporte().getCodTipoTransporte());
                                            consulta.append(" order by c.NOMBRE_CAPITULO,g.NOMBRE_GRUPO");
                LOGGER.debug(" consulta cargar meses stock grupo " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                mesesStockGrupoList=new ArrayList<MesesStockGrupo>();
                while (res.next()) 
                {
                    MesesStockGrupo nuevo=new MesesStockGrupo();
                    nuevo.getGrupos().getCapitulo().setNombreCapitulo(res.getString("NOMBRE_CAPITULO"));
                    nuevo.getGrupos().setCodGrupo(res.getInt("COD_GRUPO"));
                    nuevo.getGrupos().setNombreGrupo(res.getString("NOMBRE_GRUPO"));
                    nuevo.getTiposCompra().setCodTipoCompra(res.getInt("COD_TIPO_COMPRA"));
                    nuevo.getTiposCompra().setNombreTipoCompra(res.getString("NOMBRE_TIPO_COMPRA"));
                    nuevo.getTiposTransporte().setCodTipoTransporte(res.getInt("COD_TIPO_TRANSPORTE"));
                    nuevo.getTiposTransporte().setNombreTipoTransporte(res.getString("NOMBRE_TIPO_TRANSPORTE"));
                    nuevo.setNivelMaximoStock(res.getDouble("NIVEL_MAXIMO_STOCK"));
                    nuevo.setNivelMinimoStock(res.getDouble("NIVEL_MINIMO_STOCK"));
                    nuevo.setNroMesesStockMinimo(res.getDouble("NRO_MESES_STOCK_MINIMO"));
                    nuevo.setNroMesesStockReposicion(res.getDouble("NRO_MESES_STOCK_REPOSICION"));
                    nuevo.setNroCiclos(res.getDouble("NUMERO_CICLOS"));
                    nuevo.setVerificarStockHermes(res.getInt("VERIFICAR_CANTIDAD_LOTE")>0);
                    nuevo.setVerificarCantidadLote(res.getInt("VERIFICAR_STOCK_HERMES")>0);
                    mesesStockGrupoList.add(nuevo);
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
    //</editor-fold>
    
    
    //<editor-fold desc="Materiales compraProveedor" defaultstate="collapsed">
    public String agregarMaterialesCompraProveedorSelectList()
    {
        this.cargarProveedoresSelectList();
        materialesCompraProveedorAgregar=new MaterialesCompraProveedor();
        return null;
    }
    public String guardarCambioProveedorMaterialCompra_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("update MATERIALES_COMPRA_PROVEEDOR");
                                        consulta.append(" set ");
                                            consulta.append(" COD_ESTADO_REGISTRO=2");
                                            consulta.append(" where COD_MATERIAL=?");
            PreparedStatement pstUp = con.prepareStatement(consulta.toString());
            consulta=new StringBuilder("INSERT INTO MATERIALES_COMPRA_PROVEEDOR(COD_MATERIAL, COD_PROVEEDOR, COD_ESTADO_REGISTRO, FECHA_HABILITACION)");
                                consulta.append("VALUES (");
                                    consulta.append("?,");//codMaterial
                                    consulta.append(materialesCompraProveedorAgregar.getProveedores().getCodProveedor()).append(",");
                                    consulta.append("1,");//estado registro
                                    consulta.append("GETDATE()");
                                consulta.append(")");
            LOGGER.debug("consulta agregar material proveedor "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            for(MaterialesCompraProveedor bean:materialesCompraProveedorList)
            {
                if(bean.getChecked())
                {
                    pstUp.setString(1,bean.getMateriales().getCodMaterial());
                    if(pstUp.executeUpdate()>0)LOGGER.info("se cambio el estado del anterior proveedor");
                    pst.setString(1,bean.getMateriales().getCodMaterial());LOGGER.info("p1: "+bean.getMateriales().getCodMaterial());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el cambio de proveedor");
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
        if(mensaje.equals("1"))
        {
            this.cargarMaterialesCompraProveedorList();
        }
        return null;
    }
    private void cargarProveedoresSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select p.COD_PROVEEDOR,p.NOMBRE_PROVEEDOR");
                                        consulta.append(" from PROVEEDORES p ");
                                        consulta.append(" where p.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by p.NOMBRE_PROVEEDOR");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            proveedoresSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                proveedoresSelectList.add(new SelectItem(res.getInt("COD_PROVEEDOR"),res.getString("NOMBRE_PROVEEDOR")));
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
    private void cargarCapitulosSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select c.COD_CAPITULO,c.NOMBRE_CAPITULO");
                                        consulta.append(" from CAPITULOS c");
                                        consulta.append(" where c.COD_CAPITULO in (2,3,4,8)");
                                        consulta.append(" order by c.NOMBRE_CAPITULO");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            capitulosSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                capitulosSelectList.add(new SelectItem(res.getString("COD_CAPITULO"),res.getString("NOMBRE_CAPITULO")));
                
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
    private void cargarGruposSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select g.COD_GRUPO,g.NOMBRE_GRUPO");
                                        consulta.append(" from GRUPOS g");
                                        consulta.append(" where g.COD_CAPITULO in (2,3,4,8)");
                                            if(materialesCompraProveedorBuscar.getMateriales().getGrupo().getCapitulo().getCodCapitulo()>0)
                                                consulta.append(" and g.COD_CAPITULO=").append(materialesCompraProveedorBuscar.getMateriales().getGrupo().getCapitulo().getCodCapitulo());
                                        consulta.append(" order by g.NOMBRE_GRUPO");
            LOGGER.debug("consulta cargar grupos "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            gruposSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                gruposSelectList.add(new SelectItem(res.getString("COD_GRUPO"),res.getString("NOMBRE_GRUPO")));
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
    }
    public String getCargarMaterialesCompraProveedorList()
    {
        this.cargarCapitulosSelectList();
        this.cargarGruposSelectList();
        this.cargarMaterialesCompraProveedorList();
        return null;
    }
    public String codCapituloMaterialComraProveedor_change()
    {
        this.cargarGruposSelectList();
        return null;
    }
    public String buscarMaterialesCompraProveedorList_action()
    {
        this.cargarMaterialesCompraProveedorList();
        return null;
    }
    private void cargarMaterialesCompraProveedorList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO,mcp.FECHA_HABILITACION,");
                                                consulta.append(" isnull(p.NOMBRE_PROVEEDOR,'sin asignar ')as nombreProveedor,mcp.COD_PROVEEDOR");
                                        consulta.append(" from MATERIALES m ");
                                                consulta.append(" inner join GRUPOS g on g.COD_GRUPO=m.COD_GRUPO");
                                                consulta.append(" inner join CAPITULOS c on c.COD_CAPITULO=g.COD_CAPITULO");
                                                consulta.append(" left outer join MATERIALES_COMPRA_PROVEEDOR mcp on mcp.COD_MATERIAL=M.COD_MATERIAL");
                                                        consulta.append(" and mcp.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" LEFT OUTER JOIN PROVEEDORES P on p.COD_PROVEEDOR=mcp.COD_PROVEEDOR");
                                        consulta.append(" where m.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and c.COD_CAPITULO in (2,3,4,8)");
                                                if(materialesCompraProveedorBuscar.getMateriales().getGrupo().getCodGrupo()>0)
                                                    consulta.append(" and g.COD_GRUPO=").append(materialesCompraProveedorBuscar.getMateriales().getGrupo().getCodGrupo());
                                                if(materialesCompraProveedorBuscar.getMateriales().getGrupo().getCapitulo().getCodCapitulo()>0)
                                                    consulta.append(" and c.COD_CAPITULO=").append(materialesCompraProveedorBuscar.getMateriales().getGrupo().getCapitulo().getCodCapitulo());
                                        consulta.append(" ORDER BY 2");
            LOGGER.debug("consulta cargar materiales proveedor " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            materialesCompraProveedorList=new ArrayList<MaterialesCompraProveedor>();
            while (res.next()) 
            {
                MaterialesCompraProveedor nuevo=new MaterialesCompraProveedor();
                nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                nuevo.getMateriales().getGrupo().setNombreGrupo(res.getString("NOMBRE_GRUPO"));
                nuevo.getMateriales().getGrupo().getCapitulo().setNombreCapitulo(res.getString("NOMBRE_CAPITULO"));
                nuevo.setFechaHabilitacion(res.getTimestamp("FECHA_HABILITACION"));
                nuevo.getProveedores().setCodProveedor(res.getInt("COD_PROVEEDOR"));
                nuevo.getProveedores().setNombreProveedor(res.getString("nombreProveedor"));
                materialesCompraProveedorList.add(nuevo);
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
    }
    //</editor-fold>
    public String guardarProgramaProduccionPeriodoSolicitudCompraDetalleCambioProveedor_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst;
            StringBuilder consulta = new StringBuilder("select p.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA");
                                        consulta.append(" from PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA p ");
                                        consulta.append(" where p.COD_PROVEEDOR=").append(programaProduccionPeriodoSolicitudCompraCambioProveedor.getProveedores().getCodProveedor());
                                            consulta.append(" and p.COD_PROGRAMA_PROD=").append(programaProduccionPeriodoSolicitudCompraBean.getProgramaProduccionPeriodo().getCodProgramaProduccion());
            LOGGER.debug("consulta buscar codigo solicitud si existe " + consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            if(res.next())
            {
                programaProduccionPeriodoSolicitudCompraCambioProveedor.setCodProgramaProduccionPeriodoSolicitudCompra(res.getInt("COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA"));
            }
            else
            {
                consulta=new StringBuilder("INSERT INTO PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA(COD_PROGRAMA_PROD,FECHA_REGISTRO, COD_PROVEEDOR, NUMERO_SOLICITUD)");
                            consulta.append(" VALUES (");
                                    consulta.append(programaProduccionPeriodoSolicitudCompraBean.getProgramaProduccionPeriodo().getCodProgramaProduccion()).append(",");
                                    consulta.append(" GETDATE(),");
                                    consulta.append(programaProduccionPeriodoSolicitudCompraCambioProveedor.getProveedores().getCodProveedor()).append(",");
                                    consulta.append(" (select isnull(max(p.NUMERO_SOLICITUD),0)+1 from PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA p where p.COD_PROGRAMA_PROD=").append(programaProduccionPeriodoSolicitudCompraBean.getProgramaProduccionPeriodo().getCodProgramaProduccion()).append(" )");
                            consulta.append(")");
                LOGGER.debug("consulta registra proveedor sin asignacion "+consulta.toString());
                pst=con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                if(pst.executeUpdate()>0)LOGGER.info("se registro la solicitud para el proveedor");
                res=pst.getGeneratedKeys();
                if(res.next())programaProduccionPeriodoSolicitudCompraCambioProveedor.setCodProgramaProduccionPeriodoSolicitudCompra(res.getInt(1));
            }
            consulta=new StringBuilder("update PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                        consulta.append(" set COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA=").append(programaProduccionPeriodoSolicitudCompraCambioProveedor.getCodProgramaProduccionPeriodoSolicitudCompra());
                        consulta.append(" where COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=").append(programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor.getCodProgramaProduccionPeriodoSolicitudCompraDetalle());
            LOGGER.debug("consulta cambio proveedor detalle "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se cambio el proveedor ");
            for(int i=0;i<programaProduccionPeriodoSolicitudCompraDetalleList.size();i++)
            {
                if(programaProduccionPeriodoSolicitudCompraDetalleList.get(i).getCodProgramaProduccionPeriodoSolicitudCompraDetalle()==programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor.getCodProgramaProduccionPeriodoSolicitudCompraDetalle());
                {
                    programaProduccionPeriodoSolicitudCompraDetalleList.remove(i);
                }
            }
            con.commit();
            mensaje = "1";
        }
        catch (SQLException ex) 
        {
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
    private void cargarTiposTransporteSelectList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select tt.COD_TIPO_TRANSPORTE,tt.NOMBRE_TIPO_TRANSPORTE");
                                        consulta.append(" from TIPOS_TRANSPORTE tt");
                                        consulta.append(" order by tt.NOMBRE_TIPO_TRANSPORTE");
            LOGGER.debug("consulta cargar tipo Transporte " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposTransporteSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposTransporteSelectList.add(new SelectItem(res.getInt("COD_TIPO_TRANSPORTE"),res.getString("NOMBRE_TIPO_TRANSPORTE")));
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
    public String seleccionarProgramaProduccionPeriodoSolicitudCompraDetalleCambioProveedor_action()
    {
        programaProduccionPeriodoSolicitudCompraCambioProveedor=new ProgramaProduccionPeriodoSolicitudCompra();
        programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor=(ProgramaProduccionPeriodoSolicitudCompraDetalle)programaProduccionPeriodoSolicitudCompraDetalleDataTable.getRowData();
        this.cargarProveedoresSelectList();
        return null;
    }
    public String descartarProgramaProduccionPeriodoSolicitudCompraDetalle_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            ProgramaProduccionPeriodoSolicitudCompraDetalle bean=(ProgramaProduccionPeriodoSolicitudCompraDetalle)programaProduccionPeriodoSolicitudCompraDetalleDataTable.getRowData();
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" update PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                                        consulta.append(" set COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=2");
                                        consulta.append(" where COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=").append(bean.getCodProgramaProduccionPeriodoSolicitudCompraDetalle());
            LOGGER.debug("consulta descargar solicitud compra detalle programa produccion periodo " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0)LOGGER.info("se cambio el estado de la solicitud compra detalle ");
            consulta=new StringBuilder("select ep.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE,ep.NOMBRE_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                        consulta.append(" from ESTADOS_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE ep");
                        consulta.append(" where ep.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=2");
            LOGGER.debug("consulta obtener estado programa produccion solicitud compra "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            if(res.next())
            {
                bean.getEstadosProgramaProduccionPeriodoSolicitudCompraDetalle().setCodEstadoProgramaProduccionPeriodoSolicitudCompraDetalle(res.getInt("COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE"));
                bean.getEstadosProgramaProduccionPeriodoSolicitudCompraDetalle().setNombreEstadoProgramaProduccionPeriodoSolicitudCompraDetalle(res.getString("NOMBRE_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE"));
            }
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
        
        return null;
    }
    public String agregarProgramaProduccionPeriodoSolicitudCompraDetalleFraccion_action()throws SQLException
    {
        ProgramaProduccionPeriodoSolicitudCompraDetalle detalle=(ProgramaProduccionPeriodoSolicitudCompraDetalle)programaProduccionPeriodoSolicitudCompraDetalleDataTable.getRowData();
        detalle.getProgramaProduccionPeriodoSolicitudCompraDetalleFraccionList().add(new ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion());
        return null;
    }
    
    public String guardarProgramaProduccionPeriodoSolicitudCompraDetalle_action()throws SQLException
    {
        mensaje = "";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" UPDATE PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                                        consulta.append(" SET COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE =?,");
                                                consulta.append(" CANTIDAD_SOLICITUD_COMPRA = ?,");
                                                consulta.append(" PRECIO_UNITARIO = ?");
                                        consulta.append(" WHERE COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE =?");
            LOGGER.debug("consulta update solicitud compra detalle" + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            consulta=new StringBuilder(" delete PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE_FRACCION ");
                        consulta.append(" where COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=?");
                        consulta.append(" and isnull(COD_ORDEN_COMPRA,0)=0");
            LOGGER.debug("consulta delete seguimiento anterior "+consulta.toString());
            PreparedStatement pstDel=con.prepareStatement(consulta.toString());
            consulta=new StringBuilder(" INSERT INTO PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE_FRACCION(COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE, CANTIDAD_FRACCION,COD_TIPO_TRANSPORTE, OBSERVACION,GENERAR_OC)");
                        consulta.append(" VALUES (");
                                    consulta.append("?,");//cod programa produccion solicitud compra 
                                    consulta.append("?,");//cantidad material compra
                                    consulta.append("?,");//tipo transporte
                                    consulta.append("?,");//observacion
                                    consulta.append("?");//generar o.c.
                        consulta.append(")");
            LOGGER.debug("consulta registrar solicitud compra detalle fraccion" + consulta.toString());
            PreparedStatement pstFrac=con.prepareStatement(consulta.toString());
            
            for(ProgramaProduccionPeriodoSolicitudCompraDetalle bean:programaProduccionPeriodoSolicitudCompraDetalleList)
            {
                pst.setInt(1,bean.getEstadosProgramaProduccionPeriodoSolicitudCompraDetalle().getCodEstadoProgramaProduccionPeriodoSolicitudCompraDetalle());LOGGER.info("pst p1:"+bean.getEstadosProgramaProduccionPeriodoSolicitudCompraDetalle().getCodEstadoProgramaProduccionPeriodoSolicitudCompraDetalle());
                pst.setDouble(2,bean.getCantidadSolicitudCompra());LOGGER.info("pst p2:"+bean.getCantidadSolicitudCompra());
                pst.setDouble(3,bean.getPrecioUnitario());LOGGER.info("pst p3:"+bean.getPrecioUnitario());
                pst.setInt(4,bean.getCodProgramaProduccionPeriodoSolicitudCompraDetalle());LOGGER.info("pst p4:"+bean.getCodProgramaProduccionPeriodoSolicitudCompraDetalle());
                if(pst.executeUpdate()>0)LOGGER.info("se registro el cambio programa produccion solicitud detalle");
                pstDel.setInt(1,bean.getCodProgramaProduccionPeriodoSolicitudCompraDetalle());
                if(pstDel.executeUpdate()>0)LOGGER.info("se eliminaron solicitudes sin oc");
                for(ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion bean1:bean.getProgramaProduccionPeriodoSolicitudCompraDetalleFraccionList())
                {
                    if(bean1.getOrdenesCompraDetalle().getOrdenesCompra().getCodOrdenCompra()==0)
                    {
                        pstFrac.setInt(1,bean.getCodProgramaProduccionPeriodoSolicitudCompraDetalle());LOGGER.info("pstfrac p1: "+bean.getCodProgramaProduccionPeriodoSolicitudCompraDetalle());
                        pstFrac.setDouble(2,bean1.getCantidadFraccion());LOGGER.info("pstfrac p2:"+bean1.getCantidadFraccion());
                        pstFrac.setInt(3,bean1.getTiposTransporte().getCodTipoTransporte());LOGGER.info("pstfracc p3:"+bean1.getTiposTransporte().getCodTipoTransporte());
                        pstFrac.setString(4,bean1.getObservacion());LOGGER.info("pstfracc p4: "+bean1.getObservacion());
                        pstFrac.setInt(5,(bean1.getChecked()?1:0));LOGGER.info("pstfracc p5: "+(bean1.getChecked()?1:0));
                        if(pstFrac.executeUpdate()>0)LOGGER.info("se registro solicitud compra detalle");
                    }
                    
                }
            }
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            consulta=new StringBuilder(" exec PAA_REGISTRO_ORDEN_COMPRA_SOLICITUD_MATERIAL_EXPLOSION ");
                        consulta.append(programaProduccionPeriodoSolicitudCompraBean.getCodProgramaProduccionPeriodoSolicitudCompra()).append(",");
                        consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            LOGGER.debug("consulta verificar generacion o.c. "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se generaron oc ");
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
    private void cargarEstadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select eppsd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE,eppsd.NOMBRE_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                                        consulta.append(" from ESTADOS_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE eppsd");
                                        consulta.append(" where eppsd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE in (1,2,5,6,7)");
                                        consulta.append(" order by eppsd.NOMBRE_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            estadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                estadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList.add(new SelectItem(res.getInt("COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE"),res.getString("NOMBRE_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE")));
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

    
    private void cargarUnidadesMedidaSelectList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA+'('+um.ABREVIATURA+')' as nombreUnidadMedida");
                                        consulta.append(" from  UNIDADES_MEDIDA um ");
                                        consulta.append(" where um.COD_ESTADO_REGISTRO=1");
                                        consulta.append(" order by um.NOMBRE_UNIDAD_MEDIDA");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            unidadesMedidaSelectList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                unidadesMedidaSelectList.add(new SelectItem(res.getString("COD_UNIDAD_MEDIDA"),res.getString("nombreUnidadMedida")));
                
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
    public String seleccionarProgramaProduccionPeriodoSolicitudCompra_action()
    {
        programaProduccionPeriodoSolicitudCompraBean=(ProgramaProduccionPeriodoSolicitudCompra)programaProduccionPeriodoSolicitudCompraDataTable.getRowData();
        return null;
    }
    public String getCargarProgramaProduccionPeriodoSolicitudCompraDetalleList()
    {
        this.cargarTiposTransporteSelectList();
        this.cargarEstadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList();
        this.cargarUnidadesMedidaSelectList();
        this.cargarProgramaProduccionPeriodoSolicitudCompraDetalleList();
        this.cargarProveedoresSelectList();
        this.cargarCapitulosSelectList();
        return null;
    }
    private void cargarProgramaProduccionPeriodoSolicitudCompraDetalleList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pppscd.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE,");
                                                consulta.append(" m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,um2.NOMBRE_UNIDAD_MEDIDA as nombreUnidadCompra,");
                                                consulta.append(" pppscd.PRECIO_UNITARIO, pppscd.CANTIDAD_SOLICITUD_PRODUCCION,pppscd.CANTIDAD_SOLICITUD_COMPRA,pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                                                consulta.append(" ,detalleUltimaCompra.PRECIO_UNITARIO as ultimoPrecioUnitario,detalleUltimaCompra.CANTIDAD_NETA,detalleUltimaCompra.COD_ORDEN_COMPRA,detalleUltimaCompra.NOMBRE_TIPO_TRANSPORTE");
                                                consulta.append(" ,pppscf.CANTIDAD_FRACCION,pppscf.COD_TIPO_TRANSPORTE,pppscf.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE_FRACCION");
                                                consulta.append(" ,pppscf.OBSERVACION,datosOC.NRO_ORDEN_COMPRA,datosOC.COD_ORDEN_COMPRA as codOrdenCompraGenerada");
                                                consulta.append(" ,pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE,epp.NOMBRE_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                                                consulta.append(" ,tt.NOMBRE_TIPO_TRANSPORTE,aprobadosTransitorio.cantidad as cantidadExistenciaTransitorio,datosOrdenCompra.cantidadTransito");
                                        consulta.append(" from PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE pppscd");
                                                consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE_FRACCION pppscf on pppscd.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=pppscf.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                                                consulta.append(" inner join materiales m on m.COD_MATERIAL=pppscd.COD_MATERIAL");
                                                consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=pppscd.COD_UNIDAD_MEDIDA_PRODUCCION");
                                                consulta.append(" inner join UNIDADES_MEDIDA um2 on um2.COD_UNIDAD_MEDIDA=pppscd.COD_UNIDAD_MEDIDA_COMPRA");
                                                consulta.append(" left outer JOIN ESTADOS_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE epp on epp.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE");
                                                consulta.append(" left outer join TIPOS_TRANSPORTE tt on tt.COD_TIPO_TRANSPORTE=pppscf.COD_TIPO_TRANSPORTE");
                                                consulta.append(" outer apply(");
                                                        consulta.append(" select top 1 ocd.PRECIO_UNITARIO,ocd.CANTIDAD_NETA,oc.COD_ORDEN_COMPRA,tt.NOMBRE_TIPO_TRANSPORTE");
                                                        consulta.append(" from ORDENES_COMPRA oc");
                                                                consulta.append(" inner join ORDENES_COMPRA_DETALLE ocd on oc.COD_ORDEN_COMPRA = ocd.COD_ORDEN_COMPRA");
                                                                consulta.append(" left outer join TIPOS_TRANSPORTE tt on tt.COD_TIPO_TRANSPORTE=oc.COD_TIPO_TRANSPORTE");
                                                        consulta.append(" where oc.COD_ESTADO_COMPRA in (2, 5, 6, 7, 13, 14, 18)");
                                                                consulta.append(" and ocd.COD_MATERIAL = m.COD_MATERIAL");
                                                        consulta.append(" order by oc.FECHA_EMISION desc");
                                                consulta.append(" ) as detalleUltimaCompra");
                                                consulta.append(" outer apply");
                                                consulta.append(" (");
                                                        consulta.append(" select top 1 oc.NRO_ORDEN_COMPRA,oc.COD_ORDEN_COMPRA");
                                                        consulta.append(" from ORDENES_COMPRA oc ");
                                                                consulta.append(" inner join ORDENES_COMPRA_DETALLE ocd on ocd.COD_ORDEN_COMPRA=oc.COD_ORDEN_COMPRA");
                                                        consulta.append(" where oc.COD_ORDEN_COMPRA>0");
                                                                consulta.append(" and oc.COD_ORDEN_COMPRA=pppscf.COD_ORDEN_COMPRA");
                                                        consulta.append(" and ocd.COD_MATERIAL=pppscd.COD_MATERIAL");
                                                consulta.append(" ) as datosOC");
                                                consulta.append(" left join ");
                                                        consulta.append("(");
                                                                consulta.append("select iade.cod_material,SUM(iade.cantidad_restante) as cantidad");
                                                                consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                                                                        consulta.append(" inner join INGRESOS_ALMACEN ia on iade.COD_INGRESO_ALMACEN = ia.COD_INGRESO_ALMACEN");
                                                                consulta.append(" where ia.COD_ESTADO_INGRESO_ALMACEN = 1");
                                                                        consulta.append(" and ia.ESTADO_SISTEMA = 1");
                                                                        consulta.append(" and ia.FECHA_INGRESO_ALMACEN < getdate()");
                                                                        consulta.append(" and iade.COD_ESTADO_MATERIAL in (2, 6,8)");
                                                                        consulta.append(" and iade.CANTIDAD_RESTANTE > 0");
                                                                        consulta.append(" and ia.COD_ALMACEN = 17");
                                                                consulta.append(" group by iade.cod_material");
                                                        consulta.append(") aprobadosTransitorio on aprobadosTransitorio.cod_material = m.cod_material");
                                                consulta.append(" outer APPLY");
                                                        consulta.append(" (");
                                                                    consulta.append(" select sum((ocd.CANTIDAD_NETA - ocd.CANTIDAD_INGRESO_ALMACEN)) as cantidadTransito,max(oc.FECHA_ENTREGA) as FECHA_ENTREGA");
                                                                    consulta.append(" from ORDENES_COMPRA oc");
                                                                    consulta.append(" inner join ORDENES_COMPRA_DETALLE ocd on oc.COD_ORDEN_COMPRA = ocd.COD_ORDEN_COMPRA");
                                                                    consulta.append(" outer APPLY");
                                                                    consulta.append(" (");
                                                                    consulta.append(" select (case WHEN ocd.COD_UNIDAD_MEDIDA = e.COD_UNIDAD_MEDIDA then e.VALOR_EQUIVALENCIA else 1 / e.VALOR_EQUIVALENCIA end) as equivalencia");
                                                                    consulta.append(" from EQUIVALENCIAS e");
                                                                    consulta.append(" where (e.COD_UNIDAD_MEDIDA = ocd.COD_UNIDAD_MEDIDA and e.COD_UNIDAD_MEDIDA2 = m.COD_UNIDAD_MEDIDA) or");
                                                                    consulta.append(" (e.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and e.COD_UNIDAD_MEDIDA2 = ocd.COD_UNIDAD_MEDIDA)");
                                                                    consulta.append(" ) as equivalencia");
                                                                    consulta.append(" where oc.COD_ESTADO_COMPRA in (2, 6, 13) ");
                                                                    consulta.append(" and oc.ESTADO_SISTEMA = 1 and");
                                                                    consulta.append(" ocd.COD_MATERIAL = m.COD_MATERIAL and");
                                                                    consulta.append(" oc.FECHA_ENTREGA > '2015/01/01 00:00' and");
                                                                    consulta.append(" (ocd.CANTIDAD_NETA - ocd.CANTIDAD_INGRESO_ALMACEN) > 0");
                                                        consulta.append(" ) as datosOrdenCompra");
                                        consulta.append(" where pppscd.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA=").append(programaProduccionPeriodoSolicitudCompraBean.getCodProgramaProduccionPeriodoSolicitudCompra());
                                        consulta.append(" order by m.NOMBRE_MATERIAL    ");
            LOGGER.debug("consulta cargar programa produccion periodo solicitud compra detalle " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            consulta=new StringBuilder("select top 1 ocd.PRECIO_UNITARIO,ocd.CANTIDAD_NETA");
                        consulta.append(" from ORDENES_COMPRA oc");
                                consulta.append(" inner join ORDENES_COMPRA_DETALLE ocd on oc.COD_ORDEN_COMPRA=ocd.COD_ORDEN_COMPRA");
                        consulta.append(" where oc.COD_ESTADO_COMPRA in (2, 5, 6, 7, 13, 14, 18)");
                                consulta.append(" and ocd.COD_MATERIAL = ?");
                                consulta.append(" and ocd.COD_ORDEN_COMPRA<>?");
                        consulta.append(" order by oc.FECHA_EMISION desc");
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            ResultSet resDetalle;
            programaProduccionPeriodoSolicitudCompraDetalleList=new ArrayList<ProgramaProduccionPeriodoSolicitudCompraDetalle>();
            ProgramaProduccionPeriodoSolicitudCompraDetalle nuevo=new ProgramaProduccionPeriodoSolicitudCompraDetalle();
            while (res.next()) 
            {
                if(nuevo.getCodProgramaProduccionPeriodoSolicitudCompraDetalle()!=res.getInt("COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE"))
                {
                    if(nuevo.getCodProgramaProduccionPeriodoSolicitudCompraDetalle()>0)
                    {
                        /*pst.setString(1,nuevo.getMateriales().getCodMaterial());
                        pst.setInt(2,nuevo.getUltimaOrdenCompra().getOrdenesCompra().getCodOrdenCompra());
                        resDetalle=pst.executeQuery();
                        if(resDetalle.next())
                        {
                            nuevo.getPenultimaOrdenCompra().setCantidadNeta(resDetalle.getDouble("CANTIDAD_NETA"));
                            nuevo.getPenultimaOrdenCompra().setPrecioUnitario(resDetalle.getDouble("PRECIO_UNITARIO"));
                        }*/
                        programaProduccionPeriodoSolicitudCompraDetalleList.add(nuevo);
                    }
                    nuevo=new ProgramaProduccionPeriodoSolicitudCompraDetalle();
                    nuevo.setCodProgramaProduccionPeriodoSolicitudCompraDetalle(res.getInt("COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE"));
                    nuevo.getEstadosProgramaProduccionPeriodoSolicitudCompraDetalle().setCodEstadoProgramaProduccionPeriodoSolicitudCompraDetalle(res.getInt("COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE"));
                    nuevo.getEstadosProgramaProduccionPeriodoSolicitudCompraDetalle().setNombreEstadoProgramaProduccionPeriodoSolicitudCompraDetalle(res.getString("NOMBRE_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE"));
                    nuevo.getMateriales().setCodMaterial(res.getString("COD_MATERIAL"));
                    nuevo.getMateriales().setNombreMaterial(res.getString("NOMBRE_MATERIAL"));
                    nuevo.setCantidadSolicitudProduccion(res.getDouble("CANTIDAD_SOLICITUD_PRODUCCION"));
                    nuevo.setCantidadSolicitudCompra(res.getDouble("CANTIDAD_SOLICITUD_COMPRA"));
                    nuevo.getUnidadMedidaProduccion().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                    nuevo.getUnidadMedidaCompra().setNombreUnidadMedida(res.getString("nombreUnidadCompra"));
                    nuevo.setPrecioUnitario(res.getDouble("PRECIO_UNITARIO"));
                    nuevo.getUltimaOrdenCompra().setCantidadNeta(res.getDouble("CANTIDAD_NETA"));
                    nuevo.getUltimaOrdenCompra().setPrecioUnitario(res.getDouble("ultimoPrecioUnitario"));
                    nuevo.getUltimaOrdenCompra().getOrdenesCompra().setCodOrdenCompra(res.getInt("COD_ORDEN_COMPRA"));
                    nuevo.getUltimaOrdenCompra().getOrdenesCompra().getTiposTransporte().setNombreTipoTransporte(res.getString("NOMBRE_TIPO_TRANSPORTE"));
                    nuevo.setCantidadExistenciaAlmacenTransitorio(res.getDouble("cantidadExistenciaTransitorio"));
                    nuevo.setCantidadTransito(res.getDouble("cantidadTransito"));
                    nuevo.setProgramaProduccionPeriodoSolicitudCompraDetalleFraccionList(new ArrayList<ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion>());
                }
                ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion bean=new ProgramaProduccionPeriodoSolicitudCompraDetalleFraccion();
                bean.setCodProgramaProduccionPeriodoSolicitudCompraDetalleFraccion(res.getInt("COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE_FRACCION"));
                bean.setCantidadFraccion(res.getDouble("CANTIDAD_FRACCION"));
                bean.getTiposTransporte().setCodTipoTransporte(res.getInt("COD_TIPO_TRANSPORTE"));
                bean.getTiposTransporte().setNombreTipoTransporte(res.getString("NOMBRE_TIPO_TRANSPORTE"));
                bean.setObservacion(res.getString("OBSERVACION"));
                bean.getOrdenesCompraDetalle().getOrdenesCompra().setNroOrdenCompra(res.getInt("NRO_ORDEN_COMPRA"));
                bean.getOrdenesCompraDetalle().getOrdenesCompra().setCodOrdenCompra(res.getInt("codOrdenCompraGenerada"));
                
                nuevo.getProgramaProduccionPeriodoSolicitudCompraDetalleFraccionList().add(bean);
            }
            if(nuevo.getCodProgramaProduccionPeriodoSolicitudCompraDetalle()>0)
            {
                /*pst.setString(1,nuevo.getMateriales().getCodMaterial());
                pst.setInt(2,nuevo.getUltimaOrdenCompra().getOrdenesCompra().getCodOrdenCompra());
                resDetalle=pst.executeQuery();
                if(resDetalle.next())
                {
                    nuevo.getPenultimaOrdenCompra().setCantidadNeta(resDetalle.getDouble("CANTIDAD_NETA"));
                    nuevo.getPenultimaOrdenCompra().setPrecioUnitario(resDetalle.getDouble("PRECIO_UNITARIO"));
                }*/
                programaProduccionPeriodoSolicitudCompraDetalleList.add(nuevo);
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
    public String getCargarProgramaProduccionPeriodoSolicitudCompraList()
    {
        this.cargarProgramaProduccionPeriodoSolicitudCompraList();
        return null;
    }
    private void cargarProgramaProduccionPeriodoSolicitudCompraList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select pppsc.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA,pppsc.COD_PROVEEDOR,p.NOMBRE_PROVEEDOR,");
                                                consulta.append(" pppsc.FECHA_REGISTRO,pppsc.NUMERO_SOLICITUD,pppsc.COD_PROGRAMA_PROD,detalleEstado.*");
                                        consulta.append(" from PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA pppsc");
                                                consulta.append(" left outer join proveedores p on p.COD_PROVEEDOR=pppsc.COD_PROVEEDOR");
                                                consulta.append(" left join ");
                                                consulta.append(" (");
                                                            consulta.append(" select pp.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA,");
                                                                        consulta.append(" sum(case when isnull(pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE,0)=0 then 1 else 0 end) as cantSinEstado,");
                                                                        consulta.append(" sum(case when pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=1 then 1 else 0 end) as cantCotizacion,");
                                                                        consulta.append(" sum(case when pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=2 then 1 else 0 end) as cantDescartado,");
                                                                        consulta.append(" sum(case when pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=3 then 1 else 0 end) as cantOcParcial,");
                                                                        consulta.append(" sum(case when pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=4 then 1 else 0 end) as cantOcTotal,");
                                                                        consulta.append(" sum(case when pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=5 then 1 else 0 end) as cantConOc,");
                                                                        consulta.append(" sum(case when pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=6 then 1 else 0 end) as cantComite,");
                                                                        consulta.append(" sum(case when pppscd.COD_ESTADO_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE=7 then 1 else 0 end) as cantRechazadoGI");
                                                            consulta.append(" from PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA_DETALLE pppscd");
                                                                    consulta.append(" INNER join PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA pp on pp.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA=pppscd.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA");
                                                            consulta.append(" group by pp.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA    ");
                                                consulta.append(" ) as detalleEstado on detalleEstado.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA=pppsc.COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA");
                                        consulta.append(" where pppsc.COD_PROGRAMA_PROD=").append(programaProduccionPeriodoBean.getCodProgramaProduccion());
                                        consulta.append(" order by p.NOMBRE_PROVEEDOR");
            LOGGER.debug("consulta cargar programa prodiccion solicitud compra " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            programaProduccionPeriodoSolicitudCompraList=new ArrayList<ProgramaProduccionPeriodoSolicitudCompra>();
            while (res.next()) 
            {
                
                ProgramaProduccionPeriodoSolicitudCompra nuevo=new ProgramaProduccionPeriodoSolicitudCompra();
                nuevo.setNumeroSolicitud(res.getInt("NUMERO_SOLICITUD"));
                nuevo.setCodProgramaProduccionPeriodoSolicitudCompra(res.getInt("COD_PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA"));
                nuevo.getProveedores().setCodProveedor(res.getInt("COD_PROVEEDOR"));
                nuevo.getProveedores().setNombreProveedor(res.getString("NOMBRE_PROVEEDOR"));
                nuevo.setFechaRegistro(res.getTimestamp("FECHA_REGISTRO"));
                nuevo.getProgramaProduccionPeriodo().setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.setCantSinEstado(res.getInt("cantSinEstado"));
                nuevo.setCantCotizacion(res.getInt("cantCotizacion"));
                nuevo.setCantDescartado(res.getInt("cantDescartado"));
                nuevo.setCantParcial(res.getInt("cantOcParcial"));
                nuevo.setCantConOc(res.getInt("cantConOc"));
                nuevo.setCantTotal(res.getInt("cantOcTotal"));
                nuevo.setCantComite(res.getInt("cantComite"));
                nuevo.setCantRechazadoGI(res.getInt("cantRechazadoGI"));
                programaProduccionPeriodoSolicitudCompraList.add(nuevo);
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
    public String seleccionarProgramaProduccionPeriodo_action()
    {
        programaProduccionPeriodoBean=(ProgramaProduccionPeriodo)programaProduccionPeriodoDataTable.getRowData();
        return null;
    }
    public String getCargarProgramaProduccionPeriodoList()
    {
        
        this.cargarProgramaProduccionPeriodoList();
        return null;
    }
    private void cargarProgramaProduccionPeriodoList()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,CAST(ppp.OBSERVACIONES AS VARCHAR) as OBSERVACIONES,count(*) as cantidadSolicitudProveedor");
                                    consulta.append(" from PROGRAMA_PRODUCCION_PERIODO ppp");
                                            consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO_SOLICITUD_COMPRA ppsc on ppp.COD_PROGRAMA_PROD=ppsc.COD_PROGRAMA_PROD");
                                    consulta.append(" group by ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,CAST(ppp.OBSERVACIONES AS VARCHAR)");
                                    consulta.append(" order by ppp.COD_PROGRAMA_PROD desc");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            programaProduccionPeriodoList=new ArrayList<ProgramaProduccionPeriodo>();
            while (res.next()) 
            {
                ProgramaProduccionPeriodo nuevo=new ProgramaProduccionPeriodo();
                nuevo.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.setObsProgramaProduccion(res.getString("OBSERVACIONES"));
                nuevo.setCantProgramaProduccionPeriodoSolicitudCompra(res.getInt("cantidadSolicitudProveedor"));
                programaProduccionPeriodoList.add(nuevo);
                
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

        public List<ProgramaProduccionPeriodo> getProgramaProduccionPeriodoList() {
            return programaProduccionPeriodoList;
        }

        public void setProgramaProduccionPeriodoList(List<ProgramaProduccionPeriodo> programaProduccionPeriodoList) {
            this.programaProduccionPeriodoList = programaProduccionPeriodoList;
        }

        public List<ProgramaProduccionPeriodoSolicitudCompra> getProgramaProduccionPeriodoSolicitudCompraList() {
            return programaProduccionPeriodoSolicitudCompraList;
        }

        public void setProgramaProduccionPeriodoSolicitudCompraList(List<ProgramaProduccionPeriodoSolicitudCompra> programaProduccionPeriodoSolicitudCompraList) {
            this.programaProduccionPeriodoSolicitudCompraList = programaProduccionPeriodoSolicitudCompraList;
        }

        public MesesStockGrupo getMesesStockGrupoBuscar() {
            return mesesStockGrupoBuscar;
        }

        public void setMesesStockGrupoBuscar(MesesStockGrupo mesesStockGrupoBuscar) {
            this.mesesStockGrupoBuscar = mesesStockGrupoBuscar;
        }

    public int[] getCodGrupoSelectBuscarList() {
        return codGrupoSelectBuscarList;
    }

    public void setCodGrupoSelectBuscarList(int[] codGrupoSelectBuscarList) {
        this.codGrupoSelectBuscarList = codGrupoSelectBuscarList;
    }

        


        public ProgramaProduccionPeriodo getProgramaProduccionPeriodoBean() {
            return programaProduccionPeriodoBean;
        }

        public void setProgramaProduccionPeriodoBean(ProgramaProduccionPeriodo programaProduccionPeriodoBean) {
            this.programaProduccionPeriodoBean = programaProduccionPeriodoBean;
        }

        public HtmlDataTable getProgramaProduccionPeriodoDataTable() {
            return programaProduccionPeriodoDataTable;
        }

        public void setProgramaProduccionPeriodoDataTable(HtmlDataTable programaProduccionPeriodoDataTable) {
            this.programaProduccionPeriodoDataTable = programaProduccionPeriodoDataTable;
        }



        public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }




        public List<SelectItem> getUnidadesMedidaSelectList() {
            return unidadesMedidaSelectList;
        }

        public void setUnidadesMedidaSelectList(List<SelectItem> unidadesMedidaSelectList) {
            this.unidadesMedidaSelectList = unidadesMedidaSelectList;
        }


        public List<ProgramaProduccionPeriodoSolicitudCompraDetalle> getProgramaProduccionPeriodoSolicitudCompraDetalleList() {
            return programaProduccionPeriodoSolicitudCompraDetalleList;
        }

        public void setProgramaProduccionPeriodoSolicitudCompraDetalleList(List<ProgramaProduccionPeriodoSolicitudCompraDetalle> programaProduccionPeriodoSolicitudCompraDetalleList) {
            this.programaProduccionPeriodoSolicitudCompraDetalleList = programaProduccionPeriodoSolicitudCompraDetalleList;
        }

        public List<SelectItem> getEstadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList() {
            return estadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList;
        }

        public void setEstadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList(List<SelectItem> estadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList) {
            this.estadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList = estadosProgramaProduccionPeriodoSolicitudCompraDetalleSelectList;
        }

        public List<MaterialesCompraProveedor> getMaterialesCompraProveedorList() {
            return materialesCompraProveedorList;
        }

        public void setMaterialesCompraProveedorList(List<MaterialesCompraProveedor> materialesCompraProveedorList) {
            this.materialesCompraProveedorList = materialesCompraProveedorList;
        }

        public MaterialesCompraProveedor getMaterialesCompraProveedorBuscar() {
            return materialesCompraProveedorBuscar;
        }

        public void setMaterialesCompraProveedorBuscar(MaterialesCompraProveedor materialesCompraProveedorBuscar) {
            this.materialesCompraProveedorBuscar = materialesCompraProveedorBuscar;
        }

        public List<SelectItem> getGruposSelectList() {
            return gruposSelectList;
        }

        public void setGruposSelectList(List<SelectItem> gruposSelectList) {
            this.gruposSelectList = gruposSelectList;
        }

        public List<SelectItem> getCapitulosSelectList() {
            return capitulosSelectList;
        }

        public void setCapitulosSelectList(List<SelectItem> capitulosSelectList) {
            this.capitulosSelectList = capitulosSelectList;
        }

        public MaterialesCompraProveedor getMaterialesCompraProveedorAgregar() {
            return materialesCompraProveedorAgregar;
        }

        public void setMaterialesCompraProveedorAgregar(MaterialesCompraProveedor materialesCompraProveedorAgregar) {
            this.materialesCompraProveedorAgregar = materialesCompraProveedorAgregar;
        }

        public List<SelectItem> getProveedoresSelectList() {
            return proveedoresSelectList;
        }

        public void setProveedoresSelectList(List<SelectItem> proveedoresSelectList) {
            this.proveedoresSelectList = proveedoresSelectList;
        }

        public ProgramaProduccionPeriodoSolicitudCompra getProgramaProduccionPeriodoSolicitudCompraBean() {
            return programaProduccionPeriodoSolicitudCompraBean;
        }

        public void setProgramaProduccionPeriodoSolicitudCompraBean(ProgramaProduccionPeriodoSolicitudCompra programaProduccionPeriodoSolicitudCompraBean) {
            this.programaProduccionPeriodoSolicitudCompraBean = programaProduccionPeriodoSolicitudCompraBean;
        }

        public HtmlDataTable getProgramaProduccionPeriodoSolicitudCompraDataTable() {
            return programaProduccionPeriodoSolicitudCompraDataTable;
        }

        public void setProgramaProduccionPeriodoSolicitudCompraDataTable(HtmlDataTable programaProduccionPeriodoSolicitudCompraDataTable) {
            this.programaProduccionPeriodoSolicitudCompraDataTable = programaProduccionPeriodoSolicitudCompraDataTable;
        }

        public List<Materiales> getMaterialesList() {
            return materialesList;
        }

        public void setMaterialesList(List<Materiales> materialesList) {
            this.materialesList = materialesList;
        }

        public HtmlDataTable getMaterialesDataTable() {
            return materialesDataTable;
        }

        public void setMaterialesDataTable(HtmlDataTable materialesDataTable) {
            this.materialesDataTable = materialesDataTable;
        }



        public HtmlDataTable getProgramaProduccionPeriodoSolicitudCompraDetalleDataTable() {
            return programaProduccionPeriodoSolicitudCompraDetalleDataTable;
        }

        public void setProgramaProduccionPeriodoSolicitudCompraDetalleDataTable(HtmlDataTable programaProduccionPeriodoSolicitudCompraDetalleDataTable) {
            this.programaProduccionPeriodoSolicitudCompraDetalleDataTable = programaProduccionPeriodoSolicitudCompraDetalleDataTable;
        }

        public List<SelectItem> getTiposTransporteSelectList() {
            return tiposTransporteSelectList;
        }

        public void setTiposTransporteSelectList(List<SelectItem> tiposTransporteSelectList) {
            this.tiposTransporteSelectList = tiposTransporteSelectList;
        }

        public ProgramaProduccionPeriodoSolicitudCompraDetalle getProgramaProduccionPeriodoSolicitudCompraDetalleCambioProveedor() {
            return programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor;
        }

        public void setProgramaProduccionPeriodoSolicitudCompraDetalleCambioProveedor(ProgramaProduccionPeriodoSolicitudCompraDetalle programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor) {
            this.programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor = programaProduccionPeriodoSolicitudCompraDetalleCambioProveedor;
        }
        

        public ProgramaProduccionPeriodoSolicitudCompra getProgramaProduccionPeriodoSolicitudCompraCambioProveedor() {
            return programaProduccionPeriodoSolicitudCompraCambioProveedor;
        }

        public Materiales getMaterialesBuscarAgregar() {
            return materialesBuscarAgregar;
        }

        public void setMaterialesBuscarAgregar(Materiales materialesBuscarAgregar) {
            this.materialesBuscarAgregar = materialesBuscarAgregar;
        }

        public void setProgramaProduccionPeriodoSolicitudCompraCambioProveedor(ProgramaProduccionPeriodoSolicitudCompra programaProduccionPeriodoSolicitudCompraCambioProveedor) {
            this.programaProduccionPeriodoSolicitudCompraCambioProveedor = programaProduccionPeriodoSolicitudCompraCambioProveedor;
        }

        public List<MesesStockGrupo> getMesesStockGrupoList() {
            return mesesStockGrupoList;
        }

        public void setMesesStockGrupoList(List<MesesStockGrupo> mesesStockGrupoList) {
            this.mesesStockGrupoList = mesesStockGrupoList;
        }

        public MesesStockGrupo getMesesStockGrupoEditar() {
            return mesesStockGrupoEditar;
        }

        public void setMesesStockGrupoEditar(MesesStockGrupo mesesStockGrupoEditar) {
            this.mesesStockGrupoEditar = mesesStockGrupoEditar;
        }

        public List<SelectItem> getGruposCapitulosSelectList() {
            return gruposCapitulosSelectList;
        }

        public void setGruposCapitulosSelectList(List<SelectItem> gruposCapitulosSelectList) {
            this.gruposCapitulosSelectList = gruposCapitulosSelectList;
        }

        public List<SelectItem> getTiposCompraSelectList() {
            return tiposCompraSelectList;
        }

        public void setTiposCompraSelectList(List<SelectItem> tiposCompraSelectList) {
            this.tiposCompraSelectList = tiposCompraSelectList;
        }

    //</editor-fold>
    
    
    
    
    
    
    
}
