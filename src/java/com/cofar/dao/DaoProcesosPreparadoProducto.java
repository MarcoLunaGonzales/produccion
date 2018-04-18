/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.bean.ProcesosPreparadoProducto;
import com.cofar.bean.ProcesosPreparadoProductoConsumo;
import com.cofar.bean.ProcesosPreparadoProductoMaquinaria;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoProcesosPreparadoProducto extends DaoBean{
    
    public DaoProcesosPreparadoProducto() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoProcesosPreparadoProducto(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public List<ProcesosPreparadoProducto> listar(ProcesosPreparadoProducto procesosPreparadoProducto){
        List<ProcesosPreparadoProducto> procesosPreparadoProductoList = new ArrayList<>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select * ");
                                        consulta.append(" from VISTA_PROCESOS_PREPARADO_PRODUCTO vpp");
                                        consulta.append(" where vpp.COD_VERSION= ").append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion());
                                                consulta.append(" and vpp.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosPreparadoProducto.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                                                consulta.append(" and vpp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=?");
                                        consulta.append(" order by vpp.NRO_PASO,vpp.COD_PROCESO_PREPARADO_PRODUCTO");
            LOGGER.debug("consulta prepare statement pasos preparado "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            consulta = new StringBuilder("select  * ");
                    consulta.append(" from VISTA_PROCESOS_PREPARADO_PRODUCTO vpp");
                    consulta.append(" where vpp.COD_VERSION= ").append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion());
                        consulta.append(" and vpp.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosPreparadoProducto.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
                        consulta.append(" and vpp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE =").append(procesosPreparadoProducto.getProcesosPreparadoProductoPadre() != null ? procesosPreparadoProducto.getProcesosPreparadoProductoPadre().getCodProcesoPreparadoProducto() : 0);
                    consulta.append(" order by vpp.NRO_PASO,vpp.COD_PROCESO_PREPARADO_PRODUCTO");
            LOGGER.debug("consulta cargar pasos"+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            ProcesosPreparadoProducto nuevo=new ProcesosPreparadoProducto();
            ResultSet resDetalle;
            procesosPreparadoProductoList=new ArrayList<ProcesosPreparadoProducto>();
            while (res.next()){
                
                if(nuevo.getCodProcesoPreparadoProducto()!=res.getInt("COD_PROCESO_PREPARADO_PRODUCTO")){
                    
                    if(nuevo.getCodProcesoPreparadoProducto()>0){
                        procesosPreparadoProductoList.add(nuevo);
                    }
                    nuevo=new ProcesosPreparadoProducto();
                    nuevo.setCodProcesoPreparadoProducto(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                    nuevo.setNroPaso(res.getInt("NRO_PASO"));
                    nuevo.getActividadesPreparado().setCodActividadPreparado(res.getInt("COD_ACTIVIDAD_PREPARADO"));
                    nuevo.getActividadesPreparado().setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                    nuevo.setDescripcion(res.getString("DESCRIPCION"));
                    nuevo.setOperarioTiempoCompleto(res.getInt("OPERARIO_TIEMPO_COMPLETO")>0);
                    nuevo.setTiempoProceso(res.getDouble("TIEMPO_PROCESO"));
                    nuevo.setToleranciaTiempo(res.getDouble("TOLERANCIA_TIEMPO"));
                    nuevo.setSustanciaResultante(res.getString("SUSTANCIA_RESULTANTE"));
                    nuevo.setProcesoSecuencial(res.getInt("PROCESO_SECUENCIAL") > 0);
                    if(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO_DESTINO") > 0){
                        nuevo.setProcesosPreparadoProductoDestino(new ProcesosPreparadoProducto());
                        nuevo.getProcesosPreparadoProductoDestino().setCodProcesoPreparadoProducto(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO_DESTINO"));
                        nuevo.getProcesosPreparadoProductoDestino().setNroPaso(res.getInt("nroPasoDestino"));
                        nuevo.getProcesosPreparadoProductoDestino().getActividadesPreparado().setNombreActividadPreparado(res.getString("NOMBRE_ACTIVIDAD_PREPARADODestino"));
                    }
                    
                    nuevo.setProcesosPreparadoProductoMaquinariaList(new ArrayList<ProcesosPreparadoProductoMaquinaria>());
                    nuevo.setSubProcesosPreparadoProductoList(new ArrayList<ProcesosPreparadoProducto>());
                    pst.setInt(1,nuevo.getCodProcesoPreparadoProducto());
                    resDetalle=pst.executeQuery();
                    ProcesosPreparadoProducto subProceso=new ProcesosPreparadoProducto();
                    while(resDetalle.next())
                    {
                        if(subProceso.getCodProcesoPreparadoProducto()!=resDetalle.getInt("COD_PROCESO_PREPARADO_PRODUCTO"))
                        {
                            if(subProceso.getCodProcesoPreparadoProducto()>0)
                            {
                                nuevo.getSubProcesosPreparadoProductoList().add(subProceso);
                            }
                            subProceso=new ProcesosPreparadoProducto();
                            subProceso.setCodProcesoPreparadoProducto(resDetalle.getInt("COD_PROCESO_PREPARADO_PRODUCTO"));
                            subProceso.setNroPaso(resDetalle.getInt("NRO_PASO"));
                            subProceso.getActividadesPreparado().setCodActividadPreparado(resDetalle.getInt("COD_ACTIVIDAD_PREPARADO"));
                            subProceso.getActividadesPreparado().setNombreActividadPreparado(resDetalle.getString("NOMBRE_ACTIVIDAD_PREPARADO"));
                            subProceso.setDescripcion(resDetalle.getString("DESCRIPCION"));
                            subProceso.setOperarioTiempoCompleto(resDetalle.getInt("OPERARIO_TIEMPO_COMPLETO")>0);
                            subProceso.setTiempoProceso(resDetalle.getDouble("TIEMPO_PROCESO"));
                            subProceso.setToleranciaTiempo(resDetalle.getDouble("TOLERANCIA_TIEMPO"));
                            subProceso.setProcesosPreparadoProductoMaquinariaList(new ArrayList<ProcesosPreparadoProductoMaquinaria>());
                        }
                        ProcesosPreparadoProductoMaquinaria maquina=new ProcesosPreparadoProductoMaquinaria();
                        maquina.setCodProcesoPreparadProductoMaquinaria(resDetalle.getInt("COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA"));
                        maquina.getMaquinaria().setCodMaquina(resDetalle.getString("COD_MAQUINA"));
                        maquina.getMaquinaria().setCodigo(resDetalle.getString("NOMBRE_MAQUINA"));
                        maquina.getMaquinaria().setNombreMaquina(resDetalle.getString("CODIGO"));
                        subProceso.getProcesosPreparadoProductoMaquinariaList().add(maquina);
                    }
                    if(subProceso.getCodProcesoPreparadoProducto()>0)
                    {
                        nuevo.getSubProcesosPreparadoProductoList().add(subProceso);
                    }
                }
                ProcesosPreparadoProductoMaquinaria bean=new ProcesosPreparadoProductoMaquinaria();
                bean.setCodProcesoPreparadProductoMaquinaria(res.getInt("COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA"));
                bean.getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                bean.getMaquinaria().setCodigo(res.getString("NOMBRE_MAQUINA"));
                bean.getMaquinaria().setNombreMaquina(res.getString("CODIGO"));
                nuevo.getProcesosPreparadoProductoMaquinariaList().add(bean);
            }
            if(nuevo.getCodProcesoPreparadoProducto()>0){
                procesosPreparadoProductoList.add(nuevo);
            }
            st.close();
        } 
        catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } 
        finally {
            this.cerrarConexion(con);
        }
        return procesosPreparadoProductoList;
    }
    
    public boolean guardar(ProcesosPreparadoProducto procesosPreparadoProducto) throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("---------------------------INICIO REGISTRO NUEVO PROCESO PREPARADO-----------");
        try {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("select isnull(max(ppp.NRO_PASO),0)+1 as nroPaso");
                                    consulta.append(" from PROCESOS_PREPARADO_PRODUCTO ppp");
                                    consulta.append(" where ppp.COD_VERSION=").append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion());
                                        consulta.append(" and ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE = ").append(procesosPreparadoProducto.getProcesosPreparadoProductoPadre() != null ? procesosPreparadoProducto.getProcesosPreparadoProductoPadre().getCodProcesoPreparadoProducto() : 0);
                                        consulta.append(" and ppp.COD_PROCESO_ORDEN_MANUFACTURA=").append(procesosPreparadoProducto.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura());
            LOGGER.debug("consulta obtener nro correlativo "+consulta.toString());
            Statement st =con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            if(res.next())procesosPreparadoProducto.setNroPaso(res.getInt(1));
            consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO(COD_VERSION, COD_ACTIVIDAD_PREPARADO, NRO_PASO, DESCRIPCION, TIEMPO_PROCESO,");
                                    consulta.append("TOLERANCIA_TIEMPO, OPERARIO_TIEMPO_COMPLETO, COD_PROCESO_ORDEN_MANUFACTURA,COD_PROCESO_PREPARADO_PRODUCTO_PADRE,PROCESO_SECUENCIAL,")
                                            .append("COD_PROCESO_PREPARADO_PRODUCTO_DESTINO,SUSTANCIA_RESULTANTE)");
                                consulta.append("VALUES (");
                                    consulta.append(procesosPreparadoProducto.getComponentesProdVersion().getCodVersion()).append(",");
                                    consulta.append(procesosPreparadoProducto.getActividadesPreparado().getCodActividadPreparado()).append(",");
                                    consulta.append(procesosPreparadoProducto.getNroPaso()).append(",");
                                    consulta.append("?,");
                                    consulta.append(procesosPreparadoProducto.getTiempoProceso()).append(",");
                                    consulta.append(procesosPreparadoProducto.getToleranciaTiempo()).append(",");
                                    consulta.append(procesosPreparadoProducto.isOperarioTiempoCompleto()?1:0).append(",");
                                    consulta.append(procesosPreparadoProducto.getProcesosOrdenManufactura().getCodProcesoOrdenManufactura()).append(",");
                                    consulta.append(procesosPreparadoProducto.getProcesosPreparadoProductoPadre() != null ?  procesosPreparadoProducto.getProcesosPreparadoProductoPadre().getCodProcesoPreparadoProducto() : 0).append(",");
                                    consulta.append(procesosPreparadoProducto.isProcesoSecuencial()?1:0).append(",");
                                    consulta.append(procesosPreparadoProducto.getProcesosPreparadoProductoDestino() != null ? procesosPreparadoProducto.getProcesosPreparadoProductoDestino().getCodProcesoPreparadoProducto() : 0).append(",");
                                    consulta.append("?");
                                consulta.append(")");
            LOGGER.debug("consulta registrar proceso "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1,procesosPreparadoProducto.getDescripcion());LOGGER.info("p1 : "+procesosPreparadoProducto.getDescripcion());
            pst.setString(2,procesosPreparadoProducto.getSustanciaResultante());LOGGER.info("p1 : "+procesosPreparadoProducto.getSustanciaResultante());
            if(pst.executeUpdate()>0)LOGGER.info("se registro la actividad para producto "+procesosPreparadoProducto.getActividadesPreparado().getCodActividadPreparado());
            
            if(procesosPreparadoProducto.getProcesosPreparadoProductoMaquinariaList() != null){
                res = pst.getGeneratedKeys();
                res.next();
                consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA(COD_PROCESO_PREPARADO_PRODUCTO,COD_MAQUINA)");
                            consulta.append(" VALUES (").append(res.getInt(1)).append(",?)");
                LOGGER.debug("consulta registrar maquinaria proceso pstmaq:  "+consulta.toString());
                PreparedStatement pstMaq=con.prepareStatement(consulta.toString());
                for(ProcesosPreparadoProductoMaquinaria maquina:procesosPreparadoProducto.getProcesosPreparadoProductoMaquinariaList())
                {
                    pstMaq.setString(1,maquina.getMaquinaria().getCodMaquina());LOGGER.info("p1 pstmaq : "+maquina.getMaquinaria().getCodMaquina());
                    if(pstMaq.executeUpdate()>0)LOGGER.info("se registro la maquinaria "+maquina.getMaquinaria().getCodMaquina());
                }
            }
            con.commit();
            guardado = true;
        }
        catch (SQLException ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
            con.rollback();
        }
        catch (Exception ex) 
        {
            guardado = false;
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        LOGGER.debug("---------------------------FIN REGISTRO NUEVO PROCESO PREPARADO-----------");
        return guardado;
        
    }
    public boolean editar(ProcesosPreparadoProducto procesosPreparadoProducto) throws SQLException
    {
        boolean guardado = false;
        LOGGER.debug("---------------------------INICIO EDICION PROCESO PREPARADO-----------");
        if(procesosPreparadoProducto.getCodProcesoPreparadoProducto() > 0){
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("update PROCESOS_PREPARADO_PRODUCTO");
                                            consulta.append(" set COD_ACTIVIDAD_PREPARADO=").append(procesosPreparadoProducto.getActividadesPreparado().getCodActividadPreparado());
                                                    consulta.append(" , NRO_PASO=").append(procesosPreparadoProducto.getNroPaso());
                                                    consulta.append(" , DESCRIPCION=?");
                                                    consulta.append(" , TIEMPO_PROCESO=").append(procesosPreparadoProducto.getTiempoProceso());
                                                    consulta.append(" , TOLERANCIA_TIEMPO=").append(procesosPreparadoProducto.getToleranciaTiempo());
                                                    consulta.append(" , PROCESO_SECUENCIAL = ").append(procesosPreparadoProducto.isProcesoSecuencial() ? 1 : 0);
                                                    consulta.append(" , SUSTANCIA_RESULTANTE = ?");
                                                    consulta.append(" , OPERARIO_TIEMPO_COMPLETO= ").append(procesosPreparadoProducto.isOperarioTiempoCompleto() ?1 :0 );
                                                    consulta.append(" , COD_PROCESO_PREPARADO_PRODUCTO_DESTINO = ").append(procesosPreparadoProducto.getProcesosPreparadoProductoDestino() != null ? procesosPreparadoProducto.getProcesosPreparadoProductoDestino().getCodProcesoPreparadoProducto() : 0);
                                            consulta.append(" where COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto());
                LOGGER.debug("consulta " + consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
                pst.setString(1,procesosPreparadoProducto.getDescripcion());LOGGER.info("p1: "+procesosPreparadoProducto.getDescripcion());
                pst.setString(2,procesosPreparadoProducto.getSustanciaResultante());LOGGER.info("p2: "+procesosPreparadoProducto.getSustanciaResultante());
                if (pst.executeUpdate() > 0)LOGGER.info("Se edito el proceso de preparado");
                //en caso de ya no aplicar sustancia resultante se eliminan todos los procesos que la utilizan
                if(procesosPreparadoProducto.getSustanciaResultante().trim().length()==0){
                        consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO ")
                                            .append(" where COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto());
                        LOGGER.debug("consulta eliminar procesos que utilizan sustancia resultante "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info(" se elimino el proceso");
                }
                //<editor-fold defaultstate="collapsed" desc="registro de maquinarias procesos">

                    if(procesosPreparadoProducto.getProcesosPreparadoProductoMaquinariaList() != null){
                        consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA(COD_PROCESO_PREPARADO_PRODUCTO,COD_MAQUINA)");
                                   consulta.append(" VALUES (").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto()).append(",?)");
                        pst=con.prepareStatement(consulta.toString());
                        StringBuilder codigosMaquinaria=new StringBuilder();
                        for(ProcesosPreparadoProductoMaquinaria bean : procesosPreparadoProducto.getProcesosPreparadoProductoMaquinariaList())
                        {
                            if(!bean.isActivoAntesDeEdicion()){
                                pst.setInt(1,Integer.valueOf(bean.getMaquinaria().getCodMaquina()));
                                if(pst.executeUpdate()>0)LOGGER.info("se registro la nueva maquinaria "+bean.getMaquinaria().getCodMaquina());
                            }
                            else{
                                LOGGER.info("la maquinaria ya se encontraba registrada: "+bean.getMaquinaria().getCodMaquina());
                            }
                            codigosMaquinaria.append(codigosMaquinaria.length()>0?",":"").append(bean.getMaquinaria().getCodMaquina());
                        }

                        consulta=new StringBuilder("delete from PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA");
                                 consulta.append(" where COD_MAQUINA not in (").append(codigosMaquinaria.toString()).append(")");
                                 consulta.append(" and COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto());
                        LOGGER.debug(" consulta eliminar maquinarias no incluidas: "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las maquinarias ");

                        consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA");
                                 consulta.append(" where COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA not in (");
                                        consulta.append(" select  pppm.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA from PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA pppm");
                                 consulta.append(")");
                        LOGGER.debug(" consulta eliminar especificaciones equipos no utilizados: "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las especifcaciones de maquinarias no seleccionadas");
                    }
                //</editor-fold>
                //<editor-fold defaultstate="collapsed" desc="registro de consumo">
                    if(procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList() != null){

                        consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM")
                                .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc")
                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM ppcm on ppc.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppcm.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                .append(" where ppc.COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto());
                        LOGGER.debug("consulta eliminar consumo material "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se elimino consumo material");

                        consulta=new StringBuilder(" delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO")
                                            .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc")
                                                    .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO  ppcp on ppc.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppcp.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                            .append(" where ppc.COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto());
                        LOGGER.debug("consulta eliminar consumo proceso "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se elimino consumo proceso");

                        consulta =new StringBuilder("DELETE PROCESOS_PREPARADO_PRODUCTO_CONSUMO");
                                    consulta.append(" WHERE COD_PROCESO_PREPARADO_PRODUCTO=").append(procesosPreparadoProducto.getCodProcesoPreparadoProducto());
                        LOGGER.debug("consulta delete procesos producto consumo "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)LOGGER.info("se eliminaron especificaciones anteriores");

                        consulta=new StringBuilder(" INSERT INTO PROCESOS_PREPARADO_PRODUCTO_CONSUMO(COD_PROCESO_PREPARADO_PRODUCTO,")
                                                    .append(" MATERIAL_TRANSITORIO, ORDEN_ADICION)")
                                            .append(" VALUES (")
                                                    .append(procesosPreparadoProducto.getCodProcesoPreparadoProducto()).append(", ")
                                                    .append("?, ")//material transitorio
                                                    .append("? ")//orden adicion
                                            .append(")");
                        LOGGER.debug("consulta registrar consumo psc "+consulta.toString());
                        pst = con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);

                        consulta=new StringBuilder(" INSERT INTO PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM(COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO, COD_MATERIAL,")
                                                    .append(" COD_TIPO_MATERIAL_PRODUCCION, COD_FORMULA_MAESTRA_FRACCIONES)")
                                            .append(" VALUES (")
                                                    .append("?,")//cod proceso consumo
                                                    .append("?,")//cod material
                                                    .append("?,")// cod tipo materia produccion
                                                    .append("?")//cod formula maestra fracciones
                                            .append(")");
                        LOGGER.debug("consulta registrar consumo material pstmat "+consulta.toString());
                        PreparedStatement pstMat=con.prepareStatement(consulta.toString());

                        consulta=new StringBuilder("INSERT INTO PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO(COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO, COD_PROCESO_PREPARADO_PRODUCTO)")
                                            .append(" VALUES (")
                                                    .append("?,")//cod procesos consumo
                                                    .append("?")//cod proceso preparado
                                            .append(")");
                        LOGGER.debug("consulta registrar consumo proceso pstPro "+consulta.toString());
                        PreparedStatement pstPro=con.prepareStatement(consulta.toString());
                        int orden=0;
                        ResultSet res;

                        for(ProcesosPreparadoProductoConsumo bean : procesosPreparadoProducto.getProcesosPreparadoProductoConsumoList()){

                            orden++;
                            pst.setInt(1,bean.getMaterialTransitorio()?1:0);LOGGER.info("p1 psc : "+(bean.getMaterialTransitorio()?1:0));
                            pst.setInt(2,orden);LOGGER.info("p2 psc : "+orden);
                            if(pst.executeUpdate()>0)LOGGER.info("se registro el consumo");
                            res=pst.getGeneratedKeys();
                            res.next();

                            if(bean.getProcesosPreparadoConsumoMaterialFm()!=null)
                            {
                                pstMat.setInt(1,res.getInt(1));LOGGER.info("p1 pstmat: "+res.getInt(1));
                                pstMat.setString(2,bean.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getMateriales().getCodMaterial());LOGGER.info("p2 pstmat: "+bean.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getMateriales().getCodMaterial());
                                pstMat.setInt(3,bean.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getTiposMaterialProduccion().getCodTipoMaterialProduccion());LOGGER.info("p3 pstmat: "+bean.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getTiposMaterialProduccion().getCodTipoMaterialProduccion());
                                pstMat.setString(4,bean.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getCodFormulaMaestraFracciones());LOGGER.info("p4 pstmat: "+bean.getProcesosPreparadoConsumoMaterialFm().getFormulaMaestraDetalleMPfracciones().getCodFormulaMaestraFracciones() );
                                if(pstMat.executeUpdate()>0)LOGGER.info("se registrar el consumo material");
                            }

                            if(bean.getProcesosPreparadoProductoConsumoProceso()!=null)
                            {
                                pstPro.setInt(1,res.getInt(1));LOGGER.info("p1 pstPro: "+res.getInt(1));
                                pstPro.setInt(2,bean.getProcesosPreparadoProductoConsumoProceso().getProcesosPreparadoProducto().getCodProcesoPreparadoProducto());LOGGER.info("p2 pstPro: "+bean.getProcesosPreparadoProductoConsumoProceso().getProcesosPreparadoProducto().getCodProcesoPreparadoProducto());
                                if(pstPro.executeUpdate()>0)LOGGER.info("se registro el consumo del proceso");
                            }

                        }
                    }
                //</editor-fold>
                con.commit();
                guardado = true;
            }
            catch (SQLException ex) 
            {
                guardado = false;
                LOGGER.warn(ex);
                con.rollback();
            }
            catch (Exception ex) 
            {
                guardado = false;
                LOGGER.warn(ex);
            }
            finally 
            {
                this.cerrarConexion(con);
            }
        }
        else{
            LOGGER.info("codigo de preparado incorrecto : "+procesosPreparadoProducto.getCodProcesoPreparadoProducto());
            guardado = false;
        }
        LOGGER.debug("---------------------------FIN EDICION PROCESO PREPARADO-----------");
        return guardado;
        
    }
    public boolean eliminar(int codProcesoPreparadoProducto) throws SQLException
    {
        boolean eliminado = false;
        LOGGER.debug("---------------------------INICIO ELIMINAR PROCESO PREPARADO-----------");
        if(codProcesoPreparadoProducto > 0){
            try {
                con = Util.openConnection(con);
                con.setAutoCommit(false);
                StringBuilder consulta = new StringBuilder("DELETE PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA")
                                                    .append(" FROM PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA pppm")
                                                            .append(" inner join PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA ppem on ppem.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA = pppm.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA")
                                                            .append(" INNER JOIN  PROCESOS_PREPARADO_PRODUCTO ppp on ppp.COD_PROCESO_PREPARADO_PRODUCTO =pppm.COD_PROCESO_PREPARADO_PRODUCTO")
                                                    .append(" where ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE = ").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta eliminar especificacione maquinaria procesos hijos: "+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0) LOGGER.info("Se eliminaron las especificaciones de maquinaria hijo");

                consulta=new StringBuilder("DELETE PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA ");
                            consulta.append(" FROM PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA pppm")
                                    .append(" INNER join PROCESOS_PREPARADO_PRODUCTO ppp on ppp.COD_PROCESO_PREPARADO_PRODUCTO =pppm.COD_PROCESO_PREPARADO_PRODUCTO")
                            .append(" where ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE = ").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta delete maquinaria procesos hijos: "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las maquinarias hijos");

                consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM")
                                .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc")
                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM ppcm on ppc.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppcm.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO ppp on ppp.COD_PROCESO_PREPARADO_PRODUCTO = ppc.COD_PROCESO_PREPARADO_PRODUCTO")
                                .append(" where ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta eliminar consumo material procesos hijos"+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino consumo material procesos hijos");

                consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO")
                                .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc")
                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO ppcm on ppc.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppcm.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO ppp on ppp.COD_PROCESO_PREPARADO_PRODUCTO = ppc.COD_PROCESO_PREPARADO_PRODUCTO")
                                .append(" where ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta eliminar consumo procesos hijos "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino consumo procesos hijos");

                consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO")
                                    .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc")
                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO ppp on ppp.COD_PROCESO_PREPARADO_PRODUCTO = ppc.COD_PROCESO_PREPARADO_PRODUCTO")
                                    .append(" where ppp.COD_PROCESO_PREPARADO_PRODUCTO_PADRE=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta eliminar consumo procesos hijos"+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino consumo procesos hijos");

                consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO");
                          consulta.append(" where COD_PROCESO_PREPARADO_PRODUCTO_PADRE=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta delete procesos hijos "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se eliminaron los procesos hijos");





                consulta = new StringBuilder("DELETE PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA")
                                                    .append(" FROM PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA pppm")
                                                            .append(" inner join PROCESOS_PREPARADO_PRODUCTO_ESPECIFICACIONES_MAQUINARIA ppem on ppem.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA = pppm.COD_PROCESO_PREPARADO_PRODUCTO_MAQUINARIA")
                                                    .append(" where pppm.COD_PROCESO_PREPARADO_PRODUCTO = ").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta eliminar especificaciones maquinaria" +consulta.toString());
                pst = con.prepareStatement(consulta.toString());
                if (pst.executeUpdate() > 0) LOGGER.info("Se eliminaron las especificaciones de maquinaria");

                consulta=new StringBuilder("DELETE PROCESOS_PREPARADO_PRODUCTO_MAQUINARIA ");
                           consulta.append(" where COD_PROCESO_PREPARADO_PRODUCTO=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta delete maquinaria "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las maquinarias");

                consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM")
                                .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc")
                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_MATERIAL_FM ppcm on ppc.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppcm.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                .append(" where ppc.COD_PROCESO_PREPARADO_PRODUCTO=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta eliminar consumo material "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino consumo material");

                consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO")
                                .append(" from PROCESOS_PREPARADO_PRODUCTO_CONSUMO ppc")
                                        .append(" inner join PROCESOS_PREPARADO_PRODUCTO_CONSUMO_PROCESO ppcm on ppc.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO=ppcm.COD_PROCESO_PREPARADO_PRODUCTO_CONSUMO")
                                .append(" where ppc.COD_PROCESO_PREPARADO_PRODUCTO=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta eliminar consumo proceso "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino consumo proceso");

                consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO_CONSUMO")
                                  .append(" where COD_PROCESO_PREPARADO_PRODUCTO=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta eliminar consumo proceso "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino consumo proceso");

                consulta=new StringBuilder("delete PROCESOS_PREPARADO_PRODUCTO");
                          consulta.append(" where COD_PROCESO_PREPARADO_PRODUCTO=").append(codProcesoPreparadoProducto);
                LOGGER.debug("consulta delete proceso "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino el proceso");
                con.commit();
                eliminado = true;
            }
            catch (SQLException ex) 
            {
                eliminado = false;
                LOGGER.warn(ex.getMessage());
                con.rollback();
            }
            catch (Exception ex) 
            {
                eliminado = false;
                LOGGER.warn(ex.getMessage());
            }
            finally 
            {
                this.cerrarConexion(con);
            }
            
        }
        else{
            LOGGER.info("codigo de proceso incorrecto : "+codProcesoPreparadoProducto);
            eliminado = false;
        }
        LOGGER.debug("---------------------------FIN ELIMINAR PROCESO PREPARADO-----------");
        return eliminado;
        
    }
    
}
