/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ProgramaProdControlCalidadDetalle;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.ProgramaProduccionControlCalidad;
import com.cofar.bean.ProgramaProduccionControlCalidadAnalisis;
import com.cofar.bean.ProgramaProduccionPeriodo;

import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.faces.context.FacesContext;
import javax.faces.model.ListDataModel;
import javax.faces.model.SelectItem;
import org.joda.time.DateTime;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author hvaldivia
 */

public class ManagedProgramaProduccionControlCalidad {

  
    List programaProduccionPeriodoList = new ArrayList();
    HtmlDataTable programaProduccionPeriodoDataTable = new HtmlDataTable();
    ProgramaProduccionPeriodo programaProduccionPeriodo = new ProgramaProduccionPeriodo();
    private ProgramaProduccionPeriodo programaProduccionPeriodoEditar=new ProgramaProduccionPeriodo();
    ProgramaProduccionPeriodo programaProduccionPeriodoSeleccionado = new ProgramaProduccionPeriodo();
    private List<ProgramaProduccionControlCalidad> programaProduccionControlCalidadList = new ArrayList<ProgramaProduccionControlCalidad>();
    
    private List<ProgramaProduccionControlCalidad> programaProduccionEditarList=new ArrayList<ProgramaProduccionControlCalidad>();
    private ProgramaProduccionControlCalidad programaProduccionControlCalidadBean=new ProgramaProduccionControlCalidad();
    private List<SelectItem> formulasMaestrasSelectList=new ArrayList<SelectItem>();
    private String mensaje="";
    private Date fechaLote=new Date();
    private Connection con=null;
    private List<ProgramaProduccionControlCalidadAnalisis> programaProduccionControlCalidadAnalisisAgregarList=new ArrayList<ProgramaProduccionControlCalidadAnalisis>();
    private List<SelectItem> tiposMaterialReactivoList=new ArrayList<SelectItem>();
    private List<SelectItem> programaProdPeriodosList=new ArrayList<SelectItem>();
    private List<SelectItem> almacenMuestraSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> tiposEstudioEstabilidadSelectList=new ArrayList<SelectItem>();
    private ProgramaProduccionControlCalidad programaProduccionControlCalidadAgregar=new ProgramaProduccionControlCalidad();
    private ProgramaProduccion programaProduccionBuscar=new ProgramaProduccion();
    private ListDataModel programaProdDataModel=new ListDataModel();
    private ProgramaProduccionControlCalidad programaProduccionControlCalidadEditar=new ProgramaProduccionControlCalidad();
    private ProgramaProduccionControlCalidad programaProduccionControlCalidadReporte=new ProgramaProduccionControlCalidad();
    private ListDataModel materialesDataModel=new ListDataModel();
    private HtmlDataTable programaProduccionControlCalidadDataTable=new HtmlDataTable();
    private Date fechaInicioAnalisis=new Date();
    private ProgramaProduccionControlCalidadAnalisis produccionControlCalidadAnalisisEditar=new ProgramaProduccionControlCalidadAnalisis();
    private HtmlDataTable ProgramaProduccionControlCalidadAnalisisDataTable = new HtmlDataTable();
    private HtmlDataTable ProgramaProduccionControlCalidadAnalisisEditarDataTable = new HtmlDataTable();
    private boolean recorrerFechas=true;
    private Date fechaInicialAnalisis=new Date();
    int cantidadAfectados=0;
    ProgramaProduccionControlCalidadAnalisis programaProduccionControlCalidadAnalisisSeleccionado = new ProgramaProduccionControlCalidadAnalisis();
    public List materialesList = new ArrayList();
//    List<ResultadoFisicoEstabilidad> resultadoFisicoEstabilidad = new ArrayList<ResultadoFisicoEstabilidad>();
//    List<ResultadoQuimicoEstabilidad> resultadoQuimicoEstabilidad = new ArrayList<ResultadoQuimicoEstabilidad>();
      /** Creates a new instance of ManagedProgramaProduccionControlCalidad */
    public ManagedProgramaProduccionControlCalidad() {
    }

    public List getProgramaProduccionPeriodoList() {
        return programaProduccionPeriodoList;
    }

    public void setProgramaProduccionPeriodoList(List programaProduccionPeriodoList) {
        this.programaProduccionPeriodoList = programaProduccionPeriodoList;
    }

    public HtmlDataTable getProgramaProduccionPeriodoDataTable() {
        return programaProduccionPeriodoDataTable;
    }

    public void setProgramaProduccionPeriodoDataTable(HtmlDataTable programaProduccionPeriodoDataTable) {
        this.programaProduccionPeriodoDataTable = programaProduccionPeriodoDataTable;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodo() {
        return programaProduccionPeriodo;
    }

    public void setProgramaProduccionPeriodo(ProgramaProduccionPeriodo programaProduccionPeriodo) {
        this.programaProduccionPeriodo = programaProduccionPeriodo;
    }

    public List<SelectItem> getFormulasMaestrasSelectList() {
        return formulasMaestrasSelectList;
    }

    public void setFormulasMaestrasSelectList(List<SelectItem> formulasMaestrasSelectList) {
        this.formulasMaestrasSelectList = formulasMaestrasSelectList;
    }

    public List<ProgramaProduccionControlCalidadAnalisis> getProgramaProduccionControlCalidadAnalisisAgregarList() {
        return programaProduccionControlCalidadAnalisisAgregarList;
    }

    public void setProgramaProduccionControlCalidadAnalisisAgregarList(List<ProgramaProduccionControlCalidadAnalisis> programaProduccionControlCalidadAnalisisAgregarList) {
        this.programaProduccionControlCalidadAnalisisAgregarList = programaProduccionControlCalidadAnalisisAgregarList;
    }

    public ProgramaProduccionControlCalidad getProgramaProduccionControlCalidadBean() {
        return programaProduccionControlCalidadBean;
    }

    public void setProgramaProduccionControlCalidadBean(ProgramaProduccionControlCalidad programaProduccionControlCalidadBean) {
        this.programaProduccionControlCalidadBean = programaProduccionControlCalidadBean;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public Date getFechaLote() {
        return fechaLote;
    }

    public void setFechaLote(Date fechaLote) {
        this.fechaLote = fechaLote;
    }

    public ProgramaProduccionControlCalidad getProgramaProduccionControlCalidadEditar() {
        return programaProduccionControlCalidadEditar;
    }

    public void setProgramaProduccionControlCalidadEditar(ProgramaProduccionControlCalidad programaProduccionControlCalidadEditar) {
        this.programaProduccionControlCalidadEditar = programaProduccionControlCalidadEditar;
    }

    public List<ProgramaProduccionControlCalidad> getProgramaProduccionControlCalidadList() {
        return programaProduccionControlCalidadList;
    }

    public void setProgramaProduccionControlCalidadList(List<ProgramaProduccionControlCalidad> programaProduccionControlCalidadList) {
        this.programaProduccionControlCalidadList = programaProduccionControlCalidadList;
    }
    

    public List<ProgramaProduccionControlCalidad> getProgramaProduccionEditarList() {
        return programaProduccionEditarList;
    }

    public void setProgramaProduccionEditarList(List<ProgramaProduccionControlCalidad> programaProduccionEditarList) {
        this.programaProduccionEditarList = programaProduccionEditarList;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoSeleccionado() {
        return programaProduccionPeriodoSeleccionado;
    }

    public void setProgramaProduccionPeriodoSeleccionado(ProgramaProduccionPeriodo programaProduccionPeriodoSeleccionado) {
        this.programaProduccionPeriodoSeleccionado = programaProduccionPeriodoSeleccionado;
    }

    public List<SelectItem> getTiposMaterialReactivoList() {
        return tiposMaterialReactivoList;
    }

    public void setTiposMaterialReactivoList(List<SelectItem> tiposMaterialReactivoList) {
        this.tiposMaterialReactivoList = tiposMaterialReactivoList;
    }

    public List<SelectItem> getProgramaProdPeriodosList() {
        return programaProdPeriodosList;
    }

    public void setProgramaProdPeriodosList(List<SelectItem> programaProdPeriodosList) {
        this.programaProdPeriodosList = programaProdPeriodosList;
    }

    public ListDataModel getProgramaProdDataModel() {
        return programaProdDataModel;
    }

    public void setProgramaProdDataModel(ListDataModel programaProdDataModel) {
        this.programaProdDataModel = programaProdDataModel;
    }

    public ProgramaProduccion getProgramaProduccionBuscar() {
        return programaProduccionBuscar;
    }

    public void setProgramaProduccionBuscar(ProgramaProduccion programaProduccionBuscar) {
        this.programaProduccionBuscar = programaProduccionBuscar;
    }

    public ListDataModel getMaterialesDataModel() {
        return materialesDataModel;
    }

    public void setMaterialesDataModel(ListDataModel materialesDataModel) {
        this.materialesDataModel = materialesDataModel;
    }

    public ProgramaProduccionControlCalidad getProgramaProduccionControlCalidadReporte() {
        return programaProduccionControlCalidadReporte;
    }

    public void setProgramaProduccionControlCalidadReporte(ProgramaProduccionControlCalidad programaProduccionControlCalidadReporte) {
        this.programaProduccionControlCalidadReporte = programaProduccionControlCalidadReporte;
    }

    public HtmlDataTable getProgramaProduccionControlCalidadDataTable() {
        return programaProduccionControlCalidadDataTable;
    }

    public void setProgramaProduccionControlCalidadDataTable(HtmlDataTable programaProduccionControlCalidadDataTable) {
        this.programaProduccionControlCalidadDataTable = programaProduccionControlCalidadDataTable;
    }
    public String seleccionarProgProdCCReporte()
    {
        programaProduccionControlCalidadReporte=(ProgramaProduccionControlCalidad)programaProduccionControlCalidadDataTable.getRowData();
        return null;
    }

    public List<SelectItem> getAlmacenMuestraSelectList() {
        return almacenMuestraSelectList;
    }

    public void setAlmacenMuestraSelectList(List<SelectItem> almacenMuestraSelectList) {
        this.almacenMuestraSelectList = almacenMuestraSelectList;
    }

    public List<SelectItem> getTiposEstudioEstabilidadSelectList() {
        return tiposEstudioEstabilidadSelectList;
    }

    public void setTiposEstudioEstabilidadSelectList(List<SelectItem> tiposEstudioEstabilidadSelectList) {
        this.tiposEstudioEstabilidadSelectList = tiposEstudioEstabilidadSelectList;
    }

    public ProgramaProduccionControlCalidad getProgramaProduccionControlCalidadAgregar() {
        return programaProduccionControlCalidadAgregar;
    }

    public void setProgramaProduccionControlCalidadAgregar(ProgramaProduccionControlCalidad programaProduccionControlCalidadAgregar) {
        this.programaProduccionControlCalidadAgregar = programaProduccionControlCalidadAgregar;
    }

    public Date getFechaInicioAnalisis() {
        return fechaInicioAnalisis;
    }

    public void setFechaInicioAnalisis(Date fechaInicioAnalisis) {
        this.fechaInicioAnalisis = fechaInicioAnalisis;
    }

    public ProgramaProduccionControlCalidadAnalisis getProduccionControlCalidadAnalisisEditar() {
        return produccionControlCalidadAnalisisEditar;
    }

    public void setProduccionControlCalidadAnalisisEditar(ProgramaProduccionControlCalidadAnalisis produccionControlCalidadAnalisisEditar) {
        this.produccionControlCalidadAnalisisEditar = produccionControlCalidadAnalisisEditar;
    }

    public boolean isRecorrerFechas() {
        return recorrerFechas;
    }

    public void setRecorrerFechas(boolean recorrerFechas) {
        this.recorrerFechas = recorrerFechas;
    }

    public int getCantidadAfectados() {
        return cantidadAfectados;
    }

    public void setCantidadAfectados(int cantidadAfectados) {
        this.cantidadAfectados = cantidadAfectados;
    }

    public HtmlDataTable getProgramaProduccionControlCalidadAnalisisDataTable() {
        return ProgramaProduccionControlCalidadAnalisisDataTable;
    }

    public void setProgramaProduccionControlCalidadAnalisisDataTable(HtmlDataTable ProgramaProduccionControlCalidadAnalisisDataTable) {
        this.ProgramaProduccionControlCalidadAnalisisDataTable = ProgramaProduccionControlCalidadAnalisisDataTable;
    }

    public List getMaterialesList() {
        return materialesList;
    }

    public void setMaterialesList(List materialesList) {
        this.materialesList = materialesList;
    }

    public HtmlDataTable getProgramaProduccionControlCalidadAnalisisEditarDataTable() {
        return ProgramaProduccionControlCalidadAnalisisEditarDataTable;
    }

    public void setProgramaProduccionControlCalidadAnalisisEditarDataTable(HtmlDataTable ProgramaProduccionControlCalidadAnalisisEditarDataTable) {
        this.ProgramaProduccionControlCalidadAnalisisEditarDataTable = ProgramaProduccionControlCalidadAnalisisEditarDataTable;
    }

//    public List<ResultadoFisicoEstabilidad> getResultadoFisicoEstabilidad() {
//        return resultadoFisicoEstabilidad;
//    }
//
//    public void setResultadoFisicoEstabilidad(List<ResultadoFisicoEstabilidad> resultadoFisicoEstabilidad) {
//        this.resultadoFisicoEstabilidad = resultadoFisicoEstabilidad;
//    }
//
//    public List<ResultadoQuimicoEstabilidad> getResultadoQuimicoEstabilidad() {
//        return resultadoQuimicoEstabilidad;
//    }
//
//    public void setResultadoQuimicoEstabilidad(List<ResultadoQuimicoEstabilidad> resultadoQuimicoEstabilidad) {
//        this.resultadoQuimicoEstabilidad = resultadoQuimicoEstabilidad;
//    }





   

    

    


    

     public int diferenciasDeFechas(Date fechaInicial, Date fechaFinal) {

        DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM);
        String fechaInicioString = df.format(fechaInicial);
        try {
            fechaInicial = df.parse(fechaInicioString);
        } 
        catch (ParseException ex)
        {
        }
        String fechaFinalString = df.format(fechaFinal);
        try {
            fechaFinal = df.parse(fechaFinalString);
        } 
        catch (ParseException ex)
        {
        }
        long fechaInicialMs = fechaInicial.getTime();
        long fechaFinalMs = fechaFinal.getTime();
        long diferencia = fechaFinalMs - fechaInicialMs;
        double dias = Math.floor(diferencia / (1000 * 60 * 60 * 24));
        return ((int) dias);
    }


    public String guardarEdicionControlCalidadAnalisis_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            String consulta="UPDATE PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS"+
                            " SET FECHA_ANALISIS = '"+sdf.format(produccionControlCalidadAnalisisEditar.getFechaAnalisis())+" 12:00:00',"+
                            " PROCEDE = '"+produccionControlCalidadAnalisisEditar.getProcede()+"',"+
                            " OBSERVACION = '"+produccionControlCalidadAnalisisEditar.getObservacion()+"'"+
                            " WHERE COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"' and "+
                            " COD_CONTROL_CALIDAD_ANALISIS = '"+produccionControlCalidadAnalisisEditar.getCodControlCalidadAnalisis()+"'";
            System.out.println("consulta update analisis "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            
            if(pst.executeUpdate()>0)System.out.println("se actualizo el analisis");
            int cantidadDias=diferenciasDeFechas(fechaInicialAnalisis,produccionControlCalidadAnalisisEditar.getFechaAnalisis());
            cantidadAfectados=0;
            if(recorrerFechas&&(cantidadDias!=0))
            {
                consulta=" update PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS set"+
                         " FECHA_ANALISIS=DATEADD(day,"+cantidadDias+",FECHA_ANALISIS)"+
                         " where COD_CONTROL_CALIDAD_ANALISIS <> '"+produccionControlCalidadAnalisisEditar.getCodControlCalidadAnalisis()+"'"+
                         " and COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"'" +
                         " and FECHA_ANALISIS>'"+sdf.format(fechaInicialAnalisis)+" 00:00:00'";
                System.out.println("consulta incrementar fechas "+consulta);
                pst=con.prepareStatement(consulta);
                cantidadAfectados=pst.executeUpdate();
                if(cantidadAfectados>0)System.out.println("se incrementaron registros "+cantidadAfectados);
            }
            con.commit();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de registrar el analisis,intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarProgramaProduccionControlCalidad();
        }
        return null;
    }
    
    private Date sumarFechasMeses(Date fecha, int meses) {
        Calendar cal = new GregorianCalendar();
        cal.setTimeInMillis(fecha.getTime());
        cal.add(Calendar.MONTH, meses);
        return new Date(cal.getTimeInMillis());
    }
    public String generarCronogramaAnalisisEditar_action()
    {
        programaProduccionControlCalidadEditar.getProgramaProduccionControlCalidadAnalisisList().clear();
        int contador=(programaProduccionControlCalidadEditar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==0?0:(
                programaProduccionControlCalidadEditar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==3?10:4));
        int cantidadMeses=0;
        Date fechaActual=(Date)fechaInicioAnalisis.clone();
        ProgramaProduccionControlCalidadAnalisis nuevo=new ProgramaProduccionControlCalidadAnalisis();
        nuevo.setFechaAnalisis(null);
        programaProduccionControlCalidadEditar.getProgramaProduccionControlCalidadAnalisisList().add(nuevo);
        int cantidadIncremento=0;
        for(int i=1;i<contador;i++)
        {
            nuevo=new ProgramaProduccionControlCalidadAnalisis();
            cantidadMeses+=(i==0?0:((i>0&&contador==4)?2:((i<5&&contador==10)?3:12) ) );
            cantidadIncremento+=(i==1?0:((i>1&&contador==4)?2:((i<4&&contador==10)?3:12) ) );
            nuevo.setTiempoEstudio(cantidadMeses);
            nuevo.setFechaAnalisis(sumarFechasMeses(fechaActual,cantidadIncremento));
            programaProduccionControlCalidadEditar.getProgramaProduccionControlCalidadAnalisisList().add(nuevo);
        }
        return null;
    }
    public String generaraCronogramaAnalisis_action()
    {
        programaProduccionControlCalidadAnalisisAgregarList.clear();
        int contador=(programaProduccionControlCalidadAgregar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==0?0:(
                programaProduccionControlCalidadAgregar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==3?10:4));
        int cantidadMeses=0;
        Date fechaActual=(Date)fechaInicioAnalisis.clone();
        ProgramaProduccionControlCalidadAnalisis nuevo=new ProgramaProduccionControlCalidadAnalisis();
        nuevo.setFechaAnalisis(null);
        nuevo.setMaterialesList(this.cargaMateriales());
        //programaProduccionControlCalidadAnalisisAgregarList.add(nuevo);
        int cantidadIncremento=0;
        for(int i=1;i<=contador;i++)
        {
            nuevo=new ProgramaProduccionControlCalidadAnalisis();
            cantidadMeses+=(i==0?0:((i>0&&contador==4)?2:((i<5&&contador==10)?3:12) ) );
            cantidadIncremento+=(i==1?0:((i>1&&contador==4)?2:((i<4&&contador==10)?3:12) ) );
            nuevo.setTiempoEstudio(cantidadIncremento);
            nuevo.setFechaAnalisis(sumarFechasMeses(fechaActual,cantidadIncremento));
            nuevo.setProgramaProduccionControlCalidad(programaProduccionControlCalidadAgregar);
            nuevo.setMaterialesList(this.cargaMateriales());
            programaProduccionControlCalidadAnalisisAgregarList.add(nuevo);
        }
        return null;
    }

    public String tipoEstudioEstabilidad_change()
    {
        programaProduccionControlCalidadAnalisisAgregarList.clear();
        programaProduccionControlCalidadAgregar.setTiempoEstudio(
        programaProduccionControlCalidadAgregar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==0?0:(
                programaProduccionControlCalidadAgregar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==3?72:6));
        return null;
    }
    public String tipoEstudioEstabilidadEditar_change()
    {
        programaProduccionControlCalidadEditar.getProgramaProduccionControlCalidadAnalisisList().clear();
        programaProduccionControlCalidadEditar.setTiempoEstudio(
        programaProduccionControlCalidadEditar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==0?0:(
                programaProduccionControlCalidadEditar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==3?72:6));
        return null;
    }
    
    public String getCargarNuevoRegistroProgramaPeriodo()
    {
        programaProduccionPeriodo=new ProgramaProduccionPeriodo();
        return null;
    }
    public String editarProgramaPeriodoControlCalidad_action()
    {
        Iterator e=programaProduccionPeriodoList.iterator();
        while(e.hasNext())
        {
            ProgramaProduccionPeriodo bean=(ProgramaProduccionPeriodo)e.next();
            if(bean.getChecked())
            {
                programaProduccionPeriodoEditar=bean;
            }
        }
        return null;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodoEditar() {
        return programaProduccionPeriodoEditar;
    }

    public void setProgramaProduccionPeriodoEditar(ProgramaProduccionPeriodo programaProduccionPeriodoEditar) {
        this.programaProduccionPeriodoEditar = programaProduccionPeriodoEditar;
    }


    

    public String buscarProgramaProduccionAgregarAction()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.nombre_prod_semiterminado,cp.COD_COMPPROD,pp.COD_PROGRAMA_PROD,"+
                            " pp.COD_FORMULA_MAESTRA,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,"+
                            " ppp.NOMBRE_PROGRAMA_PROD,pp.CANT_LOTE_PRODUCCION,pp.COD_LOTE_PRODUCCION"+
                            " from PROGRAMA_PRODUCCION pp"+
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pp.COD_COMPPROD"+
                            " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                            " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                            " where pp.COD_ESTADO_PROGRAMA <> 4"+
                            (programaProduccionBuscar.getCodProgramaProduccion().equals("0")?"":" and pp.COD_PROGRAMA_PROD='"+programaProduccionBuscar.getCodProgramaProduccion()+"'")+
                            (programaProduccionBuscar.getCodLoteProduccion().equals("")?"":" and pp.COD_LOTE_PRODUCCION like '%"+programaProduccionBuscar.getCodLoteProduccion()+"%'")+
                            " order by ppp.COD_PROGRAMA_PROD,cp.nombre_prod_semiterminado";

            System.out.println("consulta cargar programa prod "+consulta);
            ResultSet res=st.executeQuery(consulta);
            programaProdDataModel.setWrappedData(new ArrayList());
            List programaprod=new ArrayList();
            while(res.next())
            {
                ProgramaProduccionControlCalidad nuevo=new ProgramaProduccionControlCalidad();
                nuevo.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getProgramaProduccionPeriodoLoteProduccion().setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                nuevo.getProgramaProduccionPeriodoLoteProduccion().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                nuevo.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.setCantLoteProduccion(res.getDouble("CANT_LOTE_PRODUCCION"));
                programaprod.add(nuevo);
            }
            programaProdDataModel.setWrappedData(programaprod);
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
    public String seleccionarProgramaProduccionEditar_action()
    {
        ProgramaProduccionControlCalidad seleccion =(ProgramaProduccionControlCalidad) programaProdDataModel.getRowData();
        programaProduccionControlCalidadEditar.setCodLoteProduccion(seleccion.getCodLoteProduccion());
        programaProduccionControlCalidadEditar.getProgramaProduccionPeriodoLoteProduccion().setCodProgramaProduccion(seleccion.getProgramaProduccionPeriodoLoteProduccion().getCodProgramaProduccion());
        programaProduccionControlCalidadEditar.getProgramaProduccionPeriodoLoteProduccion().setNombreProgramaProduccion(seleccion.getProgramaProduccionPeriodoLoteProduccion().getNombreProgramaProduccion());
        programaProduccionControlCalidadEditar.getTiposProgramaProduccion().setCodTipoProgramaProd(seleccion.getTiposProgramaProduccion().getCodTipoProgramaProd());
        programaProduccionControlCalidadEditar.getTiposProgramaProduccion().setNombreTipoProgramaProd(seleccion.getTiposProgramaProduccion().getNombreTipoProgramaProd());
        programaProduccionControlCalidadEditar.getComponentesProd().setCodCompprod(seleccion.getComponentesProd().getCodCompprod());
        programaProduccionControlCalidadEditar.getComponentesProd().setNombreProdSemiterminado(seleccion.getComponentesProd().getNombreProdSemiterminado());
        programaProduccionControlCalidadEditar.getFormulaMaestra().setCodFormulaMaestra(seleccion.getFormulaMaestra().getCodFormulaMaestra());
        programaProduccionControlCalidadEditar.setCantLoteProduccion(seleccion.getCantLoteProduccion());
        return null;
    }
    public String seleccionarProgramaProduccion_action()
    {
        programaProduccionControlCalidadAgregar=(ProgramaProduccionControlCalidad) programaProdDataModel.getRowData();
        return null;
    }
   
    private void cargarProgramaProduccionPeriodo()
    {
        try
        {
            String consulta="select ppr.COD_PROGRAMA_PROD,ppr.NOMBRE_PROGRAMA_PROD  from PROGRAMA_PRODUCCION_PERIODO ppr" +
                            " where ppr.COD_ESTADO_PROGRAMA<>4 and ISNULL(ppr.COD_TIPO_PRODUCCION,1) in (1)"+
                            " order by ppr.COD_PROGRAMA_PROD";
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            programaProdPeriodosList.clear();
            while(res.next())
            {
                programaProdPeriodosList.add(new SelectItem(res.getString("COD_PROGRAMA_PROD"),res.getString("NOMBRE_PROGRAMA_PROD")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        
    }
    private void cargarTiposMaterialReactivo()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY) ;
            String consulta="select tmr.COD_TIPO_MATERIAL_REACTIVO,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO"+
                            " from TIPOS_MATERIAL_REACTIVO tmr order by tmr.NOMBRE_TIPO_MATERIAL_REACTIVO";
            ResultSet res=st.executeQuery(consulta);
            tiposMaterialReactivoList.clear();

            while(res.next())
            {
                tiposMaterialReactivoList.add(new SelectItem(res.getInt("COD_TIPO_MATERIAL_REACTIVO"),res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }

        public String codLoteProveedorEnProgramaProduccion(String codProgramaProduccion, String codComprod,String codFormulaMaestra,String codAreaEmpresaComponente){
            String codLote="";
            String restrColumnas="''";
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


            String consulta = " SELECT  DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO  " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE() " +
                    " AND CP.COD_COMPPROD='"+codComprod+"' ORDER BY IADE.FECHA_VENCIMIENTO ASC ";

            consulta = "SELECT PPR.COD_COMPPROD,PPR.COD_FORMULA_MAESTRA,PPR.COD_LOTE_PRODUCCION " +
                    " FROM  PROGRAMA_PRODUCCION_CONTROL_CALIDAD PPR WHERE PPR.COD_ESTADO_PROGRAMA = 2 " +
                    " AND PPR.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"' " +
                    " AND PPR.COD_COMPPROD='"+codComprod+"'";
                    System.out.println("consulta" + consulta);
            ResultSet rs = st.executeQuery(consulta);

            while (rs.next()) {
                restrColumnas = restrColumnas +",'"+ rs.getString("COD_COMPPROD") + rs.getString("COD_FORMULA_MAESTRA") + rs.getString("COD_LOTE_PRODUCCION")+"'" ;
            }

            // MAYOR O IGUAL AL TAMAÑO DE LOTE 1 = 1000

            consulta = " SELECT DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO, IADE.CANTIDAD_RESTANTE,CP.nombre_prod_semiterminado   " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD   " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA   " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL   " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE()   " +
                    " AND CP.COD_COMPPROD='"+codComprod+"' " +
                    " AND convert(varchar,CP.COD_COMPPROD)+CONVERT(varchar,FM.COD_FORMULA_MAESTRA)+convert(varchar,IADE.LOTE_MATERIAL_PROVEEDOR) NOT IN("+restrColumnas+") " +
                    " ORDER BY IADE.FECHA_VENCIMIENTO ASC ";

            consulta = "select sum(iade.CANTIDAD_RESTANTE)as cantidad ,iad.cod_material, ia.COD_PROVEEDOR,isnull(iade.LOTE_MATERIAL_PROVEEDOR,'-')as LOTE_MATERIAL_PROVEEDOR,iade.FECHA_VENCIMIENTO, iade.COD_ESTADO_MATERIAL " +
                    " from INGRESOS_ALMACEN ia,INGRESOS_ALMACEN_DETALLE iad, " +
                    " INGRESOS_ALMACEN_DETALLE_ESTADO iade, proveedores p,FORMULA_MAESTRA FM,FORMULA_MAESTRA_DETALLE_EP FMDEP,presentaciones_primarias prp" +
                    " where ia.COD_INGRESO_ALMACEN=iad.COD_INGRESO_ALMACEN  " +
                    " and iad.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN  " +
                    " and ia.cod_proveedor=p.cod_proveedor  " +
                    " AND ia.cod_estado_ingreso_almacen=1 " +
                    " and iad.cod_material=iade.cod_material  " +
                    " AND FMDEP.COD_MATERIAL = IADE.COD_MATERIAL " +
                    " AND FM.COD_FORMULA_MAESTRA = FMDEP.COD_FORMULA_MAESTRA  " +
                    " and iade.CANTIDAD_RESTANTE>0 AND FM.COD_COMPPROD='"+codComprod+"' " +
                    " AND IADE.FECHA_VENCIMIENTO>=GETDATE() and prp.cod_presentacion_primaria=fmdep.cod_presentacion_primaria and prp.cod_compprod='"+codComprod+"'" +
                    " AND convert(varchar,FM.COD_COMPPROD)+CONVERT(varchar,FM.COD_FORMULA_MAESTRA)+'6'+convert(varchar,IADE.LOTE_MATERIAL_PROVEEDOR) NOT IN("+restrColumnas+") " +
                    " AND FMDEP.COD_MATERIAL IN ( select m1.COD_MATERIAL   from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO and g.COD_CAPITULO=3 ) " +
                    " GROUP BY iad.cod_material, ia.COD_PROVEEDOR,iade.LOTE_MATERIAL_PROVEEDOR,iade.FECHA_VENCIMIENTO, iade.COD_ESTADO_MATERIAL " +
                    " order by iade.FECHA_VENCIMIENTO asc ";

            System.out.println("la consulta armada " + consulta);

            rs = st.executeQuery(consulta);
            if(rs.next()){
                codLote = rs.getString("LOTE_MATERIAL_PROVEEDOR");
            }

            if(codLote.equals("")){
                        consulta= " select max(cast(SUBSTRING(p.COD_LOTE_PRODUCCION,5,LEN(p.COD_LOTE_PRODUCCION)+1) as int))+1 COD_LOTE_PRODUCCION from PROGRAMA_PRODUCCION p, componentes_prod c " +
                                        " where p.COD_PROGRAMA_PROD = " + codProgramaProduccion + " and " +
                                        " p.COD_ESTADO_PROGRAMA in (1,2,6)  and" +
                                        " c.cod_compprod=p.cod_compprod and c.cod_area_empresa in (" + codAreaEmpresaComponente + ") " +
                                        " and p.COD_LOTE_PRODUCCION like 'S%' " +
                                        " union all " +
                                        " select count(*)+1 COD_LOTE_PRODUCCION from PROGRAMA_PRODUCCION_CONTROL_CALIDAD p, componentes_prod c " +
                                        " where p.COD_PROGRAMA_PROD = " + codProgramaProduccion + " and " +
                                        " p.COD_ESTADO_PROGRAMA in (1,2,6)  and" +
                                        " c.cod_compprod=p.cod_compprod and c.cod_area_empresa in (" + codAreaEmpresaComponente + ") " +
                                        " and p.COD_LOTE_PRODUCCION like 'S%' ";

                        System.out.println("consulta lote" + consulta);
                        st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        rs = st.executeQuery(consulta);
                        if(rs.next()){
                            codLote = "S-L " + (rs.getString("COD_LOTE_PRODUCCION")==null?"1":rs.getString("COD_LOTE_PRODUCCION"));
                        }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return codLote;
      }
 public String generaCodLoteProduccion(String codProgramaPeriodo, String codCompProdP,int cantidadLoteP ,String codFormulaMaestraP,String obsProgProdP,String codTipoProgramaProduccionP) {
         String codLoteProduccion="";
        try {

            con = Util.openConnection(con);

            // deducir el prefijo para la forma farmaceutica
            String consulta = " select ffl.COD_LOTE_FORMA,cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp  " +
                    "  inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma = cp.COD_FORMA " +
                    " inner join FORMAS_FARMACEUTICAS_LOTE ffl on ffl.COD_FORMA = ff.cod_forma " +
                    " where cp.COD_COMPPROD = "+codCompProdP+" ";

            System.out.println("consulta" + consulta);
            Statement stLoteForma = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsLoteForma= stLoteForma.executeQuery(consulta);
            String codLoteForma = "";
            String codAreaEmpresa = "";
            if(rsLoteForma.next()){
                codLoteForma = rsLoteForma.getString("COD_LOTE_FORMA");
                codAreaEmpresa = rsLoteForma.getString("COD_AREA_EMPRESA");
            }

            // el mes de la gestion
            System.out.println("cod area "+codAreaEmpresa+" "+codLoteForma);
            DateTime dt = new DateTime(fechaLote);



            SimpleDateFormat sdf = new SimpleDateFormat("MM");
            dt=dt.withMonthOfYear(Integer.valueOf(sdf.format(fechaLote)));
            String loteMes = "";
                if (dt.getMonthOfYear() < 10) {
                    loteMes = "0" + Integer.toString(dt.getMonthOfYear());
                } else {
                    loteMes = Integer.toString(dt.getMonthOfYear());
                }



            System.out.println("la fecha de lote que generara" +fechaLote.toString() +" lote mes " + loteMes );

            //el caso de liquidos esteriles
            if(codAreaEmpresa.equals("81") && codLoteForma.equals("1")){
                System.out.println("entro111111");
                    codLoteProduccion=this.codLoteProveedorEnProgramaProduccion(codProgramaPeriodo, codCompProdP, codFormulaMaestraP,codAreaEmpresa);
            }else{
                        // el correlativo
                        consulta = " SELECT MAX(CAST(SUBSTRING(PPR.COD_LOTE_PRODUCCION,5,LEN(SUBSTRING(PPR.COD_LOTE_PRODUCCION,5,50))-1) AS BIGINT)) +1 correlativo " +
                            " FROM PROGRAMA_PRODUCCION_CONTROL_CALIDAD PPR  " +
                            " INNER JOIN COMPONENTES_PROD CP ON CP.COD_COMPPROD = PPR.COD_COMPPROD " +
                            " INNER JOIN AREAS_EMPRESA AE ON AE.COD_AREA_EMPRESA = CP.COD_AREA_EMPRESA " +
                            " INNER JOIN FORMAS_FARMACEUTICAS FF ON FF.cod_forma = CP.COD_FORMA " +
                            " WHERE PPR.COD_PROGRAMA_PROD = "+codProgramaPeriodo+" " +
                            " AND AE.COD_AREA_EMPRESA in (select cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp where cp.COD_COMPPROD = "+codCompProdP+") " +
                            " AND LEN(PPR.COD_LOTE_PRODUCCION)>=6 " ;
                        //correlativo individual para oftalmicos
                            //System.out.println("consulta " + consulta);
                        /*if(codLoteForma.equals("7")){
                            consulta = consulta + " and  CP.COD_FORMA = 25 ";
                        }*/
                    //el caso de inyectables

                    System.out.println("consulta" + consulta);
                    Statement stCorrelativo = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsCorrelativo= stCorrelativo.executeQuery(consulta);
                    int correlativo = 0;
                    if(rsCorrelativo.next()){
                        correlativo = rsCorrelativo.getInt("correlativo");
                    }
                    if(correlativo==0){
                        correlativo = 1;
                    }

                    String correlativoLote = "";
                    if(correlativo<10){
                        correlativoLote = "0"+String.valueOf(correlativo);
                    }else{
                        correlativoLote = String.valueOf(correlativo);
                    }



                    //calculo del año
                    dt = new DateTime(fechaLote);
                    String gestionLote = Integer.toString(dt.getYear()).substring(3, 4);

                    codLoteProduccion =codLoteForma+ loteMes + correlativoLote + gestionLote ;
                    System.out.println("codLoteProduccion " + codLoteProduccion);
            if(rsCorrelativo !=null) {
                rsCorrelativo.close();
                rsCorrelativo = null;
                stCorrelativo.close();
                stCorrelativo=null;
            }
            }
            codLoteProduccion="6"+codLoteProduccion;
            System.out.println("codLoteProduccion " + codLoteProduccion);
            if(rsLoteForma !=null ) {
                rsLoteForma.close();
                rsLoteForma=null;
                stLoteForma.close();
                stLoteForma=null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return (codLoteProduccion);
    }
     public String guardarEdicionProgramaProduccionControlCalidad_action()throws SQLException
     {
         mensaje="";
         try
         {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="UPDATE PROGRAMA_PRODUCCION_CONTROL_CALIDAD"+
                            " SET COD_FORMULA_MAESTRA = '"+programaProduccionControlCalidadEditar.getFormulaMaestra().getCodFormulaMaestra()+"',"+
                            "  COD_LOTE_PRODUCCION = '"+programaProduccionControlCalidadEditar.getCodLoteProduccion()+"',"+
                            " TIEMPO_ESTUDIO = '"+programaProduccionControlCalidadEditar.getTiempoEstudio()+"',"+
                            " CANTIDAD_MUESTRAS = '"+programaProduccionControlCalidadEditar.getCantidadMuestras()+"',"+
                            " COD_ALMACEN_MUESTRA ='"+programaProduccionControlCalidadEditar.getAlmacenesMuestra().getCodAlmacenMuestra()+"',"+
                            " COD_TIPO_ESTUDIO_ESTABILIDAD = '"+programaProduccionControlCalidadEditar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()+"',"+
                            " COD_PROGRAMA_PROD_LOTE_PRODUCCCION ='"+programaProduccionControlCalidadEditar.getProgramaProduccionPeriodoLoteProduccion().getCodProgramaProduccion()+"',"+
                            " COD_TIPO_PROGRAMA_PROD = '"+programaProduccionControlCalidadEditar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'"+
                            " WHERE COD_PROGRAMA_PROD_CONTROL_CALIDAD ='"+programaProduccionControlCalidadEditar.getCodProgramaProdControlCalidad()+"'";
            System.out.println("consulta update programa estabilidad "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo la información del programa");
            consulta="delete PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS  where COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+programaProduccionControlCalidadEditar.getCodProgramaProdControlCalidad()+"'";
            System.out.println("consulta delete anteriores analisis "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores");
            int codControlCalidad=0;
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            for(ProgramaProduccionControlCalidadAnalisis current:programaProduccionControlCalidadEditar.getProgramaProduccionControlCalidadAnalisisList())
            {
                codControlCalidad++;
                consulta="INSERT INTO PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS(COD_CONTROL_CALIDAD_ANALISIS,"+
                        " COD_PROGRAMA_PROD_CONTROL_CALIDAD, FECHA_ANALISIS, TIEMPO_ESTUDIO, "+
                        "CANTIDAD_TEST_DISOLUCION, CANTIDAD_TEST_VALORACION, COD_TIPO_MATERIAL_REACTIVO,OBSERVACION,PROCEDE)"+
                        "VALUES ('"+codControlCalidad+"','"+programaProduccionControlCalidadEditar.getCodProgramaProdControlCalidad()+"'" +
                        ",'"+sdf.format(current.getFechaAnalisis())+"'," +
                        "'"+current.getTiempoEstudio()+"','"+current.getCantidadTestDisolucion()+"','"+current.getCantidadTestValoracion()+"',"+
                        "'"+current.getTipoMaterialReactivo().getCodTipoMaterialReactivo()+"','"+current.getObservacion()+"',0)";
                System.out.println("consulta insert analisis "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el analisis");
                consulta = " delete from programa_prod_control_calidad_detalle where cod_programa_prod_control_calidad = '"+programaProduccionControlCalidadEditar.getCodProgramaProdControlCalidad()+"' and cod_control_calidad_analisis = '"+current.getCodControlCalidadAnalisis()+"'  ";
                System.out.println("consulta " + consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("borrado de materiales ");
                


                Iterator i = current.getMaterialesList().iterator();
                while(i.hasNext()){
                    ProgramaProdControlCalidadDetalle p = (ProgramaProdControlCalidadDetalle) i.next();

                    consulta =  " insert into programa_prod_control_calidad_detalle(cod_programa_prod_control_calidad,cod_formula_maestra,cod_lote_produccion,cod_material,cantidad,cod_control_calidad_analisis,cod_unidad_medida)" +
                            " values('"+programaProduccionControlCalidadEditar.getCodProgramaProdControlCalidad()+"','"+programaProduccionControlCalidadEditar.getFormulaMaestra().getCodFormulaMaestra()+"','"+programaProduccionControlCalidadEditar.getCodLoteProduccion()+"','"+p.getMateriales().getCodMaterial()+"','"+p.getCantidad()+"','"+codControlCalidad+"','"+p.getMateriales().getUnidadesMedida().getCodUnidadMedida()+"') ";
                    System.out.println("consulta " + consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el detalle materiales analisis");

                }

            }
            con.commit();
            mensaje="1";
            con.close();
         }
         catch(SQLException ex)
         {
             con.rollback();
             mensaje="Ocurrio un error al guardar la edicion del programa de estabilidad, intente  de nuevo";
             ex.printStackTrace();
         }
         return null;

     }

    public String guardarProgramaProduccionControl2_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="select ISNULL(max(ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD),0) + 1 as codProgProdCC"+
                            " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD ppcc";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            int codProgramaProdControlCalidad=0;
            if(res.next())
            {
                codProgramaProdControlCalidad=res.getInt("codProgProdCC");
            }
            consulta="INSERT INTO PROGRAMA_PRODUCCION_CONTROL_CALIDAD(COD_PROGRAMA_PROD,"+
                     " COD_FORMULA_MAESTRA, COD_LOTE_PRODUCCION, TIEMPO_ESTUDIO, CANTIDAD_MUESTRAS,"+
                     " COD_PROGRAMA_PROD_CONTROL_CALIDAD, COD_ALMACEN_MUESTRA,"+
                    " COD_TIPO_ESTUDIO_ESTABILIDAD, COD_PROGRAMA_PROD_LOTE_PRODUCCCION,"+
                    " COD_TIPO_PROGRAMA_PROD)"+
                    " VALUES ('"+programaProduccionPeriodoSeleccionado.getCodProgramaProduccion()+"'," +
                    "'"+programaProduccionControlCalidadAgregar.getFormulaMaestra().getCodFormulaMaestra()+"'," +
                    "'"+programaProduccionControlCalidadAgregar.getCodLoteProduccion()+"',"+
                    " '"+(programaProduccionControlCalidadAgregar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()==3?72:6)+"'," +
                    " '"+programaProduccionControlCalidadAgregar.getCantidadMuestras()+"','"+codProgramaProdControlCalidad+"',"+
                    " '"+programaProduccionControlCalidadAgregar.getAlmacenesMuestra().getCodAlmacenMuestra()+"'," +
                    " '"+programaProduccionControlCalidadAgregar.getTiposEstudioEstabilidad().getCodTipoEstudioEstabilidad()+"',"+
                    " '"+programaProduccionControlCalidadAgregar.getProgramaProduccionPeriodoLoteProduccion().getCodProgramaProduccion()+"'," +
                    " '"+programaProduccionControlCalidadAgregar.getTiposProgramaProduccion().getCodTipoProgramaProd()+"')";
            System.out.println("consulta insert programa prod "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el programa ProduccionControl calidad");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            int codControlCalidad=0;
            for(ProgramaProduccionControlCalidadAnalisis bean:programaProduccionControlCalidadAnalisisAgregarList)
            {
                codControlCalidad++;
                consulta="INSERT INTO PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS(COD_CONTROL_CALIDAD_ANALISIS,"+
                        " COD_PROGRAMA_PROD_CONTROL_CALIDAD, FECHA_ANALISIS, TIEMPO_ESTUDIO, "+
                        "CANTIDAD_TEST_DISOLUCION, CANTIDAD_TEST_VALORACION, COD_TIPO_MATERIAL_REACTIVO,OBSERVACION,PROCEDE)"+
                        "VALUES ('"+codControlCalidad+"','"+codProgramaProdControlCalidad+"','"+sdf.format(bean.getFechaAnalisis())+"'," +
                        "'"+bean.getTiempoEstudio()+"','"+bean.getCantidadTestDisolucion()+"','"+bean.getCantidadTestValoracion()+"',"+
                        "'"+bean.getTipoMaterialReactivo().getCodTipoMaterialReactivo()+"','"+bean.getObservacion()+"',0)";
                System.out.println("consulta insert analisis "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el analisis");

                Iterator i = bean.getMaterialesList().iterator();
                while(i.hasNext()){
                    ProgramaProdControlCalidadDetalle p = (ProgramaProdControlCalidadDetalle) i.next();

                    consulta =  " insert into programa_prod_control_calidad_detalle(cod_programa_prod_control_calidad,cod_formula_maestra,cod_lote_produccion,cod_material,cantidad,cod_control_calidad_analisis,cod_unidad_medida)" +
                            " values('"+codProgramaProdControlCalidad+"','"+programaProduccionControlCalidadAgregar.getFormulaMaestra().getCodFormulaMaestra()+"','"+programaProduccionControlCalidadAgregar.getCodLoteProduccion()+"','"+p.getMateriales().getCodMaterial()+"','"+p.getCantidad()+"','"+codControlCalidad+"','"+p.getMateriales().getUnidadesMedida().getCodUnidadMedida()+"') ";
                    System.out.println("consulta " + consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el detalle materiales analisis");
                }
                

            }
            con.commit();
            mensaje="1";
            pst.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar los datos, intente de nuevo";
            ex.printStackTrace();
            con.rollback();
        }
        finally
        {
            con.close();
        }
        return null;
    }

    public String guardarProgramaProduccionControlCalidad_action()throws SQLException
    {
        mensaje="";
        Connection con=null;
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            PreparedStatement pst=null;
            
            
     /*       String codLoteProduccion=this.generaCodLoteProduccion(programaProduccionPeriodoSeleccionado.getCodProgramaProduccion(),
                    programa.getComponentesProd().getCodCompprod(), 1,programa.getFormulaMaestra().getCodFormulaMaestra(),programa.getObservacion(),programa.getTiposProgramaProduccion().getCodTipoProgramaProd());
       */     int codProgramaProdControlCalidad=0;
            String consulta="select ISNULL(max(ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD),0) + 1 as codProgProdCC"+
                            " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD ppcc";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                codProgramaProdControlCalidad=res.getInt("codProgProdCC");
            }
            /* for(ProgramaProduccionControlCalidad bean:programaProduccionAgregar)
            {
               consulta="INSERT INTO PROGRAMA_PRODUCCION_CONTROL_CALIDAD(COD_PROGRAMA_PROD,"+
                        " COD_COMPPROD, COD_FORMULA_MAESTRA, COD_ESTADO_PROGRAMA, COD_LOTE_PRODUCCION,"+
                        " CANT_LOTE_PRODUCCION, OBSERVACION, COD_TIPO_PROGRAMA_PROD, TIEMPO_ESTUDIO,"+
                        " PRODUCTO, CANTIDAD_MUESTRAS, DISOLUCION, VALORACION,COD_PROGRAMA_PROD_CONTROL_CALIDAD,COD_TIPO_MATERIAL_REACTIVO)"+
                        " VALUES ('"+programaProduccionPeriodoSeleccionado.getCodProgramaProduccion()+"'," +
                        "'"+bean.getComponentesProd().getCodCompprod()+"','"+bean.getFormulaMaestra().getCodFormulaMaestra()+"',"+
                        " 2,'"+codLoteProduccion+"','"+bean.getFormulaMaestra().getCantidadLote()+"','"+bean.getObservacion()+"',"+
                        "'"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"','"+bean.getTiempoEstudio()+"', " +
                        " '"+bean.getProducto()+"','"+bean.getCantidadMuestras()+"','"+(bean.isDisolucion()?1:0)+"'" +
                        ",'"+(bean.isValoracion()?1:0)+"','"+codProgramaProdControlCalidad+"','"+bean.getTiposMaterialReactivo().getCodTipoMaterialReactivo()+"')";
             System.out.println("consulta Insert "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>=0)System.out.println("se registro el programa produccion de control de calidad");
                consulta="select fmd.COD_MATERIAL,fmd.CANTIDAD,fmd.COD_UNIDAD_MEDIDA,fmd.COD_TIPO_ANALISIS_MATERIAL"+
                         " from FORMULA_MAESTRA_DETALLE_MR fmd where fmd.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'"+
                         " and fmd.COD_TIPO_MATERIAL='"+bean.getTiposMaterialReactivo().getCodTipoMaterialReactivo()+"' and fmd.COD_TIPO_ANALISIS_MATERIAL in ("+(bean.isValoracion()?"1":"-1")+","+(bean.isDisolucion()?"2":"-1")+")";
                res=st.executeQuery(consulta);
                while(res.next())
                {
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_CONTROL_CALIDAD_DETALLE(COD_PROGRAMA_PROD_CONTROL_CALIDAD, COD_MATERIAL," +
                            " COD_UNIDAD_MEDIDA, CANTIDAD,COD_TIPO_ANALISIS_MATERIAL)"+
                            " VALUES ('"+codProgramaProdControlCalidad+"','"+res.getString("COD_MATERIAL")+"', " +
                            "'"+res.getString("COD_UNIDAD_MEDIDA")+"','"+(res.getDouble("CANTIDAD")*bean.getCantidadMuestras())+"'," +
                            "'"+res.getString("COD_TIPO_ANALISIS_MATERIAL")+"')";
                    System.out.println("consulta insert "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registraron los materiales");
                }

            }*/
            con.commit();
            mensaje="1";
            res.close();
            st.close();
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un problema al momento de registrar el programa de produccion,intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
        return null;
    }

    private void cargarAlmacenesMuestra()
    {
        try
        {
            con=Util.openConnection(con);
            String consulta="SELECT a.COD_ALMACEN_MUESTRA,a.NOMBRE_ALMACEN_MUESTRA FROM ALMACENES_MUESTRA a"+
                            " where a.COD_ESTADO_REGISTRO=1 order by a.NOMBRE_ALMACEN_MUESTRA  ";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            almacenMuestraSelectList.clear();
            while(res.next())
            {
                almacenMuestraSelectList.add(new SelectItem(res.getInt("COD_ALMACEN_MUESTRA"),res.getString("NOMBRE_ALMACEN_MUESTRA")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarTiposEstudioEstabilidad()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tee.COD_TIPO_ESTUDIO_ESTABILIDAD,tee.NOMBRE_TIPO_ESTUDIO_ESTABILIDAD from TIPOS_ESTUDIO_ESTABILIDAD tee where tee.COD_ESTADO_REGISTRO=1 "+
                            " order by tee.NOMBRE_TIPO_ESTUDIO_ESTABILIDAD";
            ResultSet res=st.executeQuery(consulta);
            tiposEstudioEstabilidadSelectList.clear();
            while(res.next())
            {
                tiposEstudioEstabilidadSelectList.add(new SelectItem(res.getInt("COD_TIPO_ESTUDIO_ESTABILIDAD"),res.getString("NOMBRE_TIPO_ESTUDIO_ESTABILIDAD")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }

    public String getCargarAgregarProgramaControlCalidad()
    {
        this.cargarTiposMaterialReactivo();
        this.cargarTiposEstudioEstabilidad();
        this.cargarAlmacenesMuestra();
        this.cargarFormulasMaestrasSelect();
        programaProduccionControlCalidadAgregar=new ProgramaProduccionControlCalidad();
        programaProduccionControlCalidadAgregar.setTiempoEstudio(6);
        programaProdDataModel.setWrappedData(new ArrayList());
        programaProduccionControlCalidadAnalisisAgregarList.clear();
        return null;
    }
    public String getCargarEditarProgramaControlCalidad()
    {
        this.cargarTiposMaterialReactivo();
        this.cargarTiposEstudioEstabilidad();
        this.cargarAlmacenesMuestra();
        this.cargarFormulasMaestrasSelect();
        programaProduccionBuscar.setCodProgramaProduccion(programaProduccionControlCalidadEditar.getProgramaProduccionPeriodoLoteProduccion().getCodProgramaProduccion());
        programaProduccionBuscar.setCodLoteProduccion(programaProduccionControlCalidadEditar.getCodLoteProduccion());
        this.buscarProgramaProduccionAgregarAction();
        fechaInicioAnalisis=(Date)programaProduccionControlCalidadEditar.getProgramaProduccionControlCalidadAnalisisList().get(1).getFechaAnalisis().clone();
        this.cargarMateriales();
        return null;
    }
    
    public String guardarEdicionLotesProgramaProduccionCC_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=null;
            String consulta="";
            PreparedStatement pst=null;
            for(ProgramaProduccionControlCalidad bean:programaProduccionEditarList)
            {
/*                consulta="UPDATE PROGRAMA_PRODUCCION_CONTROL_CALIDAD"+
                         " SET COD_PROGRAMA_PROD = '"+bean.getProgramaProduccionPeriodo().getCodProgramaProduccion()+"',"+
                         " COD_COMPPROD = '"+bean.getComponentesProd().getCodCompprod()+"',"+
                         " COD_FORMULA_MAESTRA = '"+bean.getFormulaMaestra().getCodFormulaMaestra()+"',"+
                         " COD_ESTADO_PROGRAMA = '1',"+
                         " COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"',"+
                         " CANT_LOTE_PRODUCCION = '"+bean.getFormulaMaestra().getCantidadLote()+"',"+
                         " OBSERVACION = '"+bean.getObservacion()+"',"+
                         " COD_TIPO_PROGRAMA_PROD = '"+bean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"',"+
                         " TIEMPO_ESTUDIO = '"+bean.getTiempoEstudio()+"',"+
                         " PRODUCTO = '"+bean.getProducto()+"',"+
                         " CANTIDAD_MUESTRAS = '"+bean.getCantidadMuestras()+"',"+
                         " DISOLUCION = '"+(bean.isDisolucion()?"1":"0")+"',"+
                         " VALORACION = '"+(bean.isValoracion()?"1":"0")+"',"+
                         " COD_TIPO_MATERIAL_REACTIVO = '"+bean.getTiposMaterialReactivo().getCodTipoMaterialReactivo()+"'"+
                         " WHERE COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+bean.getCodProgramaProdControlCalidad()+"'";
             */   System.out.println("consulta update programaProdControlCalidad "+consulta );
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se actualizo el programa de produccion");
                consulta="delete PROGRAMA_PRODUCCION_CONTROL_CALIDAD_DETALLE where COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+bean.getCodProgramaProdControlCalidad()+"'";
                System.out.println("consulta delete detalle "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se eliminaron los detalles");
           /*       consulta="select fmd.COD_MATERIAL,fmd.CANTIDAD,fmd.COD_UNIDAD_MEDIDA,fmd.COD_TIPO_ANALISIS_MATERIAL"+
                         " from FORMULA_MAESTRA_DETALLE_MR fmd where fmd.COD_FORMULA_MAESTRA='"+bean.getFormulaMaestra().getCodFormulaMaestra()+"'"+
                         " and fmd.COD_TIPO_MATERIAL='"+bean.getTiposMaterialReactivo().getCodTipoMaterialReactivo()+"' and fmd.COD_TIPO_ANALISIS_MATERIAL in ("+(bean.isValoracion()?"1":"-1")+","+(bean.isDisolucion()?"2":"-1")+")";
             */   res=st.executeQuery(consulta);
                while(res.next())
                {
                    consulta="INSERT INTO PROGRAMA_PRODUCCION_CONTROL_CALIDAD_DETALLE(COD_PROGRAMA_PROD_CONTROL_CALIDAD, COD_MATERIAL," +
                            " COD_UNIDAD_MEDIDA, CANTIDAD,COD_TIPO_ANALISIS_MATERIAL)"+
                            " VALUES ('"+bean.getCodProgramaProdControlCalidad()+"','"+res.getString("COD_MATERIAL")+"', " +
                            "'"+res.getString("COD_UNIDAD_MEDIDA")+"','"+(res.getDouble("CANTIDAD")*bean.getCantidadMuestras())+"'," +
                            "'"+res.getString("COD_TIPO_ANALISIS_MATERIAL")+"')";
                    System.out.println("consulta insert "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registraron los materiales");
                }
            }
            con.commit();
            mensaje="1";
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            mensaje="Ocurrio un problema la momento de registrar la edicion, intente de nuevo";
            ex.printStackTrace();
            con.rollback();
        }
        return null;

    }

    private void cargarFormulasMaestrasSelect()
    {
        
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select fm.COD_FORMULA_MAESTRA,(cp.nombre_prod_semiterminado+'('+CAST(fm.CANTIDAD_LOTE as varchar)+')') as productoFormula"+
                            " from FORMULA_MAESTRA fm inner join COMPONENTES_PROD cp "+
                            " on cp.COD_COMPPROD=fm.COD_COMPPROD where cp.COD_ESTADO_COMPPROD=1"+
                            " and fm.COD_ESTADO_REGISTRO=1"+
                            " order by cp.nombre_prod_semiterminado";
            ResultSet res=st.executeQuery(consulta);
            programaProduccionControlCalidadBean.getFormulaMaestra().setCodFormulaMaestra(consulta);
            System.out.println("consulta cargar "+consulta);
            formulasMaestrasSelectList.clear();
            formulasMaestrasSelectList.add(new SelectItem("0","-Seleccion una opción-"));
            while(res.next())
            {
                formulasMaestrasSelectList.add(new SelectItem(res.getString("COD_FORMULA_MAESTRA"),res.getString("productoFormula")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarContenidoProgramaProduccionPeriodo()
    {
        try {
//            programaProduccionBuscar = new ProgramaProduccion();
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES,(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA),pp.fecha_inicio,pp.fecha_final NOMBRE_ESTADO_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 AND PP.COD_TIPO_PRODUCCION = 3";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionPeriodoList.clear();
            while(rs.next()){
                ProgramaProduccionPeriodo programaProduccionPeriodo = new ProgramaProduccionPeriodo();
                programaProduccionPeriodo.setCodProgramaProduccion(rs.getString("COD_PROGRAMA_PROD"));
                programaProduccionPeriodo.setNombreProgramaProduccion(rs.getString("NOMBRE_PROGRAMA_PROD"));
                programaProduccionPeriodo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccionPeriodo.setObsProgramaProduccion(rs.getString("OBSERVACIONES"));
                programaProduccionPeriodo.setFechaInicio(rs.getDate("fecha_inicio"));
                programaProduccionPeriodo.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccionPeriodoList.add(programaProduccionPeriodo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String getCargarContenidoProgramaProduccionPeriodo(){

        this.cargarContenidoProgramaProduccionPeriodo();
        return null;
    }
    public String guardarEdicionProgramaProduccionPeriodo_action(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            String consulta =" Update PROGRAMA_PRODUCCION_PERIODO set NOMBRE_PROGRAMA_PROD='"+programaProduccionPeriodoEditar.getNombreProgramaProduccion()+"'"+
                              " ,OBSERVACIONES='"+programaProduccionPeriodoEditar.getObsProgramaProduccion()+"' where COD_PROGRAMA_PROD='"+programaProduccionPeriodoEditar.getCodProgramaProduccion()+"'";
            System.out.println("consuslta " + consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se guardo la edicion del programa produccion periodo");
            con.close();
            Util.redireccionar("navegador_programa_periodo_control_calidad.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarProgramaProduccionPeriodo_action()
    {
        try
        {
            con=Util.openConnection(con);
            Iterator e =programaProduccionPeriodoList.iterator();
            while(e.hasNext())
            {
                ProgramaProduccionPeriodo bean=(ProgramaProduccionPeriodo)e.next();
                if(bean.getChecked())
                {
                    String consulta="delete PROGRAMA_PRODUCCION_PERIODO  where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"'";
                    System.out.println("consulta delete programa periodo "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino el programa de produccion");
                    consulta="delete PROGRAMA_PRODUCCION_CONTROL_CALIDAD_DETALLE where"+
                             " COD_PROGRAMA_PROD_CONTROL_CALIDAD in ("+
                             " select pp.COD_PROGRAMA_PROD_CONTROL_CALIDAD from PROGRAMA_PRODUCCION_CONTROL_CALIDAD pp where pp.COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"')";
                    System.out.println("consulta delete detalle programa produccion "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los detalles de los lotes del programa");
                    consulta="delete PROGRAMA_PRODUCCION_CONTROL_CALIDAD  where COD_PROGRAMA_PROD='"+bean.getCodProgramaProduccion()+"'";
                    System.out.println("consulta delete programa produccion "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los lotes del programa");
                }   
            }
            con.close();
        }
        catch(SQLException ex)
        { 
            ex.printStackTrace();
        }
        this.cargarContenidoProgramaProduccionPeriodo();
        return null;
    }
    public String guardarProgramaProduccionPeriodo_action(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            String consulta = " INSERT INTO PROGRAMA_PRODUCCION_PERIODO(  COD_PROGRAMA_PROD,  NOMBRE_PROGRAMA_PROD,  OBSERVACIONES,  COD_ESTADO_PROGRAMA," +
                    "  FECHA_INICIO,  FECHA_FINAL,  COD_TIPO_PRODUCCION) VALUES ( (select max((isnull(cod_programa_prod,0)))+1 from programa_produccion_periodo), '"+programaProduccionPeriodo.getNombreProgramaProduccion()+"'," +
                    "  '"+programaProduccionPeriodo.getObsProgramaProduccion()+"',  1, '"+sdf.format(new Date())+"' , null,  3);";
            System.out.println("consuslta " + consulta);
            st.executeUpdate(consulta);
            st.close();
            con.close();
            Util.redireccionar("navegador_programa_periodo_control_calidad.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String getCargarEdicionLoteProgramaProduccion()
    {
        this.cargarAlmacenesMuestra();
        return null;
    }
    public String eliminarProgramaProduccionControlCalidad_action()throws SQLException
    {
        mensaje="";
        Iterator e=programaProduccionControlCalidadList.iterator();
        while(e.hasNext())
        {
            ProgramaProduccionControlCalidad bean=(ProgramaProduccionControlCalidad)e.next();
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="delete PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS  where COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+bean.getCodProgramaProdControlCalidad()+"'";
                    System.out.println("consulta delete analisis lote "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se eliminaron los analisis del lote");
                    consulta="delete PROGRAMA_PRODUCCION_CONTROL_CALIDAD  where COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+bean.getCodProgramaProdControlCalidad()+"'";
                    System.out.println("consulta delete programa produccion cc "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino el  DETALLE programa de produccion cc ");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un  problema la momento de eliminar el registro, intente de nuevo";
                    con.rollback();
                    ex.printStackTrace();
                }
                finally
                {
                    con.close();
                    
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarProgramaProduccionControlCalidad();
        }
        return null;
    }
    public String editarLoteProgramaProduccionControlCalidad_action()
    {
        Iterator e=programaProduccionControlCalidadList.iterator();
        programaProduccionEditarList.clear();
        while(e.hasNext())
        {
            ProgramaProduccionControlCalidad bean=(ProgramaProduccionControlCalidad)e.next();
            if(bean.getChecked())
            {
                programaProduccionEditarList.add(bean);
            }
        }
        return  null;
    }
    public String ingresarProgramaProduccion_action(){
        try {
            programaProduccionPeriodoSeleccionado = (ProgramaProduccionPeriodo)programaProduccionPeriodoDataTable.getRowData();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    private void cargarProgramaProduccionControlCalidad()
    {
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = "select ppcca.COD_CONTROL_CALIDAD_ANALISIS,ppcc.COD_LOTE_PRODUCCION,ppcc.CANTIDAD_MUESTRAS,pp.CANT_LOTE_PRODUCCION,"+
                              " ppcc.COD_ALMACEN_MUESTRA,am.NOMBRE_ALMACEN_MUESTRA,cp.COD_COMPPROD,"+
                              " cp.nombre_prod_semiterminado,ppcc.COD_FORMULA_MAESTRA,ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD,"+
                              " ppcc.COD_TIPO_ESTUDIO_ESTABILIDAD,tee.NOMBRE_TIPO_ESTUDIO_ESTABILIDAD,ppcc.TIEMPO_ESTUDIO,"+
                              " tmr.NOMBRE_TIPO_MATERIAL_REACTIVO,tmr.COD_TIPO_MATERIAL_REACTIVO,ppcca.CANTIDAD_TEST_DISOLUCION,"+
                              " ppcca.FECHA_ANALISIS,ppcca.OBSERVACION,ppcca.PROCEDE,ppcca.TIEMPO_ESTUDIO as tiempoEstudioDetalle,ppcca.CANTIDAD_TEST_VALORACION" +
                              " ,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppp.COD_PROGRAMA_PROD as codProgramaLoteProd,ppp.NOMBRE_PROGRAMA_PROD"+
                              " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD ppcc inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD=ppcc.COD_PROGRAMA_PROD_LOTE_PRODUCCCION and ppcc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION" +
                              " and ppcc.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD and pp.COD_FORMULA_MAESTRA=ppcc.COD_FORMULA_MAESTRA" +
                              " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                              " inner join ALMACENES_MUESTRA am on am.COD_ALMACEN_MUESTRA=ppcc.COD_ALMACEN_MUESTRA"+
                              " inner join TIPOS_ESTUDIO_ESTABILIDAD tee on tee.COD_TIPO_ESTUDIO_ESTABILIDAD=ppcc.COD_TIPO_ESTUDIO_ESTABILIDAD"+
                              " inner join PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS ppcca on ppcca.COD_PROGRAMA_PROD_CONTROL_CALIDAD =ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD" +
                              " left outer join TIPOS_MATERIAL_REACTIVO tmr on"+
                              " tmr.COD_TIPO_MATERIAL_REACTIVO=ppcca.COD_TIPO_MATERIAL_REACTIVO" +
                              " left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppcc.COD_TIPO_PROGRAMA_PROD" +
                              " left outer join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=ppcc.COD_PROGRAMA_PROD_LOTE_PRODUCCCION" +
                              " where ppcc.COD_PROGRAMA_PROD='"+programaProduccionPeriodoSeleccionado.getCodProgramaProduccion()+"'"+
                              " order by cp.nombre_prod_semiterminado,ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD,ppcca.FECHA_ANALISIS";
            System.out.println("consulta cargar pp "+consulta);
            ResultSet res = st.executeQuery(consulta);
            programaProduccionControlCalidadList.clear();
            int codCabeceraProd=0;
            ProgramaProduccionControlCalidad programaProduccion = new ProgramaProduccionControlCalidad();
            List<ProgramaProduccionControlCalidadAnalisis> nuevaLista=null;
            while(res.next()){
                if(codCabeceraProd!=res.getInt("COD_PROGRAMA_PROD_CONTROL_CALIDAD"))
                {
                    if(codCabeceraProd>0)
                    {
                        programaProduccion.setProgramaProduccionControlCalidadAnalisisList(nuevaLista);
                        programaProduccionControlCalidadList.add(programaProduccion);
                    }
                    programaProduccion=new ProgramaProduccionControlCalidad();
                    programaProduccion.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                    programaProduccion.setCantidadMuestras(res.getInt("CANTIDAD_MUESTRAS"));
                    programaProduccion.setCantLoteProduccion(res.getDouble("CANT_LOTE_PRODUCCION"));
                    programaProduccion.getAlmacenesMuestra().setCodAlmacenMuestra(res.getInt("COD_ALMACEN_MUESTRA"));
                    programaProduccion.getAlmacenesMuestra().setNombreAlmacenMuestra(res.getString("NOMBRE_ALMACEN_MUESTRA"));
                    programaProduccion.getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                    programaProduccion.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                    programaProduccion.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                    programaProduccion.setCodProgramaProdControlCalidad(res.getInt("COD_PROGRAMA_PROD_CONTROL_CALIDAD"));
                    programaProduccion.getTiposEstudioEstabilidad().setCodTipoEstudioEstabilidad(res.getInt("COD_TIPO_ESTUDIO_ESTABILIDAD"));
                    programaProduccion.getTiposEstudioEstabilidad().setNombreTipoEstudioEstabilidad(res.getString("NOMBRE_TIPO_ESTUDIO_ESTABILIDAD"));
                    programaProduccion.setTiempoEstudio(res.getInt("TIEMPO_ESTUDIO"));
                    programaProduccion.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                    programaProduccion.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                    programaProduccion.getProgramaProduccionPeriodoLoteProduccion().setCodProgramaProduccion(res.getString("codProgramaLoteProd"));
                    programaProduccion.getProgramaProduccionPeriodoLoteProduccion().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                    nuevaLista=new ArrayList<ProgramaProduccionControlCalidadAnalisis>();
                    codCabeceraProd=res.getInt("COD_PROGRAMA_PROD_CONTROL_CALIDAD");
                }
                ProgramaProduccionControlCalidadAnalisis nuevo=new ProgramaProduccionControlCalidadAnalisis();
                nuevo.setCodControlCalidadAnalisis(res.getInt("COD_CONTROL_CALIDAD_ANALISIS"));
                nuevo.getTipoMaterialReactivo().setNombreTipoMaterialReactivo(res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO"));
                nuevo.getTipoMaterialReactivo().setCodTipoMaterialReactivo(res.getInt("COD_TIPO_MATERIAL_REACTIVO"));
                nuevo.setCantidadTestDisolucion(res.getInt("CANTIDAD_TEST_DISOLUCION"));
                nuevo.setFechaAnalisis(res.getTimestamp("FECHA_ANALISIS"));
                nuevo.setObservacion(res.getString("OBSERVACION"));
                nuevo.setProcede(res.getInt("PROCEDE"));
                nuevo.setTiempoEstudio(res.getInt("tiempoEstudioDetalle"));
                nuevo.setCantidadTestValoracion(res.getInt("CANTIDAD_TEST_VALORACION"));
                nuevaLista.add(nuevo);
            }
            if(codCabeceraProd>0)
            {
                programaProduccion.setProgramaProduccionControlCalidadAnalisisList(nuevaLista);
                programaProduccionControlCalidadList.add(programaProduccion);
            }
            st.close();
            
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String getCargarProgramaProduccionControlCalidad(){
        
        this.cargarProgramaProduccionPeriodo();
        this.cargarProgramaProduccionControlCalidad();
        
        return null;
    }
    public void cargarMateriales(){
        try {
                    System.out.println("entro cargar materiales .....");
                    Connection con = null;
                    con = Util.openConnection(con);
                    Statement st = con.createStatement();
                            
            for(ProgramaProduccionControlCalidadAnalisis pr :programaProduccionControlCalidadEditar.getProgramaProduccionControlCalidadAnalisisList()){

                //System.out.println("data "  + pr.getProgramaProduccionControlCalidad() + " " +
                //      programaProduccionControlCalidadEditar.getCodLoteProduccion() + pr.getCodControlCalidadAnalisis());
                    String consulta = " select m.COD_MATERIAL,m.NOMBRE_MATERIAL,u.cod_unidad_medida,u.ABREVIATURA,p.cod_control_calidad_analisis,p.cantidad" +
                            " from PROGRAMA_PROD_CONTROL_CALIDAD_DETALLE p" +
                            " inner join materiales m on m.COD_MATERIAL = p.cod_material" +
                            " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = p.cod_unidad_medida" +
                            " where p.cod_programa_prod_control_calidad = '"+programaProduccionControlCalidadEditar.getCodProgramaProdControlCalidad()+"'" +
                            " and p.cod_lote_produccion = '"+programaProduccionControlCalidadEditar.getCodLoteProduccion()+"'" +
                            " and p.cod_control_calidad_analisis = '"+pr.getCodControlCalidadAnalisis()+"' ";
                    
                    System.out.println("consulta " + consulta);
                    ResultSet rs = st.executeQuery(consulta);
                    pr.getMaterialesList().clear();
                    while(rs.next()){
                        ProgramaProdControlCalidadDetalle p = new ProgramaProdControlCalidadDetalle();
                        p.getMateriales().setCodMaterial(rs.getString("cod_material"));
                        p.getMateriales().setNombreMaterial(rs.getString("nombre_material"));
                        p.getMateriales().getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
                        p.getMateriales().getUnidadesMedida().setAbreviatura(rs.getString("abreviatura"));
                        p.setCodProgramaProdControlCalidadDetalle(rs.getInt("cod_control_calidad_analisis"));
                        p.setCantidad(rs.getDouble("cantidad"));
                        pr.getMaterialesList().add(p);
                    }
            }
            st.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String seleccionarAnalisisProgramaProduccion()
    {
        Map<String,String> params=FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
       produccionControlCalidadAnalisisEditar.setCodControlCalidadAnalisis(Integer.valueOf(params.get("codControlAnalisis")));
       ProgramaProduccionControlCalidad nuevo=new ProgramaProduccionControlCalidad();
       nuevo.setCodProgramaProdControlCalidad(Integer.valueOf(params.get("codPrograma")));
       try
       {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select cp.nombre_prod_semiterminado,am.NOMBRE_ALMACEN_MUESTRA,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                            " ,ppcc.COD_LOTE_PRODUCCION,ppcca.FECHA_ANALISIS,tmr.COD_TIPO_MATERIAL_REACTIVO,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO"+
                            " ,ppcca.CANTIDAD_TEST_DISOLUCION,ppcca.CANTIDAD_TEST_VALORACION,ppcca.PROCEDE,ppcca.OBSERVACION,ppcca.TIEMPO_ESTUDIO as tiempoEstudioDetalle"+
                            " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD ppcc inner join "+
                            " PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS ppcca on"+
                            " ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD=ppcca.COD_PROGRAMA_PROD_CONTROL_CALIDAD"+
                            " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=ppcc.COD_FORMULA_MAESTRA"+
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD"+
                            " inner join ALMACENES_MUESTRA am on am.COD_ALMACEN_MUESTRA=ppcc.COD_ALMACEN_MUESTRA"+
                            " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppcc.COD_TIPO_PROGRAMA_PROD"+
                            " inner join TIPOS_MATERIAL_REACTIVO tmr on tmr.COD_TIPO_MATERIAL_REACTIVO=ppcca.COD_TIPO_MATERIAL_REACTIVO"+
                            " where ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+nuevo.getCodProgramaProdControlCalidad()+"'"+
                            " and ppcca.COD_CONTROL_CALIDAD_ANALISIS='"+produccionControlCalidadAnalisisEditar.getCodControlCalidadAnalisis()+"'";
            System.out.println("consulta cargar analisis "+consulta);
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                nuevo.getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.getAlmacenesMuestra().setNombreAlmacenMuestra(res.getString("NOMBRE_ALMACEN_MUESTRA"));
                nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                nuevo.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                produccionControlCalidadAnalisisEditar.setFechaAnalisis(res.getTimestamp("FECHA_ANALISIS"));
                fechaInicialAnalisis=res.getTimestamp("FECHA_ANALISIS");
                recorrerFechas=true;
                produccionControlCalidadAnalisisEditar.getTipoMaterialReactivo().setCodTipoMaterialReactivo(res.getInt("COD_TIPO_MATERIAL_REACTIVO"));
                produccionControlCalidadAnalisisEditar.getTipoMaterialReactivo().setNombreTipoMaterialReactivo(res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO"));
                produccionControlCalidadAnalisisEditar.setCantidadTestDisolucion(res.getInt("CANTIDAD_TEST_DISOLUCION"));
                produccionControlCalidadAnalisisEditar.setCantidadTestValoracion(res.getInt("CANTIDAD_TEST_VALORACION"));
                produccionControlCalidadAnalisisEditar.setProcede(res.getInt("PROCEDE"));
                produccionControlCalidadAnalisisEditar.setObservacion(res.getString("OBSERVACION"));
                produccionControlCalidadAnalisisEditar.setTiempoEstudio(res.getInt("tiempoEstudioDetalle"));
                produccionControlCalidadAnalisisEditar.setProgramaProduccionControlCalidad(nuevo);
            }
            res.close();
            st.close();
            con.close();
       }
       catch(SQLException ex)
       {
           ex.printStackTrace();
       }
       return null;
    }

    int codTipoResultado = 0;
    
//    public String registrarResultados_action()
//    {
//
//
//      try {
//
//       Map<String,String> params=FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
//       produccionControlCalidadAnalisisEditar.setCodControlCalidadAnalisis(Integer.valueOf(params.get("codControlAnalisis")));
//       produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().setCodProgramaProdControlCalidad(Integer.valueOf(params.get("codPrograma")));
//       produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().setCodLoteProduccion(params.get("codLoteProduccion"));
//       produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().getTiposProgramaProduccion().setNombreTipoProgramaProd(params.get("nombreTipoProgramaProd"));
//       produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().getComponentesProd().setNombreProdSemiterminado(params.get("nombreProdSemiterminado"));
//       produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().setCodLoteProduccion(params.get("codLoteProduccion"));
//       produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().getAlmacenesMuestra().setNombreAlmacenMuestra(params.get("nombreAlmacenMuestra"));
//       produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().getTiposEstudioEstabilidad().setNombreTipoEstudioEstabilidad(params.get("nombreTipoEstudioEstabilidad"));
//       produccionControlCalidadAnalisisEditar.setCodTipoResultadoEstabilidad(params.get("codTipoResultadoEstabilidad"));
//
//
//
//
//
//       ProgramaProduccionControlCalidad nuevo=new ProgramaProduccionControlCalidad();
//       nuevo.setCodProgramaProdControlCalidad(Integer.valueOf(params.get("codPrograma")));
//       String consulta =  " select f1.COD_ESPECIFICACION,f1.NOMBRE_ESPECIFICACION," +
//               " f.LIMITE_INFERIOR,f.LIMITE_SUPERIOR,f.DESCRIPCION,f.VALOR_EXACTO," +
//               " f1.COD_TIPO_RESULTADO_ANALISIS,r.cantidad,r.COD_TIPO_RESULTADO_DESCRIPTIVO,r.resultado_numerico " +
//               " from ESPECIFICACIONES_FISICAS_PRODUCTO f" +
//               " inner join ESPECIFICACIONES_FISICAS_CC f1" +
//               " on f.COD_ESPECIFICACION=f1.COD_ESPECIFICACION" +
//               " left outer join resultado_fisico_estabilidad r on r.cod_especificacion = f.COD_ESPECIFICACION " +
//               " and r.cod_programa_prod_control_calidad = '"+params.get("codPrograma")+"' and r.cod_control_calidad_analisis = '"+params.get("codControlAnalisis")+"'  and r.cod_tipo_resultado_estabilidad ='"+produccionControlCalidadAnalisisEditar.getCodTipoResultadoEstabilidad()+"'  " +
//               " where f.COD_PRODUCTO='"+params.get("codCompProd")+"' and f.ESTADO=1 ";
//
//       System.out.println("consulta " + consulta);
//       Connection con = null;
//       con = Util.openConnection(con);
//       Statement st = con.createStatement();
//       ResultSet rs = st.executeQuery(consulta);
////       resultadoFisicoEstabilidad.clear();
////       while(rs.next()){
////           ResultadoFisicoEstabilidad r = new ResultadoFisicoEstabilidad();
////           r.getProgramaProduccionControlCalidadAnalisis().getProgramaProduccionControlCalidad().setCodProgramaProdControlCalidad(Integer.valueOf(params.get("codPrograma")));
////           r.getProgramaProduccionControlCalidadAnalisis().setCodControlCalidadAnalisis(Integer.valueOf(params.get(("codControlAnalisis"))));
////           r.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().setCodEspecificacion(rs.getInt("cod_especificacion"));
////           r.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().setNombreEspecificacion(rs.getString("nombre_especificacion"));
////           r.getEspecificacionesFisicasProducto().setLimiteInferior(rs.getDouble("limite_inferior"));
////           r.getEspecificacionesFisicasProducto().setLimiteSuperior(rs.getDouble("limite_superior"));
////           r.getEspecificacionesFisicasProducto().setDescripcion(rs.getString("descripcion"));
////           r.getEspecificacionesFisicasProducto().setValorExacto(rs.getDouble("valor_exacto"));
////           r.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getTipoResultadoAnalisis().setCodTipoResultadoAnalisis(rs.getString("cod_tipo_resultado_analisis"));
////           r.setCantidad(rs.getDouble("cantidad"));
////           r.setCodTipoResultadoDescriptivo(rs.getInt("cod_tipo_resultado_descriptivo"));
////           r.setResultadoNumerico(rs.getDouble("resultado_numerico"));
////           resultadoFisicoEstabilidad.add(r);
////       }
//            System.out.println("la lista " + resultadoFisicoEstabilidad.size());
//
//       consulta = " select m.cod_material,m.nombre_material,eqp.COD_ESPECIFICACION,m.NOMBRE_MATERIAL,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.DESCRIPCION,r.resultado_numerico,r.cod_tipo_resultado,r.COD_TIPO_RESULTADO_DESCRIPTIVO,r.resultado_numerico" +
//               " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp" +
//               " inner join materiales m on m.COD_MATERIAL=eqp.COD_MATERIAL" +
//               " left outer join resultado_quimico_estabilidad r on r.cod_especificacion = eqp.COD_ESPECIFICACION" +
//               " and r.cod_programa_prod_control_calidad ='"+params.get("codPrograma")+"' and r.cod_control_calidad_analisis = '"+params.get("codControlAnalisis")+"' and r.cod_tipo_resultado_estabilidad ='"+produccionControlCalidadAnalisisEditar.getCodTipoResultadoEstabilidad()+"' and r.cod_material = eqp.cod_material " +
//               " where eqp.COD_PRODUCTO='"+params.get("codCompProd")+"' and eqp.ESTADO=1 and eqp.cod_especificacion = 2 ";
//       System.out.println("consulta " + consulta);
//       con = Util.openConnection(con);
//       Statement st1 = con.createStatement();
//       ResultSet rs1 = st.executeQuery(consulta);
////       resultadoQuimicoEstabilidad.clear();
////       while(rs1.next()){
////           ResultadoQuimicoEstabilidad r = new ResultadoQuimicoEstabilidad();
////           r.getProgramaProduccionControlCalidadAnalisis().getProgramaProduccionControlCalidad().setCodProgramaProdControlCalidad(Integer.valueOf(params.get("codPrograma")));
////           r.getProgramaProduccionControlCalidadAnalisis().setCodControlCalidadAnalisis(Integer.valueOf(params.get(("codControlAnalisis"))));
////           r.getEspecificacionesQuimicasProducto().getEspecificacionQuimica().setCodEspecificacion(rs1.getInt("cod_especificacion"));
////
////           r.getEspecificacionesQuimicasProducto().setLimiteInferior(rs1.getDouble("limite_inferior"));
////           r.getEspecificacionesQuimicasProducto().setLimiteSuperior(rs1.getDouble("limite_superior"));
////           r.getEspecificacionesQuimicasProducto().setDescripcion(rs1.getString("descripcion"));
////           r.getEspecificacionesQuimicasProducto().setValorExacto(0);
////
////           r.setCodTipoResultadoDescriptivo(rs1.getInt("cod_tipo_resultado_descriptivo"));
////           r.setResultadoNumerico(rs1.getDouble("resultado_numerico"));
////           r.getMateriales().setCodMaterial(rs1.getString("cod_material"));
////           r.getMateriales().setNombreMaterial(rs1.getString("nombre_material"));
////           resultadoQuimicoEstabilidad.add(r);
////       }
////          System.out.println("la lista " + resultadoQuimicoEstabilidad.size());
//
//
//
//
//        //System.out.println("cod programa prod " + params.get("codPrograma") + " cod_control analisis  " + params.get("codControlAnalisis") );
//
//       } catch (Exception e) {
//           e.printStackTrace();
//        }
//       return null;
//    }
//    public String guardarResultadosFisicosEstabilidad()
//    {
//        try {
//            Map<String,String> params=FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
//            Connection con = null;
//            con = Util.openConnection(con);
//            Statement st = con.createStatement();
//            String consulta = "";
//            consulta = " delete from resultado_fisico_estabilidad where cod_programa_prod_control_calidad = '"+produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"' and cod_control_calidad_analisis ='"+produccionControlCalidadAnalisisEditar.getCodControlCalidadAnalisis()+"' and cod_tipo_resultado_estabilidad = '"+produccionControlCalidadAnalisisEditar.getCodTipoResultadoEstabilidad()+"' ";
//            System.out.println("consulta " + consulta);
//            st.executeUpdate(consulta);
//            for(ResultadoFisicoEstabilidad r:resultadoFisicoEstabilidad){
//            consulta = " INSERT INTO resultado_fisico_estabilidad( cod_programa_prod_control_calidad,  cod_control_calidad_analisis," +
//                    "  cod_especificacion,  cod_tipo_resultado,  cantidad,  COD_TIPO_RESULTADO_DESCRIPTIVO," +
//                    "  resultado_numerico,cod_tipo_resultado_estabilidad) VALUES ( '"+r.getProgramaProduccionControlCalidadAnalisis().getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"',  '"+r.getProgramaProduccionControlCalidadAnalisis().getCodControlCalidadAnalisis()+"',  '"+r.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getCodEspecificacion()+"'," +
//                    "  1,  0,  '"+r.getCodTipoResultadoDescriptivo()+"',  '"+r.getResultadoNumerico()+"','"+produccionControlCalidadAnalisisEditar.getCodTipoResultadoEstabilidad()+"'); ";
//                    System.out.println("consulta guardar "+consulta);
//                    st.executeUpdate(consulta);
//            }
//            consulta = " delete from resultado_quimico_estabilidad where cod_programa_prod_control_calidad = '"+produccionControlCalidadAnalisisEditar.getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"' and cod_control_calidad_analisis ='"+produccionControlCalidadAnalisisEditar.getCodControlCalidadAnalisis()+"' and cod_tipo_resultado_estabilidad = '"+produccionControlCalidadAnalisisEditar.getCodTipoResultadoEstabilidad()+"' ";
//            System.out.println("consulta " + consulta);
//            st.executeUpdate(consulta);
////            for(ResultadoFisicoEstabilidad r:resultadoFisicoEstabilidad){
////            consulta = " INSERT INTO resultado_fisico_estabilidad(  cod_programa_prod_control_calidad,  cod_control_calidad_analisis," +
////                    "  cod_especificacion,  cod_tipo_resultado,  cantidad,  COD_TIPO_RESULTADO_DESCRIPTIVO," +
////                    "  resultado_numerico) VALUES ( '"+r.getProgramaProduccionControlCalidadAnalisis().getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"',  '"+r.getProgramaProduccionControlCalidadAnalisis().getCodControlCalidadAnalisis()+"',  '"+r.getEspecificacionesFisicasProducto().getEspecificacionFisicaCC().getCodEspecificacion()+"'," +
////                    "  1,  0,  '"+r.getCodTipoResultadoDescriptivo()+"',  '"+r.getResultadoNumerico()+"'); ";
////                    System.out.println("consulta guardar "+consulta);
////                    st.executeUpdate(consulta);
////            }
//            for(ResultadoQuimicoEstabilidad r:resultadoQuimicoEstabilidad){
//            consulta = " INSERT INTO resultado_quimico_estabilidad(cod_programa_prod_control_calidad,  cod_control_calidad_analisis,  cod_especificacion," +
//                    "  cod_tipo_resultado,  cantidad,  COD_TIPO_RESULTADO_DESCRIPTIVO,  resultado_numerico,cod_material,cod_tipo_resultado_estabilidad) VALUES ('"+r.getProgramaProduccionControlCalidadAnalisis().getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"',  '"+r.getProgramaProduccionControlCalidadAnalisis().getCodControlCalidadAnalisis()+"',  '"+r.getEspecificacionesQuimicasProducto().getEspecificacionQuimica().getCodEspecificacion()+"'," +
//                    "  2,  0,  '"+r.getCodTipoResultadoDescriptivo()+"',  '"+r.getResultadoNumerico()+"','"+r.getMateriales().getCodMaterial()+"','"+produccionControlCalidadAnalisisEditar.getCodTipoResultadoEstabilidad()+"'); ";
//
//                    System.out.println("consulta guardar "+consulta);
//                    st.executeUpdate(consulta);
//            }
//
//            st.close();
//
//            con.close();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
    
    public String editarProgramaProduccionControlCalidad_action()
    {
        for(ProgramaProduccionControlCalidad bean:programaProduccionControlCalidadList)
        {
            if(bean.getChecked())
            {
                programaProduccionControlCalidadEditar=bean;
            }
        }
        return null;
    }
    
    public List cargaMateriales(){
        List materialesList = new ArrayList();
        try {
        
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
           
        String consulta = "select f.COD_FORMULA_MAESTRA,m.COD_MATERIAL,m.NOMBRE_MATERIAL,u.COD_UNIDAD_MEDIDA,u.ABREVIATURA,f.CANTIDAD cantidad_fm,p.cantidad" +
                " from FORMULA_MAESTRA_DETALLE_MR f inner join materiales m on m.COD_MATERIAL = f.COD_MATERIAL" +
                " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = f.COD_UNIDAD_MEDIDA" +
                " left outer join PROGRAMA_PROD_CONTROL_CALIDAD_DETALLE p on p.cod_formula_maestra = f.COD_FORMULA_MAESTRA" +
                " and p.cod_material = f.COD_MATERIAL and p.cod_programa_prod_control_calidad = '"+programaProduccionControlCalidadAgregar.getCodProgramaProdControlCalidad()+"'" +
                " and p.cod_lote_produccion = '"+programaProduccionControlCalidadAgregar.getCodLoteProduccion()+"'" +
                " where f.COD_FORMULA_MAESTRA = '"+programaProduccionControlCalidadAgregar.getFormulaMaestra().getCodFormulaMaestra()+"'";
            System.out.println("consulta " + consulta);

        ResultSet rs = st.executeQuery(consulta);

        while(rs.next()){
            ProgramaProdControlCalidadDetalle p = new ProgramaProdControlCalidadDetalle();
            p.getMateriales().setCodMaterial(rs.getString("cod_material"));
            p.getMateriales().setNombreMaterial(rs.getString("nombre_material"));
            p.getMateriales().getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
            p.getMateriales().getUnidadesMedida().setAbreviatura(rs.getString("abreviatura"));
            p.setCantidad(rs.getDouble("cantidad")>0.0?rs.getDouble("cantidad"):rs.getDouble("cantidad_fm"));
            materialesList.add(p);
        }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return materialesList;
    }
    public String cargarMateriales_action(){
        programaProduccionControlCalidadAnalisisSeleccionado = (ProgramaProduccionControlCalidadAnalisis)ProgramaProduccionControlCalidadAnalisisDataTable.getRowData();
        materialesList = programaProduccionControlCalidadAnalisisSeleccionado.getMaterialesList();
        return null;
    }
    public String cargarMaterialesEditar_action(){
        programaProduccionControlCalidadAnalisisSeleccionado = (ProgramaProduccionControlCalidadAnalisis)ProgramaProduccionControlCalidadAnalisisEditarDataTable.getRowData();
        materialesList = programaProduccionControlCalidadAnalisisSeleccionado.getMaterialesList();
        return null;
    }
    public String guardarMateriales(ProgramaProduccionControlCalidadAnalisis pr){
        try {
        
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();

        String consulta = " INSERT INTO PROGRAMA_PROD_CONTROL_CALIDAD_DETALLE(  cod_programa_prod,  cod_formula_maestra,  cod_lote_produccion,  cod_material," +
                "  cantidad) VALUES (  '"+pr.getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"',  :cod_formula_maestra,  :cod_lote_produccion,  :cod_material,  :cantidad);";
            System.out.println("consulta " + consulta);

        ResultSet rs = st.executeQuery(consulta);

        while(rs.next()){
            ProgramaProdControlCalidadDetalle p = new ProgramaProdControlCalidadDetalle();
            p.getMateriales().setCodMaterial(rs.getString("cod_material"));
            p.getMateriales().setNombreMaterial(rs.getString("nombre_material"));
            p.getMateriales().getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
            p.getMateriales().getUnidadesMedida().setAbreviatura(rs.getString("abreviatura"));
            p.setCantidad(rs.getDouble("cantidad")>0.0?rs.getDouble("cantidad"):rs.getDouble("cantidad_fm"));
            materialesList.add(p);
       }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEditarMateriales(ProgramaProduccionControlCalidadAnalisis pr){
        try {

        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        String consulta = " delete from programa_prod_control_calidad_detalle where cod_programa_prod = '' and cod_formula_maestra = '' and cod_material = '' and cod_material = '' and  ";

        consulta = " INSERT INTO PROGRAMA_PROD_CONTROL_CALIDAD_DETALLE(  cod_programa_prod,  cod_formula_maestra,  cod_lote_produccion,  cod_material," +
                "  cantidad) VALUES (  '"+pr.getProgramaProduccionControlCalidad().getCodProgramaProdControlCalidad()+"',  :cod_formula_maestra,  :cod_lote_produccion,  :cod_material,  :cantidad);";

            System.out.println("consulta " + consulta);

        ResultSet rs = st.executeQuery(consulta);

        while(rs.next()){
            ProgramaProdControlCalidadDetalle p = new ProgramaProdControlCalidadDetalle();
            p.getMateriales().setCodMaterial(rs.getString("cod_material"));
            p.getMateriales().setNombreMaterial(rs.getString("nombre_material"));
            p.getMateriales().getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
            p.getMateriales().getUnidadesMedida().setAbreviatura(rs.getString("abreviatura"));
            p.setCantidad(rs.getDouble("cantidad")>0.0?rs.getDouble("cantidad"):rs.getDouble("cantidad_fm"));
            materialesList.add(p);
       }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    


    



}
