/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ProductosDivisionLotes;
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

/**
 *
 * @author aquispe
 */

public class ManagedProductosDivisionLotes extends ManagedBean{
    private ProductosDivisionLotes productosDivisionLotesEditar= new ProductosDivisionLotes();
    private ProductosDivisionLotes productosDivisionLotesNuevo= new ProductosDivisionLotes();
    private List<ProductosDivisionLotes> productosDivisionLotesList= new ArrayList<ProductosDivisionLotes>();
    private Connection con=null;
    private List<SelectItem> componentesProdList= new ArrayList<SelectItem>();
    private List<SelectItem> tiposProgramaProduccionList= new ArrayList<SelectItem>();
    /** Creates a new instance of ManagedProductosDivisionLotes */
    public ManagedProductosDivisionLotes() {
        this.LOGGER = LogManager.getRootLogger();
    }
    private void cargarTiposProgramaProd()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta=" select tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION tpp";
            ResultSet res=st.executeQuery(consulta);
            tiposProgramaProduccionList.clear();
            while(res.next())
            {
                tiposProgramaProduccionList.add(new SelectItem(res.getString("COD_TIPO_PROGRAMA_PROD"),res.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
     private void cargarProductosActivosEditar(String codComprod,String codTipoProgProd,String codComprodAsociado)
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado "+
                            " from COMPONENTES_PROD cp where "+
                            " cp.COD_COMPPROD not in ('"+codComprod+"',(select pdl.COD_COMPPROD_DIVISION from PRODUCTOS_DIVISION_LOTES pdl "+
                            " where pdl.COD_COMPPROD='"+codComprod+"' and pdl.COD_TIPO_PROGRAMA_PRODUCCION='"+codTipoProgProd+"'" +
                            " and pdl.COD_COMPPROD_DIVISION not in ('"+codComprodAsociado+"') ))" +
                            " order by cp.nombre_prod_semiterminado";
            System.out.println("consulta cargar productos editar"+consulta);
            ResultSet res=st.executeQuery(consulta);
            componentesProdList.clear();
            while(res.next())
            {
                componentesProdList.add(new SelectItem(res.getString("COD_COMPPROD"),res.getString("nombre_prod_semiterminado")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarProductosActivosNuevo()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder("select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,cp.TAMANIO_LOTE_PRODUCCION")
                                                .append(" from COMPONENTES_PROD cp")
                                                            .append(" inner join TIPOS_PRODUCCION tp on tp.COD_TIPO_PRODUCCION = cp.COD_TIPO_PRODUCCION")
                                                .append(" where cp.COD_ESTADO_COMPPROD = 1")
                                                            .append(" and tp.DISPONIBLE_LOTE_PRODUCCION =1")
                                                .append(" order by cp.nombre_prod_semiterminado");
            LOGGER.debug("consulta cargar productos disponibles divisio : "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            componentesProdList.clear();
            while(res.next())
            {
                componentesProdList.add(new SelectItem(res.getString("COD_COMPPROD"),res.getString("nombre_prod_semiterminado")+" | "+res.getInt("TAMANIO_LOTE_PRODUCCION")+" u"));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            LOGGER.warn("error", ex);
        }
    }
    public String nuevoRegistroAction()
    {
        productosDivisionLotesNuevo= new ProductosDivisionLotes();
        return null;
    }
    public String guardarProductoDivisionLoteAction()
    {
        transaccionExitosa = false;
        try
        {
            con=Util.openConnection(con);
            StringBuilder consulta = new StringBuilder(" INSERT INTO PRODUCTOS_DIVISION_LOTES(COD_COMPPROD, COD_COMPPROD_DIVISION,")
                                                        .append(" COD_TIPO_PROGRAMA_PRODUCCION)")
                                                .append(" VALUES (")
                                                        .append(productosDivisionLotesNuevo.getComponentesProd().getCodCompprod()).append(",")
                                                        .append(productosDivisionLotesNuevo.getComponentesProdAsociado().getCodCompprod()).append(",")
                                                        .append(productosDivisionLotesNuevo.getTiposProgramaProduccion().getCodTipoProgramaProd())
                                                .append(")");
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se registro el producto divisible");
            con.close();
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente la configuracion para división de lotes");
        }
        catch(SQLException ex){
            LOGGER.warn("error", ex);
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar la división de lotes");
        }
        if(transaccionExitosa){
            this.cargarProductosDivisionLotes();
        }
        return null;
    }
    private void cargarProductosDivisionLotes()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder(" select pdl.COD_COMPPROD,pdl.COD_COMPPROD_DIVISION,pdl.COD_TIPO_PROGRAMA_PRODUCCION,")
                                                        .append(" cp.nombre_prod_semiterminado as nombreProducto,cp.TAMANIO_LOTE_PRODUCCION as tamanioLoteProduccion,")
                                                        .append(" cp1.nombre_prod_semiterminado as nombreProductoAsociado,cp1.TAMANIO_LOTE_PRODUCCION as tamanioLoteProduccionAsociado,")
                                                        .append(" tpp.NOMBRE_TIPO_PROGRAMA_PROD, datosLote.cantidadLotes,pdl.COD_PRODUCTO_DIVISION_LOTE")
                                                .append(" from PRODUCTOS_DIVISION_LOTES pdl")
                                                        .append(" inner join COMPONENTES_PROD cp on pdl.COD_COMPPROD = cp.COD_COMPPROD")
                                                        .append(" inner join COMPONENTES_PROD cp1 on pdl.COD_COMPPROD_DIVISION =cp1.COD_COMPPROD")
                                                        .append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD = pdl.COD_TIPO_PROGRAMA_PRODUCCION")
                                                        .append(" left join(")
                                                                .append(" SELECT count(distinct pp.COD_LOTE_PRODUCCION) as cantidadLotes,pp.COD_COMPPROD,pp1.COD_TIPO_PROGRAMA_PROD")
                                                                .append(" ,pp1.COD_COMPPROD as codCompProdAlternativo")
                                                                .append(" from PROGRAMA_PRODUCCION pp")
                                                                        .append(" inner join programa_produccion_periodo ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD")
                                                                        .append(" inner join PROGRAMA_PRODUCCION pp1 on pp.COD_PROGRAMA_PROD=pp1.COD_PROGRAMA_PROD")
                                                                                .append(" and pp.COD_LOTE_PRODUCCION =pp1.COD_LOTE_PRODUCCION")
                                                                                .append(" and pp.COD_COMPPROD<>pp1.COD_COMPPROD")
                                                                .append(" where pp.COD_PROGRAMA_PROD>0")
                                                                        .append(" and pp.COD_COMPPROD= pp.COD_COMPPROD_PADRE")
                                                                        .append(" and len(pp.COD_LOTE_PRODUCCION)>5")
                                                                        .append(" and ppp.COD_TIPO_PRODUCCION=1")
                                                                        .append(" and ppp.COD_ESTADO_PROGRAMA<>4")                                                                .append(" group by pp.COD_COMPPROD,pp1.COD_TIPO_PROGRAMA_PROD,pp1.COD_COMPPROD")
                                                        .append(" )as datosLote on pdl.COD_COMPPROD = datosLote.COD_COMPPROD")
                                                                    .append(" and pdl.COD_TIPO_PROGRAMA_PRODUCCION = datosLote.COD_TIPO_PROGRAMA_PROD")
                                                                    .append(" and pdl.COD_COMPPROD_DIVISION = datosLote.codCompProdAlternativo")
                                                .append(" order by cp.nombre_prod_semiterminado");
            LOGGER.debug("consulta cargar lista productos division: "+consulta.toString());
            ResultSet res=st.executeQuery(consulta.toString());
            productosDivisionLotesList.clear();
            while(res.next())
            {
                ProductosDivisionLotes nuevo=new ProductosDivisionLotes();
                nuevo.setCodProductoDivisionLote(res.getInt("COD_PRODUCTO_DIVISION_LOTE"));
                nuevo.setCantidadLotesCreados(res.getInt("cantidadLotes"));
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombreProducto"));
                nuevo.getComponentesProdAsociado().setCodCompprod(res.getString("COD_COMPPROD_DIVISION"));
                nuevo.getComponentesProdAsociado().setNombreProdSemiterminado(res.getString("nombreProductoAsociado"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PRODUCCION"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.getComponentesProd().setTamanioLoteProduccion(res.getInt("tamanioLoteProduccion"));
                nuevo.getComponentesProdAsociado().setTamanioLoteProduccion(res.getInt("tamanioLoteProduccionAsociado"));
                productosDivisionLotesList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }

    public String eliminarProductoDivisibleAction(int codProductoDivisionLote)
    {
        transaccionExitosa = false;
        try{
            con=Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("DELETE PRODUCTOS_DIVISION_LOTES")
                                                .append(" WHERE COD_PRODUCTO_DIVISION_LOTE = ").append(codProductoDivisionLote);
            LOGGER.debug("consulta eliminar productos division lote "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)LOGGER.info("se eliminar la configuracion division lote");
            this.mostrarMensajeTransaccionExitosa("se elimino satisfactoriamente la configuracion de division de lotes");
        }
        catch(SQLException ex){
            LOGGER.warn("error", ex);
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar la configuracion, intente de nuevo");
        }
        catch(Exception ex){
            LOGGER.warn("error", ex);
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de eliminar la configuracion, intente de nuevo");
        }
        this.cargarProductosDivisionLotes();
        return null;
    }

    public String getCargarProductosDivisiblesLotes()
    {
        this.cargarProductosActivosNuevo();
        this.cargarTiposProgramaProd();
        this.cargarProductosDivisionLotes();
        return null;
    }
    public List<SelectItem> getComponentesProdList() {
        return componentesProdList;
    }

    public void setComponentesProdList(List<SelectItem> componentesProdList) {
        this.componentesProdList = componentesProdList;
    }

    public ProductosDivisionLotes getProductosDivisionLotesEditar() {
        return productosDivisionLotesEditar;
    }

    public void setProductosDivisionLotesEditar(ProductosDivisionLotes productosDivisionLotesEditar) {
        this.productosDivisionLotesEditar = productosDivisionLotesEditar;
    }

    public List<ProductosDivisionLotes> getProductosDivisionLotesList() {
        return productosDivisionLotesList;
    }

    public void setProductosDivisionLotesList(List<ProductosDivisionLotes> productosDivisionLotesList) {
        this.productosDivisionLotesList = productosDivisionLotesList;
    }

    public ProductosDivisionLotes getProductosDivisionLotesNuevo() {
        return productosDivisionLotesNuevo;
    }

    public void setProductosDivisionLotesNuevo(ProductosDivisionLotes productosDivisionLotesNuevo) {
        this.productosDivisionLotesNuevo = productosDivisionLotesNuevo;
    }

    public List<SelectItem> getTiposProgramaProduccionList() {
        return tiposProgramaProduccionList;
    }

    public void setTiposProgramaProduccionList(List<SelectItem> tiposProgramaProduccionList) {
        this.tiposProgramaProduccionList = tiposProgramaProduccionList;
    }
    
    

}
