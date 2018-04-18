/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.IngresosAcond;
import com.cofar.bean.IngresosDetalleAcond;
import com.cofar.bean.IngresosdetalleCantidadPeso;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.util.Util;
import com.cofar.web.ManagedAccesoSistema;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoIngresosAcond extends DaoBean{

    public DaoIngresosAcond() {
        this.LOGGER = LogManager.getRootLogger();
    }
    
    public DaoIngresosAcond(Logger looger) {
        this.LOGGER = looger;
    }
    public Boolean guardar(IngresosAcond ingresosAcond, String descripcionTransaccion){
        LOGGER.debug("----------------------------inicio registro ingreso acond-------------------------------------");
        boolean guardado = false;
        int COD_TIPO_INGRESO_ACOND_PRODUCCION = 1;
        int COD_ESTADO_INGRESO_ACOND_CONFIRMAR = 1;
        int COD_TIPO_ENTREGA_TOTAL = 2;
        int COD_ESTADO_PROGRAMA_TERMINADO = 6;
        int COD_TIPO_TRANSACCION_NUEVO_REGISTRO = 3;
        try {
            ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" select isnull(max(i.COD_INGRESO_ACOND),0)+1 as codIngreso")
                                                .append(" from INGRESOS_ACOND i");
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            int codIngreso = 0;
            if(res.next())codIngreso = res.getInt("codIngreso");
            ingresosAcond.setCodIngresoAcond(codIngreso);
            
            consulta = new StringBuilder("select max(g.COD_GESTION) as codGestion")
                                .append(" from GESTIONES g")
                                .append(" where g.GESTION_ESTADO=1");
            res=st.executeQuery(consulta.toString());
            int codGestion=0;
            if(res.next())codGestion=res.getInt("codGestion");
            
            consulta = new StringBuilder("select isnull(max(ia.NRO_INGRESOACOND),0)+1 as nroIngreso")
                                .append(" from INGRESOS_ACOND ia")
                                .append(" where ia.COD_GESTION = ").append(codGestion)
                                        .append(" and ia.COD_ALMACENACOND = ").append(ingresosAcond.getAlmacenAcond().getCodAlmacenAcond());
            LOGGER.debug("consulta nro ingreso "+consulta.toString());
            res=st.executeQuery(consulta.toString());
            int nroIngreso=0;
            if(res.next())nroIngreso=res.getInt("nroIngreso");
            ingresosAcond.setNroIngresoAcond(nroIngreso);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            consulta = new StringBuilder("insert into ingresos_acond(cod_ingreso_acond,cod_tipoingresoacond,cod_gestion")
                                            .append(",cod_estado_ingresoacond,fecha_ingresoacond,nro_ingresoacond,nro_doc_ingresoacond,")
                                            .append(" cod_almacenacond,obs_ingresoacond)")
                                    .append(" values(")
                                            .append(codIngreso).append(",")
                                            .append(COD_TIPO_INGRESO_ACOND_PRODUCCION).append(",")
                                            .append(codGestion).append(",")
                                            .append(COD_ESTADO_INGRESO_ACOND_CONFIRMAR).append(",")
                                            .append("GETDATE(),")
                                            .append(nroIngreso).append(",")
                                            .append("'-',")
                                            .append(ingresosAcond.getAlmacenAcond().getCodAlmacenAcond()).append(",")
                                            .append("?")
                                    .append(")");
            LOGGER.debug("consulta registrar ingreso acond "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,ingresosAcond.getObsIngresoAcond());
            if (pst.executeUpdate() > 0)LOGGER.info("se registro el ingreso");
            
            if(ingresosAcond.getProgramaProduccionIngresoAcond() != null){
                consulta = new StringBuilder(" INSERT INTO PROGRAMA_PRODUCCION_INGRESOS_ACOND(  COD_PROGRAMA_PROD,  COD_COMPPROD,  COD_FORMULA_MAESTRA,  COD_LOTE_PRODUCCION,")
                                            .append(" COD_TIPO_PROGRAMA_PROD,  COD_INGRESO_ACOND,COD_TIPO_ENTREGA_ACOND,COD_PERSONAL_REGISTRO)")
                                    .append(" VALUES (")
                                        .append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getCodProgramaProduccion()).append(",")
                                        .append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod()).append(",")
                                        .append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra()).append(",")  
                                        .append("'").append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getCodLoteProduccion()).append("',")
                                        .append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd()).append(",")
                                        .append(codIngreso).append(",")
                                        .append(ingresosAcond.getProgramaProduccionIngresoAcond().getTiposEntregaAcond().getCodTipoEntregaAcond()).append(",")
                                        .append(managed.getUsuarioModuloBean().getCodUsuarioGlobal())
                                .append(")");
                LOGGER.debug("consulta registrar programa ingreso: "  + consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la relacion del programa con el ingresos");
                
                if(ingresosAcond.getProgramaProduccionIngresoAcond().getTiposEntregaAcond().getCodTipoEntregaAcond() == COD_TIPO_ENTREGA_TOTAL){
                    consulta = new StringBuilder("update PROGRAMA_PRODUCCION set COD_ESTADO_PROGRAMA=").append(COD_ESTADO_PROGRAMA_TERMINADO)
                                        .append(" where COD_LOTE_PRODUCCION = '").append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getCodLoteProduccion()).append("'")
                                                .append(" and COD_PROGRAMA_PROD=").append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getCodProgramaProduccion())
                                                .append(" and COD_COMPPROD=").append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getFormulaMaestra().getComponentesProd().getCodCompprod())
                                                .append(" and COD_FORMULA_MAESTRA=").append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getFormulaMaestra().getCodFormulaMaestra())
                                                .append(" and COD_TIPO_PROGRAMA_PROD=").append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getTiposProgramaProduccion().getCodTipoProgramaProd());
                    LOGGER.debug("consulta cerrar lote "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se cerro el lote de produccion ");
                    
                    consulta = new StringBuilder("exec PAA_REGISTRO_PROGRAMA_PRODUCCION_LOG ")
                                                .append(" ?,")//cod lote produccion
                                                .append(ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getCodProgramaProduccion()).append(",")//cod lote produccion
                                                .append("?,")//cod personal transaccion
                                                .append("1,")//edicion
                                                .append("0,")//codigos desviacion
                                                .append("'cambio a terminado enviado'");//descirpcion cambio
                    LOGGER.debug("consulta registrar log " + consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    pst.setString(1,ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getCodLoteProduccion());LOGGER.info("p1: "+ingresosAcond.getProgramaProduccionIngresoAcond().getProgramaProduccion().getCodLoteProduccion());
                    pst.setString(2,managed.getUsuarioModuloBean().getCodUsuarioGlobal());LOGGER.info("p2: "+managed.getUsuarioModuloBean().getCodUsuarioGlobal());
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el log");   
                }
            }
            
            consulta = new StringBuilder("SELECT MAX(COD_INGRESODETALLE_CANTIDADPESO)+1 COD_INGRESODETALLE_CANTIDADPESO")
                                .append(" FROM  INGRESODETALLE_CANTIDADPESO");
            res=st.executeQuery(consulta.toString());
            int codIngresoCantidadPeso=0;
            if(res.next())codIngresoCantidadPeso=res.getInt("COD_INGRESODETALLE_CANTIDADPESO");
            
            consulta = new StringBuilder("INSERT INTO INGRESOS_DETALLEACOND_UBICACION(COD_INGRESO_ACOND, COD_COMPPROD,")
                                        .append(" COD_LOTE_PRODUCCION, COD_ESTANTE_AMBIENTE_ACOND, CANTIDAD_PRODUCTO, FILA,")
                                        .append(" COLUMNA, PESO_PRODUCTO)")
                                .append(" VALUES (")
                                        .append(codIngreso).append(",")
                                        .append("?,")//cod compprod
                                        .append("?,")//codLoteProduccion
                                        .append("0,")
                                        .append("?,")//cantidad producto
                                        .append("'',")//fila
                                        .append("'',")//columna
                                        .append("?")//peso producto
                                .append(")");
            LOGGER.debug("consulta registrar detalle peso ubicacion : "+consulta.toString());
            PreparedStatement pstCantidadPeso = con.prepareStatement(consulta.toString());
                        
            sdf=new SimpleDateFormat("yyyy/MM/dd");
            consulta = new StringBuilder("INSERT INTO INGRESOS_DETALLEACOND(COD_INGRESO_ACOND, COD_LOTE_PRODUCCION,")
                                        .append(" COD_COMPPROD, FECHA_VEN, CANT_INGRESO_PRODUCCION, PESO_PRODUCCION,")
                                        .append(" CANT_TOTAL_INGRESO, CANT_INGRESOBUENOS, CANT_INGRESOFALLADOS, PESO_CONFIRMADO,")
                                        .append(" CANT_RESTANTE, OBSERVACION, cod_envase, cantidad_envase, ingresoCantidadPeso,")
                                        .append(" CANTIDAD_ENVASE_CONFIRMADO)")
                                .append(" VALUES (")
                                        .append(codIngreso).append(",")
                                        .append("?,")//cod lote produccion
                                        .append("?,")//codCompprod
                                        .append("?,")//fecha de vencimiento
                                        .append("?,")//canitdad ingresos produccion
                                        .append("?,")//peso produccion
                                        .append("?,")//cantidad total ingreso
                                        .append("?,")//cantidad total ingreso buenos
                                        .append("?,")//cantidad total ingreso fallados
                                        .append("?,")//peso confirmado
                                        .append("?,")//cantidad restante
                                        .append("?,")//observacion
                                        .append("?,")//cod Envase
                                        .append("?,")//cantidad envase
                                        .append("?,")//ingreso cantidad peso
                                        .append("?")//cantidad envase confirmado
                                .append(")");
            LOGGER.debug("consulta registrar detalle: "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            for(IngresosDetalleAcond bean : ingresosAcond.getIngresosDetalleAcondList()){
                LOGGER.info("-------------iniciando registro detalle");
                pst.setString(1, bean.getCodLoteProduccion());LOGGER.info("p1: "+bean.getCodLoteProduccion());
                pst.setString(2, bean.getComponentesProd().getCodCompprod());LOGGER.info("p2: "+bean.getComponentesProd().getCodCompprod());
                pst.setString(3, sdf.format(bean.getFechaVencimiento()));LOGGER.info("p3: "+sdf.format(bean.getFechaVencimiento()));
                pst.setInt(4, bean.getCantIngresoProduccion());LOGGER.info("p4: "+bean.getCantIngresoProduccion());
                pst.setDouble(5, bean.getPesoProduccion());LOGGER.info("p5: "+bean.getPesoProduccion());
                pst.setInt(6, bean.getCantTotalIngreso());LOGGER.info("p6: "+bean.getCantTotalIngreso());
                pst.setInt(7, bean.getCantIngresoBuenos());LOGGER.info("p7: "+bean.getCantIngresoBuenos());
                pst.setInt(8, bean.getCantIngresoFallados());LOGGER.info("p8: "+bean.getCantIngresoFallados());
                pst.setDouble(9, bean.getPesoConfirmado());LOGGER.info("p9: "+bean.getPesoConfirmado());
                pst.setInt(10, bean.getCantRestante());LOGGER.info("p10: "+bean.getCantRestante());
                pst.setString(11, bean.getObsIngresoDetalleAcond());LOGGER.info("p11: "+bean.getObsIngresoDetalleAcond());
                pst.setString(12, bean.getTiposEnvase().getCodTipoEnvase());LOGGER.info("p12: "+bean.getTiposEnvase().getCodTipoEnvase());
                pst.setInt(13,bean.getCantidadEnvase());LOGGER.info("p13 :"+bean.getCantidadEnvase());
                pst.setString(14, bean.getIngresoCantidadPeso());LOGGER.info("p14: "+bean.getIngresoCantidadPeso());
                pst.setInt(15, 0);
                if(pst.executeUpdate() > 0)LOGGER.info("se registro el detalle "+consulta.toString());
                for(IngresosdetalleCantidadPeso beanPeso : bean.getListadoCantidadPeso()){
                    LOGGER.debug("-----inicio registro detalle peso----");
                    pstCantidadPeso.setString(1,bean.getComponentesProd().getCodCompprod());LOGGER.info("p1 pstd: "+bean.getComponentesProd().getCodCompprod());
                    pstCantidadPeso.setString(2, bean.getCodLoteProduccion());LOGGER.info("p2 pstd: "+bean.getCodLoteProduccion());
                    pstCantidadPeso.setFloat(3,beanPeso.getCantidad());LOGGER.info("p3 pstd: "+beanPeso.getCantidad());
                    pstCantidadPeso.setDouble(4,beanPeso.getPeso());LOGGER.info("p4 pstd: "+beanPeso.getPeso());
                    if(pstCantidadPeso.executeUpdate()>0)LOGGER.info("se registro detalle peso "+consulta.toString());
                    codIngresoCantidadPeso++;
                    LOGGER.debug("-----termino registro detalle peso----");
                }
                LOGGER.info("-------------termino registro detalle");
            }
                    
            consulta = new StringBuilder("exec PAA_REGISTRO_INGRESOS_ACOND_LOG ")
                            .append(ingresosAcond.getCodIngresoAcond()).append(",")
                            .append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",")
                            .append(COD_TIPO_TRANSACCION_NUEVO_REGISTRO).append(",")
                            .append("?");
            LOGGER.debug("consulta registrar log de ingreso acond editar: "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            pst.setString(1, "registro nueva presentacion ");
            if(pst.executeUpdate() > 0)LOGGER.info("se registraron logs");
            con.commit();
            guardado = true;
            
        } 
        catch (SQLException ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
            this.rollbackConexion(con);
        }
        catch(Exception ex){
            guardado = false;
            LOGGER.warn("error", ex);
            this.rollbackConexion(con);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("----------------------------termino registro ingreso acond-------------------------------------");
        return guardado;
    }
    public Boolean modificar(IngresosAcond ingresosAcond,String descripcionTransaccion){
        LOGGER.debug("------------------------inicio modificar ingreso acond=------------------------------");
        boolean editado = false;
        int COD_TIPO_TRANSACCION_EDITAR = 1;
        try{
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("UPDATE INGRESOS_ACOND set ")
                                                    .append(" COD_ESTADO_INGRESOACOND = ").append(ingresosAcond.getEstadosIngresoAcond().getCodEstadoIngresoAcond())
                                                    .append(" ,NRO_INGRESOACOND = ").append(ingresosAcond.getNroIngresoAcond())
                                                    .append(" ,COD_ALMACENACOND = ").append(ingresosAcond.getAlmacenAcond().getCodAlmacenAcond())
                                                    .append(" ,OBS_INGRESOACOND = ?")
                                            .append(" WHERE  COD_INGRESO_ACOND = ").append(ingresosAcond.getCodIngresoAcond());
            LOGGER.debug("consulta editar ingreso acond "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            pst.setString(1, ingresosAcond.getObsIngresoAcond());LOGGER.info("p1: "+ingresosAcond.getObsIngresoAcond());
            if(pst.executeUpdate()>0)LOGGER.info("se actualizo el ingreso");
            
            
            
            consulta = new StringBuilder("INSERT INTO INGRESOS_DETALLEACOND_UBICACION(COD_INGRESO_ACOND, COD_COMPPROD,")
                                        .append(" COD_LOTE_PRODUCCION, COD_ESTANTE_AMBIENTE_ACOND, CANTIDAD_PRODUCTO, FILA,")
                                        .append(" COLUMNA, PESO_PRODUCTO)")
                                .append(" VALUES (")
                                        .append(ingresosAcond.getCodIngresoAcond()).append(",")
                                        .append("?,")//cod compprod
                                        .append("?,")//codLoteProduccion
                                        .append("0,")
                                        .append("?,")//cantidad producto
                                        .append("'',")//fila
                                        .append("'',")//columna
                                        .append("?")//peso producto
                                .append(")");
            LOGGER.debug("consulta registrar detalle peso: "+consulta.toString());
            PreparedStatement pstCantidadPeso = con.prepareStatement(consulta.toString());
            
            consulta = new StringBuilder("DELETE INGRESOS_DETALLEACOND ")
                                .append(" WHERE  COD_INGRESO_ACOND = ").append(ingresosAcond.getCodIngresoAcond());
            LOGGER.debug("consulta eliminar detalle acond "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("se eliminaron detalles acondicionamiento");
            
            consulta = new StringBuilder("delete INGRESOS_DETALLEACOND_UBICACION")
                                    .append(" WHERE  COD_INGRESO_ACOND = ").append(ingresosAcond.getCodIngresoAcond());
            LOGGER.debug("consulta eliminar detalle peso ubicacion: "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)LOGGER.info("se eliminaro detalle ubicacion peso");
            
            
            consulta = new StringBuilder("INSERT INTO INGRESOS_DETALLEACOND(COD_INGRESO_ACOND, COD_LOTE_PRODUCCION,")
                                        .append(" COD_COMPPROD, FECHA_VEN, CANT_INGRESO_PRODUCCION, PESO_PRODUCCION,")
                                        .append(" CANT_TOTAL_INGRESO, CANT_INGRESOBUENOS, CANT_INGRESOFALLADOS, PESO_CONFIRMADO,")
                                        .append(" CANT_RESTANTE, OBSERVACION, cod_envase, cantidad_envase, ingresoCantidadPeso,")
                                        .append(" CANTIDAD_ENVASE_CONFIRMADO)")
                                .append(" VALUES (")
                                        .append(ingresosAcond.getCodIngresoAcond()).append(",")
                                        .append("?,")//cod lote produccion
                                        .append("?,")//codCompprod
                                        .append("?,")//fecha de vencimiento
                                        .append("?,")//canitdad ingresos produccion
                                        .append("?,")//peso produccion
                                        .append("?,")//cantidad total ingreso
                                        .append("?,")//cantidad total ingreso buenos
                                        .append("?,")//cantidad total ingreso fallados
                                        .append("?,")//peso confirmado
                                        .append("?,")//cantidad restante
                                        .append("?,")//observacion
                                        .append("?,")//cod Envase
                                        .append("?,")//cantidad envase
                                        .append("?,")//ingreso cantidad peso
                                        .append("?")//cantidad envase confirmado
                                .append(")");
            LOGGER.debug("consulta registrar ingresos detalle acond "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            for(IngresosDetalleAcond bean  : ingresosAcond.getIngresosDetalleAcondList()){
                LOGGER.info("-------------iniciando registro detalle");
                pst.setString(1, bean.getCodLoteProduccion());LOGGER.info("p1: "+bean.getCodLoteProduccion());
                pst.setString(2, bean.getComponentesProd().getCodCompprod());LOGGER.info("p2: "+bean.getComponentesProd().getCodCompprod());
                pst.setString(3, sdf.format(bean.getFechaVencimiento()));LOGGER.info("p3: "+sdf.format(bean.getFechaVencimiento()));
                pst.setInt(4, bean.getCantIngresoProduccion());LOGGER.info("p4: "+bean.getCantIngresoProduccion());
                pst.setDouble(5, bean.getPesoProduccion());LOGGER.info("p5: "+bean.getPesoProduccion());
                pst.setInt(6, bean.getCantTotalIngreso());LOGGER.info("p6: "+bean.getCantTotalIngreso());
                pst.setInt(7, bean.getCantIngresoBuenos());LOGGER.info("p7: "+bean.getCantIngresoBuenos());
                pst.setInt(8, bean.getCantIngresoFallados());LOGGER.info("p8: "+bean.getCantIngresoFallados());
                pst.setDouble(9, bean.getPesoConfirmado());LOGGER.info("p9: "+bean.getPesoConfirmado());
                pst.setInt(10, bean.getCantRestante());LOGGER.info("p10: "+bean.getCantRestante());
                pst.setString(11, bean.getObsIngresoDetalleAcond());LOGGER.info("p11: "+bean.getObsIngresoDetalleAcond());
                pst.setString(12, bean.getTiposEnvase().getCodTipoEnvase());LOGGER.info("p12: "+bean.getTiposEnvase().getCodTipoEnvase());
                pst.setInt(13,bean.getCantidadEnvase());LOGGER.info("p13 :"+bean.getCantidadEnvase());
                pst.setString(14, bean.getIngresoCantidadPeso());LOGGER.info("p14: "+bean.getIngresoCantidadPeso());
                pst.setInt(15, 0);
                if(pst.executeUpdate() > 0)LOGGER.info("se registro el detalle "+consulta.toString());
                for(IngresosdetalleCantidadPeso beanPeso : bean.getListadoCantidadPeso()){
                    LOGGER.debug("-----inicio registro detalle peso----");
                    pstCantidadPeso.setString(1,bean.getComponentesProd().getCodCompprod());LOGGER.info("p1 pstd: "+bean.getComponentesProd().getCodCompprod());
                    pstCantidadPeso.setString(2, bean.getCodLoteProduccion());LOGGER.info("p2 pstd: "+bean.getCodLoteProduccion());
                    pstCantidadPeso.setFloat(3,beanPeso.getCantidad());LOGGER.info("p3 pstd: "+beanPeso.getCantidad());
                    pstCantidadPeso.setDouble(4,beanPeso.getPeso());LOGGER.info("p4 pstd: "+beanPeso.getPeso());
                    if(pstCantidadPeso.executeUpdate()>0)LOGGER.info("se registro detalle peso "+consulta.toString());
                    LOGGER.debug("-----termino registro detalle peso----");
                }
                LOGGER.info("-------------termino registro detalle");
            }       
                    
            ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            consulta = new StringBuilder("exec PAA_REGISTRO_INGRESOS_ACOND_LOG ")
                            .append(ingresosAcond.getCodIngresoAcond()).append(",")
                            .append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",")
                            .append(COD_TIPO_TRANSACCION_EDITAR).append(",")
                            .append("?");
            LOGGER.debug("consulta registrar log de ingreso acond editar: "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            pst.setString(1,descripcionTransaccion);LOGGER.info("p1: "+descripcionTransaccion);
            if(pst.executeUpdate() > 0)LOGGER.info("se registraron logs");
            con.commit();
            editado = true;
        } 
        catch (SQLException ex) {
            editado = false;
            LOGGER.warn(ex.getMessage());
            this.rollbackConexion(con);
        }
        finally {
            this.cerrarConexion(con);
        }
        LOGGER.debug("------------------------termino modificar ingreso acond=------------------------------");
        return editado;
    }
    
    public List<IngresosAcond> listarPorProgramaProduccion(ProgramaProduccion programaProduccion){
        List<IngresosAcond> ingresosAcondList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ppia.COD_PROGRAMA_PROD,ia.COD_INGRESO_ACOND,ida.COD_COMPPROD,ppia.COD_LOTE_PRODUCCION,")
                                                    .append(" ida.CANT_TOTAL_INGRESO,eia.NOMBRE_ESTADO_INGRESOACOND,ia.COD_ESTADO_INGRESOACOND,")
                                                    .append(" ia.COD_INGRESO_ACOND,IA.fecha_ingresoacond,IA.FECHA_INGRESOACOND_CONFIRMADO,")
                                                    .append(" ia.NRO_INGRESOACOND,ia.COD_ALMACENACOND,aa.NOMBRE_ALMACENACOND,")
                                                    .append(" ida.CANT_INGRESO_PRODUCCION,cp.nombre_prod_semiterminado")
                                                    .append(" ,ia.OBS_INGRESOACOND,ida.COD_COMPPROD,ida.COD_LOTE_PRODUCCION,ida.FECHA_VEN")
                                                    .append(" ,ida.PESO_PRODUCCION,ida.cod_envase,ida.cantidad_envase")
                                            .append(" from PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia")
                                                    .append(" inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND")
                                                    .append(" inner join ESTADOS_INGRESOSACOND eia on eia.COD_ESTADO_INGRESOACOND = ia.COD_ESTADO_INGRESOACOND")
                                                    .append(" inner join INGRESOS_DETALLEACOND ida on ida.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND")
                                                    .append(" inner join ALMACENES_ACOND aa on aa.COD_ALMACENACOND = ia.COD_ALMACENACOND")
                                                    .append(" inner join componentes_prod cp on cp.COD_COMPPROD = ida.COD_COMPPROD")
                                            .append(" where ppia.COD_LOTE_PRODUCCION = '").append(programaProduccion.getCodLoteProduccion()).append("'")
                                                    .append(" and ppia.COD_PROGRAMA_PROD=").append(programaProduccion.getCodProgramaProduccion())
                                                    .append(" and ppia.COD_COMPPROD = ").append(programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod())
                                                    .append(" and ppia.COD_TIPO_PROGRAMA_PROD = ").append(programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd())
                                            .append(" order by ia.fecha_ingresoacond");
            LOGGER.debug("consulta cargar ingresos del lote "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next()){
                IngresosAcond ingresosAcond = new IngresosAcond();
                ingresosAcond.setCodIngresoAcond(res.getInt("COD_INGRESO_ACOND"));
                ingresosAcond.setNroIngresoAcond(res.getInt("NRO_INGRESOACOND"));
                ingresosAcond.setFechaIngresoAcond(res.getTimestamp("fecha_ingresoacond"));
                ingresosAcond.setFechaIngresoAcondConfirmado(res.getTimestamp("FECHA_INGRESOACOND_CONFIRMADO"));
                ingresosAcond.getAlmacenAcond().setCodAlmacenAcond(res.getInt("COD_ALMACENACOND"));
                ingresosAcond.getAlmacenAcond().setNombreAlmacenAcond(res.getString("NOMBRE_ALMACENACOND"));
                ingresosAcond.getEstadosIngresoAcond().setCodEstadoIngresoAcond(res.getInt("COD_ESTADO_INGRESOACOND"));
                ingresosAcond.getEstadosIngresoAcond().setNombreEstadoIngresoAcond(res.getString("NOMBRE_ESTADO_INGRESOACOND"));
                ingresosAcond.setObsIngresoAcond(res.getString("OBS_INGRESOACOND"));
                IngresosDetalleAcond detalle = new IngresosDetalleAcond();
                detalle.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                detalle.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                detalle.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                detalle.setFechaVencimiento(res.getTimestamp("FECHA_VEN"));
                detalle.setCantTotalIngreso(res.getInt("CANT_TOTAL_INGRESO"));
                detalle.setCantIngresoProduccion(res.getInt("CANT_INGRESO_PRODUCCION"));
                detalle.setPesoProduccion(res.getDouble("PESO_PRODUCCION"));
                detalle.getTiposEnvase().setCodTipoEnvase(res.getString("cod_envase"));
                detalle.setCantidadEnvase(res.getInt("cantidad_envase"));
                detalle.setIngresosAcondicionamiento(ingresosAcond);
                ingresosAcond.setIngresosDetalleAcondList(new ArrayList<>());
                ingresosAcond.getIngresosDetalleAcondList().add(detalle);
                ingresosAcondList.add(ingresosAcond);
            }
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }    
        return ingresosAcondList;
    }
    
    
}
