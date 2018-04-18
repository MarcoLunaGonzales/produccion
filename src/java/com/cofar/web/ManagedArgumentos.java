/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ComponentesProd;
import com.cofar.bean.DocumentacionArgumentosProducto;
import com.cofar.bean.PresentacionesProducto;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author hvaldivia
 */

public class ManagedArgumentos {

    /** Creates a new instance of ManagedArgumentos */
    public ManagedArgumentos() {
    }
    List componentesProdList = new ArrayList();
    HtmlDataTable componentesProdDataTable = new HtmlDataTable();
    PresentacionesProducto componentesProd = new PresentacionesProducto();
    List argumentosList = new ArrayList();
    List estadosReferencialesList = new ArrayList();

    public List getArgumentosList() {
        return argumentosList;
    }

    public void setArgumentosList(List argumentosList) {
        this.argumentosList = argumentosList;
    }

    public PresentacionesProducto getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(PresentacionesProducto componentesProd) {
        this.componentesProd = componentesProd;
    }

    

    public HtmlDataTable getComponentesProdDataTable() {
        return componentesProdDataTable;
    }

    public void setComponentesProdDataTable(HtmlDataTable componentesProdDataTable) {
        this.componentesProdDataTable = componentesProdDataTable;
    }

    public List getComponentesProdList() {
        return componentesProdList;
    }

    public void setComponentesProdList(List componentesProdList) {
        this.componentesProdList = componentesProdList;
    }

    public List getEstadosReferencialesList() {
        return estadosReferencialesList;
    }

    public void setEstadosReferencialesList(List estadosReferencialesList) {
        this.estadosReferencialesList = estadosReferencialesList;
    }
    
    public String getCargarComponentesProd(){
        try {
        String consulta = " select p.cod_presentacion,p.nombre_producto_presentacion,(SELECT ','+d.descripcion_argumento AS [text()]" +
                " FROM DOCUMENTACION_ARGUMENTOS_PRODUCTO d WHERE d.cod_presentacion = p.cod_presentacion" +
                " ORDER BY d.descripcion_argumento FOR XML PATH('')) argumentos from presentaciones_producto p where p.cod_estado_registro = 1";
        System.out.println("consulta " + consulta);
        componentesProdList.clear();
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        while(rs.next()){
            PresentacionesProducto c = new PresentacionesProducto();
            c.setNombreProductoPresentacion(rs.getString("nombre_producto_presentacion"));
            c.setCodPresentacion(rs.getString("cod_presentacion"));
            c.setDescr(rs.getString("argumentos"));
            componentesProdList.add(c);
        }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verArgumentos_action(){
        componentesProd = (PresentacionesProducto)componentesProdDataTable.getRowData();
        return null;
    }
    public String getCargarArgumentos(){
        try {
            String consulta = " SELECT d.cod_presentacion, d.nombre_argumento, d.descripcion_argumento, d.cod_estado_registro,d.descripcion_pregunta" +
                    " FROM DOCUMENTACION_ARGUMENTOS_PRODUCTO d inner join estados_referenciales e on e.cod_estado_registro =d.cod_estado_registro" +
                    " where cod_presentacion = '"+componentesProd.getCodPresentacion()+"' ";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            argumentosList.clear();
            while(rs.next()){
                DocumentacionArgumentosProducto d = new DocumentacionArgumentosProducto();
                d.getPresentacionesProducto().setNombreProductoPresentacion(rs.getString("cod_presentacion"));
                d.setNombreArgumento(rs.getString("nombre_argumento"));
                d.setDescripcionArgumento(rs.getString("descripcion_argumento"));
                d.setDescripcionPregunta(rs.getString("descripcion_pregunta"));
                d.getEstadoReferencial().setCodEstadoRegistro(rs.getString("cod_estado_registro"));
                argumentosList.add(d);
            }
            st.close();
            rs.close();
            con.close();
            estadosReferencialesList.clear();
            estadosReferencialesList.add(new SelectItem("1","Activo"));
            estadosReferencialesList.add(new SelectItem("2","No Activo"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String mas_action(){
        DocumentacionArgumentosProducto d = new DocumentacionArgumentosProducto();
        argumentosList.add(d);
        return null;
    }
    public String menos_action(){
        List respuestasDocumentacionList = new ArrayList();
        Iterator i = argumentosList.iterator();
        while(i.hasNext()){
            DocumentacionArgumentosProducto d = (DocumentacionArgumentosProducto) i.next();
            if(d.getChecked()==false){
                DocumentacionArgumentosProducto copia = new DocumentacionArgumentosProducto();
                copia.getPresentacionesProducto().setCodPresentacion(d.getPresentacionesProducto().getCodPresentacion());
                copia.getPresentacionesProducto().setNombreProductoPresentacion(d.getPresentacionesProducto().getNombreProductoPresentacion());
                copia.setNombreArgumento(d.getNombreArgumento());
                copia.setDescripcionArgumento(d.getDescripcionArgumento());
                copia.getEstadoReferencial().setCodEstadoRegistro(d.getEstadoReferencial().getCodEstadoRegistro());
                copia.getEstadoReferencial().setNombreEstadoRegistro(d.getEstadoReferencial().getNombreEstadoRegistro());
                respuestasDocumentacionList.add(copia);
            }
        }
        argumentosList = respuestasDocumentacionList;
        return null;
    }
    public String guardarArgumentos_action(){
        try {
            String consulta = " delete from documentacion_argumentos_producto where cod_presentacion = '"+componentesProd.getCodPresentacion()+"' ";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            st.executeUpdate(consulta);
            Iterator i = argumentosList.iterator();
            while(i.hasNext()){
                DocumentacionArgumentosProducto d = (DocumentacionArgumentosProducto) i.next();
                consulta = " INSERT INTO DOCUMENTACION_ARGUMENTOS_PRODUCTO(  cod_presentacion,  nombre_argumento,  descripcion_argumento,  cod_estado_registro," +
                        "  cod_argumento,  descripcion_pregunta) VALUES (  '"+componentesProd.getCodPresentacion()+"',  '"+d.getNombreArgumento()+"',  '"+d.getDescripcionArgumento()+"'," +
                        "  '"+d.getEstadoReferencial().getCodEstadoRegistro()+"',  (select isnull(max(cod_argumento),0) +1 from documentacion_argumentos_producto where cod_presentacion = '"+componentesProd.getCodPresentacion()+"'),  '"+d.getDescripcionPregunta()+"'); ";
                System.out.println("consulta " + consulta);
                st.executeUpdate(consulta);
            }
            st.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


}
