/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.ComponentesPresProdVersion;
import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.FormulaMaestraDetalleES;
import com.cofar.bean.FormulaMaestraEsVersion;
import com.cofar.bean.RegistroControlCambios;
import com.cofar.bean.util.correos.EnvioCorreoAprobacionVersionEmpaqueSecundario;
import com.cofar.bean.util.correos.EnvioCorreoRegistroControlCambios;
import com.cofar.dao.DaoComponentesPresProdVersion;
import com.cofar.dao.DaoFormulaMaestraDetalleEsVersion;
import com.cofar.dao.DaoPresentacionesProducto;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import javax.servlet.ServletContext;
import org.apache.logging.log4j.LogManager;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author DASISAQ
 */
public class ManagedFormulaMaestraEsVersion extends ManagedBean
{
    //<editor-fold desc="Variables">
        private boolean defineLoteEs = false;
        private String mensaje="";
        private Connection con;
        private ComponentesProdVersion componentesProdVersionBean;
        private List<FormulaMaestraEsVersion> formulaMaestraEsVersionList;
        private HtmlDataTable formulaMaestraEsVersionDataTable;
        private FormulaMaestraEsVersion formulaMaestraEsVersionBean;
        private List<ComponentesPresProdVersion> componentesPresProdVersionList;
        private ComponentesPresProdVersion componentesPresProdVersionAgregar;
        private ComponentesPresProdVersion componentesPresProdVersionEditar;
        private List<SelectItem> presentacionesSelectList; 
        private List<SelectItem> tiposProgramaProduccionSelectList;
        
        
        private List<FormulaMaestraEsVersion> formulaMaestraEsVersionAprobacionList;
        private FormulaMaestraEsVersion formulaMaestraEsVersionRevision;
        private RegistroControlCambios registroControlCambios;
    //</editor-fold>
    
    public ManagedFormulaMaestraEsVersion() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
        formulaMaestraEsVersionDataTable=new HtmlDataTable();
    }
    
    //<editor-fold desc="funciones">
        public String eliminarFormulaMaestraEsVersionControlDeCambios_action()throws SQLException
        {
            mensaje="";
            for(FormulaMaestraEsVersion bean:formulaMaestraEsVersionList)
            {
                if(bean.getChecked())
                {
                    mensaje = "";
                    try 
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder(" delete FORMULA_MAESTRA_ES_VERSION");
                                                    consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(bean.getCodFormulaMaestraEsVersion());
                        LOGGER.debug("consulta eliminar fm es " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0)LOGGER.info("se elimino la formula maestra es version");
                        consulta=new StringBuilder(" delete COMPONENTES_PRESPROD_VERSION");
                                    consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(bean.getCodFormulaMaestraEsVersion());
                        LOGGER.debug("consulta eliminar componentes presprod "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se elimino componentes presprod ");
                        consulta=new StringBuilder(" delete FORMULA_MAESTRA_DETALLE_ES_VERSION ");
                                    consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(bean.getCodFormulaMaestraEsVersion());
                        LOGGER.debug("consulta eliminar fm es "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se elimino fm detalle es "+consulta.toString());  
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
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarFormulaMaestraEsVersion();
            }
            return null;
        }
        
        public String agregarVersionPorControlDeCambios()throws SQLException
        {
            registroControlCambios=new RegistroControlCambios();
            mensaje="";
            ManagedAccesoSistema usuario=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta=new StringBuilder("select count(*)");
                                        consulta.append(" from FORMULA_MAESTRA_ES_VERSION f");
                                        consulta.append(" where f.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                                consulta.append(" and  f.COD_ESTADO_VERSION in (1,5,3)");
                LOGGER.debug("consutla verificar es pendiente "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                res.next();
                if(res.getInt(1)==0)
                {
                        consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                                    consulta.append(" from AREAS_EMPRESA ae ");
                                                            consulta.append(" inner join personal p on p.COD_AREA_EMPRESA=ae.COD_AREA_EMPRESA");
                                                    consulta.append(" where p.COD_PERSONAL=").append(usuario.getUsuarioModuloBean().getCodUsuarioGlobal());
                        res = st.executeQuery(consulta.toString());
                        if(res.next())
                        {
                            registroControlCambios.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                            registroControlCambios.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                        }
                        registroControlCambios.getPersonalRegistra().setCodPersonal(usuario.getUsuarioModuloBean().getCodUsuarioGlobal());
                        registroControlCambios.getPersonalRegistra().setNombrePersonal(usuario.getUsuarioModuloBean().getApPaternoUsuarioGlobal()+" "+usuario.getUsuarioModuloBean().getApMaternoUsuarioGlobal()+" "+usuario.getUsuarioModuloBean().getNombrePilaUsuarioGlobal());
                        mensaje="1";
                }
                else
                {
                    mensaje="No se puede crear un nuevo cambio ya que existen modificaciones aun no aprobadas";
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
        public String enviarAprobacionFormulaMaestraEsVersion_action()throws SQLException
        {
            mensaje = "";
            for(FormulaMaestraEsVersion bean:formulaMaestraEsVersionList)
            {
                if(bean.getChecked())
                {
                    try 
                    {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder("UPDATE FORMULA_MAESTRA_ES_VERSION ");
                                                consulta.append(" SET COD_ESTADO_VERSION=8");
                                                        consulta.append(" ,FECHA_ENVIO_APROBACION=GETDATE()");
                                                consulta.append(" WHERE COD_FORMULA_MAESTRA_ES_VERSION=").append(bean.getCodFormulaMaestraEsVersion());
                        LOGGER.debug("consulta enviar aprobacion " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se envio a aprobación");
                        con.commit();
                        mensaje = "1";
                    }
                    catch (SQLException ex) 
                    {
                        mensaje = "Ocurrio un error al momento de enviar a aprobación";
                        LOGGER.warn(ex.getMessage());
                        con.rollback();
                    }
                    catch (Exception ex) 
                    {
                        mensaje = "Ocurrio un error al momento de enviar a aprobación,verifique los datos introducidos";
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
                this.cargarFormulaMaestraEsVersion();
            }
            return null;
        }
        public String eliminarComponentesPresProdVersion_action()throws SQLException
        {
            mensaje = "";
            for(ComponentesPresProdVersion bean:componentesPresProdVersionList)
            {
                if(bean.getChecked())
                {
                    DaoComponentesPresProdVersion daoComponentesPresProdVersion = new DaoComponentesPresProdVersion(LOGGER);
                    bean.setFormulaMaestraEsVersion(formulaMaestraEsVersionBean);
                    if(daoComponentesPresProdVersion.eliminar(bean)){
                        mensaje = "1";
                    }
                    else{
                        mensaje = "Ocurrio un error al momento de eliminar el registro, intente de nuevo";
                    }
                    break;
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarComponentesPresProdFormulaMaestraDetaleEsList();
            }
            return null;
        }
        public String guardarEdicionComponentesPresProdVersion_action()throws SQLException
        {
            DaoComponentesPresProdVersion daoComponentesPres = new DaoComponentesPresProdVersion(LOGGER);
            List<FormulaMaestraDetalleES> formulaEsEditarList = new ArrayList<FormulaMaestraDetalleES>();
            for(FormulaMaestraDetalleES bean : componentesPresProdVersionEditar.getFormulaMaestraDetalleESList()){
                if(bean.getChecked()){
                    formulaEsEditarList.add(bean);
                }
            }
            componentesPresProdVersionEditar.setFormulaMaestraDetalleESList(formulaEsEditarList);
            if(daoComponentesPres.editarConDetalleEs(componentesPresProdVersionEditar, formulaMaestraEsVersionBean))
            {
                mensaje = "1";
            }
            else
            {
                mensaje = "Ocurrio un error al momento de editar el registro, intente de nuevo";
            }
            return null;
        }
        public String getCargarEditarComponentesPresProdVersion_action()
        {
            DaoFormulaMaestraDetalleEsVersion daoFmEs = new DaoFormulaMaestraDetalleEsVersion(LOGGER);
            componentesPresProdVersionEditar.setFormulaMaestraDetalleESList(daoFmEs.listarEditar(componentesPresProdVersionEditar, formulaMaestraEsVersionBean));
            return null;
        }
    
        public String editarComponentesPresProdVersion_action()throws SQLException
        {
            for(ComponentesPresProdVersion bean:componentesPresProdVersionList)
            {
                if(bean.getChecked())
                {
                    componentesPresProdVersionEditar=bean;
                    break;
                }
            }
            return null;
        }
    
    
    
    
        public String guardarAgregarComponentesPresProdVersion_action()throws SQLException
        {
            DaoComponentesPresProdVersion daoComponentesPresProd  = new DaoComponentesPresProdVersion(LOGGER);
            List<FormulaMaestraDetalleES> formulaEsList = new ArrayList<>();
            for(FormulaMaestraDetalleES bean : componentesPresProdVersionAgregar.getFormulaMaestraDetalleESList()){
                if(bean.getChecked()){
                    formulaEsList.add(bean);
                }
            }
            componentesPresProdVersionAgregar.setFormulaMaestraDetalleESList(formulaEsList);
            if(daoComponentesPresProd.guardarConDetalleEs(componentesPresProdVersionAgregar, formulaMaestraEsVersionBean))
            {
                mensaje = "1";
            }
            else
            {
                mensaje = "Ocurrio un error al momento de guardar el registro, intente de nuevo";
            }
            return null;
        }
        public String codPresentacionAgregar_change()
        {
            try 
            {
                con = Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                String consulta = "select p.cantidad_presentacion from PRESENTACIONES_PRODUCTO p" +
                                  " where p.cod_presentacion='"+componentesPresProdVersionAgregar.getPresentacionesProducto().getCodPresentacion()+"'";
                ResultSet res = st.executeQuery(consulta);
                while (res.next()) 
                {
                    componentesPresProdVersionAgregar.setCantCompProd(res.getFloat("cantidad_presentacion"));
                }
                res.close();
                st.close();
                con.close();
            } catch (SQLException ex) {
                LOGGER.warn("error", ex);
            }
            return null;
        }
        private void cargarTiposProgramaProduccionSelectList()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                                            consulta.append(" from TIPOS_PROGRAMA_PRODUCCION tpp");
                                            consulta.append(" where tpp.COD_ESTADO_REGISTRO=1");
                                            consulta.append(" order by tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                tiposProgramaProduccionSelectList=new ArrayList<SelectItem>();
                while (res.next()) 
                {
                    tiposProgramaProduccionSelectList.add(new SelectItem(res.getString("COD_TIPO_PROGRAMA_PROD"),res.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
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
        private void cargarPresentacionesSelectList()
        {
            DaoPresentacionesProducto  daoPresentaciones = new DaoPresentacionesProducto();
            presentacionesSelectList = daoPresentaciones.listarPresentacionesProductoSelectList();
            
        }
        
        public String getCargarAgregarMaterialesEsVersion()
        {
            DaoFormulaMaestraDetalleEsVersion daoFmEs = new DaoFormulaMaestraDetalleEsVersion();
            componentesPresProdVersionAgregar=new ComponentesPresProdVersion();
            componentesPresProdVersionAgregar.setFormulaMaestraDetalleESList(daoFmEs.listarAgregar());
            this.cargarPresentacionesSelectList();
            this.cargarTiposProgramaProduccionSelectList();
            
            return null;
        }
        public String getCargarComponentesPresProdFormulaMaestraDetalleEs()
        {
            this.cargarComponentesPresProdFormulaMaestraDetaleEsList();
            return null;
        }
        private void cargarComponentesPresProdFormulaMaestraDetaleEsList()
        {
            DaoFormulaMaestraDetalleEsVersion daoFmEs = new DaoFormulaMaestraDetalleEsVersion(LOGGER);
            componentesPresProdVersionList = daoFmEs.listarPorComponentesPresProd(formulaMaestraEsVersionBean);
        }
        public String seleccionarFormulaMaestraEsVersion_action()
        {
            formulaMaestraEsVersionBean=(FormulaMaestraEsVersion)formulaMaestraEsVersionDataTable.getRowData();
            return null;
        }
        public String crearNuevaFormulaMaestraEsVersion_action()throws SQLException
        {
            mensaje = "";
            EnvioCorreoRegistroControlCambios envioCorreo=null;
            if(componentesProdVersionBean.getCodVersion()>0)
            {
                try 
                {
                    con = Util.openConnection(con);
                    con.setAutoCommit(false);
                    ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
                    StringBuilder consulta=new StringBuilder("select count(*) as registrosEmpaqueSecundarioPendiente");
                                            consulta.append(" from FORMULA_MAESTRA_ES_VERSION fmev ");
                                                    consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=fmev.COD_VERSION");
                                            consulta.append(" where cpv.COD_COMPPROD=").append(componentesProdVersionBean.getCodCompprod());
                                                    consulta.append(" and fmev.COD_ESTADO_VERSION in (1,5,3,8)");
                                                    consulta.append(" and cpv.COD_TIPO_COMPONENTES_PROD_VERSION=1");
                    LOGGER.debug("consulta verificar ningun pendiente es "+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    res.next();
                    if(res.getInt("registrosEmpaqueSecundarioPendiente")==0)
                    {
                        consulta = new StringBuilder("INSERT INTO FORMULA_MAESTRA_ES_VERSION(COD_ESTADO_VERSION,NRO_VERSION,OBSERVACION, COD_PERSONAL, FECHA_CREACION,COD_VERSION)");
                                    consulta.append("VALUES (");
                                            consulta.append("1,");//registrado
                                            consulta.append("(select isnull(max(f.NRO_VERSION),0)+1 from FORMULA_MAESTRA_ES_VERSION f where f.COD_VERSION=").append(componentesProdVersionBean.getCodVersion()).append("),");
                                            consulta.append("?,");
                                            consulta.append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",");
                                            consulta.append("'").append(sdf.format(new Date())).append("',");
                                            consulta.append(componentesProdVersionBean.getCodVersion());
                                    consulta.append(")");
                        LOGGER.debug("consulta" + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                        pst.setString(1, registroControlCambios.getPropositoCambio());
                        if (pst.executeUpdate() > 0) LOGGER.info("se registro la formula maestra es ");
                        res=pst.getGeneratedKeys();
                        int codFormulaMaestraVersionEs=0;
                        int codFormulaMaestraVersionEsAnterior=0;
                        if(res.next())codFormulaMaestraVersionEs=res.getInt(1);
                        consulta=new StringBuilder("select f.COD_FORMULA_MAESTRA_ES_VERSION");
                                    consulta.append(" from FORMULA_MAESTRA_ES_VERSION f");
                                    consulta.append(" where f.COD_ESTADO_VERSION=2");
                                    consulta.append(" and f.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                        res=st.executeQuery(consulta.toString());
                        if(res.next())codFormulaMaestraVersionEsAnterior=res.getInt(1);
                        consulta=new StringBuilder("INSERT INTO COMPONENTES_PRESPROD_VERSION(COD_VERSION, COD_COMPPROD,COD_PRESENTACION, CANT_COMPPROD, COD_TIPO_PROGRAMA_PROD, COD_ESTADO_REGISTRO,COD_FORMULA_MAESTRA_ES_VERSION)");
                                        consulta.append(" select cpv.COD_VERSION,cpv.COD_COMPPROD,cpv.COD_PRESENTACION,cpv.CANT_COMPPROD,");
                                        consulta.append(" cpv.COD_TIPO_PROGRAMA_PROD,cpv.COD_ESTADO_REGISTRO,").append(codFormulaMaestraVersionEs);
                                        consulta.append(" from COMPONENTES_PRESPROD_VERSION cpv");
                                        consulta.append(" where cpv.COD_FORMULA_MAESTRA_ES_VERSION=").append(codFormulaMaestraVersionEsAnterior);
                        LOGGER.debug("consulta registrar componentes pres prod copia "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro los componentes pres prod");
                        consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_DETALLE_ES_VERSION(COD_VERSION,COD_FORMULA_MAESTRA, COD_MATERIAL, CANTIDAD, COD_UNIDAD_MEDIDA,");
                                            consulta.append("COD_PRESENTACION_PRODUCTO, COD_TIPO_PROGRAMA_PROD, FECHA_MODIFICACION,COD_FORMULA_MAESTRA_ES_VERSION,DEFINE_NUMERO_LOTE)");
                                    consulta.append(" select f.COD_VERSION,f.COD_FORMULA_MAESTRA,f.COD_MATERIAL,f.CANTIDAD,f.COD_UNIDAD_MEDIDA,");
                                            consulta.append(" f.COD_PRESENTACION_PRODUCTO,f.COD_TIPO_PROGRAMA_PROD,GETDATE(),").append(codFormulaMaestraVersionEs).append(",f.DEFINE_NUMERO_LOTE");
                                    consulta.append(" from FORMULA_MAESTRA_DETALLE_ES_VERSION f");
                                    consulta.append(" where f.COD_FORMULA_MAESTRA_ES_VERSION=").append(codFormulaMaestraVersionEsAnterior);
                        LOGGER.debug(" consulta registrar es "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se registro el empaque secundario");
                        //<editor-fold desc="registro control de cambios">
                            consulta=new StringBuilder("INSERT INTO REGISTRO_CONTROL_CAMBIOS(COD_COMPPROD, COD_VERSION_PROD, COD_FORMULA_MAESTRA_ES_VERSION, COD_PERSONAL_REGISTRA,COD_AREA_EMPRESA, CAMBIO_PROPUESTO, COORELATIVO, PROPOSITO_DEL_CAMBIO,");
                                                consulta.append(" FECHA_REGISTRO)");
                                        consulta.append("VALUES (");
                                                consulta.append(componentesProdVersionBean.getCodCompprod()).append(",");
                                                consulta.append(componentesProdVersionBean.getCodVersion()).append(",");
                                                consulta.append(codFormulaMaestraVersionEs).append(",");
                                                consulta.append(registroControlCambios.getPersonalRegistra().getCodPersonal()).append(",");
                                                consulta.append(registroControlCambios.getAreasEmpresa().getCodAreaEmpresa()).append(",");
                                                consulta.append("?,");//cambio propuesto
                                                consulta.append("'S/C',");//sin correlativo asignado
                                                consulta.append("?,");//proposito del cambio
                                                consulta.append("GETDATE()");
                                        consulta.append(")");
                            LOGGER.debug("consulta registrar control de cambios "+consulta.toString());
                            pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                            pst.setString(1,registroControlCambios.getPropositoCambio());
                            pst.setString(2,registroControlCambios.getPropositoCambio());
                            if(pst.executeUpdate()>0)LOGGER.info("se registro el control de cambios");
                            res=pst.getGeneratedKeys();
                            mensaje = "1";
                            if(res.next())envioCorreo=new EnvioCorreoRegistroControlCambios(res.getInt(1),(ServletContext)FacesContext.getCurrentInstance().getExternalContext().getContext());
                            
                    }
                    else
                    {
                        mensaje="No se puede crear un nuevo registro ya que existen cambios pendientes de aprobación";
                    }
                    //</editor-fold>
                    con.commit();
                    
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
            }
            else
            {
                mensaje="Es posible que su sesion haya terminado, por favor vuelva a hacer login";
            }
            if(mensaje.equals("1"))
            {
                this.cargarFormulaMaestraEsVersion();
                if(envioCorreo!=null)
                {
                    envioCorreo.start();;
                }
            }
            return null;
        }
        public String getCargarFormulaMaestraEsVersion()
        {
            try
            {
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext externalContext = facesContext.getExternalContext();
                Map map = externalContext.getSessionMap();
                componentesProdVersionBean = (ComponentesProdVersion)map.get("ComponentesProdVersionEs");
                this.cargarFormulaMaestraEsVersion();
            }
            catch(Exception ex)
            {
                LOGGER.warn("error", ex);
            }
            return null;
        }
        private void cargarFormulaMaestraEsVersion()
        {
            try {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select fmev.COD_FORMULA_MAESTRA_ES_VERSION,fmev.COD_PERSONAL,");
                                                    consulta.append(" isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL,'Sin Personal Asignado') as nombrePersonal,");
                                                    consulta.append(" fmev.FECHA_APROBACION,fmev.FECHA_CREACION,fmev.OBSERVACION");
                                                    consulta.append(" ,fmev.COD_ESTADO_VERSION,evc.NOMBRE_ESTADO_VERSION_COMPONENTES_PROD,fmev.FECHA_ENVIO_APROBACION,fmev.NRO_VERSION");
                                            consulta.append(" from FORMULA_MAESTRA_ES_VERSION fmev");
                                                    consulta.append(" left outer join PERSONAL p on p.COD_PERSONAL=fmev.COD_PERSONAL");
                                                    consulta.append(" inner join ESTADOS_VERSION_COMPONENTES_PROD evc on evc.COD_ESTADO_VERSION_COMPONENTES_PROD=fmev.COD_ESTADO_VERSION");
                                            consulta.append(" where fmev.COD_VERSION=").append(componentesProdVersionBean.getCodVersion());
                                            consulta.append(" order by fmev.FECHA_CREACION");
                LOGGER.debug("consulta cargar versiones es" + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                formulaMaestraEsVersionList=new ArrayList<FormulaMaestraEsVersion>();
                while (res.next()) 
                {
                    FormulaMaestraEsVersion nuevo=new FormulaMaestraEsVersion();
                    nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                    nuevo.setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                    nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                    nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                    nuevo.setFechaAprobacion(res.getTimestamp("FECHA_APROBACION"));
                    nuevo.setFechaEnvioAprobacion(res.getTimestamp("FECHA_ENVIO_APROBACION"));
                    nuevo.setFechaCreacion(res.getTimestamp("FECHA_CREACION"));
                    nuevo.setObservacion(res.getString("OBSERVACION"));
                    nuevo.setComponentesProdVersion((ComponentesProdVersion)componentesProdVersionBean.clone());
                    nuevo.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("COD_ESTADO_VERSION"));
                    nuevo.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("NOMBRE_ESTADO_VERSION_COMPONENTES_PROD"));
                    formulaMaestraEsVersionList.add(nuevo);
                }
                consulta = new StringBuilder("select f.COD_FORMA,f.DEFINE_LOTE_ES ")
                                    .append(" from FORMAS_FARMACEUTICAS_LOTE f")
                                    .append(" where f.COD_FORMA =").append(componentesProdVersionBean.getForma().getCodForma());
                LOGGER.debug("consulta verificar lote es definre "+consulta.toString());
                res = st.executeQuery(consulta.toString());
                defineLoteEs = false;
                if(res.next())
                {
                    defineLoteEs = res.getInt("DEFINE_LOTE_ES") > 0;
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
        
    //<editor-fold desc="funciones aprobacion">
        public String aprobarFormulaMaestraEsVersion_action()throws SQLException
        {
            mensaje = "";
            EnvioCorreoAprobacionVersionEmpaqueSecundario correo=null;
            try 
            {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("exec PAA_APROBACION_FORMULA_MAESTRA_ES_VERSION ");
                                            consulta.append(formulaMaestraEsVersionRevision.getCodFormulaMaestraEsVersion()).append(",");
                                            consulta.append(formulaMaestraEsVersionRevision.getComponentesProdVersion().getCodVersion()).append(",");
                                            consulta.append(formulaMaestraEsVersionRevision.getComponentesProdVersion().getCodCompprod()).append(",");
                                            consulta.append(formulaMaestraEsVersionRevision.getComponentesProdVersion().getCodFormulaMaestra());
                LOGGER.debug("consulta aprobar version fm es  "+consulta.toString());
                PreparedStatement pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version de empaque secundario ");
                correo=new EnvioCorreoAprobacionVersionEmpaqueSecundario(formulaMaestraEsVersionRevision.getCodFormulaMaestraEsVersion(), (ServletContext)FacesContext.getCurrentInstance().getExternalContext().getContext());
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
            if(mensaje.equals("1")&&correo!=null)
            {
                correo.start();
            }
            return null;
        }
        public String devolverVersionFormulaMaestraEsVersion_action()throws SQLException
        {
            mensaje = "";
            for(FormulaMaestraEsVersion bean:formulaMaestraEsVersionAprobacionList)
            {
                if(bean.getChecked())
                {
                    
                    try {
                        con = Util.openConnection(con);
                        con.setAutoCommit(false);
                        StringBuilder consulta = new StringBuilder("update FORMULA_MAESTRA_ES_VERSION ");
                                                    consulta.append(" set COD_ESTADO_VERSION=1,");
                                                    consulta.append(" FECHA_ENVIO_APROBACION=null");
                                                    consulta.append(" where COD_FORMULA_MAESTRA_ES_VERSION=").append(bean.getCodFormulaMaestraEsVersion());
                        LOGGER.debug("consulta devolver version empaque secundario " + consulta.toString());
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        if (pst.executeUpdate() > 0) LOGGER.info("se registro la devolucion de version de empaque secundario");
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
                    break;
                }
            }
            if(mensaje.equals("1"))
            {
                this.cargarFormulaMaestraEsVersionAprobacionList();
            }
            return null;
        }
        
        public String seleccionarRevisionFormulaMaestraEsVersionAprobacion_action()
        {
            for(FormulaMaestraEsVersion bean:formulaMaestraEsVersionAprobacionList)
            {
                if(bean.getChecked())
                {
                    formulaMaestraEsVersionRevision=bean;
                    break;
                }
            }
            return null;
        }
        
        
        public String getCargarFormulaMaestraEsVersionAprobacionList()
        {
            this.cargarFormulaMaestraEsVersionAprobacionList();
            return null;
        }
        private void cargarFormulaMaestraEsVersionAprobacionList()
        {
            try 
            {
                con = Util.openConnection(con);
                StringBuilder consulta = new StringBuilder("select fmev.COD_FORMULA_MAESTRA_ES_VERSION,cpv.nombre_prod_semiterminado,cpv.TAMANIO_LOTE_PRODUCCION,");
                                                    consulta.append(" (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombrePersonal,");
                                                    consulta.append(" fmev.FECHA_CREACION,fmev.FECHA_ENVIO_APROBACION,fmev.OBSERVACION");
                                                    consulta.append(" ,cpv.COD_COMPPROD,fmv.COD_FORMULA_MAESTRA,cpv.COD_VERSION");
                                            consulta.append(" from FORMULA_MAESTRA_ES_VERSION fmev");
                                                    consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=fmev.COD_VERSION");
                                                    consulta.append(" inner join PERSONAL p on p.COD_PERSONAL=fmev.COD_PERSONAL");
                                                    consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD_VERSION=cpv.COD_VERSION");
                                                            consulta.append(" and fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                            consulta.append(" where fmev.COD_ESTADO_VERSION=8");
                                            consulta.append(" order by cpv.nombre_prod_semiterminado");
                LOGGER.debug("consulta cargar versiones aprobacion " + consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res = st.executeQuery(consulta.toString());
                formulaMaestraEsVersionAprobacionList=new ArrayList<FormulaMaestraEsVersion>();
                while (res.next()) 
                {
                    FormulaMaestraEsVersion nuevo=new FormulaMaestraEsVersion();
                    nuevo.getComponentesProdVersion().setCodFormulaMaestra(res.getInt("COD_FORMULA_MAESTRA"));
                    nuevo.getComponentesProdVersion().setCodVersion(res.getInt("COD_VERSION"));
                    nuevo.getComponentesProdVersion().setCodCompprod(res.getString("COD_COMPPROD"));
                    nuevo.setCodFormulaMaestraEsVersion(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION"));
                    nuevo.getComponentesProdVersion().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    nuevo.getComponentesProdVersion().setTamanioLoteProduccion(res.getInt("TAMANIO_LOTE_PRODUCCION"));
                    nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                    nuevo.setFechaCreacion(res.getTimestamp("FECHA_CREACION"));
                    nuevo.setFechaEnvioAprobacion(res.getTimestamp("FECHA_ENVIO_APROBACION"));
                    nuevo.setObservacion(res.getString("OBSERVACION"));
                    formulaMaestraEsVersionAprobacionList.add(nuevo);
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
        
    //<editor-fold desc="getter and setter">
       public String getMensaje() {
            return mensaje;
        }

        public void setMensaje(String mensaje) {
            this.mensaje = mensaje;
        }

        public ComponentesProdVersion getComponentesProdVersionBean() {
            return componentesProdVersionBean;
        }

        public void setComponentesProdVersionBean(ComponentesProdVersion componentesProdVersionBean) {
            this.componentesProdVersionBean = componentesProdVersionBean;
        }

        public List<FormulaMaestraEsVersion> getFormulaMaestraEsVersionList() {
            return formulaMaestraEsVersionList;
        }

        public void setFormulaMaestraEsVersionList(List<FormulaMaestraEsVersion> formulaMaestraEsVersionList) {
            this.formulaMaestraEsVersionList = formulaMaestraEsVersionList;
        }
        
        public HtmlDataTable getFormulaMaestraEsVersionDataTable() {
            return formulaMaestraEsVersionDataTable;
        }

        public void setFormulaMaestraEsVersionDataTable(HtmlDataTable formulaMaestraEsVersionDataTable) {
            this.formulaMaestraEsVersionDataTable = formulaMaestraEsVersionDataTable;
        }
        
        public FormulaMaestraEsVersion getFormulaMaestraEsVersionBean() {
            return formulaMaestraEsVersionBean;
        }

        public void setFormulaMaestraEsVersionBean(FormulaMaestraEsVersion formulaMaestraEsVersionBean) {
            this.formulaMaestraEsVersionBean = formulaMaestraEsVersionBean;
        }

        public List<ComponentesPresProdVersion> getComponentesPresProdVersionList() {
            return componentesPresProdVersionList;
        }

        public void setComponentesPresProdVersionList(List<ComponentesPresProdVersion> componentesPresProdVersionList) {
            this.componentesPresProdVersionList = componentesPresProdVersionList;
        }
        
        public ComponentesPresProdVersion getComponentesPresProdVersionAgregar() {
            return componentesPresProdVersionAgregar;
        }

        public void setComponentesPresProdVersionAgregar(ComponentesPresProdVersion componentesPresProdVersionAgregar) {
            this.componentesPresProdVersionAgregar = componentesPresProdVersionAgregar;
        }

        public List<SelectItem> getPresentacionesSelectList() {
            return presentacionesSelectList;
        }

        public void setPresentacionesSelectList(List<SelectItem> presentacionesSelectList) {
            this.presentacionesSelectList = presentacionesSelectList;
        }
        
        public List<SelectItem> getTiposProgramaProduccionSelectList() {
            return tiposProgramaProduccionSelectList;
        }

        public void setTiposProgramaProduccionSelectList(List<SelectItem> tiposProgramaProduccionSelectList) {
            this.tiposProgramaProduccionSelectList = tiposProgramaProduccionSelectList;
        }
        
        public ComponentesPresProdVersion getComponentesPresProdVersionEditar() {
            return componentesPresProdVersionEditar;
        }

        public void setComponentesPresProdVersionEditar(ComponentesPresProdVersion componentesPresProdVersionEditar) {
            this.componentesPresProdVersionEditar = componentesPresProdVersionEditar;
        }
        
        public List<FormulaMaestraEsVersion> getFormulaMaestraEsVersionAprobacionList() {
            return formulaMaestraEsVersionAprobacionList;
        }

        public void setFormulaMaestraEsVersionAprobacionList(List<FormulaMaestraEsVersion> formulaMaestraEsVersionAprobacionList) {
            this.formulaMaestraEsVersionAprobacionList = formulaMaestraEsVersionAprobacionList;
        }

        public FormulaMaestraEsVersion getFormulaMaestraEsVersionRevision() {
            return formulaMaestraEsVersionRevision;
        }

        public void setFormulaMaestraEsVersionRevision(FormulaMaestraEsVersion formulaMaestraEsVersionRevision) {
            this.formulaMaestraEsVersionRevision = formulaMaestraEsVersionRevision;
        }
        
        public RegistroControlCambios getRegistroControlCambios() {
            return registroControlCambios;
        }

        public void setRegistroControlCambios(RegistroControlCambios registroControlCambios) {
            this.registroControlCambios = registroControlCambios;
        }
        
        public boolean isDefineLoteEs() {
            return defineLoteEs;
        }

        public void setDefineLoteEs(boolean defineLoteEs) {
            this.defineLoteEs = defineLoteEs;
        }

        
        
    
    
    
    
    //</editor-fold>

    
    

    

    

    

    
}
