/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.reporte;

import com.cofar.bean.ProgramaProduccion;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.faces.model.SelectItem;

/**
 *
 * @author sistemas1
 */

public class ManagedReporteProgramaProduccion {

    /** Creates a new instance of ManagedReporteProgramaProduccion */
    private List programaProduccionList=new ArrayList();
    private List areaProduccionList=new ArrayList();
    private List componentesProduccionList=new ArrayList();
    private Date fechaInicial = new Date();
    private Date fechaFinal = new Date();
    private ProgramaProduccion programaProduccion = new ProgramaProduccion();
    private Connection con;

    public List getAreaProduccionList() {
        return areaProduccionList;
    }

    public void setAreaProduccionList(List areaProduccionList) {
        this.areaProduccionList = areaProduccionList;
    }

    public List getComponentesProduccionList() {
        return componentesProduccionList;
    }

    public void setComponentesProduccionList(List componentesProduccionList) {
        this.componentesProduccionList = componentesProduccionList;
    }

    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public Date getFechaInicial() {
        return fechaInicial;
    }

    public void setFechaInicial(Date fechaInicial) {
        this.fechaInicial = fechaInicial;
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public List getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }
    

    public ManagedReporteProgramaProduccion() {
    }

    public String getCargarDatosReporteProgramaProduccion(){
        try {
                this.cargarProgramaProduccion();
                this.cargarAreasProduccion();
                this.cargarComponentesProduccion();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarProgramaProduccion(){
        try {
            programaProduccionList.clear();
            
            con=Util.openConnection(con);

            String consulta = " SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES (SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA) FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 ";
            ResultSet rs=null;

            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(consulta);
                
                while(rs.next()){
                    programaProduccionList.add(new SelectItem(rs.getString("COD_PROGRAMA_PROD"),rs.getString("NOMBRE_PROGRAMA_PROD")));
                }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }       
    }
    public void cargarComponentesProduccion(){
        try {
            componentesProduccionList.clear();

            con=Util.openConnection(con);

            String consulta = " SELECT PPR.COD_PROGRAMA_PROD,PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD ,CPR.nombre_prod_semiterminado ,FM.COD_FORMULA_MAESTRA  " +
                    " FROM PROGRAMA_PRODUCCION PPR INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = PPR.COD_FORMULA_MAESTRA " +
                    " AND CPR.COD_COMPPROD = FM.COD_COMPPROD WHERE PPR.COD_ESTADO_PROGRAMA IN (2,5) AND PPR.COD_PROGRAMA_PROD='"+programaProduccion.getCodProgramaProduccion()+"' " +
                    " ORDER BY CPR.nombre_prod_semiterminado ";
            
            ResultSet rs=null;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(consulta);

                while(rs.next()){
                    componentesProduccionList.add(new SelectItem(rs.getString("COD_LOTE_PRODUCCION")+rs.getString("COD_COMPPROD"),
                            "("+rs.getString("COD_LOTE_PRODUCCION")+") "+rs.getString("nombre_prod_semiterminado")));
                    
                }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void cargarAreasProduccion(){
        try {
            areaProduccionList.clear();

            con=Util.openConnection(con);

            String consulta = " SELECT PPR.COD_PROGRAMA_PROD,PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD ,CPR.nombre_prod_semiterminado ,FM.COD_FORMULA_MAESTRA  " +
                    " FROM PROGRAMA_PRODUCCION PPR INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = PPR.COD_FORMULA_MAESTRA " +
                    " AND CPR.COD_COMPPROD = FM.COD_COMPPROD WHERE PPR.COD_ESTADO_PROGRAMA IN (2,5) AND PPR.COD_PROGRAMA_PROD='"+programaProduccion.getCodProgramaProduccion()+"' " +
                    " ORDER BY CPR.nombre_prod_semiterminado ";
                    
            ResultSet rs=null;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(consulta);

                while(rs.next()){
                    areaProduccionList.add(new SelectItem(rs.getString("COD_LOTE_PRODUCCION")+rs.getString("COD_COMPPROD"),
                            "("+rs.getString("COD_LOTE_PRODUCCION")+") "+rs.getString("nombre_prod_semiterminado")));

                }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }



}
