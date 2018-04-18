/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.EspecificacionesFisicasProducto;
import com.cofar.bean.FormulaMaestraDetalleEP;
import com.cofar.bean.FormulaMaestraVersion;
import com.cofar.bean.PresentacionesPrimarias;
import com.cofar.util.Util;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoEspecificacionesFisicasProducto extends DaoBean 
{
    public DaoEspecificacionesFisicasProducto() {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    public DaoEspecificacionesFisicasProducto(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public boolean guardarLista(List<EspecificacionesFisicasProducto> especificacionesFisicasProductoList)throws SQLException
    {
        LOGGER.debug("---------------------inicio registro especificaciones fisicas------------------------");
        boolean guardado = false;
        try
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" delete ESPECIFICACIONES_FISICAS_PRODUCTO")
                                                .append(" where COD_VERSION=").append(especificacionesFisicasProductoList.get(0).getComponenteProd().getCodVersion());
            LOGGER.debug("consulta delete especificaciones fisicas "+consulta.toString());
            PreparedStatement pst =con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminaron las anteriores especificaciones");
            
            for(EspecificacionesFisicasProducto bean:especificacionesFisicasProductoList)
            {
                consulta = new StringBuilder( "INSERT INTO ESPECIFICACIONES_FISICAS_PRODUCTO(COD_PRODUCTO, COD_ESPECIFICACION,")
                                            .append(" LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION, COD_REFERENCIA_CC, ESTADO,")
                                            .append(" VALOR_EXACTO, COD_TIPO_ESPECIFICACION_FISICA, COD_VERSION)")
                                .append(" VALUES (")
                                        .append(bean.getComponenteProd().getCodCompprod()).append(",")
                                        .append(bean.getEspecificacionFisicaCC().getCodEspecificacion()).append(",")
                                        .append(bean.getLimiteInferior()).append(",")
                                        .append(bean.getLimiteSuperior()).append(",")
                                        .append("?,")//descripcion
                                        .append(bean.getEspecificacionFisicaCC().getTiposReferenciaCc().getCodReferenciaCc()).append(",")
                                        .append(" 1,")
                                        .append(bean.getValorExacto()).append(",")
                                        .append(bean.getTiposEspecificacionesFisicas().getCodTipoEspecificacionFisica()).append(",")
                                        .append(bean.getComponenteProd().getCodVersion())
                                .append(")");
                LOGGER.debug("consulta insertar especificacion fisica"+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                pst.setString(1,bean.getDescripcion());LOGGER.info("p1 : "+bean.getDescripcion());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la especificacion fisica producto");
                
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
        LOGGER.debug("---------------------final registro especificaciones fisicas------------------------");
        return guardado;
    }
    
    public List<EspecificacionesFisicasProducto> listarAgregarEditar(ComponentesProdVersion componentesProdVersion)
    {
        List<EspecificacionesFisicasProducto> especificacionesFisicasList = new ArrayList<>();
        try{
            con=Util.openConnection(con);
            StringBuilder consulta = new StringBuilder(" select ISNULL(trcc.COD_REFERENCIACC, 0) as codTipoReferencia,efcc.COD_ESPECIFICACION,")
                                                    .append(" ISNULL(efcc.COEFICIENTE, '') AS COEFICIENTE,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,")
                                                    .append(" ISNULL(efp.DESCRIPCION, '') as descripcion,ISNULL(efp.LIMITE_INFERIOR, 0) as limiteInferior, ISNULL(efp.LIMITE_SUPERIOR, 0) as limiteSuperior,")
                                                    .append(" ISNULL(efp.VALOR_EXACTO, 0) as valorExacto,ISNULL(efp.ESTADO, 2) as estado,isnull(tra.SIMBOLO, '') as simbolo,")
                                                    .append(" isnull(eff.COD_TIPO_ESPECIFICACION_FISICA, 0) as codTipoEspecificacion,")
                                                    .append(" isnull(tef.NOMBRE_TIPO_ESPECIFICACION_FISICA, '') as nombreTipoEspcificacion" )
                                                    .append(" ,isnull(efp.COD_ESPECIFICACION,0) as registrado")
                                                .append(" from ESPECIFICACIONES_ANALISIS_FORMAFAR eff")
                                                        .append(" inner join ESPECIFICACIONES_FISICAS_CC efcc on efcc.COD_ESPECIFICACION =eff.COD_ESPECIFICACION")
                                                        .append(" left outer join ESPECIFICACIONES_FISICAS_PRODUCTO efp on efp.COD_ESPECIFICACION = efcc.COD_ESPECIFICACION")
                                                                .append(" and efp.COD_PRODUCTO = ").append(componentesProdVersion.getCodCompprod())
                                                                .append(" and efp.COD_VERSION = ").append(componentesProdVersion.getCodVersion())
                                                        .append(" left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC = efp.COD_REFERENCIA_CC")
                                                        .append(" left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS = efcc.COD_TIPO_RESULTADO_ANALISIS")
                                                        .append(" left outer join TIPOS_ESPECIFICACIONES_FISICAS tef on tef.COD_TIPO_ESPECIFICACION_FISICA = eff.COD_TIPO_ESPECIFICACION_FISICA")
                                                .append(" where eff.COD_FORMAFAR = ").append(componentesProdVersion.getForma().getCodForma())
                                                        .append(" AND eff.COD_TIPO_ANALISIS = 1")
                                                .append(" order by efcc.NOMBRE_ESPECIFICACION");
            LOGGER.debug("consulta agregar listas especificaciones " + consulta.toString());
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                EspecificacionesFisicasProducto bean= new EspecificacionesFisicasProducto();
                bean.getComponenteProd().setCodCompprod(componentesProdVersion.getCodCompprod());
                bean.getComponenteProd().setCodVersion(componentesProdVersion.getCodVersion());
                bean.setChecked(res.getInt("registrado")>0);
                bean.setValorExacto(res.getDouble("valorExacto"));
                bean.setDescripcion(res.getString("descripcion"));
                bean.setLimiteInferior(res.getDouble("limiteInferior"));
                bean.setLimiteSuperior(res.getDouble("limiteSuperior"));
                bean.getEspecificacionFisicaCC().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.getEspecificacionFisicaCC().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getEspecificacionFisicaCC().setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.getEspecificacionFisicaCC().getTiposReferenciaCc().setCodReferenciaCc(res.getInt("codTipoReferencia"));
                bean.getEspecificacionFisicaCC().setCoeficiente(res.getString("COEFICIENTE"));
                bean.getEspecificacionFisicaCC().getTipoResultadoAnalisis().setSimbolo(res.getString("simbolo"));
                bean.getEstado().setCodEstadoRegistro(res.getString("estado"));
                bean.getTiposEspecificacionesFisicas().setCodTipoEspecificacionFisica(res.getInt("codTipoEspecificacion"));
                bean.getTiposEspecificacionesFisicas().setNombreTipoEspecificacionFisica(res.getString("nombreTipoEspcificacion"));
                especificacionesFisicasList.add(bean);
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
        return especificacionesFisicasList;
    }
    
}
