/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestra;
import com.cofar.bean.FormulaMaestraDetalleFPActividad;
import com.cofar.bean.FormulaMaestraDetalleFP;
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

public class ManagedFormulaMaestraDetalleFPActividad {
    
    Connection con = null;
    FormulaMaestra formulaMaestra = new FormulaMaestra();
    FormulaMaestraDetalleFP formulaMaestraDetalleFP = new FormulaMaestraDetalleFP();
    FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividad = new FormulaMaestraDetalleFPActividad();
    List formulaMaestraDetalleFPActividadList = new ArrayList();
    HtmlDataTable formulaMaestrasDetalleFPActividadDataTable = new HtmlDataTable();

    public FormulaMaestraDetalleFP getFormulaMaestraDetalleFP() {
        return formulaMaestraDetalleFP;
    }

    public void setFormulaMaestraDetalleFP(FormulaMaestraDetalleFP formulaMaestraDetalleFP) {
        this.formulaMaestraDetalleFP = formulaMaestraDetalleFP;
    }

    public FormulaMaestraDetalleFPActividad getFormulaMaestraDetalleFPActividad() {
        return formulaMaestraDetalleFPActividad;
    }

    public void setFormulaMaestraDetalleFPActividad(FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividad) {
        this.formulaMaestraDetalleFPActividad = formulaMaestraDetalleFPActividad;
    }

    public List getFormulaMaestraDetalleFPActividadList() {
        return formulaMaestraDetalleFPActividadList;
    }

    public void setFormulaMaestraDetalleFPActividadList(List formulaMaestraDetalleFPActividadList) {
        this.formulaMaestraDetalleFPActividadList = formulaMaestraDetalleFPActividadList;
    }

    public HtmlDataTable getFormulaMaestrasDetalleFPActividadDataTable() {
        return formulaMaestrasDetalleFPActividadDataTable;
    }

    public void setFormulaMaestrasDetalleFPActividadDataTable(HtmlDataTable formulaMaestrasDetalleFPActividadDataTable) {
        this.formulaMaestrasDetalleFPActividadDataTable = formulaMaestrasDetalleFPActividadDataTable;
    }

    
    
    
    


    /** Creates a new instance of ManagedFormulaMaestraFaseActividad */
    public ManagedFormulaMaestraDetalleFPActividad() {
    }
    public String getCargarContenidoFormulaMaestraDetalleFPActividad(){
        try {
                this.cargarFormulaMaestraDetalleFPActividad();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarFormulaMaestraDetalleFPActividad(){
        try {
                ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
                Map<String, Object> sessionMap = externalContext.getSessionMap();
                formulaMaestraDetalleFP=(FormulaMaestraDetalleFP)sessionMap.get("formulaMaestraDetalleFP");


                con = Util.openConnection(con);
                String consulta = " SELECT COD_FASE_ACTIVIDAD, COD_FASE_PREPARADO, DESCRIPCION_ACTIVIDAD, TIEMPO_ACTIVIDAD, NRO_REPETICIONES," +
                        " OBSERVACION, TEMPERATURA_FINAL1, TEMPERATURA_FINAL2 FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD " +
                        " WHERE COD_FASE_PREPARADO = '"+formulaMaestraDetalleFP.getCodFasePreparado()+"' " +
                        " ORDER BY COD_FASE_ACTIVIDAD ASC";
                System.out.println("consulta" + consulta);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(consulta);
                formulaMaestraDetalleFPActividadList.clear();
                while(rs.next()){
                    FormulaMaestraDetalleFPActividad formulaMaestraFaseActividadItem = new FormulaMaestraDetalleFPActividad();
                    formulaMaestraFaseActividadItem.setFormulaMaestraFasePreparado(formulaMaestraDetalleFP);
                    formulaMaestraFaseActividadItem.setCodFaseActividad(rs.getInt("COD_FASE_ACTIVIDAD"));
                    formulaMaestraFaseActividadItem.setDescripcionActividad(rs.getString("DESCRIPCION_ACTIVIDAD"));
                    formulaMaestraFaseActividadItem.setTiempoActividad(rs.getFloat("TIEMPO_ACTIVIDAD"));
                    formulaMaestraFaseActividadItem.setNroRepeticiones(rs.getInt("NRO_REPETICIONES"));
                    formulaMaestraFaseActividadItem.setObservacion(rs.getString("OBSERVACION"));
                    formulaMaestraFaseActividadItem.setTemperaturaFinal1(rs.getFloat("TEMPERATURA_FINAL1"));
                    formulaMaestraFaseActividadItem.setTemperaturaFinal2(rs.getFloat("TEMPERATURA_FINAL2"));
                    formulaMaestraDetalleFPActividadList.add(formulaMaestraFaseActividadItem);
                }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public String registrarFormulaMaestraDetalleFPActividad_action(){
        try {
            con=Util.openConnection(con);
               String consulta = " INSERT INTO FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD( COD_FASE_ACTIVIDAD,  COD_FASE_PREPARADO,  DESCRIPCION_ACTIVIDAD,  TIEMPO_ACTIVIDAD, " +
                       "  NRO_REPETICIONES,   OBSERVACION,   TEMPERATURA_FINAL1, TEMPERATURA_FINAL2 ) " +
                       " VALUES ((select isnull(MAX(COD_FASE_ACTIVIDAD),0) +1 from FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD where COD_FASE_PREPARADO = '"+formulaMaestraDetalleFP.getCodFasePreparado()+"'),'"+formulaMaestraDetalleFP.getCodFasePreparado()+"'," +
                       " '"+formulaMaestraDetalleFPActividad.getDescripcionActividad()+"','"+formulaMaestraDetalleFPActividad.getTiempoActividad()+"',  " +
                       " '"+formulaMaestraDetalleFPActividad.getNroRepeticiones()+"','"+formulaMaestraDetalleFPActividad.getObservacion()+"', '"+formulaMaestraDetalleFPActividad.getTemperaturaFinal1()+"', '"+formulaMaestraDetalleFPActividad.getTemperaturaFinal2()+"' ); ";
                       
               System.out.println("consulta" + consulta);

               Statement st = con.createStatement();
               st.executeUpdate(consulta);
               this.cargarFormulaMaestraDetalleFPActividad();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String agregarFormulaMaestraDetalleFPActividad_action(){
        try {
                formulaMaestraDetalleFPActividad = new FormulaMaestraDetalleFPActividad();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarFormulaMaestraDetalleFPActividad_action(){
        try {
               con=Util.openConnection(con);
               String consulta = "";
               Iterator i = formulaMaestraDetalleFPActividadList.iterator();
               while(i.hasNext()){
                   FormulaMaestraDetalleFPActividad formulaMaestraFaseActividadItem = (FormulaMaestraDetalleFPActividad)i.next();
                   if(formulaMaestraFaseActividadItem.getChecked().booleanValue()==true){                       
                       consulta = " DELETE FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD WHERE COD_FASE_PREPARADO = '"+formulaMaestraDetalleFP.getCodFasePreparado()+"'" +
                               " AND COD_FASE_ACTIVIDAD = '"+formulaMaestraFaseActividadItem.getCodFaseActividad()+"'; ";
                        System.out.println("consulta" + consulta);
                        Statement st = con.createStatement();
                        st.executeUpdate(consulta);

                        consulta = " DELETE FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MAQUINARIA WHERE COD_FASE_PREPARADO ='"+formulaMaestraDetalleFP.getCodFasePreparado()+"'" +
                                " AND COD_FASE_ACTIVIDAD = '"+formulaMaestraFaseActividadItem.getCodFaseActividad()+"' ";
                        System.out.println("consulta" + consulta);
                        st = con.createStatement();
                        st.executeUpdate(consulta);

                        consulta = " DELETE FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MATERIAL WHERE COD_FASE_PREPARADO ='"+formulaMaestraDetalleFP.getCodFasePreparado()+"' " +
                                " AND COD_FASE_ACTIVIDAD = '"+formulaMaestraFaseActividadItem.getCodFaseActividad()+"'";
                        System.out.println("consulta" + consulta);
                        st = con.createStatement();
                        st.executeUpdate(consulta);

                       break;
                   }


               }
               this.cargarFormulaMaestraDetalleFPActividad();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String editarFormulaMaestraDetalleFPActividad_action(){
        try {
               con=Util.openConnection(con);
               Iterator i = formulaMaestraDetalleFPActividadList.iterator();
               while(i.hasNext()){
                   FormulaMaestraDetalleFPActividad formulaMaestraFaseActividadItem = (FormulaMaestraDetalleFPActividad) i.next();
                   if(formulaMaestraFaseActividadItem.getChecked().booleanValue()==true){
                       formulaMaestraDetalleFPActividad =formulaMaestraFaseActividadItem;
                       break;
                   }
               }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEdicionFormulaMaestraFPActividad_action(){
        try {
            con=Util.openConnection(con);

            String consulta = " UPDATE dbo.FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD   SET  DESCRIPCION_ACTIVIDAD = '"+formulaMaestraDetalleFPActividad.getDescripcionActividad()+"'," +
                    " TIEMPO_ACTIVIDAD = '"+formulaMaestraDetalleFPActividad.getTiempoActividad()+"',  NRO_REPETICIONES = '"+formulaMaestraDetalleFPActividad.getNroRepeticiones()+"', " +
                    " OBSERVACION = '"+formulaMaestraDetalleFPActividad.getObservacion()+"'," +
                    " TEMPERATURA_FINAL1 = '"+formulaMaestraDetalleFPActividad.getTemperaturaFinal1()+"', TEMPERATURA_FINAL2 = '"+formulaMaestraDetalleFPActividad.getTemperaturaFinal2()+"' " +
                    " WHERE COD_FASE_ACTIVIDAD = '"+formulaMaestraDetalleFPActividad.getCodFaseActividad()+"' AND COD_FASE_PREPARADO = '"+formulaMaestraDetalleFP.getCodFasePreparado()+"'  ; ";
            

             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);
             this.cargarFormulaMaestraDetalleFPActividad();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String verFormulaMaestraDetalleFPActividadMaterial_action(){
        try {
            FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividadItem = (FormulaMaestraDetalleFPActividad)formulaMaestrasDetalleFPActividadDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("formulaMaestraDetalleFPActividad", formulaMaestraDetalleFPActividadItem);
            this.redireccionar("../formulaMaestraDetalleFPActividadMaterial/navegadorFormulaMaestraDetalleFPActividadMaterial.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verFormulaMaestraDetalleFPActividadMaquinaria_action(){
        try {
            FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividadItem = (FormulaMaestraDetalleFPActividad)formulaMaestrasDetalleFPActividadDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("formulaMaestraDetalleFPActividad", formulaMaestraDetalleFPActividadItem);
            this.redireccionar("../formulaMaestraDetalleFPActividadMaquinaria/navegadorFormulaMaestraDetalleFPActividadMaquinaria.jsf");
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
