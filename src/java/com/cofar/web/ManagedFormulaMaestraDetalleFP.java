/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.FormulaMaestraDetalleFP;
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
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author hvaldivia
 */

public class ManagedFormulaMaestraDetalleFP {
    Connection con = null;
    /** Creates a new instance of ManagedFormulaMaestraFasesPreparado */
    List  formulaMaestraDetalleFPList = new ArrayList();
    FormulaMaestra formulaMaestra = new FormulaMaestra();
    FormulaMaestraDetalleFP formulaMaestraDetalleFP = new FormulaMaestraDetalleFP();
    HtmlDataTable formulaMaestrasDetalleFPDataTable = new HtmlDataTable();
    FormulaMaestraPreparado formulaMaestraPreparado = new FormulaMaestraPreparado();
    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public FormulaMaestraDetalleFP getFormulaMaestraDetalleFP() {
        return formulaMaestraDetalleFP;
    }

    public void setFormulaMaestraDetalleFP(FormulaMaestraDetalleFP formulaMaestraDetalleFP) {
        this.formulaMaestraDetalleFP = formulaMaestraDetalleFP;
    }

    public List getFormulaMaestraDetalleFPList() {
        return formulaMaestraDetalleFPList;
    }

    public void setFormulaMaestraDetalleFPList(List formulaMaestraDetalleFPList) {
        this.formulaMaestraDetalleFPList = formulaMaestraDetalleFPList;
    }

    public HtmlDataTable getFormulaMaestrasDetalleFPDataTable() {
        return formulaMaestrasDetalleFPDataTable;
    }

    public void setFormulaMaestrasDetalleFPDataTable(HtmlDataTable formulaMaestrasDetalleFPDataTable) {
        this.formulaMaestrasDetalleFPDataTable = formulaMaestrasDetalleFPDataTable;
    }
    



    
    public ManagedFormulaMaestraDetalleFP() {
    }
    public String getCargarContenidoFormulaMaestraDetalleFP(){
        try {
            this.cargarFormulaMaestraDetalleFP();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarFormulaMaestraDetalleFP(){
        try {                         

               ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
               Map<String, Object> sessionMap = externalContext.getSessionMap();
               formulaMaestraPreparado=(FormulaMaestraPreparado)sessionMap.get("formulaMaestraPreparadoItem");


                con = Util.openConnection(con);
                String consulta = " SELECT COD_FASE_PREPARADO,COD_PREPARADO, DESCRIPCION_FASE,ORDEN_FASE_PREPARADO FROM FORMULA_MAESTRA_DETALLE_FP " +
                        " WHERE COD_PREPARADO ='"+formulaMaestraPreparado.getCodPreparado()+"' ORDER BY ORDEN_FASE_PREPARADO ASC;";
                System.out.println("consulta" + consulta);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(consulta);
                formulaMaestraDetalleFPList.clear();
                while(rs.next()){
                    FormulaMaestraDetalleFP formulaMaestraFasePreparadoItem = new FormulaMaestraDetalleFP();
                    formulaMaestraFasePreparadoItem.setFormulaMaestraPreparado(formulaMaestraPreparado);
                    formulaMaestraFasePreparadoItem.setCodFasePreparado(rs.getInt("COD_FASE_PREPARADO"));
                    formulaMaestraFasePreparadoItem.getFormulaMaestraPreparado().setCodPreparado(rs.getInt("COD_PREPARADO"));
                    formulaMaestraFasePreparadoItem.setDescripcionFase(rs.getString("DESCRIPCION_FASE"));
                    formulaMaestraFasePreparadoItem.setOrdenFasePreparado(rs.getInt("ORDEN_FASE_PREPARADO"));
                    formulaMaestraDetalleFPList.add(formulaMaestraFasePreparadoItem);
                }
        } catch (Exception e) {
            e.printStackTrace();
        }
      
    }
    public String registrarFormulaMaestraDetalleFP_action(){
        try {
            con=Util.openConnection(con);
               String consulta = " INSERT INTO FORMULA_MAESTRA_DETALLE_FP ( COD_FASE_PREPARADO, COD_PREPARADO, DESCRIPCION_FASE,ORDEN_FASE_PREPARADO )VALUES (  " +
                       " (select isnull(MAX(COD_FASE_PREPARADO),0) +1 from FORMULA_MAESTRA_DETALLE_FP),'"+formulaMaestraPreparado.getCodPreparado() +"','"+ formulaMaestraDetalleFP.getDescripcionFase() +"' " +
                       ",'"+formulaMaestraDetalleFP.getOrdenFasePreparado()+"' ); ";
               System.out.println("consulta" + consulta);

               Statement st = con.createStatement();
               st.executeUpdate(consulta);
               this.cargarFormulaMaestraDetalleFP();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String agregarFormulaMaestraDetalleFP_action(){
        try {
                formulaMaestraDetalleFP = new FormulaMaestraDetalleFP();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarFormulaMaestraDetalleFP_action(){
        try {
               con=Util.openConnection(con);
               String consulta = "";
               Iterator i = formulaMaestraDetalleFPList.iterator();
               while(i.hasNext()){
                   FormulaMaestraDetalleFP formulaMaestraFasePreparadoItem = (FormulaMaestraDetalleFP)i.next();
                   if(formulaMaestraFasePreparadoItem.getChecked().booleanValue()==true){
                       consulta = " DELETE FROM FORMULA_MAESTRA_DETALLE_FP WHERE COD_PREPARADO = '"+formulaMaestraPreparado.getCodPreparado()+"'" +
                               " AND COD_FASE_PREPARADO = '"+formulaMaestraFasePreparadoItem.getCodFasePreparado()+"'";
                        System.out.println("consulta" + consulta);
                        Statement st = con.createStatement();
                        st.executeUpdate(consulta);
                        
                        consulta = " DELETE FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD WHERE COD_FASE_PREPARADO='"+formulaMaestraFasePreparadoItem.getCodFasePreparado()+"' ";
                        System.out.println("consulta" + consulta);
                        st = con.createStatement();
                        st.executeUpdate(consulta);

                        consulta = " DELETE FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MAQUINARIA WHERE COD_FASE_PREPARADO ='"+formulaMaestraFasePreparadoItem.getCodFasePreparado()+"' ";
                        System.out.println("consulta" + consulta);
                        st = con.createStatement();
                        st.executeUpdate(consulta);

                        consulta = " DELETE FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MATERIAL WHERE COD_FASE_PREPARADO ='"+formulaMaestraFasePreparadoItem.getCodFasePreparado()+"' ";
                        System.out.println("consulta" + consulta);
                        st = con.createStatement();
                        st.executeUpdate(consulta);

                        


                       break;
                   }

                   
               }
               this.cargarFormulaMaestraDetalleFP();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String editarFormulaMaestraDetalleFP_action(){
        try {
               con=Util.openConnection(con);
               Iterator i = formulaMaestraDetalleFPList.iterator();
               while(i.hasNext()){
                   
                   FormulaMaestraDetalleFP formulaMaestraFasePreparadoItem = (FormulaMaestraDetalleFP) i.next();
                   if(formulaMaestraFasePreparadoItem.getChecked().booleanValue()==true){
                       formulaMaestraDetalleFP =formulaMaestraFasePreparadoItem;
                       break;
                   }
               }               
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEdicionFormulaMaestraDetalleFP_action(){
        try {
            con=Util.openConnection(con);

            String consulta = " UPDATE FORMULA_MAESTRA_DETALLE_FP  " +
                    " SET DESCRIPCION_FASE = '"+formulaMaestraDetalleFP.getDescripcionFase()+"'," +
                    " ORDEN_FASE_PREPARADO = '"+formulaMaestraDetalleFP.getOrdenFasePreparado()+"' " +
                    " WHERE COD_FASE_PREPARADO='"+formulaMaestraDetalleFP.getCodFasePreparado()+"' " +
                    " AND COD_PREPARADO ='"+formulaMaestraPreparado.getCodPreparado()+"';";
            
             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);
             this.cargarFormulaMaestraDetalleFP();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verFormulaMaestraDetalleFPActividad_action(){
        try {
            FormulaMaestraDetalleFP formulaMaestraDetalleFPItem = (FormulaMaestraDetalleFP)formulaMaestrasDetalleFPDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("formulaMaestraDetalleFP", formulaMaestraDetalleFPItem);
            this.redireccionar("../formulaMaestraDetalleFPActividad/navegadorFormulaMaestraDetalleFPActividad.jsf");
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
