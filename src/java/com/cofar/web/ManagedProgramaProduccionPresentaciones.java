/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ProgramaProduccionPresentaciones;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.faces.model.SelectItem;

/**
 *
 * @author hvaldivia
 */

public class ManagedProgramaProduccionPresentaciones {
    List programaProduccionPresentacionesList = new ArrayList();
    List tiposProgramaProduccionList = new ArrayList();
    ProgramaProduccionPresentaciones programaProduccionPresentaciones = new ProgramaProduccionPresentaciones();
    List formulaMaestraList = new ArrayList();
    List presentacionesPrimariasList = new ArrayList();
    List presentacionesSecundariasList = new ArrayList();

    ProgramaProduccionPresentaciones programaProduccionPresentacionesEditar = new ProgramaProduccionPresentaciones();
    
    

    public List getProgramaProduccionPresentacionesList() {
        return programaProduccionPresentacionesList;
    }

    public void setProgramaProduccionPresentacionesList(List programaProduccionPresentacionesList) {
        this.programaProduccionPresentacionesList = programaProduccionPresentacionesList;
    }

    public List getTiposProgramaProduccionList() {
        return tiposProgramaProduccionList;
    }

    public void setTiposProgramaProduccionList(List tiposProgramaProduccionList) {
        this.tiposProgramaProduccionList = tiposProgramaProduccionList;
    }

    public ProgramaProduccionPresentaciones getProgramaProduccionPresentaciones() {
        return programaProduccionPresentaciones;
    }

    public void setProgramaProduccionPresentaciones(ProgramaProduccionPresentaciones programaProduccionPresentaciones) {
        this.programaProduccionPresentaciones = programaProduccionPresentaciones;
    }

    public List getFormulaMaestraList() {
        return formulaMaestraList;
    }

    public void setFormulaMaestraList(List formulaMaestraList) {
        this.formulaMaestraList = formulaMaestraList;
    }

    public List getPresentacionesPrimariasList() {
        return presentacionesPrimariasList;
    }

    public void setPresentacionesPrimariasList(List presentacionesPrimariasList) {
        this.presentacionesPrimariasList = presentacionesPrimariasList;
    }

    public List getPresentacionesSecundariasList() {
        return presentacionesSecundariasList;
    }

    public void setPresentacionesSecundariasList(List presentacionesSecundariasList) {
        this.presentacionesSecundariasList = presentacionesSecundariasList;
    }

    public ProgramaProduccionPresentaciones getProgramaProduccionPresentacionesEditar() {
        return programaProduccionPresentacionesEditar;
    }

    public void setProgramaProduccionPresentacionesEditar(ProgramaProduccionPresentaciones programaProduccionPresentacionesEditar) {
        this.programaProduccionPresentacionesEditar = programaProduccionPresentacionesEditar;
    }


    

    

    

    

    /** Creates a new instance of ManagedProgramaProduccionPresentaciones */
    public ManagedProgramaProduccionPresentaciones() {
    }
    public String getCargarContenidoProgramaProduccionPresentaciones(){
        try {
            this.cargarProgramaProduccionPresentaciones();
            tiposProgramaProduccionList = this.cargarTiposProgramaProduccion();
            formulaMaestraList = this.cargarComponentesProd();
            presentacionesPrimariasList.clear();
            presentacionesPrimariasList.add(new SelectItem("0","-NINGUNO-"));
            presentacionesSecundariasList.clear();
            presentacionesSecundariasList.add(new SelectItem("0","-NINGUNO-"));
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarProgramaProduccionPresentaciones(){
        try {
            Connection con = null;
            String consulta = new String();
            consulta = " select fm.cod_formula_maestra,cp.nombre_prod_semiterminado,tppr.cod_tipo_programa_prod,tppr.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_PRESENTACION_PRIMARIA,ep.nombre_envaseprim, pp.CANTIDAD,ppr.cod_presentacion,ppr.NOMBRE_PRODUCTO_PRESENTACION  " +
                    " from PROGRAMA_PRODUCCION_PRESENTACIONES pprp " +
                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = pprp.COD_FORMULA_MAESTRA " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                    " left outer join PRESENTACIONES_PRIMARIAS pp on pp.COD_PRESENTACION_PRIMARIA = pprp.COD_PRESENTACION_PRIMARIA " +
                    " left outer join PRESENTACIONES_PRODUCTO ppr on ppr.cod_presentacion = pprp.COD_PRESENTACION_PRODUCTO " +
                    " left outer join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = pp.COD_ENVASEPRIM " +
                    " inner join TIPOS_PROGRAMA_PRODUCCION tppr on tppr.COD_TIPO_PROGRAMA_PROD = pprp.COD_TIPO_PROGRAMA_PROD";
            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionPresentacionesList.clear();
            while(rs.next()){
                ProgramaProduccionPresentaciones programaProduccionPresentaciones = new ProgramaProduccionPresentaciones();
                programaProduccionPresentaciones.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                programaProduccionPresentaciones.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                programaProduccionPresentaciones.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                programaProduccionPresentaciones.getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                programaProduccionPresentaciones.getPresentacionesPrimarias().setCodPresentacionPrimaria(rs.getString("COD_PRESENTACION_PRIMARIA"));
                programaProduccionPresentaciones.getPresentacionesPrimarias().getEnvasesPrimarios().setNombreEnvasePrim(rs.getString("nombre_envaseprim"));
                programaProduccionPresentaciones.getPresentacionesPrimarias().setCantidad(rs.getInt("CANTIDAD"));
                programaProduccionPresentaciones.getPresentacionesProducto().setCodPresentacion(rs.getString("cod_presentacion"));
                programaProduccionPresentaciones.getPresentacionesProducto().setNombreProductoPresentacion(rs.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                programaProduccionPresentacionesList.add(programaProduccionPresentaciones);
            }
            st.close();
            rs.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
       
    }
    public List cargarTiposProgramaProduccion(){
        List tiposProgramaProduccionList = new ArrayList();
        try {
            Connection con = null;
            String consulta = " select t.COD_TIPO_PROGRAMA_PROD,t.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION t where t.COD_ESTADO_REGISTRO = 1 ";
            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            tiposProgramaProduccionList.clear();
            while(rs.next()){
                tiposProgramaProduccionList.add(new SelectItem(rs.getString("COD_TIPO_PROGRAMA_PROD"),rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tiposProgramaProduccionList;
    }
    public List cargarComponentesProd(){
        List formulaMaestraList = new ArrayList();
        try {
            Connection con = null;
            String consulta = " select fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado from COMPONENTES_PROD cp inner join FORMULA_MAESTRA fm on cp.COD_COMPPROD = fm.COD_COMPPROD order by cp.nombre_prod_semiterminado asc";
            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            formulaMaestraList.clear();
            formulaMaestraList.add(new SelectItem("0","-NINGUNO-"));
            while(rs.next()){
                formulaMaestraList.add(new SelectItem(rs.getString("COD_FORMULA_MAESTRA"),rs.getString("nombre_prod_semiterminado")));                
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formulaMaestraList;
    }
    public String formulaMaestra_change(){
        try {
            presentacionesPrimariasList = this.cargarPresentacionPrimaria();
            presentacionesSecundariasList = this.cargarPresentacionSecundaria();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List cargarPresentacionPrimaria(){
        List presentacionesPrimariasList = new ArrayList();
        try {
            Connection con = null;
            String consulta = " select fep.COD_FORMULA_MAESTRA, ep.nombre_envaseprim,  ep.cod_envaseprim, pp.CANTIDAD, pp.cod_presentacion_primaria " +
                    " from FORMULA_MAESTRA fep, PRESENTACIONES_PRIMARIAS pp, ENVASES_PRIMARIOS ep " +
                    " where PP.COD_COMPPROD = fep.COD_COMPPROD AND fep.COD_FORMULA_MAESTRA = '"+ programaProduccionPresentaciones.getFormulaMaestra().getCodFormulaMaestra() +"' " +
                    " and ep.cod_envaseprim = pp.cod_envaseprim " +
                    " order by ep.nombre_envaseprim  ";
            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            presentacionesPrimariasList.clear();
            presentacionesPrimariasList.add(new SelectItem("0","-NINGUNO-"));
            while(rs.next()){
                presentacionesPrimariasList.add(new SelectItem(rs.getString("cod_presentacion_primaria"),rs.getString("nombre_envaseprim")+" x " + rs.getString("CANTIDAD") ));
            }
            rs.close();
            st.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return presentacionesPrimariasList;
    }
    public List cargarPresentacionSecundaria(){
        List presentacionesSecundariasList = new ArrayList();
        try {
            Connection con = null;
            String consulta = " select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION,  pp.cantidad_presentacion ,pp.cod_presentacion   " +
                    " from formula_maestra fm   inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD  " +
                    " inner join COMPONENTES_PRESPROD c on c.COD_COMPPROD = cp.COD_COMPPROD  " +
                    " inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion = c.COD_PRESENTACION  " +
                    " inner join ENVASES_SECUNDARIOS es on es.COD_ENVASESEC = pp.COD_ENVASESEC  where fm.COD_FORMULA_MAESTRA = '"+ programaProduccionPresentaciones.getFormulaMaestra().getCodFormulaMaestra() +"'  ";
            
            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            presentacionesSecundariasList.clear();
            presentacionesSecundariasList.add(new SelectItem("0","-NINGUNO-"));
            while(rs.next()){
                presentacionesSecundariasList.add(new SelectItem(rs.getString("cod_presentacion"),rs.getString("NOMBRE_PRODUCTO_PRESENTACION") ));
            }
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return presentacionesSecundariasList;
    }
    public String agregarProgramaProduccionPresentaciones_action(){
        try {
            Connection con = null;
            String consulta = "INSERT INTO dbo.PROGRAMA_PRODUCCION_PRESENTACIONES ( COD_FORMULA_MAESTRA, COD_TIPO_PROGRAMA_PROD, COD_PRESENTACION_PRIMARIA, " +
                    "  COD_PRESENTACION_PRODUCTO )  VALUES (   '"+ programaProduccionPresentaciones.getFormulaMaestra().getCodFormulaMaestra() +"', '"+programaProduccionPresentaciones.getTiposProgramaProduccion().getCodTipoProgramaProd() +"', " +
                    "  '"+programaProduccionPresentaciones.getPresentacionesPrimarias().getCodPresentacionPrimaria()+"', '"+programaProduccionPresentaciones.getPresentacionesProducto().getCodPresentacion() +"'  );";
            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.execute(consulta);
            st.close();
            con.close();

            this.cargarProgramaProduccionPresentaciones();

            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarProgramaProduccionPresentaciones_action(){
        try {
            ProgramaProduccionPresentaciones programaProduccionPresentaciones = new ProgramaProduccionPresentaciones();
            Iterator i = programaProduccionPresentacionesList.iterator();
            while(i.hasNext()){
                programaProduccionPresentaciones = (ProgramaProduccionPresentaciones)i.next();
                if(programaProduccionPresentaciones.getChecked().booleanValue()==true){                    
                    break;
                }
            }
            Connection con = null;
            String consulta = " DELETE FROM PROGRAMA_PRODUCCION_PRESENTACIONES " +
                    " WHERE COD_FORMULA_MAESTRA = '"+programaProduccionPresentaciones.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " AND COD_TIPO_PROGRAMA_PROD = '"+programaProduccionPresentaciones.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'  " +
                    " AND COD_PRESENTACION_PRIMARIA = '"+programaProduccionPresentaciones.getPresentacionesPrimarias().getCodPresentacionPrimaria()+"' " +
                    " AND COD_PRESENTACION_PRODUCTO = '"+programaProduccionPresentaciones.getPresentacionesProducto().getCodPresentacion()+"' ";
            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.execute(consulta);
            st.close();
            con.close();

            this.cargarProgramaProduccionPresentaciones();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String editarProgramaProduccionPresentaciones_action(){
        try {
            programaProduccionPresentaciones = new ProgramaProduccionPresentaciones();
            Iterator i = programaProduccionPresentacionesList.iterator();
            while(i.hasNext()){
                programaProduccionPresentaciones = (ProgramaProduccionPresentaciones)i.next();
                if(programaProduccionPresentaciones.getChecked().booleanValue()==true){                    
                    break;
                }
            }
            //programaProduccionPresentacionesEditar = programaProduccionPresentaciones;
            programaProduccionPresentacionesEditar.getFormulaMaestra().setCodFormulaMaestra(programaProduccionPresentaciones.getFormulaMaestra().getCodFormulaMaestra());
            programaProduccionPresentacionesEditar.getPresentacionesPrimarias().setCodPresentacionPrimaria(programaProduccionPresentaciones.getPresentacionesPrimarias().getCodPresentacionPrimaria());
            programaProduccionPresentacionesEditar.getPresentacionesProducto().setCodPresentacion(programaProduccionPresentaciones.getPresentacionesProducto().getCodPresentacion());
            programaProduccionPresentacionesEditar.getTiposProgramaProduccion().setCodTipoProgramaProd(programaProduccionPresentaciones.getTiposProgramaProduccion().getCodTipoProgramaProd());
            this.formulaMaestra_change();


        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String guardarEditarProgramaProduccionPresentaciones_action(){
        try {

            Connection con = null;
            String consulta = " UPDATE dbo.PROGRAMA_PRODUCCION_PRESENTACIONES  " +
                    " SET  COD_FORMULA_MAESTRA = '"+programaProduccionPresentacionesEditar.getFormulaMaestra().getCodFormulaMaestra()+"'," +
                    "  COD_TIPO_PROGRAMA_PROD =  '"+programaProduccionPresentacionesEditar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"', " +
                    "  COD_PRESENTACION_PRIMARIA =  '"+programaProduccionPresentacionesEditar.getPresentacionesPrimarias().getCodPresentacionPrimaria()+"'," +
                    "  COD_PRESENTACION_PRODUCTO =  '"+programaProduccionPresentacionesEditar.getPresentacionesProducto().getCodPresentacion()+"' " +
                    " WHERE  COD_FORMULA_MAESTRA = '"+programaProduccionPresentaciones.getFormulaMaestra().getCodFormulaMaestra()+"' " +
                    " and  COD_TIPO_PROGRAMA_PROD = '"+programaProduccionPresentaciones.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                    " and  COD_PRESENTACION_PRIMARIA = '"+programaProduccionPresentaciones.getPresentacionesPrimarias().getCodPresentacionPrimaria()+"'" +
                    " and COD_PRESENTACION_PRODUCTO = '"+programaProduccionPresentaciones.getPresentacionesProducto().getCodPresentacion()+"' ";


            System.out.println("consulta " + consulta);
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.execute(consulta);
            st.close();
            con.close();

            this.cargarProgramaProduccionPresentaciones();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

   

}
