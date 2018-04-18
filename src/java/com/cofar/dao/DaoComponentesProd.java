/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.dao;

import com.cofar.bean.ComponentesProd;
import com.cofar.util.Util;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ
 */
public class DaoComponentesProd extends DaoBean 
{

    public DaoComponentesProd(Logger logger) {
        this.LOGGER = logger;
    }
    
    public List<ComponentesProd> listar(ComponentesProd componentesProdBuscar,int indexInicioLista, int indexFinalLista)
    {
        List<ComponentesProd> componentesProdList = new ArrayList<ComponentesProd>();
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("EXEC PAA_LISTAR_COMPONENTES_PROD ")
                                        .append(indexInicioLista).append(",")
                                        .append(indexFinalLista).append(",")
                                        .append(componentesProdBuscar.getTiposProduccion().getCodTipoProduccion()).append(",")
                                        .append(componentesProdBuscar.getEstadoCompProd().getCodEstadoCompProd()).append(",")
                                        .append("'%").append(componentesProdBuscar.getNombreProdSemiterminado()).append("%',")
                                        .append(componentesProdBuscar.getProducto().getCodProducto()).append(",")
                                        .append("'%").append(componentesProdBuscar.getNombreGenerico()).append("%',")
                                        .append(componentesProdBuscar.getAreasEmpresa().getCodAreaEmpresa()).append(",")
                                        .append(componentesProdBuscar.getForma().getCodForma()).append(",")
                                        .append(componentesProdBuscar.getColoresPresentacion().getCodColor()).append(",")
                                        .append(componentesProdBuscar.getTamaniosCapsulasProduccion().getCodTamanioCapsulaProduccion()).append(",")
                                        .append(componentesProdBuscar.getViasAdministracionProducto().getCodViaAdministracionProducto());
            LOGGER.debug("consulta cargar productos semiterminados "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            while (res.next())
            {
                ComponentesProd nuevo=new ComponentesProd();
                nuevo.setNombreComercial(res.getString("NOMBRE_COMERCIAL"));
                nuevo.setColorFila(res.getString("COD_ESTADO_VERSION"));
                nuevo.setProductoSemiterminado(res.getInt("PRODUCTO_SEMITERMINADO")>0);
                nuevo.setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getProducto().setCodProducto(res.getString("COD_PROD"));
                nuevo.getProducto().setNombreProducto(res.getString("NOMBRE_PROD"));
                nuevo.setNroUltimaVersion(res.getInt("NRO_VERSION"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.setNombreGenerico(res.getString("NOMBRE_GENERICO"));
                nuevo.setRegSanitario(res.getString("REG_SANITARIO"));
                nuevo.setVidaUtil(res.getInt("VIDA_UTIL"));
                nuevo.setFechaVencimientoRS(res.getTimestamp("FECHA_VENCIMIENTO_RS"));
                nuevo.getForma().setNombreForma(res.getString("nombre_forma"));
                nuevo.getColoresPresentacion().setNombreColor(res.getString("NOMBRE_COLORPRESPRIMARIA"));
                nuevo.getViasAdministracionProducto().setNombreViaAdministracionProducto(res.getString("NOMBRE_VIA_ADMINISTRACION_PRODUCTO"));
                nuevo.setCantidadVolumen(res.getDouble("CANTIDAD_VOLUMEN"));
                nuevo.getUnidadMedidaVolumen().setAbreviatura(res.getString("ABREVIATURA"));
                nuevo.setPesoEnvasePrimario(res.getString("PESO_ENVASE_PRIMARIO"));
                nuevo.setToleranciaVolumenfabricar(res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR"));
                nuevo.getSaboresProductos().setNombreSabor(res.getString("NOMBRE_SABOR"));
                nuevo.getTamaniosCapsulasProduccion().setNombreTamanioCapsulaProduccion(res.getString("NOMBRE_TAMANIO_CAPSULA_PRODUCCION"));
                nuevo.setConcentracionEnvasePrimario(res.getString("CONCENTRACION_ENVASE_PRIMARIO"));
                nuevo.getEstadoCompProd().setNombreEstadoCompProd(res.getString("NOMBRE_ESTADO_COMPPROD"));
                nuevo.getEstadoCompProd().setCodEstadoCompProd(res.getInt("COD_ESTADO_COMPPROD"));
                nuevo.setTamanioLoteProduccion(res.getInt("TAMANIO_LOTE_PRODUCCION"));
                nuevo.getTiposProduccion().setCodTipoProduccion(res.getInt("COD_TIPO_PRODUCCION"));
                nuevo.getTiposProduccion().setNombreTipoProduccion(res.getString("NOMBRE_TIPO_PRODUCCION"));
                nuevo.setInformacionCompleta(res.getBoolean("INFORMACION_COMPLETA"));
                componentesProdList.add(nuevo);
            }
            
        } catch (SQLException ex) {
            LOGGER.warn(ex.getMessage());
        } catch (NumberFormatException ex) {
            LOGGER.warn(ex.getMessage());
        } finally {
            this.cerrarConexion(con);
        }
        return componentesProdList;
    }
    
}
