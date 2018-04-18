/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.EspecificacionesFisicasProducto;
import com.cofar.bean.EspecificacionesQuimicasCc;
import com.cofar.bean.EspecificacionesQuimicasProducto;
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
public class DaoEspecificacionesQuimicasProducto extends DaoBean 
{
    public DaoEspecificacionesQuimicasProducto() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    public DaoEspecificacionesQuimicasProducto(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public boolean guardarLista(List<EspecificacionesQuimicasProducto> especificacionesQuimicasProductoList)throws SQLException
    {
        LOGGER.debug("---------------------inicio registro especificaciones quimicas------------------------");
        boolean guardado = false;
        try
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("delete from ESPECIFICACIONES_QUIMICAS_PRODUCTO")
                                                .append(" where COD_VERSION = ").append(especificacionesQuimicasProductoList.get(0).getComponenteProd().getCodVersion());
            LOGGER.debug("consulta eliminar especificaciones quimicas producto :"+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron esp quimicas de la version");
            for(EspecificacionesQuimicasProducto bean : especificacionesQuimicasProductoList)
            {
                consulta = new StringBuilder("INSERT INTO ESPECIFICACIONES_QUIMICAS_PRODUCTO(COD_ESPECIFICACION, COD_PRODUCTO,")
                                                .append("COD_MATERIAL, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, ESTADO,")
                                                .append(" COD_REFERENCIA_CC,VALOR_EXACTO,COD_MATERIAL_COMPUESTO_CC,COD_VERSION)")
                                        .append(" VALUES (")
                                                .append(bean.getEspecificacionQuimica().getCodEspecificacion()).append(",")
                                                .append(bean.getComponenteProd().getCodCompprod()).append(",")
                                                .append(bean.getMaterial().getCodMaterial()).append(",")
                                                .append(bean.getLimiteInferior()).append(",")
                                                .append(bean.getLimiteSuperior()).append(",")
                                                .append("?,")//descripcion
                                                .append("1,")//estado
                                                .append(bean.getTiposReferenciaCc().getCodReferenciaCc()).append(",")
                                                .append(bean.getValorExacto()).append(",")
                                                .append(bean.getMaterialesCompuestosCc().getCodMaterialCompuestoCc()).append(",")
                                                .append(bean.getComponenteProd().getCodVersion())
                                        .append(")");
                            LOGGER.debug("consulta registrar especificacion quimica:  "+consulta.toString());
                            pst=con.prepareStatement(consulta.toString());
                            pst.setString(1,bean.getDescripcion());LOGGER.info(" p1: "+bean.getDescripcion());
                            if(pst.executeUpdate()>0)LOGGER.info("se registro el detalle");
            }
            con.commit();
            guardado = true;
        } catch (SQLException ex) {
            guardado = false;
            con.rollback();
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) {
            guardado = false;
            LOGGER.warn("error", ex);
        }
        finally{
            this.cerrarConexion(con);
        }
        LOGGER.debug("---------------------final registro especificaciones quimicas------------------------");
        return guardado;
    }
    
    public List<EspecificacionesQuimicasCc> listarPorEspecificacionQuimicaCC(ComponentesProdVersion componentesProdVersion)
    {
        List<EspecificacionesQuimicasCc> especificacionesQuimicasList = new ArrayList<>();
        try{
            con=Util.openConnection(con);
            StringBuilder consulta = new StringBuilder(" select isnull(m.NOMBRE_CCC,'Nombre genérico no registrado, comunicar a sistemas') as NOMBRE_CCC,m.COD_MATERIAL,ISNULL(eqp.ESTADO, 1) as estado")
                                                .append(" from MATERIALES m")
                                                        .append(" inner join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL=m.COD_MATERIAL")
                                                .append(" where eqp.COD_VERSION = ").append(componentesProdVersion.getCodVersion())
                                                        .append(" and eqp.COD_PRODUCTO=").append(componentesProdVersion.getCodCompprod())
                                                .append(" group by m.NOMBRE_CCC,m.COD_MATERIAL,eqp.ESTADO order by m.NOMBRE_CCC");
            LOGGER.debug("consulta materiales principio activo "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            String codMaterialesPrincipioActivo="";
            while(res.next())
            {
               codMaterialesPrincipioActivo+=(codMaterialesPrincipioActivo.equals("")?"":",")+res.getString("COD_MATERIAL");
            }
            String codMaterialCompuestoCC="";
            if(!codMaterialesPrincipioActivo.equals(""))
            {
                consulta = new StringBuilder("select DISTINCT m.COD_MATERIAL_COMPUESTO_CC from MATERIALES_COMPUESTOS_CC m")
                                    .append(" where m.COD_MATERIAL_1 in (").append(codMaterialesPrincipioActivo).append(")")
                                            .append(" and m.COD_MATERIAL_2 in (").append(codMaterialesPrincipioActivo).append(")")
                                            .append(" and m.COD_MATERIAL_1 <> m.COD_MATERIAL_2");
                LOGGER.debug("consulta buscar materiales compuestos "+consulta);
                res=st.executeQuery(consulta.toString());
                while(res.next())
                {
                    codMaterialCompuestoCC+=(codMaterialCompuestoCC.equals("")?"":",")+res.getString("COD_MATERIAL_COMPUESTO_CC");
                }
            }
            consulta = new StringBuilder(" select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,tra.NOMBRE_TIPO_RESULTADO_ANALISIS ,")
                                        .append(" ISNULL(eqcc.COEFICIENTE,'') as coeficiente,ISNULL(tra.SIMBOLO,'') as simbolo" )
                                .append(" from ESPECIFICACIONES_QUIMICAS_CC eqcc")
                                        .append(" inner join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=eqcc.COD_TIPO_RESULTADO_ANALISIS")
                                        .append(" inner join ESPECIFICACIONES_ANALISIS_FORMAFAR eqf on eqcc.COD_ESPECIFICACION=eqf.COD_ESPECIFICACION")
                                .append(" where eqf.COD_FORMAFAR = ").append(componentesProdVersion.getForma().getCodForma())
                                        .append(" and eqf.COD_TIPO_ANALISIS=2")
                                .append(" group by  eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,tra.NOMBRE_TIPO_RESULTADO_ANALISIS," )
                                        .append(" eqcc.COEFICIENTE,tra.SIMBOLO")
                                .append(" order by eqcc.NOMBRE_ESPECIFICACION");
            LOGGER.debug("consulta agregar listas especificaciones " + consulta.toString());
            res = st.executeQuery(consulta.toString());
            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle=null;
            while(res.next())
            {
                EspecificacionesQuimicasCc bean= new EspecificacionesQuimicasCc();
                bean.setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.setCoeficiente(res.getString("coeficiente"));
                bean.getTipoResultadoAnalisis().setSimbolo(res.getString("simbolo"));
                bean.getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getTipoResultadoAnalisis().setNombreTipoResultadoAnalisis(res.getString("NOMBRE_TIPO_RESULTADO_ANALISIS"));
                consulta = new StringBuilder("select eqp.COD_REFERENCIA_CC,eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,")
                                            .append(" eqp.LIMITE_SUPERIOR,eqp.ESTADO,eqp.VALOR_EXACTO,isnull(eqp.COD_ESPECIFICACION,0) as registrado")
                                    .append(" from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp ")
                                    .append(" where eqp.COD_ESPECIFICACION = ").append(res.getInt("COD_ESPECIFICACION"))
                                           .append(" and eqp.COD_PRODUCTO = ").append(componentesProdVersion.getCodCompprod())
                                           .append(" and eqp.COD_MATERIAL=-1")
                                           .append(" and eqp.COD_VERSION = ").append(componentesProdVersion.getCodVersion());
                LOGGER.debug("consulta cargar especificacion sin material "+consulta.toString());
                resDetalle=stDetalle.executeQuery(consulta.toString());
                EspecificacionesQuimicasProducto especificacionMaterial= new EspecificacionesQuimicasProducto();
                especificacionMaterial.getMaterial().setNombreCCC("SIN MATERIALES");
                especificacionMaterial.getMaterial().setCodMaterial("-1");
                especificacionMaterial.getEstado().setCodEstadoRegistro("2");
                especificacionMaterial.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(0);
                especificacionMaterial.getComponenteProd().setCodCompprod(componentesProdVersion.getCodCompprod());
                especificacionMaterial.getComponenteProd().setCodVersion(componentesProdVersion.getCodVersion());
                especificacionMaterial.getEspecificacionQuimica().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                if(resDetalle.next())
                {
                    especificacionMaterial.setLimiteInferior(resDetalle.getDouble("LIMITE_INFERIOR"));
                    especificacionMaterial.setChecked(resDetalle.getInt("registrado")>0);
                    especificacionMaterial.setLimiteSuperior(resDetalle.getDouble("LIMITE_SUPERIOR"));
                    especificacionMaterial.setDescripcion(resDetalle.getString("DESCRIPCION"));
                    especificacionMaterial.getEspecificacionQuimica().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                    especificacionMaterial.getEstado().setCodEstadoRegistro(resDetalle.getString("ESTADO"));
                    especificacionMaterial.getTiposReferenciaCc().setCodReferenciaCc(resDetalle.getInt("COD_REFERENCIA_CC"));
                    especificacionMaterial.setValorExacto(resDetalle.getDouble("VALOR_EXACTO"));

                }
                bean.getListaEspecificacionesQuimicasProducto().add(especificacionMaterial);
                consulta = new StringBuilder("select ISNULL(eqp.COD_REFERENCIA_CC,1) AS CODREFER, m.NOMBRE_CCC,m.COD_MATERIAL,m.NOMBRE_MATERIAL,ISNULL(eqp.DESCRIPCION,'') as descripciom,")
                                            .append(" ISNULL(eqp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(eqp.LIMITE_SUPERIOR,0) as limiteSuperior,")
                                            .append(" ISNULL(eqp.ESTADO,2) as estado,ISNULL(eqp.VALOR_EXACTO,0) as valorExacto" )
                                            .append(" ,isnull(eqp.COD_ESPECIFICACION,0) as registrado")
                                    .append(" from  MATERIALES m")
                                            .append(" inner join COMPONENTES_PROD_CONCENTRACION cpc on cpc.COD_MATERIAL=m.COD_MATERIAL")
                                            .append(" left outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL=m.COD_MATERIAL")
                                                    .append(" and  eqp.COD_ESPECIFICACION = ").append(res.getInt("COD_ESPECIFICACION"))
                                                    .append(" and eqp.COD_MATERIAL_COMPUESTO_CC = 0 ")
                                                    .append(" and eqp.COD_VERSION = ").append(componentesProdVersion.getCodVersion())
                                                    .append(" and eqp.COD_PRODUCTO = ").append(componentesProdVersion.getCodCompprod())
                                    .append(" where cpc.COD_VERSION=").append(componentesProdVersion.getCodVersion())
                                    .append(" group by eqp.COD_REFERENCIA_CC,m.NOMBRE_CCC,m.COD_MATERIAL,m.NOMBRE_MATERIAL,")
                                            .append(" eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.COD_ESPECIFICACION,")
                                            .append(" eqp.ESTADO,eqp.VALOR_EXACTO order by m.NOMBRE_CCC");
                LOGGER.debug("consulta detalle especificacion con materiales "+consulta.toString());
                resDetalle=stDetalle.executeQuery(consulta.toString());
                while(resDetalle.next()){
                    EspecificacionesQuimicasProducto nuevo= new EspecificacionesQuimicasProducto();
                    nuevo.getComponenteProd().setCodCompprod(componentesProdVersion.getCodCompprod());
                    nuevo.getComponenteProd().setCodVersion(componentesProdVersion.getCodVersion());
                    nuevo.getEspecificacionQuimica().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                    nuevo.setChecked(resDetalle.getInt("registrado")>0);
                    nuevo.setLimiteInferior(resDetalle.getDouble("limiteInferior"));
                    nuevo.setLimiteSuperior(resDetalle.getDouble("limiteSuperior"));
                    nuevo.setDescripcion(resDetalle.getString("descripciom"));
                    nuevo.getEspecificacionQuimica().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                    nuevo.getMaterial().setCodMaterial(resDetalle.getString("COD_MATERIAL"));
                    nuevo.getMaterial().setNombreCCC(resDetalle.getString("NOMBRE_CCC"));
                    nuevo.getMaterial().setNombreMaterial(resDetalle.getString("NOMBRE_MATERIAL"));
                    nuevo.getEstado().setCodEstadoRegistro(resDetalle.getString("estado"));
                    nuevo.getTiposReferenciaCc().setCodReferenciaCc(resDetalle.getInt("CODREFER"));
                    nuevo.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(0);
                    nuevo.setValorExacto(resDetalle.getDouble("valorExacto"));
                    bean.getListaEspecificacionesQuimicasProducto().add(nuevo);
                }
                if(!codMaterialCompuestoCC.equals("")){

                     consulta = new StringBuilder(" select ISNULL(eqp.COD_REFERENCIA_CC, 1) AS CODREFER,mccc.NOMBRE_MATERIAL_COMPUESTO_CC,")
                                                    .append(" mccc.COD_MATERIAL_COMPUESTO_CC, ISNULL(eqp.DESCRIPCION, '') as descripciom,ISNULL(eqp.LIMITE_INFERIOR, 0) as limiteInferior,")
                                                    .append(" ISNULL(eqp.LIMITE_SUPERIOR, 0) as limiteSuperior, ISNULL(eqp.ESTADO, 2) as estado,ISNULL(eqp.VALOR_EXACTO, 0) as valorExacto")
                                            .append(" from MATERIALES_COMPUESTOS_CC mccc")
                                                    .append(" left outer join ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp on eqp.COD_MATERIAL_COMPUESTO_CC=mccc.COD_MATERIAL_COMPUESTO_CC")
                                                            .append(" and eqp.COD_PRODUCTO = ").append(componentesProdVersion.getCodCompprod())
                                                            .append(" and eqp.COD_ESPECIFICACION = ").append(res.getInt("COD_ESPECIFICACION"))
                                                            .append(" and eqp.COD_VERSION = ").append(componentesProdVersion.getCodVersion())
                                                            .append(" and eqp.COD_MATERIAL=0")
                                            .append(" and mccc.COD_MATERIAL_COMPUESTO_CC in (").append(codMaterialCompuestoCC).append(")");
                     LOGGER.debug("consulta cargar especificaciones material compuesto cc "+consulta.toString());
                     resDetalle=stDetalle.executeQuery(consulta.toString());
                     while(resDetalle.next())
                     {
                         EspecificacionesQuimicasProducto nuevo= new EspecificacionesQuimicasProducto();
                         nuevo.getComponenteProd().setCodCompprod(componentesProdVersion.getCodCompprod());
                         nuevo.getComponenteProd().setCodVersion(componentesProdVersion.getCodVersion());
                         nuevo.getEspecificacionQuimica().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                         nuevo.setLimiteInferior(resDetalle.getDouble("limiteInferior"));
                         nuevo.setLimiteSuperior(resDetalle.getDouble("limiteSuperior"));
                         nuevo.setDescripcion(resDetalle.getString("descripciom"));
                         nuevo.getEspecificacionQuimica().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                         nuevo.getMaterial().setCodMaterial("0");
                         nuevo.getMaterialesCompuestosCc().setCodMaterialCompuestoCc(resDetalle.getInt("COD_MATERIAL_COMPUESTO_CC"));
                         nuevo.getMaterialesCompuestosCc().setNombreMaterialCompuestoCc(resDetalle.getString("NOMBRE_MATERIAL_COMPUESTO_CC"));
                         nuevo.getEstado().setCodEstadoRegistro(resDetalle.getString("estado"));
                         nuevo.getTiposReferenciaCc().setCodReferenciaCc(resDetalle.getInt("CODREFER"));
                         nuevo.setValorExacto(resDetalle.getDouble("valorExacto"));
                         bean.getListaEspecificacionesQuimicasProducto() .add(nuevo);
                     }
                 }
                especificacionesQuimicasList.add(bean);
            }
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return especificacionesQuimicasList;
    }
    
}
