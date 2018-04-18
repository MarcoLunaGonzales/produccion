/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.dao;
import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.EspecificacionesFisicasProducto;
import com.cofar.bean.EspecificacionesMicrobiologiaProducto;
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
public class DaoEspecificacionesMicrobiologiaProducto extends DaoBean 
{
    public DaoEspecificacionesMicrobiologiaProducto() {
        LOGGER = LogManager.getRootLogger();
    }
    public DaoEspecificacionesMicrobiologiaProducto(Logger LOGGER) {
        this.LOGGER = LOGGER;
    }
    public boolean guardarLista(List<EspecificacionesMicrobiologiaProducto> especificacionesMicrobiologiaProductoList)throws SQLException
    {
        LOGGER.debug("---------------------inicio registro especificaciones microbiologicas------------------------");
        boolean guardado = false;
        try
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder(" DELETE ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO")
                                        .append(" WHERE COD_VERSION = ").append(especificacionesMicrobiologiaProductoList.get(0).getComponenteProd().getCodVersion());
            LOGGER.debug("consulta delete especificaciones micro version  "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if (pst.executeUpdate() > 0) LOGGER.info("se eliminaron la especificaciones microbiologicas");
            
            for(EspecificacionesMicrobiologiaProducto bean: especificacionesMicrobiologiaProductoList)
            {
                consulta = new StringBuilder("INSERT INTO ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO(COD_COMPROD,")
                                            .append(" COD_ESPECIFICACION, LIMITE_INFERIOR, LIMITE_SUPERIOR, DESCRIPCION,COD_REFERENCIA_CC,ESTADO,VALOR_EXACTO,COD_VERSION)")
                                    .append(" VALUES (")
                                            .append(bean.getComponenteProd().getCodCompprod()).append(",")
                                            .append(bean.getEspecificacionMicrobiologiaCc().getCodEspecificacion()).append(",")
                                            .append(bean.getLimiteInferior()).append(",")
                                            .append(bean.getLimiteSuperior()).append(",")
                                            .append("?,")
                                            .append(bean.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().getCodReferenciaCc()).append(",")
                                            .append("1,")
                                            .append(bean.getValorExacto()).append(",")
                                            .append(bean.getComponenteProd().getCodVersion())
                                    .append(")");
                LOGGER.debug("consulta registrar especificacion micro "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                pst.setString(1,bean.getDescripcion()); LOGGER.info("p1 : "+bean.getDescripcion());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la especificacion");
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
        LOGGER.debug("---------------------final registro especificaciones microbiologicas------------------------");
        return guardado;
    }
    
    public List<EspecificacionesMicrobiologiaProducto> listarAgregarEditar(ComponentesProdVersion componentesProdVersion)
    {
        List<EspecificacionesMicrobiologiaProducto> especificacionesMicrobiologiaList = new ArrayList<>();
        try{
            con=Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ISNULL(trcc.COD_REFERENCIACC,0) as codReferencia,efcc.COD_ESPECIFICACION,efcc.COD_TIPO_RESULTADO_ANALISIS,efcc.NOMBRE_ESPECIFICACION,ISNULL(efp.DESCRIPCION,'') as descripcion,")
                                                    .append("  ISNULL(efp.LIMITE_INFERIOR,0) as limiteInferior,ISNULL(efp.VALOR_EXACTO,0) AS valorExacto,ISNULL(efp.LIMITE_SUPERIOR,0) as limiteSuperior,ISNULL(efp.ESTADO,2) as estadoRegistro")
                                                    .append("  ,ISNULL(tra.SIMBOLO,'') as SIMBOLO,ISNULL(efcc.COEFICIENTE,'') as COEFICIENTE")
                                                    .append("  ,isnull(efp.COD_ESPECIFICACION,0) as registrado")
                                            .append("  from ESPECIFICACIONES_ANALISIS_FORMAFAR eff")
                                                    .append(" inner join ESPECIFICACIONES_MICROBIOLOGIA efcc on efcc.COD_ESPECIFICACION=eff.COD_ESPECIFICACION")
                                                    .append(" left outer join ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO efp on efp.COD_ESPECIFICACION = efcc.COD_ESPECIFICACION")
                                                            .append(" and efp.COD_COMPROD = ").append(componentesProdVersion.getCodCompprod())
                                                            .append("  and efp.COD_VERSION = ").append(componentesProdVersion.getCodVersion())
                                                    .append("  left outer join TIPOS_REFERENCIACC trcc on trcc.COD_REFERENCIACC = efp.COD_REFERENCIA_CC")
                                                    .append("  left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS = efcc.COD_TIPO_RESULTADO_ANALISIS")
                                            .append("  where eff.COD_FORMAFAR = ").append(componentesProdVersion.getForma().getCodForma())
                                                    .append("  AND eff.COD_TIPO_ANALISIS=3")
                                            .append(" order by efcc.NOMBRE_ESPECIFICACION");
            LOGGER.debug("consulta agregar listas especificaciones: " + consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                EspecificacionesMicrobiologiaProducto bean= new EspecificacionesMicrobiologiaProducto();
                bean.getComponenteProd().setCodCompprod(componentesProdVersion.getCodCompprod());
                bean.getComponenteProd().setCodVersion(componentesProdVersion.getCodVersion());
                bean.setChecked(res.getInt("registrado")>0);
                bean.getEspecificacionMicrobiologiaCc().setCodEspecificacion(res.getInt("COD_ESPECIFICACION"));
                bean.getEspecificacionMicrobiologiaCc().setNombreEspecificacion(res.getString("NOMBRE_ESPECIFICACION"));
                bean.getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(res.getString("COD_TIPO_RESULTADO_ANALISIS"));
                bean.getEspecificacionMicrobiologiaCc().setCoeficiente(res.getString("COEFICIENTE"));
                bean.setLimiteInferior(res.getDouble("limiteInferior"));
                bean.setLimiteSuperior(res.getDouble("limiteSuperior"));
                bean.setDescripcion(res.getString("descripcion"));
                bean.setValorExacto(res.getDouble("valorExacto"));
                bean.getEspecificacionMicrobiologiaCc().getTiposReferenciaCc().setCodReferenciaCc(res.getInt("codReferencia"));
                bean.getEspecificacionMicrobiologiaCc().getTipoResultadoAnalisis().setSimbolo(res.getString("SIMBOLO"));
                bean.getEstado().setCodEstadoRegistro(res.getString("estadoRegistro"));
                especificacionesMicrobiologiaList.add(bean);
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
        return especificacionesMicrobiologiaList;
    }
    
}
