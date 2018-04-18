/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.reporte;

import com.cofar.bean.ProgramaProduccion;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.component.html.HtmlSelectBooleanCheckbox;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author sistemas1
 */

public class ManagedReporteSeguimientoProgramaProduccion {
    private List programaProduccionList=new ArrayList();
    private List areaProduccionList=new ArrayList();
    private List componentesProduccionList=new ArrayList();
    private Date fechaInicial = new Date();
    private Date fechaFinal = new Date();
    private ProgramaProduccion programaProduccion = new ProgramaProduccion();
    private Connection con;
    private String[] codAreasProduccion;
    private String[] codComponentesProduccion;
    private String[] codComponentesProduccionSeleccionados;
    private String checkTodoAreasProduccion ="";
    private String checkTodoComponentesProduccion="";
    private String codEstadoProgramaProduccion="";
    private List tipoReporteSeguimientoList=new ArrayList();
    private String codTipoReporteSeguimiento = "";
    private List estadoProgramaProduccionList=new ArrayList();
    
    /** Creates a new instance of ManagedReporteSeguimientoProgramaProduccion */
    public ManagedReporteSeguimientoProgramaProduccion() {
    }

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

    public List getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public String[] getCodAreasProduccion() {
        return codAreasProduccion;
    }

    public void setCodAreasProduccion(String[] codAreasProduccion) {
        this.codAreasProduccion = codAreasProduccion;
    }

    public String[] getCodComponentesProduccion() {
        return codComponentesProduccion;
    }

    public void setCodComponentesProduccion(String[] codComponentesProduccion) {
        this.codComponentesProduccion = codComponentesProduccion;
    }

    public String getCheckTodoAreasProduccion() {
        return checkTodoAreasProduccion;
    }

    public void setCheckTodoAreasProduccion(String checkTodoAreasProduccion) {
        this.checkTodoAreasProduccion = checkTodoAreasProduccion;
    }

    public String getCheckTodoComponentesProduccion() {
        return checkTodoComponentesProduccion;
    }

    public void setCheckTodoComponentesProduccion(String checkTodoComponentesProduccion) {
        this.checkTodoComponentesProduccion = checkTodoComponentesProduccion;
    }

    public List getEstadoProgramaProduccionList() {
        return estadoProgramaProduccionList;
    }

    public void setEstadoProgramaProduccionList(List estadoProgramaProduccionList) {
        this.estadoProgramaProduccionList = estadoProgramaProduccionList;
    }

    public String getCodEstadoProgramaProduccion() {
        return codEstadoProgramaProduccion;
    }

    public void setCodEstadoProgramaProduccion(String codEstadoProgramaProduccion) {
        this.codEstadoProgramaProduccion = codEstadoProgramaProduccion;
    }

    public List getTipoReporteSeguimientoList() {
        return tipoReporteSeguimientoList;
    }

    public void setTipoReporteSeguimientoList(List tipoReporteSeguimientoList) {
        this.tipoReporteSeguimientoList = tipoReporteSeguimientoList;
    }

    public String getCodTipoReporteSeguimiento() {
        return codTipoReporteSeguimiento;
    }

    public void setCodTipoReporteSeguimiento(String codTipoReporteSeguimiento) {
        this.codTipoReporteSeguimiento = codTipoReporteSeguimiento;
    }
    

   



    public String getCargarDatosReporteSeguimientoProgramaProduccion(){
        try {
                this.cargarProgramaProduccion();
                this.cargarEstadoProgramaProduccion();
                this.cargartipoReporteSeguimientoProgramaProduccion();
                this.checkTodoAreasProduccion="false";
                this.checkTodoComponentesProduccion ="false";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void programaProduccion_change(ValueChangeEvent event){
        try {
        System.out.println("event Produccion:"+event.getNewValue());
        String codProgramaProduccion = event.getNewValue().toString();
        this.areaProduccionList.clear();        
        
        codAreasProduccion=new String[1];
        codAreasProduccion[0]="";
        System.out.println("se reinicio codAreasProduccion");
        this.cargarAreasProduccion(codProgramaProduccion);
        this.componentesProduccionList.clear();        
        //this.cargarComponentesProduccion(codProgramaProduccion,"");
        this.checkTodoAreasProduccion="false";
        this.checkTodoComponentesProduccion ="false";        
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String seleccionaProgramaProduccion_action(ActionEvent event) {
        try{

        System.out.println(programaProduccion.getCodProgramaProduccion());
        this.areaProduccionList.clear();
        codAreasProduccion=new String[1];
        codAreasProduccion[0]="";
        System.out.println("se reinicio codAreasProduccion");
        this.cargarAreasProduccion(programaProduccion.getCodProgramaProduccion());
        this.componentesProduccionList.clear();
        //this.cargarComponentesProduccion(codProgramaProduccion,"");
        this.checkTodoAreasProduccion="false";
        this.checkTodoComponentesProduccion ="false";
            
        }catch(Exception e){
        e.printStackTrace();}
        return null;
    }
    public void areaProduccion_change(ValueChangeEvent event){
        try {
        codAreasProduccion=(String[])event.getNewValue();
        codAreasProduccion=(String[])event.getNewValue();
        String codAreasEmpresa="0";
        for(int i=0;i<codAreasProduccion.length;i++){
            codAreasEmpresa=codAreasEmpresa +","+codAreasProduccion[i] ;
        }
        System.out.println("event Area:"+codAreasProduccion[0]);
        System.out.println("event El Componente:"+event.getComponent());
        System.out.println("longitud Area:"+codAreasProduccion.length);
        System.out.println("valores Area:"+codAreasProduccion[0]);
        //String codProgramaProduccion = event.getNewValue().toString();
        this.cargarComponentesProduccion(programaProduccion.getCodProgramaProduccion() ,codAreasEmpresa,codEstadoProgramaProduccion);
        this.checkTodoAreasProduccion="false";        
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String areaProduccion_action(ActionEvent event){
        try {
        //codAreasProduccion=(String[])event.getNewValue();
        //codAreasProduccion=(String[])event.getNewValue();
        System.out.println("codAreasProduccion en areaProduccion_action :"+codAreasProduccion);
        String codAreasEmpresa="0";
        for(int i=0;i<codAreasProduccion.length;i++){
            codAreasEmpresa=codAreasEmpresa +","+codAreasProduccion[i] ;
        }
        System.out.println("event Area:"+codAreasProduccion[0]);
        System.out.println("event El Componente:"+event.getComponent());
        System.out.println("longitud Area:"+codAreasProduccion.length);
        System.out.println("valores Area:"+codAreasProduccion[0]);
        //String codProgramaProduccion = event.getNewValue().toString();
        this.cargarComponentesProduccion(programaProduccion.getCodProgramaProduccion() ,codAreasEmpresa,codEstadoProgramaProduccion);
        this.checkTodoAreasProduccion="false";
        this.checkTodoComponentesProduccion ="false";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String componentesProduccion_action(ActionEvent event) {
        try {
            this.checkTodoComponentesProduccion ="false";
        }catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }

    //el evento change


    public String seleccionaTodosAreasProduccion_action(ActionEvent event) {
        try {
            System.out.println("el componente en el evento"+event.getComponent().getParent());
            HtmlSelectBooleanCheckbox check = (HtmlSelectBooleanCheckbox)event.getComponent().getParent();
            System.out.println("el valor en el evento"+check.getValue());
            if(check.getValue().toString().equals("true")){
                //codAreasProduccion=codAreasProduccionSeleccionados;
                codAreasProduccion=new String[areaProduccionList.size()+1];
                for(int i=0;i<areaProduccionList.size();i++){
                    System.out.println("el valor iterado para llenar"  + areaProduccionList.get(i).toString());
                    javax.faces.model.SelectItem item =(javax.faces.model.SelectItem)areaProduccionList.get(i);
                    System.out.println("el valor por insertar en  los valores"  + item.getValue());
                    codAreasProduccion[i]=item.getValue().toString();
                }

                String codAreasEmpresa="0";                    
                for(int j=0;j<codAreasProduccion.length;j++){
                     codAreasEmpresa=codAreasEmpresa +","+codAreasProduccion[j] ;
                    }
                    this.cargarComponentesProduccion(programaProduccion.getCodProgramaProduccion() ,codAreasEmpresa,codEstadoProgramaProduccion);
            }else{                
                codAreasProduccion=new String[areaProduccionList.size()+1];
                codComponentesProduccion=new String[componentesProduccionList.size()+1];
                componentesProduccionList.clear();
            }             
             this.checkTodoComponentesProduccion ="false";

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String seleccionaTodosComponentesProduccion_action(ActionEvent event) {
        try {
            System.out.println("el componente en el evento"+event.getComponent().getParent());
            HtmlSelectBooleanCheckbox check = (HtmlSelectBooleanCheckbox)event.getComponent().getParent();
            System.out.println("el valor en el evento"+check.getValue());
            if(check.getValue().toString().equals("true")){
                //codAreasProduccion=codAreasProduccionSeleccionados;
                codComponentesProduccion=new String[componentesProduccionList.size()+1];
                for(int i=0;i<componentesProduccionList.size();i++){
                    System.out.println("el valor iterado para llenar"  + areaProduccionList.get(i).toString());
                    javax.faces.model.SelectItem item =(javax.faces.model.SelectItem)componentesProduccionList.get(i);
                    System.out.println("el valor por insertar en  los valores"  + item.getValue());
                    codComponentesProduccion[i]=item.getValue().toString();
                }
            }else{                
                codComponentesProduccion=new String[componentesProduccionList.size()+1];
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarProgramaProduccion(){
        try {
            programaProduccionList.clear();

            con=Util.openConnection(con);

            String consulta = " SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES ,(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA) FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 ";
            System.out.println(consulta);
            ResultSet rs=null;

            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(consulta);
                programaProduccionList.add(new SelectItem("-1","-NINGUNO-"));
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
    public void cargarComponentesProduccion(String codProgramaProduccion,String codAreaEmpresa,String codEstadoPrograma){
        try {
            componentesProduccionList.clear();

            con=Util.openConnection(con);

            String consulta = " SELECT PPR.COD_PROGRAMA_PROD,PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD ,CPR.nombre_prod_semiterminado ,FM.COD_FORMULA_MAESTRA  " +
                    " FROM PROGRAMA_PRODUCCION PPR INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = PPR.COD_FORMULA_MAESTRA " +
                    " AND CPR.COD_COMPPROD = FM.COD_COMPPROD WHERE PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoPrograma+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProduccion+"' " +
                    " AND CPR.COD_AREA_EMPRESA IN ("+codAreaEmpresa+")  " +
                    " ORDER BY CPR.nombre_prod_semiterminado ";
                    System.out.println(consulta);
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
    public void cargarAreasProduccion(String codProgramaProduccion){
        try {
            areaProduccionList.clear();

            con=Util.openConnection(con);

            String consulta = "SELECT AE.COD_AREA_EMPRESA,AE.NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA IN " +
                    "(SELECT CP.COD_AREA_EMPRESA FROM COMPONENTES_PROD CP INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_COMPPROD=CP.COD_COMPPROD" +
                    " WHERE PPR.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"')";
            System.out.println(consulta);
            ResultSet rs=null;
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs=st.executeQuery(consulta);                
                while(rs.next()){
                    areaProduccionList.add(new SelectItem(rs.getString("COD_AREA_EMPRESA"),rs.getString("NOMBRE_AREA_EMPRESA")));
                }
            if(rs!=null){
                rs.close();st.close();
                rs=null;st=null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void cargarEstadoProgramaProduccion(){
        try {
            estadoProgramaProduccionList.clear();
            estadoProgramaProduccionList.add(new SelectItem("2,5,6","-TODOS-"));
            estadoProgramaProduccionList.add(new SelectItem("2,5","APROBADO"));
            estadoProgramaProduccionList.add(new SelectItem("6","TERMINADO / ENVIADO"));
                            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String estadoProgramaProduccion_action(ActionEvent event){
        try {
            
        String codAreasEmpresa="0";
        for(int i=0;i<codAreasProduccion.length;i++){
            codAreasEmpresa=codAreasEmpresa +","+codAreasProduccion[i] ;
        }
        System.out.println("longitud Area:"+codAreasProduccion.length);
        
        //String codProgramaProduccion = event.getNewValue().toString();
        this.cargarComponentesProduccion(programaProduccion.getCodProgramaProduccion() ,codAreasEmpresa,codEstadoProgramaProduccion);
        this.checkTodoAreasProduccion="false";
        this.checkTodoComponentesProduccion ="false";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void cargartipoReporteSeguimientoProgramaProduccion(){
        try {
            tipoReporteSeguimientoList.clear();
            tipoReporteSeguimientoList.add(new SelectItem("1","TODOS"));
            tipoReporteSeguimientoList.add(new SelectItem("2","CON SEGUIMIENTO"));
            tipoReporteSeguimientoList.add(new SelectItem("3","SIN SEGUIMIENTO"));
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String verReporteSeguimientoProgramaProduccion_action(){
        try {
            HttpServletRequest request = (HttpServletRequest) (FacesContext.getCurrentInstance().getExternalContext().getRequest());
            request.setAttribute("codAreaEmpresaP","codAreaEmpresaP");
            this.redireccionar("reporteSeguimientoProgramaProduccion.jsf");
            
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
