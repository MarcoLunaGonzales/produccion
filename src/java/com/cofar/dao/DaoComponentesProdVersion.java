/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdConcentracion;
import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.ComponentesProdVersionModificacion;
import com.cofar.util.Util;
import com.cofar.web.ManagedAccesoSistema;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoComponentesProdVersion extends DaoBean{

    public DaoComponentesProdVersion() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    
    public DaoComponentesProdVersion(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    /*
    */
    public boolean cambiarEstadoProducto(int codCompProd, int codEstadoProducto){
        LOGGER.debug("----------------------------------------INICIO CAMBIAR ESTADO PRODUCTO-----------------------------------");
        boolean registradoCorrectamente = false;
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" exec PAA_GENERACION_NUEVA_VERSION_PRODUCTO ");
                                        consulta.append(codCompProd).append(",");
                                        consulta.append("1,");//version de producto
                                        consulta.append("0,");
                                        consulta.append("0,?");
            LOGGER.debug("consulta regitrar copia version producto discontinuar "+consulta.toString());
            CallableStatement callVersionCopia=con.prepareCall(consulta.toString());
            callVersionCopia.registerOutParameter(1,java.sql.Types.INTEGER);
            callVersionCopia.execute();
            int codVersionNueva=callVersionCopia.getInt(1);
            consulta=new StringBuilder("update COMPONENTES_PROD_VERSION ");
                    consulta.append(" set COD_ESTADO_COMPPROD=").append(codEstadoProducto);
                    consulta.append(" where COD_VERSION=").append(codVersionNueva);
            LOGGER.debug("consulta inactivar producto "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0)LOGGER.info("se inactivo el producto en la version");
            consulta=new StringBuilder("update FORMULA_MAESTRA_VERSION set COD_ESTADO_REGISTRO=").append(codEstadoProducto);
                        consulta.append(" from COMPONENTES_PROD_VERSION cpv ");
                                consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                                        consulta.append(" and cpv.COD_VERSION=fmv.COD_COMPPROD_VERSION");
                        consulta.append(" where cpv.COD_VERSION=").append(codVersionNueva);
            LOGGER.debug("consulta inactivar version formula "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0)LOGGER.info("se inactivo el producto en version de formula maestra");
            
            // <editor-fold defaultstate="collapsed" desc="COMPONENTES PROD VERSION MODIFICACION">
                ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION,FECHA_ENVIO_APROBACION)");
                         consulta.append(" VALUES (").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",").append(codVersionNueva).append(",3,GETDATE(),GETDATE())");
                LOGGER.debug("consulta insertar usuario modificacion "+consulta);
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro el personal para la modificacion");
            //</editor-fold>
            // <editor-fold defaultstate="collapsed" desc="registrar datos de version de es">
                consulta=new StringBuilder("UPDATE FORMULA_MAESTRA_ES_VERSION");
                            consulta.append(" SET COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                                    consulta.append(" ,COD_ESTADO_VERSION=3");
                                    consulta.append(" ,FECHA_ENVIO_APROBACION=GETDATE()");
                            consulta.append(" WHERE COD_VERSION=").append(codVersionNueva);
                LOGGER.debug("consulta registrar datos es "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registraron datos de es");
            //</editor-fold>
                consulta=new StringBuilder("update COMPONENTES_PROD_VERSION ");
                            consulta.append(" set COD_ESTADO_VERSION=3");
                            consulta.append(" where COD_VERSION=").append(codVersionNueva);
                LOGGER.debug("consulta enviar aprobacion version producto "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro el envio a aprobacion");
            // <editor-fold defaultstate="collapsed" desc="aprobando version de es">
            
                consulta=new StringBuilder("exec PAA_APROBACION_COMPONENTES_PROD_VERSION ");
                            consulta.append(codVersionNueva);
                LOGGER.debug("consulta aprobar version producto "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version");
                consulta=new StringBuilder("select fmes.COD_FORMULA_MAESTRA_ES_VERSION,cpv.COD_COMPPROD,fmv.COD_FORMULA_MAESTRA");
                            consulta.append(" from FORMULA_MAESTRA_ES_VERSION fmes");
                                    consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=fmes.COD_VERSION");
                                    consulta.append(" inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_COMPPROD_VERSION=cpv.COD_VERSION");
                                            consulta.append(" and fmv.COD_COMPPROD=cpv.COD_COMPPROD");
                            consulta.append(" where cpv.COD_VERSION=").append(codVersionNueva);
                LOGGER.debug("consulta buscar version es "+consulta.toString());
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta.toString());
                if(res.next())
                {
                    consulta=new StringBuilder("exec PAA_APROBACION_FORMULA_MAESTRA_ES_VERSION ");
                            consulta.append(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")).append(",");
                            consulta.append(codVersionNueva).append(",");
                            consulta.append(res.getInt("COD_COMPPROD")).append(",");
                            consulta.append(res.getInt("COD_FORMULA_MAESTRA"));
                    LOGGER.debug("consulta  aprobar es "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version es ");
                }
            //</editor-fold>
            con.commit();
            pst.close();
            registradoCorrectamente = true;
        } 
        catch (SQLException ex){
            registradoCorrectamente = false;
            LOGGER.warn(ex.getMessage());
            this.rollbackConexion(con);
        }
        catch (NumberFormatException ex){
            registradoCorrectamente = false;
            LOGGER.warn(ex.getMessage());
            this.rollbackConexion(con);
        }
        finally{
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------------------------TERMINO CAMBIAR ESTADO PRODUCTO-----------------------------------");
        return registradoCorrectamente;
    }
    public List<ComponentesProdVersion> listar(ComponentesProdVersion componentesProdVersionBuscar)
    {
        List<ComponentesProdVersion> componentesProdVersionList = new ArrayList<ComponentesProdVersion>();
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("EXEC PAA_LISTAR_COMPONENTES_PROD_VERSION ")
                                                .append(componentesProdVersionBuscar.getCodCompprod()).append(",")
                                                .append(componentesProdVersionBuscar.getComponentesProdVersionModificacionPersonal().getPersonal().getCodPersonal());
            LOGGER.debug("consulta cargar versiones producto "+consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            List<ComponentesProdVersionModificacion> componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
            ComponentesProdVersion nuevo=new ComponentesProdVersion();
            while (res.next())
            {
                if(nuevo.getCodVersion()!=res.getInt("COD_VERSION"))
                {
                        if(nuevo.getCodVersion()>0)
                        {
                            
                            nuevo.setComponentesProdVersionModificacionList(componentesProdVersionModificacionList);
                            componentesProdVersionList.add(nuevo);
                            nuevo=new ComponentesProdVersion();
                        }
                        nuevo.setPorcientoLimiteAlerta(res.getDouble("PORCIENTO_LIMITE_ALERTA"));
                        nuevo.setPorcientoLimiteAccion(res.getDouble("PORCIENTO_LIMITE_ACCION"));
                        nuevo.getUnidadMedidaPesoTeorico().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_PESO_TEORICO"));
                        nuevo.setPesoTeorico(res.getDouble("PESO_TEORICO"));
                        nuevo.setCantidadVolumenDeDosificado(res.getDouble("CANTIDAD_VOLUMEN_DE_DOSIFICADO"));
                        nuevo.setTamanioLoteProduccion(res.getInt("TAMANIO_LOTE_PRODUCCION"));
                        nuevo.setCodFormulaMaestra(res.getInt("COD_FORMULA_MAESTRA"));
                        nuevo.setCodFormulaMaestraVersion(res.getInt("COD_VERSION_FM"));
                        nuevo.setPresentacionesRegistradasRs(res.getString("PRESENTACIONES_REGISTRADAS_RS"));
                        nuevo.getCondicionesVentasProducto().setCodCondicionVentaProducto(res.getInt("COD_CONDICION_VENTA_PRODUCTO"));
                        nuevo.getCondicionesVentasProducto().setNombreCondicionVentaProducto(res.getString("NOMBRE_CONDICION_VENTA_PRODUCTO"));
                        nuevo.setDireccionArchivoSanitario(res.getString("DIRECCION_ARCHIVO_REGISTRO_SANITARIO"));
                        nuevo.setNombreComercial(res.getString("NOMBRE_COMERCIAL"));
                        nuevo.setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO")>0);
                        nuevo.setFechaModificacion(res.getTimestamp("FECHA_MODIFICACION"));
                        nuevo.setFechaInicioVigencia(res.getTimestamp("FECHA_INICIO_VIGENCIA"));
                        nuevo.setNroVersion(res.getInt("NRO_VERSION"));
                        nuevo.setFechaVencimientoRS(res.getTimestamp("FECHA_VENCIMIENTO_RS"));
                        nuevo.setToleranciaVolumenfabricar(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR"));
                        nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                        nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                        nuevo.setCantidadVolumen(res.getDouble("CANTIDAD_VOLUMEN"));
                        nuevo.getUnidadMedidaVolumen().setCodUnidadMedida(res.getString("COD_UNIDAD_MEDIDA_VOLUMEN"));
                        nuevo.getUnidadMedidaVolumen().setAbreviatura(res.getString("ABREVIATURA"));
                        nuevo.getTamaniosCapsulasProduccion().setCodTamanioCapsulaProduccion(res.getInt("COD_TAMANIO_CAPSULA_PRODUCCION"));
                        nuevo.getTamaniosCapsulasProduccion().setNombreTamanioCapsulaProduccion(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION"));
                        nuevo.getEstadoCompProd().setCodEstadoCompProd(res.getInt("COD_ESTADO_COMPPROD"));
                        nuevo.getEstadoCompProd().setNombreEstadoCompProd(res.getString("NOMBRE_ESTADO_COMPPROD"));
                        nuevo.setPesoEnvasePrimario(res.getString("PESO_ENVASE_PRIMARIO"));
                        nuevo.setRegSanitario(res.getString("REG_SANITARIO"));
                        nuevo.setConcentracionEnvasePrimario(res.getString("CONCENTRACION_ENVASE_PRIMARIO"));
                        nuevo.setVidaUtil(res.getInt("VIDA_UTIL"));
                        nuevo.setCodVersion(res.getInt("COD_VERSION"));
                        nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                        nuevo.setNombreGenerico(res.getString("NOMBRE_GENERICO"));
                        nuevo.setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO")>0);
                        nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                        nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                        nuevo.getProducto().setCodProducto(res.getString("COD_PROD"));
                        nuevo.getProducto().setNombreProducto(res.getString("NOMBRE_PROD"));
                        nuevo.getForma().setCodForma(res.getString("COD_FORMA"));
                        nuevo.getForma().setNombreForma(res.getString("NOMBRE_FORMA"));
                        nuevo.getColoresPresentacion().setCodColor(res.getString("COD_COLORPRESPRIMARIA"));
                        nuevo.getColoresPresentacion().setNombreColor(res.getString("NOMBRE_COLORPRESPRIMARIA"));
                        nuevo.getViasAdministracionProducto().setCodViaAdministracionProducto(res.getInt("COD_VIA_ADMINISTRACION_PRODUCTO"));
                        nuevo.getViasAdministracionProducto().setNombreViaAdministracionProducto(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO"));
                        nuevo.getSaboresProductos().setCodSabor(res.getString("COD_SABOR"));
                        nuevo.getSaboresProductos().setNombreSabor(res.getString("NOMBRE_SABOR"));
                        nuevo.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("COD_ESTADO_VERSION"));
                        nuevo.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("NOMBRE_ESTADO_VERSION_COMPONENTES_PROD"));
                        nuevo.getTiposModificacionProducto().setCodTipoModificacionProducto(3);//reformulacion o cambios sobre una version oficial
                        nuevo.setAplicaEspecificacionesFisicas(res.getInt("APLICA_ESPECIFICACIONES_FISICAS")>0);
                        nuevo.setAplicaEspecificacionesQuimicas(res.getInt("APLICA_ESPECIFICACIONES_QUIMICAS")>0);
                        nuevo.setAplicaEspecificacionesMicrobiologicas(res.getInt("APLICA_ESPECIFICACIONES_MICROBIOLOGICAS")>0);
                        nuevo.setInformacionCompleta(res.getBoolean("INFORMACION_COMPLETA"));
                        nuevo.setComponentesProdVersionModificacionPersonal(new  ComponentesProdVersionModificacion());
                        nuevo.getComponentesProdVersionModificacionPersonal().getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("codEstadoVersionPersonal"));
                        nuevo.getComponentesProdVersionModificacionPersonal().getTiposPermisosEspecialesAtlas().setCodTipoPermisoEspecialAtlas(res.getInt("codTipoPermisoVersion"));
                        nuevo.setCantidadLotesConDesviacion(res.getInt("cantidadLotesDesviacion"));
                        componentesProdVersionModificacionList=new ArrayList<ComponentesProdVersionModificacion>();
                }
                ComponentesProdVersionModificacion nuevoPer=new ComponentesProdVersionModificacion();
                nuevoPer.setFechaDevolucionVersion(res.getTimestamp("FECHA_DEVOLUCION_VERSION"));
                nuevoPer.setFechaEnvioAprobacion(res.getTimestamp("FECHA_ENVIO_APROBACION"));
                nuevoPer.setFechaInclusionVersion(res.getTimestamp("FECHA_INCLUSION_VERSION"));
                nuevoPer.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                nuevoPer.setObservacionPersonalVersion(res.getString("OBSERVACION_PERSONAL_VERSION"));
                nuevoPer.getEstadosVersionComponentesProd().setCodEstadoVersionComponenteProd(res.getInt("codEstadoPersonal"));
                nuevoPer.getEstadosVersionComponentesProd().setNombreEstadoVersionComponentesProd(res.getString("estadoVersionPersonal"));
                nuevoPer.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                nuevoPer.setFechaAsignacion(res.getTimestamp("FECHA_ASIGNACION"));
                nuevoPer.getTiposPermisosEspecialesAtlas().setCodTipoPermisoEspecialAtlas(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"));
                nuevoPer.getTiposPermisosEspecialesAtlas().setNombreTipoPermisoEspecialAtlas(res.getString("NOMBRE_TIPO_PERMISO_ESPECIAL_ATLAS"));
                componentesProdVersionModificacionList.add(nuevoPer);
            }
            if(nuevo.getCodVersion()>0)
            {
                nuevo.setComponentesProdVersionModificacionList(componentesProdVersionModificacionList);
                componentesProdVersionList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        return componentesProdVersionList;
    }
            
    public List<SelectItem> getComponentesProdVersionSelectList(ComponentesProdVersion componentesProdVersionBuscar)
    {
        List<SelectItem> componentesProdVersionList=new ArrayList<SelectItem>();
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select cpv.COD_VERSION,cpv.COD_COMPPROD,cpv.nombre_prod_semiterminado,cpv.NRO_VERSION");
                                        consulta.append(" from COMPONENTES_PROD_VERSION cpv ");
                                                consulta.append(" left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cpv.COD_AREA_EMPRESA");
                                                consulta.append(" left outer join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cpv.COD_FORMA");
                                                consulta.append(" left outer join VIAS_ADMINISTRACION_PRODUCTO vap on vap.COD_VIA_ADMINISTRACION_PRODUCTO=cpv.COD_VIA_ADMINISTRACION_PRODUCTO");
                                        consulta.append(" where 1=1");
                                            if(componentesProdVersionBuscar.getCodVersion()>0)
                                                consulta.append(" cpv.COD_VERSION=").append(componentesProdVersionBuscar.getCodVersion());
                                            if(! (componentesProdVersionBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("") || componentesProdVersionBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0")))
                                                consulta.append(" and cpv.COD_AREA_EMPRESA=").append(componentesProdVersionBuscar.getAreasEmpresa().getCodAreaEmpresa());
                                            if(! (componentesProdVersionBuscar.getForma().getCodForma().equals("") || componentesProdVersionBuscar.getForma().getCodForma().equals("0")))
                                                consulta.append(" and cpv.COD_FORMA=").append(componentesProdVersionBuscar.getForma().getCodForma());
                                            if(componentesProdVersionBuscar.getTiposComponentesProdVersion().getCodTipoComponentesProdVersion()>0)
                                                consulta.append(" and cpv.COD_TIPO_COMPONENTES_PROD_VERSION=").append(componentesProdVersionBuscar.getTiposComponentesProdVersion().getCodTipoComponentesProdVersion());
                                            if(componentesProdVersionBuscar.getEstadosVersionComponentesProd().getCodEstadoVersionComponenteProd()>0)
                                                consulta.append(" and cpv.COD_ESTADO_VERSION=").append(componentesProdVersionBuscar.getEstadosVersionComponentesProd().getCodEstadoVersionComponenteProd());
                                        consulta.append(" order by cpv.nombre_prod_semiterminado,cpv.NRO_VERSION");
            LOGGER.debug("consulta cargar componentes Prod version "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next()) 
            {
                componentesProdVersionList.add(new SelectItem(res.getInt("COD_VERSION"),res.getString("nombre_prod_semiterminado")+" | V:"+res.getInt("NRO_VERSION")));
            }
            
        }
        catch (SQLException ex) 
        {
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return componentesProdVersionList;
    }
    
    public boolean guardar(ComponentesProdVersion  componentesProdVersion)throws SQLException
    {
        boolean guardado = false;
        try{
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("select isnull(min(cp.COD_COMPPROD),0)-1 as codComprod")
                                            .append(" from COMPONENTES_PROD_VERSION cp");
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            int codCompProd=-1;
            if(res.next())codCompProd=res.getInt("codComprod");
            if(codCompProd >= 0)codCompProd=-1;
            int codVersion=0;
            PreparedStatement pst=null;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION(COD_COMPPROD,COD_PROD,COD_FORMA,COD_SABOR,NOMBRE_GENERICO");
                      consulta.append(",REG_SANITARIO,FECHA_VENCIMIENTO_RS,VIDA_UTIL,PRODUCTO_SEMITERMINADO");
                      consulta.append(",NRO_VERSION,FECHA_MODIFICACION,COD_ESTADO_VERSION,COD_ESTADO_COMPPROD,NOMBRE_COMERCIAL,COD_CONDICION_VENTA_PRODUCTO,");
                      consulta.append("PRESENTACIONES_REGISTRADAS_RS,COD_TIPO_PRODUCCION,COD_TIPO_MODIFICACION_PRODUCTO,APLICA_ESPECIFICACIONES_FISICAS,")
                                .append(" APLICA_ESPECIFICACIONES_QUIMICAS,APLICA_ESPECIFICACIONES_MICROBIOLOGICAS,COD_TIPO_COMPONENTES_PROD_VERSION,")
                                .append(" PORCIENTO_LIMITE_ALERTA, PORCIENTO_LIMITE_ACCION,nombre_prod_semiterminado,COD_AREA_EMPRESA,COD_VIA_ADMINISTRACION_PRODUCTO,")
                                .append(" CANTIDAD_VOLUMEN,COD_UNIDAD_MEDIDA_VOLUMEN,TOLERANCIA_VOLUMEN_FABRICAR, PESO_TEORICO, COD_UNIDAD_MEDIDA_PESO_TEORICO,")
                                .append(" PESO_ENVASE_PRIMARIO,COD_COLORPRESPRIMARIA,COD_TAMANIO_CAPSULA_PRODUCCION,")
                                .append(" TAMANIO_LOTE_PRODUCCION,CANTIDAD_VOLUMEN_DE_DOSIFICADO)");
                      consulta.append(" VALUES (");
                                consulta.append("'").append(codCompProd).append("',");
                                consulta.append("'").append(componentesProdVersion.getProducto().getCodProducto()).append("',");
                                consulta.append("'").append(componentesProdVersion.getForma().getCodForma()).append("',");
                                consulta.append("'").append(componentesProdVersion.getSaboresProductos().getCodSabor()).append("',");
                                consulta.append("(select p.nombre_prod from productos p where p.cod_prod=").append(componentesProdVersion.getProducto().getCodProducto()).append("),");
                                consulta.append("?,")//registro sanitario
                                        .append(componentesProdVersion.getFechaVencimientoRS()!=null?("'"+sdf.format(componentesProdVersion.getFechaVencimientoRS())+"'"):"null").append(",")
                                        .append("'").append(componentesProdVersion.getVidaUtil()).append("',")
                                        .append(componentesProdVersion.isProductoSemiterminado()?1:0).append(",")
                                        .append("1,")
                                        .append("getdate(),")
                                        .append("1,")
                                        .append("1,")
                                        .append("?,")//nombre comercial
                                        .append(componentesProdVersion.getCondicionesVentasProducto().getCodCondicionVentaProducto()).append(",")
                                        .append("?,")//presentaciones registradas
                                        .append(componentesProdVersion.getTiposProduccion().getCodTipoProduccion()).append(",")
                                        .append(componentesProdVersion.getTiposModificacionProducto().getCodTipoModificacionProducto()).append(",")
                                        .append(componentesProdVersion.isAplicaEspecificacionesFisicas()?1:0).append(",")
                                        .append(componentesProdVersion.isAplicaEspecificacionesQuimicas()?1:0).append(",")
                                        .append(componentesProdVersion.isAplicaEspecificacionesMicrobiologicas()?1:0).append(",")
                                        .append("1,")//version por producto
                                        .append(componentesProdVersion.getPorcientoLimiteAlerta()).append(",")
                                        .append(componentesProdVersion.getPorcientoLimiteAccion()).append(",")
                                        .append("?,")//nombre de producto semiterminado
                                        .append("'").append(componentesProdVersion.getAreasEmpresa().getCodAreaEmpresa()).append("',")
                                        .append(componentesProdVersion.getViasAdministracionProducto().getCodViaAdministracionProducto()).append(",")
                                        .append(componentesProdVersion.getCantidadVolumen()).append(",")
                                        .append("'").append(componentesProdVersion.getUnidadMedidaVolumen().getCodUnidadMedida()).append("',")
                                        .append(componentesProdVersion.getToleranciaVolumenfabricar()).append(",")
                                        .append(componentesProdVersion.getPesoTeorico()).append(",")
                                        .append("'").append(componentesProdVersion.getUnidadMedidaPesoTeorico().getCodUnidadMedida()).append("',")
                                        .append("'").append(componentesProdVersion.getPesoTeorico()).append(" '+(select um.ABREVIATURA from UNIDADES_MEDIDA um where um.COD_UNIDAD_MEDIDA= '").append(componentesProdVersion.getUnidadMedidaPesoTeorico().getCodUnidadMedida()).append("'),")
                                        .append("'").append(componentesProdVersion.getColoresPresentacion().getCodColor()).append("',")
                                        .append(componentesProdVersion.getTamaniosCapsulasProduccion().getCodTamanioCapsulaProduccion()).append(",")
                                        .append(componentesProdVersion.getTamanioLoteProduccion()).append(",")
                                        .append(componentesProdVersion.getCantidadVolumenDeDosificado())
                                .append(")");
                      
            LOGGER.debug("consulta registrar nuevo producto"+consulta.toString());
            pst= con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,componentesProdVersion.getRegSanitario());LOGGER.info("p1: "+componentesProdVersion.getRegSanitario());
            pst.setString(2,componentesProdVersion.getNombreComercial());LOGGER.info("p2: "+componentesProdVersion.getNombreComercial());
            pst.setString(3,componentesProdVersion.getPresentacionesRegistradasRs());LOGGER.info("p3: "+componentesProdVersion.getPresentacionesRegistradasRs());
            pst.setString(4,componentesProdVersion.getNombreProdSemiterminado());LOGGER.info("p4: "+componentesProdVersion.getNombreProdSemiterminado());
            if (pst.executeUpdate() > 0)LOGGER.info("se registro el nuevo producto");
            res=pst.getGeneratedKeys();
            if(res.next())codVersion=res.getInt(1);
            consulta=new StringBuilder("INSERT INTO COMPONENTES_PROD_CONCENTRACION(COD_COMPPROD, COD_MATERIAL,");
            consulta.append(" CANTIDAD, COD_UNIDAD_MEDIDA, UNIDAD_PRODUCTO, COD_ESTADO_REGISTRO");
            consulta.append(",CANTIDAD_EQUIVALENCIA,NOMBRE_MATERIAL_EQUIVALENCIA,COD_UNIDAD_MEDIDA_EQUIVALENCIA,COD_VERSION")
                    .append(",EXCIPIENTE,PESO_MOLECULAR,COD_REFERENCIACC)");
            consulta.append(" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)");
            LOGGER.debug("consulta insertar material concentracion "+consulta.toString());
            PreparedStatement pstMaterial=con.prepareStatement(consulta.toString());
            for(ComponentesProdConcentracion bean : componentesProdVersion.getComponentesProdConcentracionList())
            {
                pstMaterial.setInt(1,codCompProd);
                pstMaterial.setString(2,bean.getMateriales().getCodMaterial());
                pstMaterial.setDouble(3,bean.getCantidad());
                pstMaterial.setString(4,bean.getUnidadesMedida().getCodUnidadMedida());
                pstMaterial.setString(5,bean.getUnidadProducto());
                pstMaterial.setString(6,"1");
                pstMaterial.setDouble(7,bean.getCantidadEquivalencia());
                pstMaterial.setString(8,bean.getNombreMaterialEquivalencia());
                pstMaterial.setString(9,bean.getUnidadMedidaEquivalencia().getCodUnidadMedida());
                pstMaterial.setInt(10, codVersion);
                pstMaterial.setInt(11,(bean.isExcipiente()?1:0));
                pstMaterial.setDouble(12,bean.getPesoMolecular());
                pstMaterial.setInt(13, bean.getTiposReferenciaCc().getCodReferenciaCc());
                if(pstMaterial.executeUpdate()>0)LOGGER.info("se registro material concentracion");
            }
            pstMaterial.close();
            pstMaterial=null;
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,");
                                consulta.append(" COD_ESTADO_VERSION_COMPONENTES_PROD,FECHA_INCLUSION_VERSION)");
                        consulta.append(" VALUES ('").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append("',");
                        consulta.append(" '").append(codVersion).append("',1,'").append(sdf.format(new Date())).append("')");
            LOGGER.debug("consulta insertar usuario modificacion "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro el personal para la modificacion");
            int codVersionFm=0;
            int codFormulaMaestra=0;
            consulta=new StringBuilder("select isnull(min(f.COD_FORMULA_MAESTRA),0)-1 as codFormulaMaestra from FORMULA_MAESTRA_VERSION f");
            res=st.executeQuery(consulta.toString());
            if(res.next())codFormulaMaestra=res.getInt("codFormulaMaestra");
            if(codFormulaMaestra>0)codFormulaMaestra=-1;
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_VERSION(COD_FORMULA_MAESTRA,COD_COMPPROD, CANTIDAD_LOTE, ESTADO_SISTEMA,");
                     consulta.append(" COD_ESTADO_REGISTRO, NRO_VERSION,FECHA_MODIFICACION, COD_ESTADO_VERSION_FORMULA_MAESTRA, FECHA_INICIO_VIGENCIA,");
                     consulta.append(" COD_PERSONAL_CREACION, COD_TIPO_MODIFICACION_FORMULA, COD_COMPPROD_VERSION,MODIFICACION_NF, MODIFICACION_MP_EP, MODIFICACION_ES, MODIFICACION_R)");
                     consulta.append(" VALUES ('").append(codFormulaMaestra).append("','").append(codCompProd).append("',0,1,1,'1','").append(sdf.format(new Date())).append("',");
                     consulta.append("1, null,'").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append("',1,'").append(codVersion).append("',1,1, 1, 1)");
            LOGGER.debug("consulta registrar formula maestra version "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la version de fm");
            consulta=new StringBuilder("INSERT INTO FORMULA_MAESTRA_ES_VERSION(OBSERVACION, COD_PERSONAL, FECHA_CREACION,COD_VERSION,COD_ESTADO_VERSION, NRO_VERSION)");
                consulta.append(" VALUES (");
                    consulta.append("'Nuevo Producto',");//nuevo producto
                    consulta.append("0,");//cod personal registra 0
                    consulta.append("GETDATE(),");//fecha registro
                    consulta.append(codVersion).append(",");
                    consulta.append("1,");//estado registrado
                    consulta.append("0");//version iniciar 0
                consulta.append(")");
            LOGGER.debug("consulta registro version es"+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la verison  de es");
            
            consulta = new StringBuilder(" exec PAA_ACTUALIZACION_CONCENTRACION_PRODUCTO ").append(codVersion);
            LOGGER.debug("consulta actualizar la concentracion "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("Se actualizo la concentracion");
            
            consulta = new StringBuilder("SELECT tp.DESARROLLO")
                                .append(" from TIPOS_PRODUCCION tp ")
                                .append(" where tp.COD_TIPO_PRODUCCION = ").append(componentesProdVersion.getTiposProduccion().getCodTipoProduccion());
            LOGGER.debug("consulta verificar producto de desarrollo "+consulta.toString());
            res = st.executeQuery(consulta.toString());
            res.next();
            if(res.getInt("DESARROLLO") > 0)
            {
                LOGGER.info("producto de desarrollo ");
                consulta = new StringBuilder("exec PAA_APROBACION_COMPONENTES_PROD_VERSION ")
                                            .append(codVersion);
                LOGGER.debug("consulta aprobar producto "+consulta.toString());
                pst = con.prepareStatement(consulta.toString());
                if(pst.executeUpdate() > 0)LOGGER.info("se aprobo la version de producto");
                StringBuilder consultaES=new StringBuilder("select f.COD_FORMULA_MAESTRA_ES_VERSION");
                                            consultaES.append(" from FORMULA_MAESTRA_ES_VERSION f ");
                                            consultaES.append(" where f.COD_VERSION=").append(codVersion);
                LOGGER.debug("consulta buscar version es "+consultaES.toString());
                res=st.executeQuery(consultaES.toString());
                if(res.next())
                {
                    consultaES=new StringBuilder("exec PAA_APROBACION_FORMULA_MAESTRA_ES_VERSION ");
                            consultaES.append(res.getInt("COD_FORMULA_MAESTRA_ES_VERSION")).append(",");
                            consultaES.append(codVersion).append(",");
                            consultaES.append("0,");
                            consultaES.append(0);
                    LOGGER.debug("consulta  aprobar es "+consultaES.toString());
                    pst=con.prepareStatement(consultaES.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se aprobo la version es ");
                }
            }
            con.commit();
            pst.close();
            guardado = true;
        } 
        catch (SQLException ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (NumberFormatException ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return guardado;
    }
            
    public boolean editar(ComponentesProdVersion componentesProdVersion)throws SQLException
    {
        LOGGER.info("---------------------------------INICIO EDICION COMPONENTES PROD VERSION-------------------------");
        boolean guardado = false;
        try{
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            if(componentesProdVersion.isProductoSemiterminado())
            {
                componentesProdVersion.getProducto().setCodProducto("null");
                componentesProdVersion.setRegSanitario("");
                componentesProdVersion.setFechaVencimientoRS(null);
                componentesProdVersion.setVidaUtil(0);
                componentesProdVersion.setConcentracionEnvasePrimario("");
                componentesProdVersion.getComponentesProdConcentracionList().clear();
            }
            if(componentesProdVersion.getAreasEmpresa().getCodAreaEmpresa().equals("80")||componentesProdVersion.getAreasEmpresa().getCodAreaEmpresa().equals("81"))
            {
                componentesProdVersion.setVolumenEnvasePrimario("");
                componentesProdVersion.setPesoEnvasePrimario("");
            }
            if(componentesProdVersion.getAreasEmpresa().getCodAreaEmpresa().equals("82")||componentesProdVersion.getAreasEmpresa().getCodAreaEmpresa().equals("95"))
            {
                componentesProdVersion.setCantidadVolumen(0d);
                componentesProdVersion.getUnidadMedidaVolumen().setCodUnidadMedida("0");
            }
            if(!componentesProdVersion.getForma().getCodForma().equals("6"))
            {
                componentesProdVersion.getTamaniosCapsulasProduccion().setCodTamanioCapsulaProduccion(0);
            }
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            
            Double cantidadLoteAnterior = 0d;
            Double pesoTeoricoAnterior = 0d;
            Double cantidadVolumenAnterior = 0d;
            boolean aplicaRecalculoCambioPeso = false;
            boolean aplicaRecalculoCambioVolumen = false;
            
            StringBuilder consulta = new StringBuilder("select cpv.TAMANIO_LOTE_PRODUCCION,cpv.CANTIDAD_VOLUMEN,cpv.PESO_TEORICO")
                                                .append(" from componentes_prod_version cpv")
                                                .append(" where cpv.COD_VERSION =").append(componentesProdVersion.getCodVersion());
            LOGGER.debug("consulta obtener tamanio lote "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            if(res.next()){
                cantidadLoteAnterior = res.getDouble("TAMANIO_LOTE_PRODUCCION");
                pesoTeoricoAnterior = res.getDouble("PESO_TEORICO");
                cantidadVolumenAnterior = res.getDouble("CANTIDAD_VOLUMEN");
            }
            
            consulta = new StringBuilder("select f.APLICA_RECALCULO_CAMBIO_PESO,f.APLICA_RECALCULO_CAMBIO_VOLUMEN")
                                .append(" from FORMAS_FARMACEUTICAS_RECALCULO_FM f")
                                .append(" where f.COD_FORMA = ").append(componentesProdVersion.getForma().getCodForma());
            LOGGER.debug("cnsulta obtener proceso recalculo: "+consulta.toString());
            res = st.executeQuery(consulta.toString());
            if(res.next()){
                aplicaRecalculoCambioPeso = res.getInt("APLICA_RECALCULO_CAMBIO_PESO") > 0;
                aplicaRecalculoCambioVolumen = res.getInt("APLICA_RECALCULO_CAMBIO_VOLUMEN") > 0;
            }
            
            consulta = new StringBuilder(" UPDATE COMPONENTES_PROD_VERSION")
                                .append(" SET  COD_FORMA = ").append(componentesProdVersion.getForma().getCodForma())
                                        .append(" ,COD_SABOR = ").append(componentesProdVersion.getSaboresProductos().getCodSabor())
                                        .append(" ,NOMBRE_COMERCIAL = (select p.nombre_prod from productos p where p.cod_prod =").append(componentesProdVersion.getProducto().getCodProducto()).append(")")
                                        .append(" ,NOMBRE_GENERICO = ?")
                                        .append(" ,PRODUCTO_SEMITERMINADO = ").append((componentesProdVersion.isProductoSemiterminado()?1:0))
                                        .append(" ,COD_PROD = ").append(componentesProdVersion.getProducto().getCodProducto())
                                        .append(" ,REG_SANITARIO = ?")
                                        .append(" ,FECHA_VENCIMIENTO_RS = ").append((componentesProdVersion.getFechaVencimientoRS()!=null?"'"+sdf.format(componentesProdVersion.getFechaVencimientoRS())+"'":"null"))
                                        .append(" ,VIDA_UTIL = ").append(componentesProdVersion.getVidaUtil())
                                        .append(" ,COD_CONDICION_VENTA_PRODUCTO = ").append(componentesProdVersion.getCondicionesVentasProducto().getCodCondicionVentaProducto())
                                        .append(" ,PRESENTACIONES_REGISTRADAS_RS= ?")
                                        .append(" ,nombre_prod_semiterminado = ?")
                                        .append(" ,COD_AREA_EMPRESA = ").append(componentesProdVersion.getAreasEmpresa().getCodAreaEmpresa())
                                        .append(" ,COD_VIA_ADMINISTRACION_PRODUCTO = ").append(componentesProdVersion.getViasAdministracionProducto().getCodViaAdministracionProducto())
                                        .append(" ,CANTIDAD_VOLUMEN = ").append(componentesProdVersion.getCantidadVolumen())
                                        .append(" ,COD_UNIDAD_MEDIDA_VOLUMEN = ").append(componentesProdVersion.getUnidadMedidaVolumen().getCodUnidadMedida())
                                        .append(" ,TOLERANCIA_VOLUMEN_FABRICAR = ").append(componentesProdVersion.getToleranciaVolumenfabricar())
                                        .append(" , PESO_TEORICO = ").append(componentesProdVersion.getPesoTeorico())
                                        .append(" , COD_UNIDAD_MEDIDA_PESO_TEORICO = ").append(componentesProdVersion.getUnidadMedidaPesoTeorico().getCodUnidadMedida())
                                        .append(" ,PORCIENTO_LIMITE_ALERTA = ").append(componentesProdVersion.getPorcientoLimiteAlerta())
                                        .append(" ,PORCIENTO_LIMITE_ACCION = ").append(componentesProdVersion.getPorcientoLimiteAccion())
                                        .append(" ,PESO_ENVASE_PRIMARIO = '").append(componentesProdVersion.getPesoTeorico()).append(" '+(select um.ABREVIATURA from UNIDADES_MEDIDA um where um.COD_UNIDAD_MEDIDA= ").append(componentesProdVersion.getUnidadMedidaPesoTeorico().getCodUnidadMedida()).append(")")
                                        .append(" ,COD_COLORPRESPRIMARIA = '").append(componentesProdVersion.getColoresPresentacion().getCodColor()).append("'")
                                        .append(" ,COD_TAMANIO_CAPSULA_PRODUCCION = ").append(componentesProdVersion.getTamaniosCapsulasProduccion().getCodTamanioCapsulaProduccion())
                                        .append(" ,TAMANIO_LOTE_PRODUCCION = ").append(componentesProdVersion.getTamanioLoteProduccion())
                                        .append(" ,CANTIDAD_VOLUMEN_DE_DOSIFICADO =").append(componentesProdVersion.getCantidadVolumenDeDosificado())
                                        .append(" ,COD_ESTADO_COMPPROD = ").append(componentesProdVersion.getEstadoCompProd().getCodEstadoCompProd())
                                        .append(" ,APLICA_ESPECIFICACIONES_FISICAS = ").append((componentesProdVersion.isAplicaEspecificacionesFisicas()?1:0))
                                        .append(" ,APLICA_ESPECIFICACIONES_QUIMICAS = ").append((componentesProdVersion.isAplicaEspecificacionesQuimicas()?1:0))
                                        .append(" ,APLICA_ESPECIFICACIONES_MICROBIOLOGICAS = ").append((componentesProdVersion.isAplicaEspecificacionesMicrobiologicas()?1:0))
                                        .append(" ,INFORMACION_COMPLETA = ").append(componentesProdVersion.isInformacionCompleta() ? 1 : 0)
                                .append(" where COD_VERSION = ").append(componentesProdVersion.getCodVersion());
            LOGGER.debug("consulta guardar edicion componentes prod version " + consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            pst.setString(1,componentesProdVersion.getNombreGenerico());LOGGER.info("p1: "+componentesProdVersion.getNombreGenerico());
            pst.setString(2,componentesProdVersion.getRegSanitario());LOGGER.info("p2: "+componentesProdVersion.getRegSanitario());
            pst.setString(3,componentesProdVersion.getPresentacionesRegistradasRs());LOGGER.info("p3: "+componentesProdVersion.getPresentacionesRegistradasRs());
            pst.setString(4,componentesProdVersion.getNombreProdSemiterminado());LOGGER.info("p4: "+componentesProdVersion.getNombreProdSemiterminado());
            if(pst.executeUpdate()>0)LOGGER.info("se edito la version del producto");
            if(componentesProdVersion.getComponentesProdConcentracionList() != null)
            {
                consulta = new StringBuilder("delete COMPONENTES_PROD_CONCENTRACION ")
                                    .append(" where COD_VERSION = ").append(componentesProdVersion.getCodVersion());
                LOGGER.debug("consulta eliminar componentes prod concentracion "+consulta.toString());
                pst = con.prepareStatement(consulta.toString());
                if(pst.executeUpdate() > 0) LOGGER.info("se eliminaron detalles anteriores");
                for(ComponentesProdConcentracion bean : componentesProdVersion.getComponentesProdConcentracionList())
                {
                    consulta = new StringBuilder("INSERT INTO COMPONENTES_PROD_CONCENTRACION(COD_COMPPROD, COD_MATERIAL,")
                                                .append(" CANTIDAD, COD_UNIDAD_MEDIDA, UNIDAD_PRODUCTO, COD_ESTADO_REGISTRO" )
                                                .append(",CANTIDAD_EQUIVALENCIA,NOMBRE_MATERIAL_EQUIVALENCIA,COD_UNIDAD_MEDIDA_EQUIVALENCIA,COD_VERSION")
                                                .append(",EXCIPIENTE,PESO_MOLECULAR,COD_REFERENCIACC)")
                                          .append(" VALUES ('").append(componentesProdVersion.getCodCompprod()).append("', '").append(bean.getMateriales().getCodMaterial()).append("',")
                                                .append("'").append(bean.getCantidad()).append("', '").append(bean.getUnidadesMedida().getCodUnidadMedida()).append("',")
                                                .append("'").append(bean.getUnidadProducto()).append("','").append(bean.getEstadoRegistro().getCodEstadoRegistro()).append("'")
                                                .append(",'").append(bean.getCantidadEquivalencia()).append("','").append(bean.getNombreMaterialEquivalencia()).append("',")
                                                .append("'").append(bean.getUnidadMedidaEquivalencia().getCodUnidadMedida()).append("','").append(componentesProdVersion.getCodVersion()).append("'")
                                                .append(",'").append((bean.isExcipiente()?1:0)).append("',")
                                                .append(bean.getPesoMolecular()).append(",")
                                                .append(bean.getTiposReferenciaCc().getCodReferenciaCc())
                                            .append(")");
                    LOGGER.debug("consulta registrar dato concentracion "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se inserto la concentracion");
                }
            }
            
            consulta = new StringBuilder(" update FORMULA_MAESTRA_VERSION ")
                                .append(" set CANTIDAD_LOTE = ").append(componentesProdVersion.getTamanioLoteProduccion())
                                        .append(" ,COD_ESTADO_REGISTRO = ").append(componentesProdVersion.getEstadoCompProd().getCodEstadoCompProd())
                                        .append(" ,ESTADO_SISTEMA = ").append(componentesProdVersion.getEstadoCompProd().getCodEstadoCompProd())
                                .append(" where COD_COMPPROD_VERSION = ").append(componentesProdVersion.getCodVersion())
                                        .append(" and COD_COMPPROD = ").append(componentesProdVersion.getCodCompprod());
            LOGGER.debug("consulta cambiar fm cantidad "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se registro el cambio de cantidad de lote");
            
            consulta = new StringBuilder(" exec PAA_ACTUALIZACION_CONCENTRACION_PRODUCTO ").append(componentesProdVersion.getCodVersion());
            LOGGER.debug("consulta actualizar la concentracion "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("Se actualizo la concentracion");
            
            if(cantidadLoteAnterior > 0)
            {
                consulta = new StringBuilder("update FORMULA_MAESTRA_DETALLE_MP_VERSION set CANTIDAD_UNITARIA_GRAMOS= fmdv.CANTIDAD_UNITARIA_GRAMOS * ?")
                                    .append(" from FORMULA_MAESTRA_VERSION fmv")
                                            .append(" inner join FORMULA_MAESTRA_DETALLE_MP_VERSION fmdv on fmdv.COD_VERSION = fmv.COD_VERSION")
                                    .append(" where fmv.COD_COMPPROD_VERSION =  ").append(componentesProdVersion.getCodVersion());
                pst = con.prepareStatement(consulta.toString());
                LOGGER.debug("consulta actualizar cantidad fm cambio: "+consulta.toString());
                if(pesoTeoricoAnterior != componentesProdVersion.getPesoTeorico()
                        && aplicaRecalculoCambioPeso
                        && pesoTeoricoAnterior >0
                        && componentesProdVersion.getPesoTeorico() > 0){
                    LOGGER.debug("cambio de peso en version producto: "+componentesProdVersion.getCodVersion());
                    LOGGER.debug("peso anterior: "+pesoTeoricoAnterior);
                    LOGGER.debug("peso nuevo: "+componentesProdVersion.getPesoTeorico());
                    pst.setDouble(1,(componentesProdVersion.getPesoTeorico() / pesoTeoricoAnterior));LOGGER.info("factor :"+(componentesProdVersion.getPesoTeorico() / pesoTeoricoAnterior));
                    if(pst.executeUpdate() > 0)LOGGER.info("Se cambiaron cantidades unitarias de items");
                }
                
                if(cantidadVolumenAnterior != componentesProdVersion.getCantidadVolumen()
                        && aplicaRecalculoCambioVolumen
                        && cantidadVolumenAnterior >0
                        && componentesProdVersion.getCantidadVolumen() > 0){
                    LOGGER.debug("cambio de volumen en version de producto : "+componentesProdVersion.getCodVersion());
                    LOGGER.debug("volumen anterior: "+cantidadVolumenAnterior);
                    LOGGER.debug("volumen nuevo: "+componentesProdVersion.getCantidadVolumen());
                    pst.setDouble(1,(componentesProdVersion.getCantidadVolumen() / cantidadVolumenAnterior));LOGGER.info("factor :"+(componentesProdVersion.getCantidadVolumen() / cantidadVolumenAnterior));
                    if(pst.executeUpdate() > 0)LOGGER.info("Se cambiaron cantidades unitarias de items");
                }
                
                consulta = new StringBuilder(" exec PAA_ACTUALIZACION_CANTIDADES_FORMULA_MAESTRA_VERSION ").append(componentesProdVersion.getCodVersion());
                LOGGER.debug("consulta actualizar mp "+consulta.toString());
                pst = con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se cambio la cantidad de fm");
                // <editor-fold defaultstate="collapsed" desc="recalculando cantidades de e.s">
                    StringBuilder consultaStr=new StringBuilder("update FORMULA_MAESTRA_DETALLE_ES_VERSION set CANTIDAD=CANTIDAD*").append(Double.valueOf(componentesProdVersion.getTamanioLoteProduccion())/cantidadLoteAnterior);
                                            consultaStr.append(" FROM FORMULA_MAESTRA_DETALLE_ES_VERSION fmdes");
                                                    consultaStr.append(" inner join FORMULA_MAESTRA_ES_VERSION fmes on fmes.COD_FORMULA_MAESTRA_ES_VERSION=fmdes.COD_FORMULA_MAESTRA_ES_VERSION");
                                            consultaStr.append(" where fmes.COD_VERSION=").append(componentesProdVersion.getCodVersion());
                    LOGGER.debug("consulta actualizar cantidad fmes "+consultaStr.toString());
                    pst=con.prepareStatement(consultaStr.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se actualizaron las cantidades de fmes");
                //</editor-fold>
            }
            
            con.commit();
            guardado = true;
        }
        catch (SQLException ex)
        {
            guardado = false;
            con.rollback();
            LOGGER.warn("error", ex);
        }
        catch (Exception ex)
        {
            guardado = false;
            LOGGER.warn("error", ex);
        }
        finally
        {
            this.cerrarConexion(con);
        }
        LOGGER.info("---------------------------------FIN EDICION COMPONENTES PROD VERSION-------------------------");
        return guardado;
    }
}
