/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.FormulaMaestraDetalleFPActividad;
import com.cofar.bean.FormulaMaestraDetalleFPActividadMaquinaria;
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

/**
 *
 * @author hvaldivia
 */

public class ManagedFormulaMaestraDetalleFPActividadMaquinaria {
    Connection con = null;
    FormulaMaestraDetalleFPActividad formulaMaestraDetalleFPActividad = new FormulaMaestraDetalleFPActividad();
    List formulaMaestraDetalleFPActividadMaquinariaList = new ArrayList();
    FormulaMaestraDetalleFPActividadMaquinaria formulaMaestraDetalleFPActividadMaquinaria = new FormulaMaestraDetalleFPActividadMaquinaria();
    List maquinariasList = new ArrayList();
    List unidadesCaudalList = new ArrayList();
    List unidadesVelocidadList = new ArrayList();

    public FormulaMaestraDetalleFPActividadMaquinaria getFormulaMaestraDetalleFPActividadMaquinaria() {
        return formulaMaestraDetalleFPActividadMaquinaria;
    }

    public void setFormulaMaestraDetalleFPActividadMaquinaria(FormulaMaestraDetalleFPActividadMaquinaria formulaMaestraDetalleFPActividadMaquinaria) {
        this.formulaMaestraDetalleFPActividadMaquinaria = formulaMaestraDetalleFPActividadMaquinaria;
    }

    public List getFormulaMaestraDetalleFPActividadMaquinariaList() {
        return formulaMaestraDetalleFPActividadMaquinariaList;
    }

    public void setFormulaMaestraDetalleFPActividadMaquinariaList(List formulaMaestraDetalleFPActividadMaquinariaList) {
        this.formulaMaestraDetalleFPActividadMaquinariaList = formulaMaestraDetalleFPActividadMaquinariaList;
    }

    public List getMaquinariasList() {
        return maquinariasList;
    }

    public void setMaquinariasList(List maquinariasList) {
        this.maquinariasList = maquinariasList;
    }

    public List getUnidadesCaudalList() {
        return unidadesCaudalList;
    }

    public void setUnidadesCaudalList(List unidadesCaudalList) {
        this.unidadesCaudalList = unidadesCaudalList;
    }

    public List getUnidadesVelocidadList() {
        return unidadesVelocidadList;
    }

    public void setUnidadesVelocidadList(List unidadesVelocidadList) {
        this.unidadesVelocidadList = unidadesVelocidadList;
    }
    
    


    /** Creates a new instance of ManagedFormulaMaestraDetalleFPActividadMaquinaria */
    public ManagedFormulaMaestraDetalleFPActividadMaquinaria() {
    }

    public String getCargarContenidoFormulaMaestraDetalleFPActividadMaquinaria(){
        try {
                this.cargarFormulaMaestraDetalleFPActividadMaquinaria();
                this.cargarMaquinaria();
                this.cargarUnidadesCaudalMaquina();
                this.cargarUnidadesVelocidadMaquina();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarFormulaMaestraDetalleFPActividadMaquinaria(){
        try {
                ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
                Map<String, Object> sessionMap = externalContext.getSessionMap();
                formulaMaestraDetalleFPActividad=(FormulaMaestraDetalleFPActividad)sessionMap.get("formulaMaestraDetalleFPActividad");


                con = Util.openConnection(con);
                String consulta = " SELECT FMD.COD_FASE_MAQUINARIA, FMD.COD_FASE_ACTIVIDAD, FMD.COD_MAQUINARIA, FMD.CAUDAL_MAQUINARIA, FMD.COD_UNIDAD_CAUDAL, " +
                        " FMD.VELOCIDAD_MAQUINARIA,FMD.COD_UNIDAD_VELOCIDAD,FMD.TIEMPO_MAQUINARIA,M.NOMBRE_MAQUINA,U1.NOMBRE_UNIDAD_VELOCIDAD NOMBRE_UNIDAD_VELOCIDAD_CAUDAL,U2.NOMBRE_UNIDAD_VELOCIDAD NOMBRE_UNIDAD_VELOCIDAD " +
                        " FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MAQUINARIA FMD  " +
                        " INNER JOIN MAQUINARIAS M ON FMD.COD_MAQUINARIA = M.COD_MAQUINA " +
                        " INNER JOIN UNIDADES_VELOCIDAD_MAQUINARIA U1 ON U1.COD_UNIDAD_VELOCIDAD = FMD.COD_UNIDAD_CAUDAL " +
                        " INNER JOIN UNIDADES_VELOCIDAD_MAQUINARIA U2 ON U2.COD_UNIDAD_VELOCIDAD = FMD.COD_UNIDAD_VELOCIDAD " +
                        " WHERE FMD.COD_FASE_PREPARADO = '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"' " +
                        " AND FMD.COD_FASE_ACTIVIDAD = '"+formulaMaestraDetalleFPActividad.getCodFaseActividad()+"' ORDER BY FMD.COD_FASE_MAQUINARIA ASC ";

                System.out.println("consulta" + consulta);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(consulta);
                formulaMaestraDetalleFPActividadMaquinariaList.clear();
                while(rs.next()){
                   
                    FormulaMaestraDetalleFPActividadMaquinaria formulaMaestraDetalleFPActividadMaquinariaItem = new FormulaMaestraDetalleFPActividadMaquinaria();
                    formulaMaestraDetalleFPActividadMaquinariaItem.setCodFaseMaquinaria(rs.getInt("COD_FASE_MAQUINARIA"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.setFormulaMaestraFaseActividad(formulaMaestraDetalleFPActividad);
                    formulaMaestraDetalleFPActividadMaquinariaItem.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINARIA"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.setCaudalMaquinaria(rs.getFloat("CAUDAL_MAQUINARIA"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.getUnidadesCaudalMaquinaria().setCodUnidadVelocidad(rs.getInt("COD_UNIDAD_CAUDAL"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.getUnidadesCaudalMaquinaria().setNombreUnidadVelocidad(rs.getString("NOMBRE_UNIDAD_VELOCIDAD_CAUDAL"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.setVelocidadMaquinaria(rs.getFloat("VELOCIDAD_MAQUINARIA"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.getUnidadesVelocidadMaquinaria().setCodUnidadVelocidad(rs.getInt("COD_UNIDAD_VELOCIDAD"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.getUnidadesVelocidadMaquinaria().setNombreUnidadVelocidad(rs.getString("NOMBRE_UNIDAD_VELOCIDAD"));
                    formulaMaestraDetalleFPActividadMaquinariaItem.setTiempoMaquinaria(rs.getFloat("TIEMPO_MAQUINARIA"));

                    formulaMaestraDetalleFPActividadMaquinariaList.add(formulaMaestraDetalleFPActividadMaquinariaItem);



                }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public String registrarFormulaMaestraDetalleFPActividadMaquinaria_action(){
        try {
            con=Util.openConnection(con);
               String consulta = " INSERT INTO FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MAQUINARIA(  COD_FASE_MAQUINARIA,  COD_FASE_ACTIVIDAD,  COD_MAQUINARIA," +
                       "  CAUDAL_MAQUINARIA,  COD_UNIDAD_CAUDAL,  VELOCIDAD_MAQUINARIA,  COD_UNIDAD_VELOCIDAD,  TIEMPO_MAQUINARIA,  COD_FASE_PREPARADO) " +
                       " VALUES ((select isnull(MAX(COD_FASE_MAQUINARIA),0) +1 from FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MAQUINARIA where COD_FASE_ACTIVIDAD = '"+formulaMaestraDetalleFPActividad.getCodFaseActividad()+"' AND COD_FASE_PREPARADO= '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"')" +
                       " ,'"+formulaMaestraDetalleFPActividad.getCodFaseActividad()+"'" +
                       ", '"+formulaMaestraDetalleFPActividadMaquinaria.getMaquinaria().getCodMaquina()+"' , '"+formulaMaestraDetalleFPActividadMaquinaria.getCaudalMaquinaria()+"', " +
                       " '"+formulaMaestraDetalleFPActividadMaquinaria.getUnidadesCaudalMaquinaria().getCodUnidadVelocidad()+"',  '"+formulaMaestraDetalleFPActividadMaquinaria.getUnidadesCaudalMaquinaria().getCodUnidadVelocidad() +"'," +
                       " '"+formulaMaestraDetalleFPActividadMaquinaria.getUnidadesVelocidadMaquinaria().getCodUnidadVelocidad()+"', '"+formulaMaestraDetalleFPActividadMaquinaria.getTiempoMaquinaria()+"',  '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"' ); ";

               

               System.out.println("consulta" + consulta);

               Statement st = con.createStatement();
               st.executeUpdate(consulta);
               this.cargarFormulaMaestraDetalleFPActividadMaquinaria();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String agregarFormulaMaestraDetalleFPActividadMaquinaria_action(){
        try {
                formulaMaestraDetalleFPActividadMaquinaria = new FormulaMaestraDetalleFPActividadMaquinaria();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarFormulaMaestraDetalleFPActividadMaquinaria_action(){
        try {
               con=Util.openConnection(con);
               String consulta = "";
               Iterator i = formulaMaestraDetalleFPActividadMaquinariaList.iterator();
               while(i.hasNext()){

                   FormulaMaestraDetalleFPActividadMaquinaria formulaMaestraDetalleFPActividadMaquinariaItem =  (FormulaMaestraDetalleFPActividadMaquinaria) i.next();
                   if(formulaMaestraDetalleFPActividadMaquinariaItem.getChecked().booleanValue()==true){
                       
                       consulta = " DELETE FROM FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MAQUINARIA WHERE COD_FASE_MAQUINARIA='"+formulaMaestraDetalleFPActividadMaquinariaItem.getCodFaseMaquinaria()+"'  " +
                               " AND COD_FASE_ACTIVIDAD = '"+formulaMaestraDetalleFPActividadMaquinariaItem.getFormulaMaestraFaseActividad().getCodFaseActividad()+"' " +
                               " AND COD_FASE_PREPARADO = '"+formulaMaestraDetalleFPActividadMaquinariaItem.getFormulaMaestraFaseActividad().getFormulaMaestraFasePreparado().getCodFasePreparado()+"'" ;

                        System.out.println("consulta" + consulta);
                        Statement st = con.createStatement();
                        st.executeUpdate(consulta);

                       break;
                   }


               }
               this.cargarFormulaMaestraDetalleFPActividadMaquinaria();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String editarFormulaMaestraDetalleFPActividadMaquinaria_action(){
        try {
               con=Util.openConnection(con);
               Iterator i = formulaMaestraDetalleFPActividadMaquinariaList.iterator();
               while(i.hasNext()){
                   FormulaMaestraDetalleFPActividadMaquinaria formulaMaestraFaseActividadMaquinariaItem = (FormulaMaestraDetalleFPActividadMaquinaria) i.next();
                   if(formulaMaestraFaseActividadMaquinariaItem.getChecked().booleanValue()==true){
                       formulaMaestraDetalleFPActividadMaquinaria =formulaMaestraFaseActividadMaquinariaItem;
                       break;
                   }
               }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEdicionFormulaMaestraFPActividadMaquinaria_action(){
        try {
            con=Util.openConnection(con);

            String consulta = " UPDATE FORMULA_MAESTRA_DETALLE_FP_ACTIVIDAD_MAQUINARIA SET COD_MAQUINARIA = '"+formulaMaestraDetalleFPActividadMaquinaria.getMaquinaria().getCodMaquina() +"'," +
                    " CAUDAL_MAQUINARIA = '"+formulaMaestraDetalleFPActividadMaquinaria.getCaudalMaquinaria()+"', " +
                    " COD_UNIDAD_CAUDAL = '"+formulaMaestraDetalleFPActividadMaquinaria.getUnidadesCaudalMaquinaria().getCodUnidadVelocidad()+"'," +
                    " VELOCIDAD_MAQUINARIA = '"+formulaMaestraDetalleFPActividadMaquinaria.getVelocidadMaquinaria()+"', " +
                    " COD_UNIDAD_VELOCIDAD = '"+formulaMaestraDetalleFPActividadMaquinaria.getUnidadesVelocidadMaquinaria().getCodUnidadVelocidad()+"'," +
                    " TIEMPO_MAQUINARIA = '"+formulaMaestraDetalleFPActividadMaquinaria.getTiempoMaquinaria()+"' " +
                    " WHERE  COD_FASE_MAQUINARIA = '"+formulaMaestraDetalleFPActividadMaquinaria.getCodFaseMaquinaria()+"' " +
                    " AND COD_FASE_ACTIVIDAD = '"+formulaMaestraDetalleFPActividad.getCodFaseActividad()+"' " +
                    " AND COD_FASE_PREPARADO = '"+formulaMaestraDetalleFPActividad.getFormulaMaestraFasePreparado().getCodFasePreparado()+"'  ";

             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);
             this.cargarFormulaMaestraDetalleFPActividadMaquinaria();

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
    public void cargarUnidadesCaudalMaquina(){
        try {
            String consulta = " select u.COD_UNIDAD_VELOCIDAD ,u.NOMBRE_UNIDAD_VELOCIDAD from UNIDADES_VELOCIDAD_MAQUINARIA u where u.COD_ESTADO_REGISTRO = 1 ";
            unidadesCaudalList.clear();
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                unidadesCaudalList.add(new SelectItem(rs.getString("COD_UNIDAD_VELOCIDAD"), rs.getString("NOMBRE_UNIDAD_VELOCIDAD")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



}
