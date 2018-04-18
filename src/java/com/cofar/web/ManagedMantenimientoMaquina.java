/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.MantenimientoMaquina;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;

/**
 *
 * @author sistemas1
 */

public class ManagedMantenimientoMaquina {
    private Connection con;
    /** Creates a new instance of ManagedMantenimientoMaquina */
    public ManagedMantenimientoMaquina() {

    }
    List mantenimientoMaquinaList = new ArrayList();
    MantenimientoMaquina mantenimientoMaquina = new MantenimientoMaquina();
    
    
    
    List programaProduccionList = new ArrayList();
    List tipoMantenimientoList = new ArrayList();
    List maquinariaList = new ArrayList();
    List frecuenciaMantenimientoMaquinaList = new ArrayList();
            
    // <editor-fold defaultstate="collapsed" desc="getter y setters">

    public List getMantenimientoMaquinaList() {
        return mantenimientoMaquinaList;
    }

    public void setMantenimientoMaquinaList(List mantenimientoMaquinaList) {
        this.mantenimientoMaquinaList = mantenimientoMaquinaList;
    }


    public List getFrecuenciaMantenimientoMaquinaList() {
        return frecuenciaMantenimientoMaquinaList;
    }

    public void setFrecuenciaMantenimientoMaquinaList(List frecuenciaMantenimientoMaquinaList) {
        this.frecuenciaMantenimientoMaquinaList = frecuenciaMantenimientoMaquinaList;
    }

    public List getMaquinariaList() {
        return maquinariaList;
    }

    public void setMaquinariaList(List maquinariaList) {
        this.maquinariaList = maquinariaList;
    }

    public List getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }

    public List getTipoMantenimientoList() {
        return tipoMantenimientoList;
    }

    public void setTipoMantenimientoList(List tipoMantenimientoList) {
        this.tipoMantenimientoList = tipoMantenimientoList;
    }

    public MantenimientoMaquina getMantenimientoMaquina() {
        return mantenimientoMaquina;
    }

    public void setMantenimientoMaquina(MantenimientoMaquina mantenimientoMaquina) {
        this.mantenimientoMaquina = mantenimientoMaquina;
    }


    // </editor-fold>

    public void cargarMantenimientoMaquina(){
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = " SELECT  mm.COD_MANTENIMIENTO_MAQUINA, mm.COD_PROGRAMA_PROD, mm.COD_TIPO_MANTENIMIENTO, mm.COD_MAQUINA, " +
                    " mm.FECHA_REGISTRO, mm.COD_FRECUENCIA_MANTENIMIENTO_MAQUINA, pprp.NOMBRE_PROGRAMA_PROD, tp.NOMBRE_TIPO_MANTEMINIENTO, " +
                    " m.NOMBRE_MAQUINA, fmm.HORAS_FRECUENCIA,tpr.NOMBRE_TIPO_PERIODO FROM  MANTENIMIENTO_MAQUINARIA mm inner join PROGRAMA_PRODUCCION_PERIODO pprp on pprp.COD_PROGRAMA_PROD = mm.COD_PROGRAMA_PROD " +
                    " inner join TIPOS_MANTENIMIENTO tp on tp.COD_TIPO_MANTEMINIENTO = mm.COD_TIPO_MANTENIMIENTO " +
                    " inner join maquinarias m on m.COD_MAQUINA = mm.COD_MAQUINA " +
                    " inner join FRECUENCIAS_MANTENIMIENTO_MAQUINA fmm  on fmm.COD_FRECUENCIA_MANTENIMIENTO_MAQUINA = mm.COD_FRECUENCIA_MANTENIMIENTO_MAQUINA   " +
                    " inner join TIPOS_PERIODO tpr on tpr.COD_TIPO_PERIODO = fmm.COD_TIPO_PERIODO";
            ResultSet rs = st.executeQuery(consulta);
            mantenimientoMaquinaList.clear();
            while(rs.next()){
                MantenimientoMaquina mantenimientoMaquinaItem = new MantenimientoMaquina();
                mantenimientoMaquinaItem.setCodMantenimientoMaquina(rs.getInt("COD_MANTENIMIENTO_MAQUINA"));
                mantenimientoMaquinaItem.getProgramaProduccionPeriodo().setCodProgramaProduccion(rs.getString("COD_PROGRAMA_PROD"));
                mantenimientoMaquinaItem.getProgramaProduccionPeriodo().setNombreProgramaProduccion(rs.getString("NOMBRE_PROGRAMA_PROD"));
                mantenimientoMaquinaItem.getTiposMantenimiento().setCodTipoMantenimiento(rs.getInt("COD_TIPO_MANTENIMIENTO"));
                mantenimientoMaquinaItem.getTiposMantenimiento().setNombreTipoMantenimiento(rs.getString("NOMBRE_TIPO_MANTEMINIENTO"));
                mantenimientoMaquinaItem.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINA"));
                mantenimientoMaquinaItem.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                mantenimientoMaquinaItem.setFechaRegistro(rs.getDate("FECHA_REGISTRO"));
                mantenimientoMaquinaItem.getFrecuenciasMantenimientoMaquina().setCodFrecuencia(rs.getInt("COD_FRECUENCIA_MANTENIMIENTO_MAQUINA"));
                mantenimientoMaquinaItem.getFrecuenciasMantenimientoMaquina().setHorasFrecuencia(rs.getFloat("HORAS_FRECUENCIA"));
                //mantenimientoMaquinaItem.getFrecuenciasMantenimientoMaquina().getTiposPeriodo().setNombreTipoPeriodo(rs.getString("NOMBRE_TIPO_PERIODO"));
                mantenimientoMaquinaList.add(mantenimientoMaquinaItem);
            }            
        } catch (Exception e) {
            e.printStackTrace();
        }        
    }
    public String getCargarMantenimientoMaquinas(){
        this.cargarMantenimientoMaquina();
        return null;
    }

    public String agregarMantenimientoMaquina_action(){
        try {                        
            mantenimientoMaquina = new MantenimientoMaquina();
            this.cargarProgramasProduccion();
            this.cargarMaquinaria();
            frecuenciaMantenimientoMaquinaList.clear();
            frecuenciaMantenimientoMaquinaList.add(new SelectItem("-1","-NINGUNO-"));
            this.cargarTiposMantenimientoMaquina();            
            this.redireccionar("agregar_mantenimiento_maquinaria.jsf");
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

    public void cargarTiposMantenimientoMaquina(){
        try {
            con = Util.openConnection(con);
            String consulta = "SELECT COD_TIPO_MANTEMINIENTO, NOMBRE_TIPO_MANTEMINIENTO, COD_ESTADO_REGISTRO FROM  TIPOS_MANTENIMIENTO  WHERE COD_ESTADO_REGISTRO=1 ";
            System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            tipoMantenimientoList.clear();
            while (rs.next()) {
                    tipoMantenimientoList.add(new SelectItem(rs.getString("COD_TIPO_MANTEMINIENTO"), rs.getString("NOMBRE_TIPO_MANTEMINIENTO")));
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

    public void cargarProgramasProduccion(){
        try {
            con = Util.openConnection(con);
            String consulta = "SELECT COD_PROGRAMA_PROD,   NOMBRE_PROGRAMA_PROD,   OBSERVACIONES,   COD_ESTADO_PROGRAMA FROM  PROGRAMA_PRODUCCION_PERIODO pprp where pprp.COD_ESTADO_PROGRAMA=2 ";
            System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionList.clear();
            while (rs.next()) {
                    programaProduccionList.add(new SelectItem(rs.getString("COD_PROGRAMA_PROD"), rs.getString("NOMBRE_PROGRAMA_PROD")));
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

    public void cargarMaquinaria(){
        try {
            con = Util.openConnection(con);
            String consulta = "SELECT COD_MAQUINA, NOMBRE_MAQUINA  FROM " +
                    " MAQUINARIAS WHERE COD_ESTADO_REGISTRO = 1 ORDER BY NOMBRE_MAQUINA ASC ";
                System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            maquinariaList.clear();
            maquinariaList.add(new SelectItem("-1","-NUNGUNO-"));
            while (rs.next()) {
                    maquinariaList.add(new SelectItem(rs.getString("COD_MAQUINA"), rs.getString("NOMBRE_MAQUINA")));
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
    public void cargarFrecuenciaMantenimientoMaquina(){
        try {
           con = Util.openConnection(con);
            String consulta = " SELECT f.COD_FRECUENCIA_MANTENIMIENTO_MAQUINA, f.COD_MAQUINA, f.COD_TIPO_PERIODO, f.HORAS_FRECUENCIA ,m.NOMBRE_MAQUINA,t.NOMBRE_TIPO_PERIODO " +
                    " FROM FRECUENCIAS_MANTENIMIENTO_MAQUINA f inner join MAQUINARIAS m on f.COD_MAQUINA = m.COD_MAQUINA inner join TIPOS_PERIODO t on t.COD_TIPO_PERIODO = f.COD_TIPO_PERIODO " +
                    " WHERE m.COD_MAQUINA = " + mantenimientoMaquina.getMaquinaria().getCodMaquina();
                    System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            frecuenciaMantenimientoMaquinaList.clear();
            frecuenciaMantenimientoMaquinaList.add(new SelectItem("-1","-NINGUNO-"));
            while (rs.next()) {
                    frecuenciaMantenimientoMaquinaList.add(new SelectItem(rs.getString("COD_FRECUENCIA_MANTENIMIENTO_MAQUINA"), "("+rs.getString("HORAS_FRECUENCIA")+")"+rs.getString("NOMBRE_TIPO_PERIODO")));
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
    public String maquinaria_change(){
        try {
            con = Util.openConnection(con);
            String consulta = " SELECT f.COD_FRECUENCIA_MANTENIMIENTO_MAQUINA, f.COD_MAQUINA, f.COD_TIPO_PERIODO, f.HORAS_FRECUENCIA ,m.NOMBRE_MAQUINA,t.NOMBRE_TIPO_PERIODO " +
                    " FROM FRECUENCIAS_MANTENIMIENTO_MAQUINA f inner join MAQUINARIAS m on f.COD_MAQUINA = m.COD_MAQUINA inner join TIPOS_PERIODO t on t.COD_TIPO_PERIODO = f.COD_TIPO_PERIODO " +
                    " WHERE m.COD_MAQUINA = " + mantenimientoMaquina.getMaquinaria().getCodMaquina();           
                    System.out.println("consulta" + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            frecuenciaMantenimientoMaquinaList.clear();
            frecuenciaMantenimientoMaquinaList.add(new SelectItem("-1","-NINGUNO-"));
            while (rs.next()) {
                    frecuenciaMantenimientoMaquinaList.add(new SelectItem(rs.getString("COD_FRECUENCIA_MANTENIMIENTO_MAQUINA"), "("+rs.getString("HORAS_FRECUENCIA")+")"+rs.getString("NOMBRE_TIPO_PERIODO")));
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
        return null;
    }
    public String guardarMantenimientoMaquina_action(){
        try {
            con = Util.openConnection(con);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            
            String consulta = "  INSERT INTO MANTENIMIENTO_MAQUINARIA ( COD_MANTENIMIENTO_MAQUINA, COD_PROGRAMA_PROD,   COD_TIPO_MANTENIMIENTO, " +
                    "  COD_MAQUINA,   FECHA_REGISTRO,   COD_FRECUENCIA_MANTENIMIENTO_MAQUINA )  " +
                    " VALUES ( (select isnull(max(COD_MANTENIMIENTO_MAQUINA),0)+1 from mantenimiento_maquinaria),"+mantenimientoMaquina.getProgramaProduccionPeriodo().getCodProgramaProduccion()+" ," +
                    "  "+ mantenimientoMaquina.getTiposMantenimiento().getCodTipoMantenimiento() +", "+mantenimientoMaquina.getMaquinaria().getCodMaquina()+", " +
                    "  '"+sdf.format(new Date())+"' ,"+mantenimientoMaquina.getFrecuenciasMantenimientoMaquina().getCodFrecuencia()+"   ) ";
            System.out.println("inserta mantenimiento maquinaria " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);
            this.redireccionar("navegador_mantenimiento_maquinaria.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
   public String cancelarAgregarMantenimientoMaquina_action(){
        try {            
            this.redireccionar("navegador_mantenimiento_maquinaria.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     
   public String cancelarEditarMantenimientoMaquina_action(){
        try {
            this.redireccionar("navegador_mantenimiento_maquinaria.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String editarMantenimientoMaquina_action(){
        try {
            Iterator i = mantenimientoMaquinaList.iterator();
            while(i.hasNext()){
                MantenimientoMaquina mantenimientoMaquinaItem = (MantenimientoMaquina)i.next();
                if(mantenimientoMaquinaItem.getChecked().booleanValue()){
                    mantenimientoMaquina = mantenimientoMaquinaItem;
                    break;
                }
            }
            this.cargarProgramasProduccion();
            this.cargarMaquinaria();
            this.cargarTiposMantenimientoMaquina();
            this.cargarFrecuenciaMantenimientoMaquina();
            this.redireccionar("editar_mantenimiento_maquinaria.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

   public String aceptarEditarMantenimientoMaquina_action(){
       try {
            con = Util.openConnection(con);
            String consulta = " UPDATE MANTENIMIENTO_MAQUINARIA  SET  COD_PROGRAMA_PROD = "+mantenimientoMaquina.getProgramaProduccionPeriodo().getCodProgramaProduccion()+", " +
                    " COD_TIPO_MANTENIMIENTO = "+ mantenimientoMaquina.getTiposMantenimiento().getCodTipoMantenimiento() +", " +
                    " COD_MAQUINA = "+mantenimientoMaquina.getMaquinaria().getCodMaquina()+", " +
                    " COD_FRECUENCIA_MANTENIMIENTO_MAQUINA = "+mantenimientoMaquina.getFrecuenciasMantenimientoMaquina().getCodFrecuencia()+" " +
                    " WHERE  COD_MANTENIMIENTO_MAQUINA = "+mantenimientoMaquina.getCodMantenimientoMaquina()+" ";

            System.out.println("actualiza mantenimiento maquinaria " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);
            this.redireccionar("navegador_mantenimiento_maquinaria.jsf");
       } catch (Exception e) {
           e.printStackTrace();
       }
       return null;
   }
   public String eliminarMantenimientoMaquina_action(){
        try {
            Iterator i = mantenimientoMaquinaList.iterator();
            while(i.hasNext()){
                MantenimientoMaquina mantenimientoMaquinaItem = (MantenimientoMaquina)i.next();
                if(mantenimientoMaquinaItem.getChecked().booleanValue()){
                    mantenimientoMaquina = mantenimientoMaquinaItem;
                    break;
                }
            }
            con = Util.openConnection(con);
            String consulta = " DELETE FROM MANTENIMIENTO_MAQUINARIA  WHERE  COD_MANTENIMIENTO_MAQUINA = "+mantenimientoMaquina.getCodMantenimientoMaquina()+" ";
                        
            System.out.println("borra mantenimiento maquinaria " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);
            consulta = " DELETE FROM  MANTENIMIENTO_MAQUINARIA_DETALLE  WHERE  COD_MANTENIMIENTO_MAQUINA = "+mantenimientoMaquina.getCodMantenimientoMaquina()+" ";
            System.out.println("borra mantenimiento maquinaria " + consulta);            
            st.executeUpdate(consulta);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }




}
