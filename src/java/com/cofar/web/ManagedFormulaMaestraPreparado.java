/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.FormulaMaestraPreparado;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author hvaldivia
 */

public class ManagedFormulaMaestraPreparado {
    Connection con  = null;
    List formulaMaestraPreparadoList = new ArrayList();
    FormulaMaestraPreparado formulaMaestraPreparado =new FormulaMaestraPreparado();
    List maquinariasList = new ArrayList();
    List maquinariasAgitadorList = new ArrayList();
    List unidadesVelocidadList = new ArrayList();
    List unidadesMedidaCargaList = new ArrayList();
    List unidadesVelocidadAgitadorList = new ArrayList();
    FormulaMaestra formulaMaestra =  new FormulaMaestra();
    HtmlDataTable formulaMaestraPreparadoDataTable = new HtmlDataTable();
    List partesMaquinariaList = new ArrayList();

    public FormulaMaestraPreparado getFormulaMaestraPreparado() {
        return formulaMaestraPreparado;
    }

    public void setFormulaMaestraPreparado(FormulaMaestraPreparado formulaMaestraPreparado) {
        this.formulaMaestraPreparado = formulaMaestraPreparado;
    }

    public List getFormulaMaestraPreparadoList() {
        return formulaMaestraPreparadoList;
    }

    public void setFormulaMaestraPreparadoList(List formulaMaestraPreparadoList) {
        this.formulaMaestraPreparadoList = formulaMaestraPreparadoList;
    }

    public List getMaquinariasAgitadorList() {
        return maquinariasAgitadorList;
    }

    public void setMaquinariasAgitadorList(List maquinariasAgitadorList) {
        this.maquinariasAgitadorList = maquinariasAgitadorList;
    }

    public List getMaquinariasList() {
        return maquinariasList;
    }

    public void setMaquinariasList(List maquinariasList) {
        this.maquinariasList = maquinariasList;
    }

    public List getUnidadesMedidaCargaList() {
        return unidadesMedidaCargaList;
    }

    public void setUnidadesMedidaCargaList(List unidadesMedidaCargaList) {
        this.unidadesMedidaCargaList = unidadesMedidaCargaList;
    }

    public List getUnidadesVelocidadAgitadorList() {
        return unidadesVelocidadAgitadorList;
    }

    public void setUnidadesVelocidadAgitadorList(List unidadesVelocidadAgitadorList) {
        this.unidadesVelocidadAgitadorList = unidadesVelocidadAgitadorList;
    }

    public List getUnidadesVelocidadList() {
        return unidadesVelocidadList;
    }

    public void setUnidadesVelocidadList(List unidadesVelocidadList) {
        this.unidadesVelocidadList = unidadesVelocidadList;
    }

    public HtmlDataTable getFormulaMaestraPreparadoDataTable() {
        return formulaMaestraPreparadoDataTable;
    }

    public void setFormulaMaestraPreparadoDataTable(HtmlDataTable formulaMaestraPreparadoDataTable) {
        this.formulaMaestraPreparadoDataTable = formulaMaestraPreparadoDataTable;
    }

    public List getPartesMaquinariaList() {
        return partesMaquinariaList;
    }

    public void setPartesMaquinariaList(List partesMaquinariaList) {
        this.partesMaquinariaList = partesMaquinariaList;
    }


    


    
    
    /** Creates a new instance of ManagedFormulaMaestraPreparado */
    public ManagedFormulaMaestraPreparado() {
    }

    public String getCargarContenidoFormulaMaestraPreparado(){
        try {
                this.cargarFormulaMaestraPreparado();
                this.cargarMaquinaria();                
                this.cargarUnidadesVelocidadMaquina();
                this.cargarMaquinariaAgitador();
                this.cargarUnidadesVelocidadAgitador();
                this.cargarUnidadesMedidaCargaMaquina();
                

                
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarFormulaMaestraPreparado(){
        try {
            

                if(Util.getParameter("codigoFormulaMaestra")!=null){
                    formulaMaestra.setCodFormulaMaestra(Util.getParameter("codigoFormulaMaestra"));
                }

                
                String consulta = "  SELECT fmp.COD_FORMULA_MAESTRA,  fmp.COD_PREPARADO,  fmp.DESCRIPCION_PRECAUCION,  fmp.OBSERVACION,  fmp.COD_MAQUINA,  " +
                        " fmp.TEMPERATURA_MAXIMA,  fmp.HUMEDAD_RELATIVA_MAXIMA,m.NOMBRE_MAQUINA,fmp.COD_PARTE_MAQUINA," +
                        " ISNULL((SELECT tpm.NOMBRE_PARTE_MAQUINA FROM partes_maquinaria tpm WHERE tpm.COD_PARTE_MAQUINA = fmp.COD_PARTE_MAQUINA),'') NOMBRE_PARTE_MAQUINA " +
                        "  FROM FORMULA_MAESTRA_PREPARADO fmp " +
                        "  inner join MAQUINARIAS m on m.COD_MAQUINA = fmp.COD_MAQUINA " +                        
                        " where fmp.COD_FORMULA_MAESTRA = '"+formulaMaestra.getCodFormulaMaestra()+"' ";
                

                System.out.println("consulta" + consulta);
                con= Util.openConnection(con);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(consulta);
                formulaMaestraPreparadoList.clear();
                while(rs.next()){

                    FormulaMaestraPreparado formulaMaestraPreparadoItem = new FormulaMaestraPreparado();
                    formulaMaestraPreparadoItem.getFormulaMaestra().setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                    formulaMaestraPreparadoItem.setCodPreparado(rs.getInt("COD_PREPARADO"));
                    formulaMaestraPreparadoItem.setDescripcionPrecaucion(rs.getString("DESCRIPCION_PRECAUCION"));
                    formulaMaestraPreparadoItem.setObservacion(rs.getString("OBSERVACION"));
                    formulaMaestraPreparadoItem.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINA"));
                    formulaMaestraPreparadoItem.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                    formulaMaestraPreparadoItem.setTemperaturaMaxima(rs.getFloat("TEMPERATURA_MAXIMA"));
                    formulaMaestraPreparadoItem.setHumedadRelativaMaxima(rs.getFloat("HUMEDAD_RELATIVA_MAXIMA"));
                    //formulaMaestraPreparadoItem.getPartesMaquinaria().setCodParteMaquina(rs.getString("COD_PARTE_MAQUINA"));
                    formulaMaestraPreparadoItem.getPartesMaquinaria().setNombreParteMaquina(rs.getString("NOMBRE_PARTE_MAQUINA"));
                    
                    
                    formulaMaestraPreparadoList.add(formulaMaestraPreparadoItem);
                 
                }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public String registrarFormulaMaestraPreparado_action(){
        try {
            con=Util.openConnection(con);
               String consulta = " INSERT INTO FORMULA_MAESTRA_PREPARADO(  COD_FORMULA_MAESTRA,  COD_PREPARADO,  DESCRIPCION_PRECAUCION," +
                       "  OBSERVACION,  COD_MAQUINA,  TEMPERATURA_MAXIMA,  HUMEDAD_RELATIVA_MAXIMA,COD_PARTE_MAQUINA) " +
                       "VALUES ( '"+formulaMaestra.getCodFormulaMaestra()+"', " +
                       " (select isnull(MAX(COD_PREPARADO),0) +1 from FORMULA_MAESTRA_PREPARADO)," +
                       " '"+formulaMaestraPreparado.getDescripcionPrecaucion()+"','"+formulaMaestraPreparado.getObservacion()+"',  " +
                       " '"+formulaMaestraPreparado.getMaquinaria().getCodMaquina()+"',  " +
                       " '"+formulaMaestraPreparado.getTemperaturaMaxima()+"'," +
                       " '"+formulaMaestraPreparado.getHumedadRelativaMaxima()+"'," +
                       " '"+formulaMaestraPreparado.getPartesMaquinaria().getCodParteMaquina()+"' ); ";
               
                    
               System.out.println("consulta" + consulta);

               Statement st = con.createStatement();
               st.executeUpdate(consulta);
               this.cargarFormulaMaestraPreparado();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String agregarFormulaMaestraPreparado_action(){
        try {
            formulaMaestraPreparado = new FormulaMaestraPreparado();
            this.cargarPartesMaquinaria();
                
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarFormulaMaestraPreparado_action(){
        try {
               con=Util.openConnection(con);
               String consulta = "";
               Iterator i = formulaMaestraPreparadoList.iterator();
               while(i.hasNext()){

                   
                   FormulaMaestraPreparado formulaMaestraPreparadoItem = (FormulaMaestraPreparado) i.next() ;
                   
                   if(formulaMaestraPreparadoItem.getChecked().booleanValue()==true){

                       consulta = " DELETE FROM FORMULA_MAESTRA_PREPARADO WHERE COD_FORMULA_MAESTRA='"+formulaMaestraPreparadoItem.getFormulaMaestra().getCodFormulaMaestra()+"' AND COD_PREPARADO='"+formulaMaestraPreparadoItem.getCodPreparado()+"' ";
                       System.out.println("consulta" + consulta);
                       Statement st = con.createStatement();
                       st.executeUpdate(consulta);

                       break;
                   }


               }
               this.cargarFormulaMaestraPreparado();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String editarFormulaMaestraPreparado_action(){
        try {
               con=Util.openConnection(con);
               Iterator i = formulaMaestraPreparadoList.iterator();
               while(i.hasNext()){
                   FormulaMaestraPreparado formulaMaestraPreparadoItem = (FormulaMaestraPreparado)i.next();
                   if(formulaMaestraPreparadoItem.getChecked().booleanValue()==true){                       
                       formulaMaestraPreparado = formulaMaestraPreparadoItem;
                       break;
                   }
               }
               this.cargarPartesMaquinaria();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarFormulaMaestraPreparado_action(){
        try {
            con=Util.openConnection(con);

            String consulta = " UPDATE FORMULA_MAESTRA_PREPARADO  SET " +
                    "  DESCRIPCION_PRECAUCION = '"+formulaMaestraPreparado.getDescripcionPrecaucion()+"'," +
                    "  OBSERVACION = '"+formulaMaestraPreparado.getObservacion()+"'," +
                    "  COD_MAQUINA = '"+formulaMaestraPreparado.getMaquinaria().getCodMaquina()+"'," +
                    "  TEMPERATURA_MAXIMA = '"+formulaMaestraPreparado.getTemperaturaMaxima()+"'," +
                    "  HUMEDAD_RELATIVA_MAXIMA = '"+formulaMaestraPreparado.getHumedadRelativaMaxima()+"', " +
                    "  COD_PARTE_MAQUINA  = '"+formulaMaestraPreparado.getPartesMaquinaria().getCodParteMaquina()+"'" +
                    " WHERE COD_FORMULA_MAESTRA = "+formulaMaestra.getCodFormulaMaestra()+" AND COD_PREPARADO = '"+formulaMaestraPreparado.getCodPreparado()+"' ";
                    
             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);
             this.cargarFormulaMaestraPreparado();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarMaquinaria(){
        try {
            String consulta = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA from maquinarias m where m.COD_ESTADO_REGISTRO = 1 ";
            maquinariasList.clear();
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                maquinariasList.add(new SelectItem(rs.getString("COD_MAQUINA"), rs.getString("NOMBRE_MAQUINA")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void cargarPartesMaquinaria(){
        try {
            String consulta = " select pm.cod_parte_maquina,pm.nombre_parte_maquina " +
                    " from partes_maquinaria pm " +
                    " where cod_maquina='"+formulaMaestraPreparado.getMaquinaria().getCodMaquina()+"' " +
                    " order by pm.nombre_parte_maquina  ";

            partesMaquinariaList.clear();
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            partesMaquinariaList.add(new SelectItem("0", "-NINGUNO-"));
            while(rs.next()){
                partesMaquinariaList.add(new SelectItem(rs.getString("cod_parte_maquina"), rs.getString("nombre_parte_maquina")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String maquinaria_change(){
        try {
           this.cargarPartesMaquinaria();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarMaquinariaAgitador(){
        try {
            String consulta = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA from maquinarias m where m.COD_ESTADO_REGISTRO = 1 ";
            maquinariasAgitadorList.clear();
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                maquinariasAgitadorList.add(new SelectItem(rs.getString("COD_MAQUINA"), rs.getString("NOMBRE_MAQUINA")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void cargarUnidadesVelocidadMaquina(){
        try {
            String consulta = " select u.COD_UNIDAD_VELOCIDAD ,u.NOMBRE_UNIDAD_VELOCIDAD from UNIDADES_VELOCIDAD_MAQUINARIA u where u.COD_ESTADO_REGISTRO = 1 ";
            unidadesVelocidadList.clear();
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                unidadesVelocidadList.add(new SelectItem(rs.getString("COD_UNIDAD_VELOCIDAD"), rs.getString("NOMBRE_UNIDAD_VELOCIDAD")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void cargarUnidadesVelocidadAgitador(){
        try {
            String consulta = " select u.COD_UNIDAD_VELOCIDAD ,u.NOMBRE_UNIDAD_VELOCIDAD from UNIDADES_VELOCIDAD_MAQUINARIA u where u.COD_ESTADO_REGISTRO = 1 ";
            unidadesVelocidadAgitadorList.clear();
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                unidadesVelocidadAgitadorList.add(new SelectItem(rs.getString("COD_UNIDAD_VELOCIDAD"), rs.getString("NOMBRE_UNIDAD_VELOCIDAD")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void cargarUnidadesMedidaCargaMaquina(){
        try {
            String consulta = " select um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA from UNIDADES_MEDIDA um where um.COD_ESTADO_REGISTRO = 1 ";
            unidadesMedidaCargaList.clear();
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                unidadesMedidaCargaList.add(new SelectItem(rs.getString("COD_UNIDAD_MEDIDA"), rs.getString("NOMBRE_UNIDAD_MEDIDA")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String verFormulaMaestraDetalleFP_action(){
        try {
            FormulaMaestraPreparado formulaMaestraPreparadoItem = (FormulaMaestraPreparado)formulaMaestraPreparadoDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("formulaMaestraPreparadoItem", formulaMaestraPreparadoItem);
            this.redireccionar("../formulaMaestraDetalleFP/navegadorFormulaMaestraDetalleFP.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String redireccionar(String direccion) {
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }



}
