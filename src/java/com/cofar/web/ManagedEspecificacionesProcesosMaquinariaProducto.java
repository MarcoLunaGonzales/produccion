/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.ComponentesProdVersion;
import com.cofar.bean.EspecificacionesProcesosProductoMaquinaria;
import com.cofar.bean.Maquinaria;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class ManagedEspecificacionesProcesosMaquinariaProducto extends ManagedBean
{
    private Connection con=null;
    private String mensaje="";
    private List<Maquinaria> maquinariasEspecificacionesList;
    private ComponentesProdVersion componentesProdVersion;
    
    public ManagedEspecificacionesProcesosMaquinariaProducto() 
    {
        LOGGER=LogManager.getLogger("Versionamiento");
    }
    
    public String getCargarEspecificacionesProcesosMaquinariaProducto()
    {
        componentesProdVersion=((ManagedComponentesProdVersion)Util.getSessionBean("ManagedComponentesProdVersion")).getComponentesProdVersionBean();
        this.cargarEspecificacionesProcesosMaquinariaProducto();
        return null;
    }
    
    private void cargarEspecificacionesProcesosMaquinariaProducto()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.CODIGO,m.COD_MAQUINA,m.NOMBRE_MAQUINA,especificacion.NOMBRE_ESPECIFICACIONES_PROCESO,");
                                        consulta.append(" especificacion.NOMBRE_UNIDAD_MEDIDA,especificacion.COD_ESPECIFICACION_PROCESO,especificacion.RESULTADO_NUMERICO,");
                                        consulta.append(" especificacion.PORCIENTO_TOLERANCIA, especificacion.valorTexto,especificacion.VALOR_EXACTO");
                                    consulta.append(" from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml");
                                        consulta.append(" inner join MAQUINARIAS m on cpml.COD_MAQUINA = m.COD_MAQUINA");
                                        consulta.append(" outer apply(select ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(um.NOMBRE_UNIDAD_MEDIDA, '') as NOMBRE_UNIDAD_MEDIDA,");
                                        consulta.append(" ep.COD_ESPECIFICACION_PROCESO,ep.RESULTADO_NUMERICO,ep.PORCIENTO_TOLERANCIA,");
                                        consulta.append(" isnull(egp.VALOR_TEXTO, '') as valorTexto,egp.VALOR_EXACTO");
                                        consulta.append(" from ESPECIFICACIONES_GRANULADO_PROD egp inner join ESPECIFICACIONES_PROCESOS ep on");
                                        consulta.append(" egp.COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO");
                                        consulta.append(" left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =ep.COD_UNIDAD_MEDIDA");
                                    consulta.append(" where  egp.COD_COMPPROD = cpml.COD_COMPPROD and");
                                    consulta.append(" egp.COD_MAQUINA = cpml.COD_MAQUINA) especificacion");
                                    consulta.append(" where m.COD_SECCION_ORDEN_MANUFACTURA = 6 and  cpml.COD_COMPPROD = '\"+componentesProdBean.getCodCompprod()+\"' order by m.NOMBRE_MAQUINA\";");
            LOGGER.debug("consulta carga especificaciones "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            maquinariasEspecificacionesList.clear();
            Maquinaria nuevo=new Maquinaria();
            List<EspecificacionesProcesosProductoMaquinaria> especificacionesProcesosProductoMaquinariaList=new ArrayList<EspecificacionesProcesosProductoMaquinaria>();
            while(res.next())
            {
                if(!nuevo.getCodMaquina().equals(res.getString("COD_MAQUINA")))
                {
                    if(nuevo.getCodMaquina().length()>0)
                    {
                        nuevo.setEspecificacionesProcesosProductoMaquinariaList(especificacionesProcesosProductoMaquinariaList);
                        maquinariasEspecificacionesList.add(nuevo);
                    }
                    especificacionesProcesosProductoMaquinariaList=new ArrayList<EspecificacionesProcesosProductoMaquinaria>();
                    nuevo=new Maquinaria();
                    nuevo.setCodigo(res.getString("CODIGO"));
                    nuevo.setCodMaquina(res.getString("COD_MAQUINA"));
                    nuevo.setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                }
                EspecificacionesProcesosProductoMaquinaria esp=new EspecificacionesProcesosProductoMaquinaria();
                esp.getEspecificacionesProcesos().setCodEspecificacionProceso(res.getInt("COD_ESPECIFICACION_PROCESO"));
                esp.getEspecificacionesProcesos().setNombreEspecificacionProceso(res.getString("NOMBRE_ESPECIFICACIONES_PROCESO"));
                esp.getEspecificacionesProcesos().getUnidadMedida().setNombreUnidadMedida(res.getString("NOMBRE_UNIDAD_MEDIDA"));
                esp.getEspecificacionesProcesos().setResultadoNumerico(res.getInt("RESULTADO_NUMERICO")>0);
                esp.setValorExacto(res.getDouble("VALOR_EXACTO"));
                esp.setValorTexto(res.getString("valorTexto"));
                esp.getEspecificacionesProcesos().setPorcientoTolerancia(res.getDouble("PORCIENTO_TOLERANCIA")*100);
                especificacionesProcesosProductoMaquinariaList.add(esp);
            }
            if(!nuevo.getCodMaquina().equals(""))
            {
                nuevo.setEspecificacionesProcesosProductoMaquinariaList(especificacionesProcesosProductoMaquinariaList);
                maquinariasEspecificacionesList.add(nuevo);
            }
            st.close();
            con.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<Maquinaria> getMaquinariasEspecificacionesList() {
        return maquinariasEspecificacionesList;
    }

    public void setMaquinariasEspecificacionesList(List<Maquinaria> maquinariasEspecificacionesList) {
        this.maquinariasEspecificacionesList = maquinariasEspecificacionesList;
    }

    public ComponentesProdVersion getComponentesProdVersion() {
        return componentesProdVersion;
    }

    public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
        this.componentesProdVersion = componentesProdVersion;
    }
    
    
}
