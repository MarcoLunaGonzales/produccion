/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestraDetalleFPActividad;
import com.cofar.bean.FormulaMaestraDetalleFPActividadMaterial;
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

public class ManagedFormulaMaestraDetalleFPActividadMaterial {
    Connection con = null;
    FormulaMaestraDetalleFPActividadMaterial formulaMaestraDetalleFPActividadMaterial = new FormulaMaestraDetalleFPActividadMaterial();
    List formulaMaestraDetalleFPActividadMaterialList = new ArrayList();
    FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividad = new FormulaMaestraDetalleFPActividad();
    HtmlDataTable formulaMaestraDetalleFPActividadMaterialDataTable = new HtmlDataTable();
    List materialesList = new ArrayList();

    public FormulaMaestraDetalleFPActividad getFormulaMaestraDetalleFPActividad() {
        return formulaMaestraDetalleFPActividad;
    }

    public void setFormulaMaestraDetalleFPActividad(FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividad) {
        this.formulaMaestraDetalleFPActividad = formulaMaestraDetalleFPActividad;
    }

    public FormulaMaestraDetalleFPActividadMaterial getFormulaMaestraDetalleFPActividadMaterial() {
        return formulaMaestraDetalleFPActividadMaterial;
    }

    public void setFormulaMaestraDetalleFPActividadMaterial(FormulaMaestraDetalleFPActividadMaterial formulaMaestraDetalleFPActividadMaterial) {
        this.formulaMaestraDetalleFPActividadMaterial = formulaMaestraDetalleFPActividadMaterial;
    }

    public HtmlDataTable getFormulaMaestraDetalleFPActividadMaterialDataTable() {
        return formulaMaestraDetalleFPActividadMaterialDataTable;
    }

    public void setFormulaMaestraDetalleFPActividadMaterialDataTable(HtmlDataTable formulaMaestraDetalleFPActividadMaterialDataTable) {
        this.formulaMaestraDetalleFPActividadMaterialDataTable = formulaMaestraDetalleFPActividadMaterialDataTable;
    }

    public List getFormulaMaestraDetalleFPActividadMaterialList() {
        return formulaMaestraDetalleFPActividadMaterialList;
    }

    public void setFormulaMaestraDetalleFPActividadMaterialList(List formulaMaestraDetalleFPActividadMaterialList) {
        this.formulaMaestraDetalleFPActividadMaterialList = formulaMaestraDetalleFPActividadMaterialList;
    }

    public List getMaterialesList() {
        return materialesList;
    }

    public void setMaterialesList(List materialesList) {
        this.materialesList = materialesList;
    }

    
    
    

    /** Creates a new instance of ManagedFormulaMaestraDetalleFPActividadMaterial */
    public ManagedFormulaMaestraDetalleFPActividadMaterial() {
    }
    public String getCargarContenidoFormulaMaestraDetalleFPActividadMaterial(){
        try {
                this.cargarFormulaMaestraDetalleFPActividadMaterial();
                this.cargarMateriales();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarFormulaMaestraDetalleFPActividadMaterial(){
        try {
                ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
                Map<String, Object> sessionMap = externalContext.getSessionMap();
                formulaMaestraDetalleFPActividad=(FormulaMaestraDetalleFPActividad)sessionMap.get("formulaMaestraDetalleFPActividad");


                con = Util.openConnection(con);
                String consulta = " SELECT FMD.COD_FASE_MATERIAL,FMD.COD_FASE_ACTIVIDAD, FMD.COD_MATERIAL,M.NOMBRE_MATERIAL, FMD.CANTIDAD, M.COD_UNIDAD_MEDIDA,U.NOMBRE_UNIDAD_MEDIDA,FMD.TEMPERATURA1,FMD.TEMPERATURA2 FROM " +
                        " FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MATERIAL FMD  " +
                        " INNER JOIN MATERIALES M ON FMD.COD_MATERIAL = M.COD_MATERIAL " +
                        " INNER JOIN UNIDADES_MEDIDA U ON U.COD_UNIDAD_MEDIDA = M.COD_UNIDAD_MEDIDA " +
                        " WHERE COD_FASE_ACTIVIDAD = '"+formulaMaestraDetalleFPActividad.getCodFaseActividad()+"'" +
                        " AND COD_FASE_PREPARADO = '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"' ORDER BY FMD.COD_FASE_MATERIAL ASC ";
                
                System.out.println("consulta" + consulta);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(consulta);
                formulaMaestraDetalleFPActividadMaterialList.clear();
                while(rs.next()){

                    FormulaMaestraDetalleFPActividadMaterial formulaMaestraDetalleFPActividadMaterialItem = new FormulaMaestraDetalleFPActividadMaterial();
                    formulaMaestraDetalleFPActividadMaterialItem.setCodFaseMaterial(rs.getInt("COD_FASE_MATERIAL"));
                    formulaMaestraDetalleFPActividadMaterialItem.setFormulaMaestraDetalleFPActividad(formulaMaestraDetalleFPActividad);
                    formulaMaestraDetalleFPActividadMaterialItem.getMateriales().setCodMaterial(rs.getString("COD_MATERIAL"));
                    formulaMaestraDetalleFPActividadMaterialItem.getMateriales().setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                    formulaMaestraDetalleFPActividadMaterialItem.setCantidad(rs.getFloat("CANTIDAD"));
                    formulaMaestraDetalleFPActividadMaterialItem.getMateriales().getUnidadesMedida().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                    formulaMaestraDetalleFPActividadMaterialItem.getMateriales().getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                    formulaMaestraDetalleFPActividadMaterialItem.setTemperatura1(rs.getFloat("TEMPERATURA1"));
                    formulaMaestraDetalleFPActividadMaterialItem.setTemperatura2(rs.getFloat("TEMPERATURA2"));

                    formulaMaestraDetalleFPActividadMaterialList.add(formulaMaestraDetalleFPActividadMaterialItem);
                }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public String registrarFormulaMaestraDetalleFPActividadMaterial_action(){
        try {
            con=Util.openConnection(con);
               String consulta = "INSERT INTO FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MATERIAL ( COD_FASE_MATERIAL, COD_FASE_ACTIVIDAD,  COD_MATERIAL,  CANTIDAD,COD_FASE_PREPARADO,TEMPERATURA1,TEMPERATURA2) " +
                       " VALUES ((select isnull(MAX(COD_FASE_MATERIAL),0) +1 from FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MATERIAL where COD_FASE_ACTIVIDAD = '"+formulaMaestraDetalleFPActividad.getCodFaseActividad()+"' AND COD_FASE_PREPARADO= '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"'), '"+formulaMaestraDetalleFPActividad.getCodFaseActividad()+"'" +
                       " ,'"+formulaMaestraDetalleFPActividadMaterial.getMateriales().getCodMaterial()+"', '"+formulaMaestraDetalleFPActividadMaterial.getCantidad()+"','"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"', " +
                       "'"+formulaMaestraDetalleFPActividadMaterial.getTemperatura1()+"','"+formulaMaestraDetalleFPActividadMaterial.getTemperatura2()+"');";
               
               System.out.println("consulta" + consulta);

               Statement st = con.createStatement();
               st.executeUpdate(consulta);
               this.cargarFormulaMaestraDetalleFPActividadMaterial();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String agregarFormulaMaestraDetalleFPActividadMaterial_action(){
        try {
                formulaMaestraDetalleFPActividadMaterial = new FormulaMaestraDetalleFPActividadMaterial();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarFormulaMaestraDetalleFPActividadMaterial_action(){
        try {
               con=Util.openConnection(con);
               String consulta = "";
               Iterator i = formulaMaestraDetalleFPActividadMaterialList.iterator();
               while(i.hasNext()){

                   FormulaMaestraDetalleFPActividadMaterial formulaMaestraDetalleFPActividadMaterialItem =  (FormulaMaestraDetalleFPActividadMaterial) i.next();
                   if(formulaMaestraDetalleFPActividadMaterialItem.getChecked().booleanValue()==true){
                       consulta =" DELETE FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MATERIAL WHERE  COD_FASE_MATERIAL= '"+formulaMaestraDetalleFPActividadMaterialItem.getCodFaseMaterial()+"' " +
                               " AND COD_FASE_ACTIVIDAD= '"+formulaMaestraDetalleFPActividadMaterialItem.getFormulaMaestraDetalleFPActividad().getCodFaseActividad()+"'" +
                               " and COD_FASE_PREPARADO = '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"' ";

                        System.out.println("consulta" + consulta);
                        Statement st = con.createStatement();
                        st.executeUpdate(consulta);

                       break;
                   }


               }
               this.cargarFormulaMaestraDetalleFPActividadMaterial();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String editarFormulaMaestraDetalleFPActividad_action(){
        try {
               con=Util.openConnection(con);
               Iterator i = formulaMaestraDetalleFPActividadMaterialList.iterator();
               while(i.hasNext()){
                   FormulaMaestraDetalleFPActividadMaterial formulaMaestraFaseActividadMaterialItem = (FormulaMaestraDetalleFPActividadMaterial) i.next();
                   if(formulaMaestraFaseActividadMaterialItem.getChecked().booleanValue()==true){
                       formulaMaestraDetalleFPActividadMaterial =formulaMaestraFaseActividadMaterialItem;
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

            String consulta = " UPDATE FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MATERIAL  SET " +
                     " COD_MATERIAL = '"+formulaMaestraDetalleFPActividadMaterial.getMateriales().getCodMaterial()+"',  CANTIDAD = '"+formulaMaestraDetalleFPActividadMaterial.getCantidad()+"',  COD_UNIDAD = '"+formulaMaestraDetalleFPActividadMaterial.getMateriales().getUnidadesMedida().getCodUnidadMedida()+"'," +
                     " TEMPERATURA1 = '"+formulaMaestraDetalleFPActividadMaterial.getTemperatura1()+"',TEMPERATURA2 ='"+formulaMaestraDetalleFPActividadMaterial.getTemperatura2()+"' " +
                     " WHERE COD_FASE_MATERIAL = '"+formulaMaestraDetalleFPActividadMaterial.getCodFaseMaterial()+"' AND COD_FASE_ACTIVIDAD='"+formulaMaestraDetalleFPActividadMaterial.getFormulaMaestraDetalleFPActividad().getCodFaseActividad()+"'  " +
                     " AND COD_FASE_PREPARADO = '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"'  ";
                     
             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);
             this.cargarFormulaMaestraDetalleFPActividadMaterial();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void cargarMateriales() {
        try {
            con = (Util.openConnection(con));
            String consulta = " select m.COD_MATERIAL, m.NOMBRE_MATERIAL from formula_maestra fm  " +
                    " inner join FORMULA_MAESTRA_DETALLE_MP fmd on fmd.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA  " +
                    " inner join materiales m on m.COD_MATERIAL = fmd.COD_MATERIAL where fm.COD_FORMULA_MAESTRA = '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getFormulaMaestraPreparado().getFormulaMaestra().getCodFormulaMaestra()+"' ";
            System.out.println("consulta" + consulta);
            ResultSet rs = null;
            
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            materialesList.clear();
            rs = st.executeQuery(consulta);
            materialesList.add(new SelectItem("0", "-SELECCIONE MATERIAL-"));
            while (rs.next()) {
                materialesList.add(new SelectItem(rs.getString("COD_MATERIAL"), rs.getString("NOMBRE_MATERIAL")));
            }

            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String material_change(){
        try {
            String consulta = "select u.NOMBRE_UNIDAD_MEDIDA from UNIDADES_MEDIDA u " +
                    " where u.COD_UNIDAD_MEDIDA IN (SELECT COD_UNIDAD_MEDIDA FROM MATERIALES WHERE COD_MATERIAL = '"+formulaMaestraDetalleFPActividadMaterial.getMateriales().getCodMaterial()+"' ) " +
                    " and u.COD_ESTADO_REGISTRO = 1" ;
            System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);            
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                formulaMaestraDetalleFPActividadMaterial.getMateriales().getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }




}
