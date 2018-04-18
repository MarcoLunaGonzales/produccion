/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ModulosInstalaciones;
import com.cofar.bean.PartesMaquinaria;
import com.cofar.bean.SeguimientoPersonalMantenimiento;
import com.cofar.bean.SolicitudMantenimiento;
import com.cofar.bean.SolicitudMantenimientoDetalleTareas;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.richfaces.component.html.HtmlDataTable;
import javax.faces.model.ListDataModel;
import org.apache.logging.log4j.LogManager;


/**
 *
 * @author hvaldivia
 */

public class ManagedSeguimientoSolicitudMantenimiento extends ManagedBean{
    Connection con = null;
    List solicitudMantenimientoList = new ArrayList();
    SolicitudMantenimiento solicitudMantenimientoItem = new SolicitudMantenimiento();
    HtmlDataTable solicitudMantenimientoDataTable = new HtmlDataTable();
    List solicitudMantenimientoDetalleTareasList = new ArrayList();
    SimpleDateFormat sdf = new  SimpleDateFormat("yyyy/MM/dd");
    SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareas = new SolicitudMantenimientoDetalleTareas();
    SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareasEditar = new SolicitudMantenimientoDetalleTareas();
    String enteAsignado = "";
    List tiposTareasList = new ArrayList();
    List personalList = new ArrayList();
    List proveedorList = new ArrayList();
    List partesMaquinariaList = new ArrayList();
    HtmlDataTable partesMaquinariaDataTable = new HtmlDataTable();
    List areasInstalacionesModulosList = new ArrayList();
    HtmlDataTable areasInstalacionesDataTable = new HtmlDataTable();
    SolicitudMantenimiento solicitudMantenimientoPreventivo = new SolicitudMantenimiento();
    List tiposNivelSolicitudMantenimientoList = new ArrayList();
    ManagedSolicitudMantenimiento managedSolicitudMantenimiento = new ManagedSolicitudMantenimiento();
    boolean enviarCorreoSolicitante = false;
    private Date fechaInicio=new Date();
    private Date fechaFinal=new Date();
    private Date fechaInicioAprobacion=new Date();
    private Date fechaFinalAprobacion=new Date();
    private SolicitudMantenimiento solicitudMantenimientoBean=new SolicitudMantenimiento();
    private List<SelectItem> maquinariasList=new ArrayList<SelectItem>();
    private List<SelectItem> personalSolicitanteList=new ArrayList<SelectItem>();
    private List<SelectItem> areasInstalacionesList=new ArrayList<SelectItem>();
    private List<SelectItem> estadosSolicitudMantenimientoList=new ArrayList<SelectItem>();
    private List<SelectItem> tiposSolicitudMantenimientoList=new ArrayList<SelectItem>();
    SolicitudMantenimientoDetalleTareas solicitudTareasEditar=new SolicitudMantenimientoDetalleTareas();
    SolicitudMantenimientoDetalleTareas solicitudTareasAgregar=new SolicitudMantenimientoDetalleTareas();
    private List<SelectItem> personalTareasList=new ArrayList<SelectItem>();
    private List<SelectItem> areasEmpresaBuscadorList=new ArrayList<SelectItem>();
    private List<SeguimientoPersonalMantenimiento> solicitudesMatenimientoPersonalList=new ArrayList<SeguimientoPersonalMantenimiento>();
    private Date fechaIniciofiltro=new Date();
    private Date fechaFinalFiltro=new Date();
    private List<SolicitudMantenimientoDetalleTareas> seguimientoSolicitudesPersonalList=new ArrayList<SolicitudMantenimientoDetalleTareas>();
    private boolean cerrarOT=false;
    private String mensaje="";
    private ListDataModel ordenesTrabajoDataModel=new ListDataModel();
    private List<SelectItem> tecnicosSolicitudMantenimiento=new ArrayList<SelectItem>();
    private String[] codPersonal;
    private boolean registroPersonal=false;
    private boolean eliminarAnterioresRegistros=false;
    public List getSolicitudMantenimientoList() {
        return solicitudMantenimientoList;
    }

    public void setSolicitudMantenimientoList(List solicitudMantenimientoList) {
        this.solicitudMantenimientoList = solicitudMantenimientoList;
    }

    public HtmlDataTable getSolicitudMantenimientoDataTable() {
        return solicitudMantenimientoDataTable;
    }

    public void setSolicitudMantenimientoDataTable(HtmlDataTable solicitudMantenimientoDataTable) {
        this.solicitudMantenimientoDataTable = solicitudMantenimientoDataTable;
    }

    public List getSolicitudMantenimientoDetalleTareasList() {
        return solicitudMantenimientoDetalleTareasList;
    }

    public void setSolicitudMantenimientoDetalleTareasList(List solicitudMantenimientoDetalleTareasList) {
        this.solicitudMantenimientoDetalleTareasList = solicitudMantenimientoDetalleTareasList;
    }

    public SolicitudMantenimientoDetalleTareas getSolicitudMantenimientoDetalleTareas() {
        return solicitudMantenimientoDetalleTareas;
    }

    public void setSolicitudMantenimientoDetalleTareas(SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareas) {
        this.solicitudMantenimientoDetalleTareas = solicitudMantenimientoDetalleTareas;
    }

    public String getEnteAsignado() {
        return enteAsignado;
    }

    public void setEnteAsignado(String enteAsignado) {
        this.enteAsignado = enteAsignado;
    }

    public List getTiposTareasList() {
        return tiposTareasList;
    }

    public void setTiposTareasList(List tiposTareasList) {
        this.tiposTareasList = tiposTareasList;
    }

    public List getPersonalList() {
        return personalList;
    }

    public void setPersonalList(List personalList) {
        this.personalList = personalList;
    }

    public List getProveedorList() {
        return proveedorList;
    }

    public void setProveedorList(List proveedorList) {
        this.proveedorList = proveedorList;
    }

    public List getPartesMaquinariaList() {
        return partesMaquinariaList;
    }

    public void setPartesMaquinariaList(List partesMaquinariaList) {
        this.partesMaquinariaList = partesMaquinariaList;
    }

    public HtmlDataTable getPartesMaquinariaDataTable() {
        return partesMaquinariaDataTable;
    }

    public void setPartesMaquinariaDataTable(HtmlDataTable partesMaquinariaDataTable) {
        this.partesMaquinariaDataTable = partesMaquinariaDataTable;
    }

    public List getAreasInstalacionesModulosList() {
        return areasInstalacionesModulosList;
    }

    public void setAreasInstalacionesModulosList(List areasInstalacionesModulosList) {
        this.areasInstalacionesModulosList = areasInstalacionesModulosList;
    }

    public HtmlDataTable getAreasInstalacionesDataTable() {
        return areasInstalacionesDataTable;
    }

    public void setAreasInstalacionesDataTable(HtmlDataTable areasInstalacionesDataTable) {
        this.areasInstalacionesDataTable = areasInstalacionesDataTable;
    }

    public SolicitudMantenimiento getSolicitudMantenimientoItem() {
        return solicitudMantenimientoItem;
    }

    public void setSolicitudMantenimientoItem(SolicitudMantenimiento solicitudMantenimientoItem) {
        this.solicitudMantenimientoItem = solicitudMantenimientoItem;
    }

    public SolicitudMantenimiento getSolicitudMantenimientoPreventivo() {
        return solicitudMantenimientoPreventivo;
    }

    public void setSolicitudMantenimientoPreventivo(SolicitudMantenimiento solicitudMantenimientoPreventivo) {
        this.solicitudMantenimientoPreventivo = solicitudMantenimientoPreventivo;
    }

    public List getTiposNivelSolicitudMantenimientoList() {
        return tiposNivelSolicitudMantenimientoList;
    }

    public void setTiposNivelSolicitudMantenimientoList(List tiposNivelSolicitudMantenimientoList) {
        this.tiposNivelSolicitudMantenimientoList = tiposNivelSolicitudMantenimientoList;
    }

    public boolean isEnviarCorreoSolicitante() {
        return enviarCorreoSolicitante;
    }

    public List<SelectItem> getEstadosSolicitudMantenimientoList() {
        return estadosSolicitudMantenimientoList;
    }

    public void setEstadosSolicitudMantenimientoList(List<SelectItem> estadosSolicitudMantenimientoList) {
        this.estadosSolicitudMantenimientoList = estadosSolicitudMantenimientoList;
    }

    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public Date getFechaFinalAprobacion() {
        return fechaFinalAprobacion;
    }

    public void setFechaFinalAprobacion(Date fechaFinalAprobacion) {
        this.fechaFinalAprobacion = fechaFinalAprobacion;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaInicioAprobacion() {
        return fechaInicioAprobacion;
    }

    public void setFechaInicioAprobacion(Date fechaInicioAprobacion) {
        this.fechaInicioAprobacion = fechaInicioAprobacion;
    }

    public ManagedSolicitudMantenimiento getManagedSolicitudMantenimiento() {
        return managedSolicitudMantenimiento;
    }

    public void setManagedSolicitudMantenimiento(ManagedSolicitudMantenimiento managedSolicitudMantenimiento) {
        this.managedSolicitudMantenimiento = managedSolicitudMantenimiento;
    }

    public List<SelectItem> getMaquinariasList() {
        return maquinariasList;
    }

    public void setMaquinariasList(List<SelectItem> maquinariasList) {
        this.maquinariasList = maquinariasList;
    }

    public List<SelectItem> getPersonalSolicitanteList() {
        return personalSolicitanteList;
    }

    public void setPersonalSolicitanteList(List<SelectItem> personalSolicitanteList) {
        this.personalSolicitanteList = personalSolicitanteList;
    }

    public SolicitudMantenimiento getSolicitudMantenimientoBean() {
        return solicitudMantenimientoBean;
    }

    public void setSolicitudMantenimientoBean(SolicitudMantenimiento solicitudMantenimientoBean) {
        this.solicitudMantenimientoBean = solicitudMantenimientoBean;
    }

    public List<SelectItem> getTiposSolicitudMantenimientoList() {
        return tiposSolicitudMantenimientoList;
    }

    public void setTiposSolicitudMantenimientoList(List<SelectItem> tiposSolicitudMantenimientoList) {
        this.tiposSolicitudMantenimientoList = tiposSolicitudMantenimientoList;
    }
    
    public void setEnviarCorreoSolicitante(boolean enviarCorreoSolicitante) {
        this.enviarCorreoSolicitante = enviarCorreoSolicitante;
    }

    public List<SelectItem> getAreasInstalacionesList() {
        return areasInstalacionesList;
    }

    public void setAreasInstalacionesList(List<SelectItem> areasInstalacionesList) {
        this.areasInstalacionesList = areasInstalacionesList;
    }

    public List<SelectItem> getPersonalTareasList() {
        return personalTareasList;
    }

    public void setPersonalTareasList(List<SelectItem> personalTareasList) {
        this.personalTareasList = personalTareasList;
    }

    public SolicitudMantenimientoDetalleTareas getSolicitudMantenimientoDetalleTareasEditar() {
        return solicitudMantenimientoDetalleTareasEditar;
    }

    public void setSolicitudMantenimientoDetalleTareasEditar(SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareasEditar) {
        this.solicitudMantenimientoDetalleTareasEditar = solicitudMantenimientoDetalleTareasEditar;
    }

    public SolicitudMantenimientoDetalleTareas getSolicitudTareasAgregar() {
        return solicitudTareasAgregar;
    }

    public void setSolicitudTareasAgregar(SolicitudMantenimientoDetalleTareas solicitudTareasAgregar) {
        this.solicitudTareasAgregar = solicitudTareasAgregar;
    }

    public SolicitudMantenimientoDetalleTareas getSolicitudTareasEditar() {
        return solicitudTareasEditar;
    }

    public void setSolicitudTareasEditar(SolicitudMantenimientoDetalleTareas solicitudTareasEditar) {
        this.solicitudTareasEditar = solicitudTareasEditar;
    }

    public List<SelectItem> getAreasEmpresaBuscadorList() {
        return areasEmpresaBuscadorList;
    }

    public void setAreasEmpresaBuscadorList(List<SelectItem> areasEmpresaBuscadorList) {
        this.areasEmpresaBuscadorList = areasEmpresaBuscadorList;
    }


      public Date getFechaFinalFiltro() {
        return fechaFinalFiltro;
    }

    public void setFechaFinalFiltro(Date fechaFinalFiltro) {
        this.fechaFinalFiltro = fechaFinalFiltro;
    }

    public Date getFechaIniciofiltro() {
        return fechaIniciofiltro;
    }

    public void setFechaIniciofiltro(Date fechaIniciofiltro) {
        this.fechaIniciofiltro = fechaIniciofiltro;
    }

    public List<SeguimientoPersonalMantenimiento> getSolicitudesMatenimientoPersonalList() {
        return solicitudesMatenimientoPersonalList;
    }

    public void setSolicitudesMatenimientoPersonalList(List<SeguimientoPersonalMantenimiento> solicitudesMatenimientoPersonalList) {
        this.solicitudesMatenimientoPersonalList = solicitudesMatenimientoPersonalList;
    }

    public List<SolicitudMantenimientoDetalleTareas> getSeguimientoSolicitudesPersonalList() {
        return seguimientoSolicitudesPersonalList;
    }

    public void setSeguimientoSolicitudesPersonalList(List<SolicitudMantenimientoDetalleTareas> seguimientoSolicitudesPersonalList) {
        this.seguimientoSolicitudesPersonalList = seguimientoSolicitudesPersonalList;
    }

    public boolean isCerrarOT() {
        return cerrarOT;
    }

    public void setCerrarOT(boolean cerrarOT) {
        this.cerrarOT = cerrarOT;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public ListDataModel getOrdenesTrabajoDataModel() {
        return ordenesTrabajoDataModel;
    }

    public void setOrdenesTrabajoDataModel(ListDataModel ordenesTrabajoDataModel) {
        this.ordenesTrabajoDataModel = ordenesTrabajoDataModel;
    }

    public boolean isRegistroPersonal() {
        return registroPersonal;
    }

    public void setRegistroPersonal(boolean registroPersonal) {
        this.registroPersonal = registroPersonal;
    }

    public List<SelectItem> getTecnicosSolicitudMantenimiento() {
        return tecnicosSolicitudMantenimiento;
    }

    public void setTecnicosSolicitudMantenimiento(List<SelectItem> tecnicosSolicitudMantenimiento) {
        this.tecnicosSolicitudMantenimiento = tecnicosSolicitudMantenimiento;
    }

    public String[] getCodPersonal() {
        return codPersonal;
    }

    public void setCodPersonal(String[] codPersonal) {
        this.codPersonal = codPersonal;
    }

    
    /** Creates a new instance of ManagedSeguimientoSolicitudMantenimiento */
    public ManagedSeguimientoSolicitudMantenimiento() {
        LOGGER=LogManager.getLogger("Mantenimiento");
    }

     public String onFechachange_action()
    {
        this.cargarPersonalMantenimientoSolicitud_action();
        return null;
    }
    public String getCargarPersonalSolicitudMantenimiento_action()
    {
        this.cargarTiposTarea();
        this.cargarPersonalAreaMantenimientoList();
        this.cargarPersonalMantenimientoSolicitud_action();
        return null;
    }
     public String guardarSeguimientoPersonalSolicitudMantenimiento()throws SQLException
    {
        mensaje="";
        Connection con=null;
        try
        {
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("delete SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS  ");
                                    consulta.append(" where COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                                        consulta.append(" and COD_PERSONAL=").append(solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal());
                                        consulta.append(" and FECHA_INICIAL BETWEEN '").append(sdf.format(fechaIniciofiltro)).append(" 00:00:00'  and '").append(sdf.format(fechaIniciofiltro)).append(" 23:59:59'");
            System.out.println("consulta delete detalles "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores");
            consulta=new StringBuilder("delete SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS  ");
                       consulta.append(" where COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                           consulta.append(" and COD_PERSONAL=").append(solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal());
                           consulta.append(" and FECHA_ASIGNACION BETWEEN '").append(sdf.format(fechaIniciofiltro)).append(" 00:00:00'  and '").append(sdf.format(fechaIniciofiltro)).append(" 23:59:59'");
            System.out.println("consulta delete detalles "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores");
            if(eliminarAnterioresRegistros)
            {
                consulta=new StringBuilder("delete SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS  ");
                        consulta.append(" where COD_PERSONAL=").append(solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal());
                            consulta.append(" and COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                            consulta.append(" and FECHA_ASIGNACION is not null");
                System.out.println("consulta borrar seguimiento innecesario "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
            }
            

            SimpleDateFormat horas=new SimpleDateFormat("HH:mm");
            for(SolicitudMantenimientoDetalleTareas bean:seguimientoSolicitudesPersonalList)
            {
                consulta=new StringBuilder("INSERT INTO SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS(COD_SOLICITUD_MANTENIMIENTO");
                         consulta.append(", COD_TIPO_TAREA, DESCRIPCION, COD_PERSONAL, FECHA_INICIAL, FECHA_FINAL,COD_PROVEEDOR, HORAS_HOMBRE,TERMINADO,REPUESTOS,HORAS_EXTRA,REGISTRO_HORAS_EXTRA)");
                         consulta.append(" VALUES (");
                             consulta.append(solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getCodSolicitudMantenimiento()).append(",");
                             consulta.append(bean.getTiposTarea().getCodTipoTarea()).append(",");
                             consulta.append("'").append(bean.getDescripcion()).append("',");
                             consulta.append(solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal()).append(",");
                             consulta.append("'").append(sdf.format(bean.getFechaInicial())).append(" ").append(horas.format(bean.getHoraInicial())).append("',");
                             consulta.append("'").append(sdf.format(bean.getFechaFinal())).append(" ").append(horas.format(bean.getHoraFinal())).append("',0,");
                             consulta.append("'").append(bean.getHorasHombre()).append("',");
                             consulta.append((bean.isTerminado()?"1":"0")).append(",");
                             consulta.append((bean.isRepuestos()?"1":"0")).append(",");
                             consulta.append("'").append(bean.getHorasExtra()).append("',");
                             consulta.append((bean.isRegistroHorasExtra()?"1":"0"));
                         consulta.append(")");
                System.out.println("consulta insert "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
            }
            if(cerrarOT)
            {
                    consulta=new StringBuilder("update SOLICITUDES_MANTENIMIENTO");
                               consulta.append(" set COD_ESTADO_SOLICITUD_MANTENIMIENTO=4");
                               consulta.append(" where COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                    System.out.println("consulta update "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)System.out.println("se cerro la orden de trabajo");
                    consulta=new StringBuilder("UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS");
                             consulta.append(" set TERMINADO=1");
                             consulta.append(" WHERE COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                                consulta.append(" and COD_PERSONAL=? and COD_TIPO_TAREA=? and FECHA_INICIAL=?");
                    System.out.println("consulta terminar actividades"+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    consulta=new StringBuilder("select smdt.COD_PERSONAL,smdt.COD_TIPO_TAREA,max(smdt.FECHA_INICIAL) as fechaInicial");
                             consulta.append(" from SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS smdt ");
                             consulta.append(" where smdt.COD_SOLICITUD_MANTENIMIENTO=").append(solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                             consulta.append(" group by smdt.COD_PERSONAL,smdt.COD_TIPO_TAREA");
                    System.out.println("consulta buscar ultimos registro de tareas");
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        pst.setInt(1,res.getInt("COD_PERSONAL"));
                        pst.setInt(2,res.getInt("COD_TIPO_TAREA"));
                        pst.setTimestamp(3,res.getTimestamp("fechaInicial"));
                        if(pst.executeUpdate()>0)System.out.println("termino la actividad");
                    }
            }
            con.commit();
            mensaje="1";

            pst.close();
            con.close();
            this.cargarPersonalMantenimientoSolicitud_action();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un problema al momento de registrar, intente de nuevo";
            con.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }

        return null;
    }
    public String mas_action()
    {
        SolicitudMantenimientoDetalleTareas nuevo=new SolicitudMantenimientoDetalleTareas();
        nuevo.setFechaInicial((Date)fechaIniciofiltro.clone());
        nuevo.setFechaFinal((Date)fechaIniciofiltro.clone());
        seguimientoSolicitudesPersonalList.add(nuevo);
        return null;
    }
    public String menos_action()
    {
        List<SolicitudMantenimientoDetalleTareas> nuevaLista=new ArrayList<SolicitudMantenimientoDetalleTareas>();
        for(SolicitudMantenimientoDetalleTareas bean:seguimientoSolicitudesPersonalList)
        {
            if(!bean.getChecked())
            {
                SolicitudMantenimientoDetalleTareas nuevo=new SolicitudMantenimientoDetalleTareas();
                nuevo.getPersonal().setCodPersonal(bean.getPersonal().getCodPersonal());
                nuevo.setFechaInicial((Date)bean.getFechaInicial().clone());
                nuevo.setHoraInicial((Date)bean.getHoraInicial());
                nuevo.setFechaFinal((Date)bean.getFechaFinal());
                nuevo.setHoraFinal((Date)bean.getHoraFinal());
                nuevo.setHorasHombre(bean.getHorasHombre());
                nuevo.setDescripcion(bean.getDescripcion());
                nuevo.setHorasExtra(bean.getHorasExtra());
                nuevo.setTerminado(bean.isTerminado());
                nuevo.setRepuestos(bean.isRepuestos());
                nuevo.getTiposTarea().setCodTipoTarea(bean.getTiposTarea().getCodTipoTarea());
                nuevaLista.add(nuevo);
            }
        }
        seguimientoSolicitudesPersonalList.clear();
        seguimientoSolicitudesPersonalList.addAll(nuevaLista);
        return null;
    }
    public String asociarOrdenTrabajo()throws SQLException
    {
        SolicitudMantenimiento bean=(SolicitudMantenimiento)ordenesTrabajoDataModel.getRowData();
        solicitudMantenimientoDetalleTareas.setSolicitudMantenimiento(bean);
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        Connection con1=null;
        try
        {
            con1=Util.openConnection(con1);
            con1.setAutoCommit(false);
            String consulta="set dateformat ymd";
            PreparedStatement pst=con1.prepareStatement(consulta);
            pst.executeUpdate();
            if(registroPersonal)
            {
                for(String var:codPersonal)
                {
                    consulta="INSERT INTO dbo.SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS("+
                                " COD_SOLICITUD_MANTENIMIENTO, COD_TIPO_TAREA, DESCRIPCION, COD_PERSONAL,"+
                                "  FECHA_ASIGNACION,FECHA_INICIAL, FECHA_FINAL)"+
                                " VALUES ('"+bean.getCodSolicitudMantenimiento()+"',0, '',"+
                                " '"+var+"','"+sdf.format(fechaIniciofiltro)+" 12:00:00'," +
                                "'"+sdf.format(fechaIniciofiltro)+" "+sdfHora.format(new Date())+"'," +
                                "'"+sdf.format(fechaIniciofiltro)+" "+sdfHora.format(new Date())+"')";
                    System.out.println("consulta insert "+consulta);
                    pst=con1.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro para la fecha");
                }
            }
            else
            {
                consulta="INSERT INTO dbo.SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS("+
                                " COD_SOLICITUD_MANTENIMIENTO, COD_TIPO_TAREA, DESCRIPCION, COD_PERSONAL,"+
                                "  FECHA_ASIGNACION,FECHA_INICIAL, FECHA_FINAL)"+
                                " VALUES ('"+bean.getCodSolicitudMantenimiento()+"',0, '',"+
                                " '"+solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal()+"','"+sdf.format(fechaIniciofiltro)+" 12:00:00'," +
                                "'"+sdf.format(fechaIniciofiltro)+" "+sdfHora.format(new Date())+"'," +
                                "'"+sdf.format(fechaIniciofiltro)+" "+sdfHora.format(new Date())+"')";
                System.out.println("consulta insert "+consulta);
                pst=con1.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro para la fecha");
            }
            con1.commit();
            pst.close();
            con1.close();
            this.cargarPersonalMantenimientoSolicitud_action();
        }
        catch(SQLException ex)
        {
            con1.rollback();
            ex.printStackTrace();
        }
        finally
        {
            con1.close();
        }
        return null;
    }
    private void cargarOrdenesTrabajoAsociar()
    {
        Connection con=null;
        try
        {
            con=Util.openConnection(con);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            String consulta="select sm.COD_SOLICITUD_MANTENIMIENTO,sm.NRO_ORDEN_TRABAJO,ae.NOMBRE_AREA_EMPRESA,"+
                            " ISNULL(ai.NOMBRE_AREA_INSTALACION,'') as NOMBRE_AREA_INSTALACION,"+
                            " ISNULL(m.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA,esm.NOMBRE_ESTADO_SOLICITUD,"+
                            " tsm.NOMBRE_TIPO_SOLICITUD,sm.OBS_SOLICITUD_MANTENIMIENTO"+
                            " from SOLICITUDES_MANTENIMIENTO sm inner join AREAS_EMPRESA ae on "+
                            " sm.COD_AREA_EMPRESA=ae.COD_AREA_EMPRESA inner join TIPOS_SOLICITUD_MANTENIMIENTO tsm on "+
                            " tsm.COD_TIPO_SOLICITUD=sm.COD_TIPO_SOLICITUD_MANTENIMIENTO"+
                            " inner join ESTADOS_SOLICITUD_MANTENIMIENTO esm on esm.COD_ESTADO_SOLICITUD=sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO"+
                            " left outer join AREAS_INSTALACIONES ai on ai.COD_AREA_INSTALACION=sm.COD_AREA_INSTALACION"+
                            " left outer join maquinarias m on m.COD_MAQUINA=sm.COD_MAQUINARIA"+
                            " where sm.NRO_ORDEN_TRABAJO>0 and sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO not in (4,8,9,3)"+
                            " and sm.FECHA_CAMBIO_ESTADOSOLICITUD < '"+sdf.format(fechaIniciofiltro)+" 23:59:59'" +
                            " order by sm.NRO_ORDEN_TRABAJO";
              System.out.println("consulta cargar ordenes "+consulta);
              Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
              ResultSet res=st.executeQuery(consulta);
              ordenesTrabajoDataModel.setWrappedData(new ArrayList());
              List<SolicitudMantenimiento> lista=new ArrayList<SolicitudMantenimiento>();
              while(res.next())
              {
                  SolicitudMantenimiento nuevo=new SolicitudMantenimiento();
                  nuevo.setCodSolicitudMantenimiento(res.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                  nuevo.setNroOrdenTrabajo(res.getInt("NRO_ORDEN_TRABAJO"));
                  nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                  nuevo.getAreasInstalaciones().setNombreAreaInstalacion(res.getString("NOMBRE_AREA_INSTALACION"));
                  nuevo.getMaquinaria().setNombreMaquina(res.getString("NOMBRE_MAQUINA"));
                  nuevo.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(res.getString("NOMBRE_ESTADO_SOLICITUD"));
                  nuevo.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(res.getString("NOMBRE_TIPO_SOLICITUD"));
                  nuevo.setObsSolicitudMantenimiento(res.getString("OBS_SOLICITUD_MANTENIMIENTO"));
                  lista.add(nuevo);
              }
              ordenesTrabajoDataModel.setWrappedData(lista);
              res.close();
              st.close();
              con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String agregarOrdenTrabajoPersonal()
    {
        registroPersonal=false;
        cerrarOT=false;
        solicitudMantenimientoDetalleTareas=new SolicitudMantenimientoDetalleTareas();
        Map<String,String> params=FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
        solicitudMantenimientoDetalleTareas.getPersonal().setCodPersonal(params.get("codPersonal"));
        solicitudMantenimientoDetalleTareas.getPersonal().setNombrePersonal(params.get("nombrePersonal"));
        solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().setNroOrdenTrabajo(0);
        seguimientoSolicitudesPersonalList=new ArrayList<SolicitudMantenimientoDetalleTareas>();
        this.cargarOrdenesTrabajoAsociar();
        return null;
    }
    public String agregarTecnicoOrdenTrabajo()
    {
        registroPersonal=true;
        codPersonal=null;
        seguimientoSolicitudesPersonalList=new ArrayList<SolicitudMantenimientoDetalleTareas>();
        solicitudMantenimientoDetalleTareas=new SolicitudMantenimientoDetalleTareas();
        cerrarOT=false;
        this.cargarOrdenesTrabajoAsociar();
        return null;
    }
    public String seleccionarTrabajoAction()
    {
       cerrarOT=false;
        LOGGER.debug("entro trabajo add");
       Map<String,String> params=FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
       String codSolicitudMantenimiento=params.get("codSolicitud");
       String codPersona=params.get("codPersonal");
       String nombrePer=params.get("nombrePersonal");
       String codTipoTarea=params.get("codTipoTarea");
       String colorFila=params.get("colorFila")==null?"":params.get("colorFila");
       SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
       String consulta="select sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO,sm.NRO_ORDEN_TRABAJO,"+
                       " isnull(m.NOMBRE_MAQUINA, '') as nombreMaquina,"+
                       " isnull(ai.NOMBRE_AREA_INSTALACION, '') as nombreAreaInstalacion,"+
                       " ae.NOMBRE_AREA_EMPRESA,esm.NOMBRE_ESTADO_SOLICITUD"+
                       " ,isnull(ultimaFecha.fecha,'"+sdf.format(fechaIniciofiltro)+"') AS fecha"+
                       " from SOLICITUDES_MANTENIMIENTO sm inner join ESTADOS_SOLICITUD_MANTENIMIENTO esm"+
                       " on sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO=esm.COD_ESTADO_SOLICITUD"+
                       " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=sm.COD_AREA_EMPRESA"+
                       " left outer join MAQUINARIAS m on m.COD_MAQUINA=sm.COD_MAQUINARIA"+
                       " left outer join AREAS_INSTALACIONES ai on ai.COD_AREA_INSTALACION=sm.COD_AREA_INSTALACION"+
                       " outer apply"+
                        "(" +
                                " select max(smdt.FECHA_FINAL) as fecha"+
                                " from SOLICITUDES_MANTENIMIENTO sm "+
                                " inner join SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS smdt on sm.COD_SOLICITUD_MANTENIMIENTO=smdt.COD_SOLICITUD_MANTENIMIENTO"+
                                " where sm.NRO_ORDEN_TRABAJO>0"+
                                " and smdt.COD_PERSONAL="+codPersona+
                                " and smdt.FECHA_FINAL BETWEEN '"+sdf.format(fechaIniciofiltro)+" 00:00' and '"+sdf.format(fechaIniciofiltro)+" 23:59'"+
                        ") as ultimaFecha"+
                       " where sm.COD_SOLICITUD_MANTENIMIENTO="+codSolicitudMantenimiento;
       System.out.println("consulta cargar cabecera "+consulta);
       eliminarAnterioresRegistros=false;
        try
       {
           con=Util.openConnection(con);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res=st.executeQuery(consulta);
           seguimientoSolicitudesPersonalList.clear();
           solicitudMantenimientoDetalleTareas=new SolicitudMantenimientoDetalleTareas();
            if(res.next())
           {
               solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().setCodSolicitudMantenimiento(Integer.valueOf(codSolicitudMantenimiento));
               solicitudMantenimientoDetalleTareas.getPersonal().setCodPersonal(codPersona);
               solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().setNroOrdenTrabajo(res.getInt("NRO_ORDEN_TRABAJO"));
               solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(res.getString("NOMBRE_ESTADO_SOLICITUD"));
               solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(res.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO"));
               solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getMaquinaria().setNombreMaquina(res.getString("nombreMaquina"));
               solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getAreasInstalaciones().setNombreAreaInstalacion(res.getString("nombreAreaInstalacion"));
               solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
               solicitudMantenimientoDetalleTareas.getPersonal().setNombrePersonal(nombrePer);
               solicitudMantenimientoDetalleTareas.setFechaFinal(res.getTimestamp("fecha"));
            }

               consulta="select  smdt.DESCRIPCION,smdt.COD_PERSONAL,smdt.FECHA_INICIAL,smdt.FECHA_FINAL,smdt.HORAS_HOMBRE,smdt.HORAS_EXTRA,"+
                        " smdt.TERMINADO,smdt.REPUESTOS,smdt.COD_TIPO_TAREA,smdt.REGISTRO_HORAS_EXTRA"+
                        " from SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS smdt "+
                        " where smdt.COD_SOLICITUD_MANTENIMIENTO='"+codSolicitudMantenimiento+"'" +
                        " and smdt.COD_PERSONAL='"+codPersona+"'"+
                        " and smdt.FECHA_INICIAL BETWEEN '"+sdf.format(fechaIniciofiltro)+" 00:00:00' and '"+sdf.format(fechaIniciofiltro)+" 23:59:59'"+
                        " order by smdt.FECHA_INICIAL";

            System.out.println("consulta cargar "+consulta );
            res=st.executeQuery(consulta);
           while(res.next())
           {
               SolicitudMantenimientoDetalleTareas bean =new SolicitudMantenimientoDetalleTareas();
               bean.setRegistroHorasExtra(res.getInt("REGISTRO_HORAS_EXTRA")>0);
               bean.getPersonal().setCodPersonal(codPersona);
               bean.setFechaInicial(res.getDate("FECHA_INICIAL"));
               bean.setHoraInicial(res.getTimestamp("FECHA_INICIAL"));
               bean.setFechaFinal(res.getDate("FECHA_FINAL"));
               bean.setHoraFinal(res.getTimestamp("FECHA_FINAL"));
               bean.setHorasHombre(res.getFloat("HORAS_HOMBRE"));
               bean.setDescripcion(res.getString("DESCRIPCION"));
               bean.setHorasExtra(res.getFloat("HORAS_EXTRA"));
               bean.setTerminado(res.getInt("TERMINADO")>0);
               bean.setRepuestos(res.getInt("REPUESTOS")>0);
               bean.getTiposTarea().setCodTipoTarea(res.getInt("COD_TIPO_TAREA"));
               seguimientoSolicitudesPersonalList.add(bean);

           }
            if(!colorFila.equals(""))
            {
               SolicitudMantenimientoDetalleTareas bean =new SolicitudMantenimientoDetalleTareas();
               bean.setColorFila(colorFila);
               bean.getPersonal().setCodPersonal(codPersona);
               bean.setFechaInicial((Date)solicitudMantenimientoDetalleTareas.getFechaFinal().clone());
               bean.setFechaFinal((Date)solicitudMantenimientoDetalleTareas.getFechaFinal().clone());
               bean.setHoraInicial((Date)solicitudMantenimientoDetalleTareas.getFechaFinal().clone());
               bean.setHoraFinal((Date)solicitudMantenimientoDetalleTareas.getFechaFinal().clone());
               bean.getHoraFinal().setHours(bean.getFechaFinal().getHours()+1);
               bean.setHorasHombre(1);
               bean.setHorasExtra(0);
              
               if(codTipoTarea.equals("0"))
               {
                   eliminarAnterioresRegistros=true;
               }
               bean.getTiposTarea().setCodTipoTarea(Integer.valueOf(codTipoTarea));
               seguimientoSolicitudesPersonalList.add(bean);
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
    private void cargarPersonalAreaMantenimientoList()
    {
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT pap.COD_PERSONAL,isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal,");
                                                consulta.append(" pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL+' '+pt.nombre2_personal) as nombrePersonal");
                                        consulta.append(" FROM PERSONAL_AREA_PRODUCCION pap");
                                                consulta.append(" left outer join PERSONAL p on p.COD_PERSONAL=pap.COD_PERSONAL");
                                                consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=pap.COD_PERSONAL");
                                        consulta.append(" where pap.COD_AREA_EMPRESA in (86,103)");
                                                consulta.append(" and pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION=1");
                                        consulta.append(" order by 2");
            LOGGER.debug("consulta cargar personal mantenimiento " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tecnicosSolicitudMantenimiento=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tecnicosSolicitudMantenimiento.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("nombrePersonal")));
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    private void cargarTecnicosSolicitudMantenimiento()
    {
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            String consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL +' '+ P.AP_MATERNO_PERSONAL+' '+P.NOMBRES_PERSONAL)  NOMBRES_PERSONAL " +
                    " from  personal P where P.cod_area_empresa=86 " +
                    " AND P.COD_ESTADO_PERSONA=1";
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            tecnicosSolicitudMantenimiento.clear();
            while(res.next())
            {
                tecnicosSolicitudMantenimiento.add(new SelectItem(res.getString("COD_PERSONAL"),res.getString("NOMBRES_PERSONAL")));
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

    private void cargarPersonalMantenimientoSolicitud_action()
    {
        Connection con1=null;
        try 
        {
            con1 = Util.openConnection(con1);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            StringBuilder consulta = new StringBuilder("exec PAA_NAVEGADOR_SEGUIMIENTO_PERSONAL_MANTENIMIENTO ");
                                    consulta.append("'").append(sdf.format(fechaIniciofiltro)).append(" 00:00'");
            LOGGER.debug("consulta cargar seguimiento maquinaria " + consulta.toString());
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            solicitudesMatenimientoPersonalList=new ArrayList<SeguimientoPersonalMantenimiento>();
            SeguimientoPersonalMantenimiento seguimientoPersonal=new SeguimientoPersonalMantenimiento();
            List<SolicitudMantenimientoDetalleTareas> solicitudesMantenimientoList=new ArrayList<SolicitudMantenimientoDetalleTareas>();
            while (res.next()) 
            {
                if(!seguimientoPersonal.getPersonal().getCodPersonal().equals(res.getString("COD_PERSONAL")))
                {
                    if(!seguimientoPersonal.getPersonal().getCodPersonal().equals(""))
                    {
                        seguimientoPersonal.setSolicitudMantenimientoDetalleTareasList(solicitudesMantenimientoList);
                        solicitudesMatenimientoPersonalList.add(seguimientoPersonal);
                    }
                    seguimientoPersonal=new SeguimientoPersonalMantenimiento();
                    seguimientoPersonal.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                    seguimientoPersonal.getPersonal().setNombrePersonal(res.getString("nombre"));
                    solicitudesMantenimientoList=new ArrayList<SolicitudMantenimientoDetalleTareas>();
                }

                SolicitudMantenimientoDetalleTareas bean=new SolicitudMantenimientoDetalleTareas();
                bean.setColorFila(res.getString("colorFila"));
                bean.setFechaInicial(res.getTimestamp("FECHA_INICIAL"));
                bean.setFechaFinal(res.getTimestamp("FECHA_FINAL"));
                bean.setHorasHombre(res.getFloat("HORAS_HOMBRE"));
                bean.getTiposTarea().setNombreTipoTarea(res.getString("NOMBRE_TIPO_TAREA"));
                bean.getTiposTarea().setCodTipoTarea(res.getInt("COD_TIPO_TAREA"));
                bean.setHorasExtra(res.getFloat("HORAS_EXTRA"));
                bean.setDescripcion(res.getString("DESCRIPCION"));
                bean.setTerminado(res.getInt("TERMINADO")>0);
                bean.setRepuestos(res.getInt("REPUESTOS")>0);
                seguimientoPersonal.setHorasHombre(seguimientoPersonal.getHorasHombre()+bean.getHorasHombre()+bean.getHorasExtra());
                bean.getSolicitudMantenimiento().setCodSolicitudMantenimiento(res.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                bean.getSolicitudMantenimiento().getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                bean.getSolicitudMantenimiento().setNroOrdenTrabajo(res.getInt("NRO_ORDEN_TRABAJO"));
                bean.getSolicitudMantenimiento().getTiposNivelSolicitudMantenimiento().setNombreNivelSolicitudMantenimiento(res.getString("NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO"));
                bean.getSolicitudMantenimiento().getMaquinaria().setCodMaquina(res.getString("COD_MAQUINA"));
                bean.getSolicitudMantenimiento().getMaquinaria().setNombreMaquina(res.getString("nombreMaquina"));
                bean.getSolicitudMantenimiento().getAreasInstalaciones().setCodAreaInstalacion(res.getInt("COD_AREA_INSTALACION"));
                bean.getSolicitudMantenimiento().getAreasInstalaciones().setNombreAreaInstalacion(res.getString("nombreAreaInstalacion"));
                bean.getSolicitudMantenimiento().setObsSolicitudMantenimiento(res.getString("ObsSolicitud"));
                if(bean.getFechaInicial()!=null)
                {
                    if(bean.getFechaInicial().getHours()>8 && bean.getFechaInicial().getHours()<18)
                    {
                        bean.setTurno(1);
                    }
                    else
                    {
                        if(bean.getFechaInicial().getHours()>13 && bean.getFechaInicial().getHours()<22)
                        {
                            bean.setTurno(2);
                        }
                        else
                        {
                            bean.setTurno(3);
                        }
                    }
                }
                if(res.getString("colorFila").equals(""))
                {
                    seguimientoPersonal.setFechaInicio(res.getTimestamp("FECHA_FINAL"));
                }
                solicitudesMantenimientoList.add(bean);
            }
            if(!seguimientoPersonal.getPersonal().getCodPersonal().equals(""))
            {
                seguimientoPersonal.setSolicitudMantenimientoDetalleTareasList(solicitudesMantenimientoList);
                solicitudesMatenimientoPersonalList.add(seguimientoPersonal);
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con1);
        }
    }
    public String codAreaEmpresa_onChange()
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO");
                                        consulta.append(" from MAQUINARIAS m");
                                        if(solicitudMantenimientoBean.getAreasEmpresa().getCodAreaEmpresa().length()>0&&(Integer.valueOf(solicitudMantenimientoBean.getAreasEmpresa().getCodAreaEmpresa())>0))
                                            consulta.append(" where m.cod_area_empresa =").append(solicitudMantenimientoBean.getAreasEmpresa().getCodAreaEmpresa());
                                        consulta.append(" order by m.NOMBRE_MAQUINA");
            LOGGER.debug("consulta cargar maquinarias "+consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            maquinariasList=new ArrayList();
            maquinariasList.add(new SelectItem("0","--TODOS--"));
            while (res.next()) 
            {
                maquinariasList.add(new SelectItem(res.getString("COD_MAQUINA"),res.getString("NOMBRE_MAQUINA")+" "+res.getString("CODIGO")));
            }
            st.close();
        }
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    public String getCargarSeguimientoSolicitudMantenimiento() {
        try {
            begin=1;
            end=10;
            fechaInicio=null;
            fechaFinal=null;
            fechaInicioAprobacion=null;
            fechaFinalAprobacion=null;
            solicitudMantenimientoBean.getMaquinaria().setCodMaquina("0");
            solicitudMantenimientoBean.getPersonal_usuario().setCodPersonal("0");
            solicitudMantenimientoBean.getModulosInstalaciones().setCodModuloInstalacion(0);
            solicitudMantenimientoBean.setAfectaraProduccion(3);
            solicitudMantenimientoBean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(0);
            solicitudMantenimientoBean.getTiposSolicitudMantenimiento().setCodTipoSolicitud(0);
            solicitudMantenimientoBean.getAreasEmpresa().setCodAreaEmpresa("0");
            ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            this.personalSolicitanteList=managedSolicitudMantenimiento.cargarPersonalSolicitante();
            this.areasInstalacionesList=managedSolicitudMantenimiento.cargarAreasInstalaciones();
            this.estadosSolicitudMantenimientoList=managedSolicitudMantenimiento.cargarEstadoSolicitud();
            this.cargarTiposSolicitudMantemiento();
            this.codAreaEmpresa_onChange();
            //cargarMaquinarias("", null,bean1);
            if(maquinariasList.size()==0){cargarMaquinarias("", null,new ManagedAccesoSistema());}
            
            solicitudMantenimientoList =  this.cargarSeguimientoSolicitudesMantenimiento();
            this.cargarAreasEmpresaBuscador();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
    public List cargarSeguimientoSolicitudesMantenimiento(){
        List solicitudMantenimientoList = new ArrayList();
        try {
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");

            String sql = "select * from (select ROW_NUMBER() OVER (" +
                    "  ORDER BY S.COD_SOLICITUD_MANTENIMIENTO desc) as 'FILAS',S.COD_SOLICITUD_MANTENIMIENTO,S.COD_AREA_EMPRESA,S.COD_GESTION,S.COD_PERSONAL,S.COD_RESPONSABLE,";
            sql += " S.COD_MAQUINARIA,S.COD_TIPO_SOLICITUD_MANTENIMIENTO,S.COD_ESTADO_SOLICITUD_MANTENIMIENTO,S.FECHA_SOLICITUD_MANTENIMIENTO,";
            sql += " S.FECHA_CAMBIO_ESTADOSOLICITUD,(select AE.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA AE WHERE AE.COD_AREA_EMPRESA=S.COD_AREA_EMPRESA) NOMBRE_AREA_EMPRESA,";
            sql += " (select TS.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO TS where TS.COD_TIPO_SOLICITUD=S.COD_TIPO_SOLICITUD_MANTENIMIENTO) NOMBRE_TIPO_SOLICITUD,";
            sql += " (select e.NOMBRE_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO e where e.COD_ESTADO_SOLICITUD = S.COD_ESTADO_SOLICITUD_MANTENIMIENTO and e.COD_ESTADO_REGISTRO = 1) NOMBRE_ESTADO_SOLICITUD,";
            sql += " (select M.NOMBRE_MAQUINA from MAQUINARIAS M where M.COD_MAQUINA=S.COD_MAQUINARIA) NOMBRE_MAQUINA,S.OBS_SOLICITUD_MANTENIMIENTO,G.NOMBRE_GESTION,";
            sql += " ISNULL((select P.AP_PATERNO_PERSONAL+' '+P.AP_MATERNO_PERSONAL+' '+P.NOMBRES_PERSONAL from PERSONAL P where P.COD_PERSONAL=S.COD_PERSONAL),'') NOMBRE_SOLICITANTE,";
            sql += " ISNULL((select TOP 1 PE.AP_PATERNO_PERSONAL+' '+PE.AP_MATERNO_PERSONAL+' '+PE.NOMBRES_PERSONAL from PERSONAL PE,APROBACION_SOLICITUDES_MANTENIMIENTO A,ESTADOS_SOLICITUD_MANTENIMIENTO ES where ES.COD_ESTADO_SOLICITUD=A.COD_ESTADO_SOLICITUD_MANTENIMIENTO AND PE.COD_PERSONAL=A.COD_PERSONAL_RESPONSABLE AND A.COD_PERSONAL_RESPONSABLE=PE.COD_PERSONAL AND A.COD_SOLICITUD_MANTENIMIENTO=S.COD_SOLICITUD_MANTENIMIENTO ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC),'') NOMBRE_RESPONSABLE,  ";            
            sql += " (select TOP 1 ES.COD_ESTADO_SOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC ) COD_ESTADO_SOLICITUD," +
                    " s.COD_FORM_SALIDA,s.COD_SOLICITUD_COMPRA,s.NRO_ORDEN_TRABAJO," +
                    " ( select pm.NOMBRE_PARTE_MAQUINA from PARTES_MAQUINARIA pm where pm.COD_PARTE_MAQUINA = s.COD_PARTE_MAQUINA ) NOMBRE_PARTE_MAQUINA,S.COD_AREA_INSTALACION," +
                    " (SELECT AI.NOMBRE_AREA_INSTALACION FROM AREAS_INSTALACIONES AI WHERE AI.COD_AREA_INSTALACION = S.COD_AREA_INSTALACION) NOMBRE_AREA_INSTALACION, " +
                    " ( select m.NOMBRE_MODULO_INSTALACION from AREAS_INSTALACIONES_MODULOS aim " +
                    " inner join MODULOS_INSTALACIONES m on m.COD_MODULO_INSTALACION = aim.COD_MODULO_INSTALACION where aim.COD_MODULO_INSTALACION = S.COD_MODULO_INSTALACION AND aim.COD_AREA_INSTALACION=S.COD_AREA_INSTALACION ) NOMBRE_MODULO_INSTALACION, " +
                    " t.COD_NIVEL_SOLICITUD_MANTENIMIENTO,t.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO,s.descripcion_estado," +
                    " isnull((select top 1 aid.NOMBRE_AREA_INSTALACION_DETALLE from AREAS_INSTALACIONES_DETALLE aid"+
                    " where aid.COD_AREA_INSTALACION_DETALLE = s.COD_AREA_INSTALACION_DETALLE),'') as nombreAreaInstalacion,"+
                    " s.COD_AREA_INSTALACION_DETALLE,s.solicitud_produccion,s.solicitud_proyecto " ;
            sql += " FROM SOLICITUDES_MANTENIMIENTO S,GESTIONES G,TIPOS_NIVEL_SOLICITUD_MANTENIMIENTO t";
            sql += " WHERE  G.COD_GESTION=S.COD_GESTION " +
                   " and S.NRO_ORDEN_TRABAJO>0  and t.COD_NIVEL_SOLICITUD_MANTENIMIENTO = s.COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO"+
                   (!solicitudMantenimientoBean.getAreasEmpresa().getCodAreaEmpresa().equals("0")?" and S.COD_AREA_EMPRESA='"+solicitudMantenimientoBean.getAreasEmpresa().getCodAreaEmpresa()+"'":"")+
                   (solicitudMantenimientoBean.getNroOrdenTrabajo()>0?" and s.NRO_ORDEN_TRABAJO ='"+solicitudMantenimientoBean.getNroOrdenTrabajo()+"'":"")+
                   (!solicitudMantenimientoBean.getMaquinaria().getCodMaquina().equals("0")?" and S.COD_MAQUINARIA='"+solicitudMantenimientoBean.getMaquinaria().getCodMaquina()+"'":"")+
                   (!solicitudMantenimientoBean.getPersonal_usuario().getCodPersonal().equals("0")?" and s.COD_PERSONAL='"+solicitudMantenimientoBean.getPersonal_usuario().getCodPersonal()+"'":"")+
                   (solicitudMantenimientoBean.getModulosInstalaciones().getCodModuloInstalacion()!=0?" and s.cod_modulo_instalacion='"+solicitudMantenimientoBean.getModulosInstalaciones().getCodModuloInstalacion()+"'":"")+
                   ((fechaInicio!=null&&fechaFinal!=null)?" and s.FECHA_SOLICITUD_MANTENIMIENTO BETWEEN '"+sdf.format(fechaInicio)+" 00:00:00' and '"+sdf.format(fechaFinal)+" 23:59:59'":"")+
                   (solicitudMantenimientoBean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()!=0?" and s.COD_ESTADO_SOLICITUD_MANTENIMIENTO='"+solicitudMantenimientoBean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()+"'":"")+
                   (solicitudMantenimientoBean.getTiposSolicitudMantenimiento().getCodTipoSolicitud()!=0?" and s.COD_TIPO_SOLICITUD_MANTENIMIENTO='"+solicitudMantenimientoBean.getTiposSolicitudMantenimiento().getCodTipoSolicitud()+"'":"")+
                   ((fechaInicioAprobacion!=null&&fechaFinalAprobacion!=null)?" and  S.FECHA_CAMBIO_ESTADOSOLICITUD between '"+sdf.format(fechaInicioAprobacion)+" 00:00:00' and '"+sdf.format(fechaFinalAprobacion)+" 23:59:59'":"")+
                   (!solicitudMantenimientoBean.getObsSolicitudMantenimiento().equals("")?" and S.OBS_SOLICITUD_MANTENIMIENTO like '%"+solicitudMantenimientoBean.getObsSolicitudMantenimiento()+"%'":"")+
                   (!solicitudMantenimientoBean.getDescripcionEstado().equals("")?" and s.descripcion_estado like '%"+solicitudMantenimientoBean.getDescripcionEstado()+"%'":"");
            sql += " ) as listado_solicitud_mantenimiento where FILAS between "+begin+" and "+end+"";
            //sql += " (select TOP 1 A.FECHA_CAMBIO_ESTADOSOLICITUD from ESTADOS_SOLICITUD_MANTENIMIENTO ES,APROBACION_SOLICITUDES_MANTENIMIENTO A where A.COD_SOLICITUD_MANTENIMIENTO = S.COD_SOLICITUD_MANTENIMIENTO AND A.COD_ESTADO_SOLICITUD_MANTENIMIENTO = ES.COD_ESTADO_SOLICITUD ORDER BY A.FECHA_CAMBIO_ESTADOSOLICITUD DESC,ES.NIVEL DESC) FECHA_CAMBIO_ESTADOSOLICITUD,";
            LOGGER.debug(" navegador:" + sql);
            con=Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();
            solicitudMantenimientoList.clear();
            rs.first();
            String cod = "";
            cantidadfilas = 0;
            for (int i = 0; i < rows; i++) {
                SolicitudMantenimiento bean = new SolicitudMantenimiento();
                bean.setCodSolicitudMantenimiento(rs.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                bean.getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                bean.getGestiones().setCodGestion(rs.getString("COD_GESTION"));
                bean.getPersonal_usuario().setCodPersonal(rs.getString("COD_PERSONAL"));
                bean.getPersonal_ejecutante().setCodPersonal(rs.getString("COD_RESPONSABLE"));
                bean.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINARIA"));
                bean.getTiposSolicitudMantenimiento().setCodTipoSolicitud(rs.getInt("COD_TIPO_SOLICITUD_MANTENIMIENTO"));
                bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt("COD_ESTADO_SOLICITUD_MANTENIMIENTO"));
                bean.setFechaSolicitudMantenimiento(rs.getDate("FECHA_SOLICITUD_MANTENIMIENTO"));
                bean.setFechaCambioEstadoSolicitud(rs.getTimestamp("FECHA_CAMBIO_ESTADOSOLICITUD"));
                bean.getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                bean.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(rs.getString("NOMBRE_TIPO_SOLICITUD"));
                bean.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString("NOMBRE_ESTADO_SOLICITUD"));
                bean.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                bean.setObsSolicitudMantenimiento(rs.getString("OBS_SOLICITUD_MANTENIMIENTO"));
                bean.getGestiones().setNombreGestion(rs.getString("NOMBRE_GESTION"));
                bean.getPersonal_usuario().setNombrePersonal(rs.getString("NOMBRE_SOLICITANTE"));
                bean.getPersonal_ejecutante().setNombrePersonal(rs.getString("NOMBRE_RESPONSABLE"));
                bean.getSolicitudesSalida().setCodFormSalida(rs.getInt("COD_FORM_SALIDA"));
                bean.getSolicitudesCompra().setCodSolicitudCompra(rs.getInt("COD_SOLICITUD_COMPRA"));
                bean.setNroOrdenTrabajo(rs.getInt("NRO_ORDEN_TRABAJO"));
                bean.getPartesMaquinaria().setNombreParteMaquina(rs.getString("NOMBRE_PARTE_MAQUINA"));
                bean.getAreasInstalaciones().setCodAreaInstalacion(rs.getInt("COD_AREA_INSTALACION"));
                bean.getAreasInstalaciones().setNombreAreaInstalacion(rs.getString("NOMBRE_AREA_INSTALACION"));
                bean.getModulosInstalaciones().setNombreModuloInstalacion(rs.getString("NOMBRE_MODULO_INSTALACION"));
                bean.getTiposNivelSolicitudMantenimiento().setCodTipoNivelSolicitudMantenimiento(rs.getInt("COD_NIVEL_SOLICITUD_MANTENIMIENTO"));
                bean.getTiposNivelSolicitudMantenimiento().setNombreNivelSolicitudMantenimiento(rs.getString("NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO"));
                bean.setDescripcionEstado(rs.getString("DESCRIPCION_ESTADO"));
                bean.getAreasInstalacionesDetalle().setCodAreaInstalacionDetalle(rs.getInt("COD_AREA_INSTALACION_DETALLE"));
                bean.getAreasInstalacionesDetalle().setNombreAreaInstalacionDetalle(rs.getString("nombreAreaInstalacion"));
                bean.setSolicitudProduccion(rs.getInt("solicitud_produccion"));
                bean.setSolicitudProyecto(rs.getInt("solicitud_proyecto"));
                //bean.setFechaCambioEstadoSolicitud( rs.getDate(19));
                //bean.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getString(20));
                if (bean.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()==4) {
                    bean.setFechaCambioEstadoSolicitud(null);
                } else {
                }

                solicitudMantenimientoList.add(bean);
                rs.next();
            }
            cantidadfilas = solicitudMantenimientoList.size();

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return solicitudMantenimientoList;
    }
    public String siguiente_action() {
        super.next();
        solicitudMantenimientoList = this.cargarSeguimientoSolicitudesMantenimiento();
        return "";
    }

    public String atras_action() {
        super.back();
        solicitudMantenimientoList = this.cargarSeguimientoSolicitudesMantenimiento();
        return "";
    }

    public String verTareasSolicitudMantenimiento_action(){
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();

             ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("solicitudMantenimiento", solicitudMantenimientoItem);
            

            this.redireccionar("navegador_solicitud_mantenimiento_detalle_tareas.jsf");
            
            //this.cargarTareasMantenimiento();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String verSolicitudMantenimientoDetalleTareas_action(){
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();
            this.redireccionar("navegador_seguimiento_solicitud_mantenimiento_tareas.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verSolicitudMantenimientoDetalleMateriales_action(){
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("solicitudMantenimiento", solicitudMantenimientoItem);
            
            this.redireccionar("navegador_seguimiento_solicitud_mantenimiento_materiales.jsf?direccion=navegador_seguimiento_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verSolicitudMantenimientoDetalleMateriales_action1(){
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("solicitudMantenimiento", solicitudMantenimientoItem);

            this.redireccionar("navegador_seguimiento_solicitud_mantenimiento_materiales.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String verMateriales_action(){
        try {
            solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();
            ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
            Map<String, Object> sessionMap = externalContext.getSessionMap();
            sessionMap.put("solicitudMantenimiento", solicitudMantenimientoItem);

            this.redireccionar("navegador_seguimiento_solicitud_mantenimiento_materiales.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String getCargarSolicitudMantenimientoDetalleTareas(){
        try {
            this.cargarSolicitudMantenimientoDetalleTareas();
            this.cargarPersonal();
            this.cargarProovedor();
            this.cargarTiposTarea();
            tiposNivelSolicitudMantenimientoList = managedSolicitudMantenimiento.cargarTiposNivelSolicitudMantenimiento();
            this.cargarPersonalTareas_action();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }



    public void cargarSolicitudMantenimientoDetalleTareas(){
        try {

                con = Util.openConnection(con);
                String consulta = "  select s.COD_SOLICITUD_MANTENIMIENTO,t.COD_TIPO_TAREA,t.NOMBRE_TIPO_TAREA," +
                        " s.COD_PERSONAL, (select p.NOMBRE_PILA from personal p where p.COD_PERSONAL = s.COD_PERSONAL) NOMBRE_PILA, " +
                        " (select p.AP_PATERNO_PERSONAL from personal p where p.COD_PERSONAL = s.COD_PERSONAL) AP_PATERNO_PERSONAL, " +
                        " (select p.AP_MATERNO_PERSONAL from personal p where p.COD_PERSONAL = s.COD_PERSONAL) AP_MATERNO_PERSONAL, " +
                        " s.DESCRIPCION,s.FECHA_INICIAL,s.FECHA_FINAL,s.COD_PROVEEDOR, " +
                        " (select pr.NOMBRE_PROVEEDOR from PROVEEDORES pr where pr.COD_PROVEEDOR = s.COD_PROVEEDOR)  NOMBRE_PROVEEDOR, " +
                        " s.HORAS_HOMBRE " +
                        " from SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS s    inner join  TIPOS_TAREA t on s.COD_TIPO_TAREA = t.COD_TIPO_TAREA  " +
                        " where s.COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoItem.getCodSolicitudMantenimiento()+"'  ";

                LOGGER.debug(" consulta" + consulta);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(consulta);
                solicitudMantenimientoDetalleTareasList.clear();
                while(rs.next()){
                    SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareasItem = new SolicitudMantenimientoDetalleTareas();

                    solicitudMantenimientoDetalleTareasItem.getSolicitudMantenimiento().setCodSolicitudMantenimiento(rs.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                    solicitudMantenimientoDetalleTareasItem.getTiposTarea().setCodTipoTarea(rs.getInt("COD_TIPO_TAREA"));
                    solicitudMantenimientoDetalleTareasItem.getTiposTarea().setNombreTipoTarea(rs.getString("NOMBRE_TIPO_TAREA"));
                    solicitudMantenimientoDetalleTareasItem.getPersonal().setCodPersonal(rs.getString("COD_PERSONAL"));
                    solicitudMantenimientoDetalleTareasItem.getPersonal().setNombrePersonal(rs.getString("NOMBRE_PILA"));
                    solicitudMantenimientoDetalleTareasItem.getPersonal().setApPaternoPersonal(rs.getString("AP_PATERNO_PERSONAL"));
                    solicitudMantenimientoDetalleTareasItem.getPersonal().setApMaternoPersonal(rs.getString("AP_MATERNO_PERSONAL"));
                    solicitudMantenimientoDetalleTareasItem.getProveedores().setCodProveedor(rs.getInt("COD_PROVEEDOR"));
                    solicitudMantenimientoDetalleTareasItem.getProveedores().setNombreProveedor(rs.getString("NOMBRE_PROVEEDOR"));
                    solicitudMantenimientoDetalleTareasItem.setDescripcion(rs.getString("DESCRIPCION"));
                    solicitudMantenimientoDetalleTareasItem.setFechaInicial(rs.getDate("FECHA_INICIAL"));
                    solicitudMantenimientoDetalleTareasItem.getFechaInicial().setTime(rs.getTimestamp("FECHA_INICIAL").getTime());
                    solicitudMantenimientoDetalleTareasItem.setFechaFinal(rs.getDate("FECHA_FINAL"));
                    solicitudMantenimientoDetalleTareasItem.getFechaFinal().setTime(rs.getTimestamp("FECHA_FINAL").getTime());
                    solicitudMantenimientoDetalleTareasItem.setHorasHombre(rs.getFloat("HORAS_HOMBRE"));
                    solicitudMantenimientoDetalleTareasItem.setHoraInicial(rs.getTimestamp("FECHA_INICIAL"));
                    solicitudMantenimientoDetalleTareasItem.setHoraFinal(rs.getTimestamp("FECHA_FINAL"));

                    solicitudMantenimientoDetalleTareasList.add(solicitudMantenimientoDetalleTareasItem);
                }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String guardarSeguimientoTareasSolicitudMantenimiento_action(){
        try {
            String consulta = "";
            Iterator i = solicitudMantenimientoDetalleTareasList.iterator();
            while(i.hasNext()){
                SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareas = (SolicitudMantenimientoDetalleTareas)i.next();
                consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS  SET " +
                        "  FECHA_INICIAL = '"+sdf.format(solicitudMantenimientoDetalleTareas.getFechaInicial())+"'," +
                        "  FECHA_FINAL = '"+sdf.format(solicitudMantenimientoDetalleTareas.getFechaFinal())+"'," +
                        "  HORAS_HOMBRE = '"+solicitudMantenimientoDetalleTareas.getHorasHombre()+"' " +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoDetalleTareas.getSolicitudMantenimiento().getCodSolicitudMantenimiento()+"' " +
                        " AND COD_TIPO_TAREA = '"+solicitudMantenimientoDetalleTareas.getTiposTarea().getCodTipoTarea()+"' ";
                
                LOGGER.debug("consulta" + consulta);
                Statement st = con.createStatement();
                st.executeUpdate(consulta);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

     public String editarSolicitudMantenimientoDetalleTareas_action(){
        try {
               con=Util.openConnection(con);
               Iterator i = solicitudMantenimientoDetalleTareasList.iterator();
               while(i.hasNext()){
                   SolicitudMantenimientoDetalleTareas solicitudMantenimientoDetalleTareasItem = (SolicitudMantenimientoDetalleTareas) i.next();
                   if(solicitudMantenimientoDetalleTareasItem.getChecked().booleanValue()==true){
                       solicitudMantenimientoDetalleTareas =solicitudMantenimientoDetalleTareasItem;
                       solicitudMantenimientoDetalleTareasEditar.getSolicitudMantenimiento().setCodSolicitudMantenimiento(solicitudMantenimientoDetalleTareasItem.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                       solicitudMantenimientoDetalleTareasEditar.getTiposTarea().setCodTipoTarea(solicitudMantenimientoDetalleTareasItem.getTiposTarea().getCodTipoTarea());
                       solicitudMantenimientoDetalleTareasEditar.getPersonal().setCodPersonal(solicitudMantenimientoDetalleTareasItem.getPersonal().getCodPersonal());
                       //solicitudMantenimientoDetalleTareasEditar.setFechaFinal(new Date());
                       solicitudMantenimientoDetalleTareas.setFechaFinal(new Date());
                       //solicitudMantenimientoDetalleTareasEditar.getFechaFinal().setTime(new Date().getTime());
                       //SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
                       //System.out.println("la fecha de hoy");
                       

                       if(!solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal().equals("0")){
                           enteAsignado="interno";
                       }
                       if(solicitudMantenimientoDetalleTareas.getProveedores().getCodProveedor()>0){
                           enteAsignado="externo";
                       }
                       LOGGER.debug(" enteAsignado " + enteAsignado);


                       break;
                   }
               }
               solicitudMantenimientoPreventivo = solicitudMantenimientoItem; //para la generacion de solicitud de mantenimiento preventiva
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

     public String cerrarSolicitudMantenimiento_action(){
        try {
            Iterator i = solicitudMantenimientoList.iterator();
            while(i.hasNext()){
                SolicitudMantenimiento solicitudesMantenimientoItem = (SolicitudMantenimiento)i.next();
                if(solicitudesMantenimientoItem.getChecked())
                {
                     StringBuilder consulta = new StringBuilder(" UPDATE SOLICITUDES_MANTENIMIENTO ");
                                             consulta.append(" SET COD_ESTADO_SOLICITUD_MANTENIMIENTO = '4' ");
                                             consulta.append(" WHERE COD_SOLICITUD_MANTENIMIENTO = ").append(solicitudesMantenimientoItem.getCodSolicitudMantenimiento());
                    LOGGER.debug("consulta" + consulta.toString());
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    PreparedStatement pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)LOGGER.info("se cerro la solicitud de mantenimiento");
                    consulta=new StringBuilder("UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS");
                             consulta.append(" set TERMINADO=1");
                             consulta.append(" WHERE COD_SOLICITUD_MANTENIMIENTO=").append(solicitudesMantenimientoItem.getCodSolicitudMantenimiento());
                                consulta.append(" and COD_PERSONAL=? and COD_TIPO_TAREA=? and FECHA_INICIAL=?");
                    LOGGER.debug("consulta terminar actividades"+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    consulta=new StringBuilder("select smdt.COD_PERSONAL,smdt.COD_TIPO_TAREA,max(smdt.FECHA_INICIAL) as fechaInicial");
                             consulta.append(" from SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS smdt ");
                             consulta.append(" where smdt.COD_SOLICITUD_MANTENIMIENTO=").append(solicitudesMantenimientoItem.getCodSolicitudMantenimiento());
                             consulta.append(" group by smdt.COD_PERSONAL,smdt.COD_TIPO_TAREA");
                    LOGGER.debug("consulta buscar ultimos registro de tareas");
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        pst.setInt(1,res.getInt("COD_PERSONAL"));
                        pst.setInt(2,res.getInt("COD_TIPO_TAREA"));
                        pst.setTimestamp(3,res.getTimestamp("fechaInicial"));
                        if(pst.executeUpdate()>0)LOGGER.info("termino la actividad");
                    }
                    con.commit();
                    con.close();
                    
                    //this.notificarCorreo(solicitudesMantenimientoItem);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        this.getCargarSeguimientoSolicitudMantenimiento();
        return null;
    }
     public void notificarCorreo(SolicitudMantenimiento solicitudMantenimiento){
        try {
            String contenido = "<b>La orden de Trabajo Nro "+solicitudMantenimiento.getNroOrdenTrabajo()+" fue cerrada por el Administrador: </b> </b> <br/><div align='center'><table  align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #000000 1px;' cellpadding='0' cellspacing='0'>" +
                    " <tr style='border : solid #000000 1px;'>" +
                    " <td  align='center' style='border : solid #000000 1px;' width='20%'><b>Nro OT</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getNroOrdenTrabajo()+"</td>" +
                    " <td  align='center' style='border : solid #000000 1px;' width='20%'><b>Tipo de Orden</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getTiposSolicitudMantenimiento().getNombreTipoSolicitud()+"</td>" +
                    " </tr>" +
                    " <tr style='border : solid #000000 1px;'>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Planta:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' ></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Afecta Produccion</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+(solicitudMantenimiento.getAfectaraProduccion()==1?"SI":"NO")+"</td>" +
                    " </tr>" +
                    " <tr style='border : solid #000000 1px;'>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Area:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getAreasEmpresa().getNombreAreaEmpresa()+"</td>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Usuario:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getPersonal_usuario().getNombrePersonal() + " " + solicitudMantenimiento.getPersonal_usuario().getApPaternoPersonal() + " " + solicitudMantenimiento.getPersonal_usuario().getApMaternoPersonal() +"</td>" +
                    " </tr> " +
                    " <tr style='border : solid #000000 1px;'>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Emision:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getFechaSolicitudMantenimiento()+"</td>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Aprobacion:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getFechaCambioEstadoSolicitud()+"</td>" +
                    " </tr> <tr style='border : solid #000000 1px;'>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Area Instalacion:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getAreasInstalaciones().getNombreAreaInstalacion()+"</td>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Modulo Instalacion:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getAreasInstalacionesModulos().getCodigo()+"</td>" +
                    " </tr>" +
                    " <tr style='border : solid #000000 1px;'>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Maquinaria:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getMaquinaria().getNombreMaquina()+"</td>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Parte Maquina:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getPartesMaquinaria().getNombreParteMaquina()+"</td>" +
                    "</tr>" +
                    " <tr style='border : solid #000000 1px;'>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Codigo:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getMaquinaria().getCodigo()+"</td>" +
                    " <td  align='center' style='border : solid #000000 1px;' ><b>Nivel de Ejecucion:</b></td>" +
                    " <td  align='center' style='border : solid #000000 1px;' >"+solicitudMantenimiento.getEstadoSolicitudMantenimiento().getNombreEstadoSolicitudMantenimiento()+"</td>" +
                    " </tr> </table></div> <br/><br/><br/> <b style = 'color:#0000FF'>Sistema Atlas<b>";
            System.out.println(contenido);
            Util.enviarCorreo("1479", contenido, "Cierre de Orden de Trabajo", "Notificacion");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
     
     public String guardarEdicionSolicitudMantenimientoDetalleTareas_action(){
        try {
            con=Util.openConnection(con);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd hh:mm");

            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS  SET   " +
                    "  COD_TIPO_TAREA = '"+solicitudMantenimientoDetalleTareas.getTiposTarea().getCodTipoTarea()+"'," +
                    "  DESCRIPCION = '"+solicitudMantenimientoDetalleTareas.getDescripcion()+"', ";
                    if(enteAsignado.equals("interno")){
                        consulta += "  COD_PERSONAL = '"+solicitudMantenimientoDetalleTareas.getPersonal().getCodPersonal()+"'," +
                        "  COD_PROVEEDOR = 0, " ;
                    }else{
                        consulta += "  COD_PERSONAL = '0'," +
                        "  COD_PROVEEDOR = "+solicitudMantenimientoDetalleTareas.getProveedores().getCodProveedor()+", " ;
                    }
                    consulta += " FECHA_FINAL = '"+ sdf.format(solicitudMantenimientoDetalleTareas.getFechaFinal())+"', " +
                    "  HORAS_HOMBRE = '"+solicitudMantenimientoDetalleTareas.getHorasHombre()+"' " +
                    "  WHERE  COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoDetalleTareasEditar.getSolicitudMantenimiento().getCodSolicitudMantenimiento()+"' " +
                    "  AND COD_TIPO_TAREA = '"+solicitudMantenimientoDetalleTareasEditar.getTiposTarea().getCodTipoTarea()+"'" +
                    "  AND COD_PERSONAL = '"+solicitudMantenimientoDetalleTareasEditar.getPersonal().getCodPersonal()+"'  ";


             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);
             if(solicitudMantenimientoDetalleTareas.getConSolicitudMantenimientoPreventiva().booleanValue()==true){
                 this.guardarSolicitudMantenimientoPreventivo();
             }
             this.cargarSolicitudMantenimientoDetalleTareas();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     public void guardarSolicitudMantenimientoPreventivo(){
        try {
            con=Util.openConnection(con);
            solicitudMantenimientoPreventivo.getTiposSolicitudMantenimiento().setCodTipoSolicitud(1); //solicitud mantenimiento preventivo
            solicitudMantenimientoPreventivo.getPersonal_ejecutante().setCodPersonal("0");
            solicitudMantenimientoPreventivo.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd hh:mm");

            ManagedAccesoSistema usuario = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            String consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO( COD_SOLICITUD_MANTENIMIENTO,COD_GESTION,COD_TIPO_SOLICITUD_MANTENIMIENTO," +
                    " COD_RESPONSABLE,  COD_ESTADO_SOLICITUD_MANTENIMIENTO,  ESTADO_SISTEMA,  COD_PERSONAL,  COD_AREA_EMPRESA,  FECHA_SOLICITUD_MANTENIMIENTO," +
                    "  OBS_SOLICITUD_MANTENIMIENTO,  FECHA_CAMBIO_ESTADOSOLICITUD,  COD_MAQUINARIA,  COD_FORM_SALIDA,  COD_SOLICITUD_COMPRA," +
                    "  AFECTARA_PRODUCCION,  FECHA_APROBACION,  NRO_ORDEN_TRABAJO,  COD_AREA_INSTALACION,  COD_MODULO_INSTALACION,  COD_PARTE_MAQUINA,  COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO ) VALUES ( (SELECT ISNULL(MAX(S.COD_SOLICITUD_MANTENIMIENTO),0)+1 FROM SOLICITUDES_MANTENIMIENTO S), " +
                    " (select G.COD_GESTION from GESTIONES G where GETDATE() BETWEEN G.FECHA_INI AND G.FECHA_FIN)," +
                    "  '"+solicitudMantenimientoPreventivo.getTiposSolicitudMantenimiento().getCodTipoSolicitud()+"',  '"+solicitudMantenimientoPreventivo.getPersonal_ejecutante().getCodPersonal()+"'," +
                    "  '"+solicitudMantenimientoPreventivo.getEstadoSolicitudMantenimiento().getCodEstadoSolicitudMantenimiento()+"', " +
                    "  1, '"+usuario.getUsuarioModuloBean().getCodUsuarioGlobal()+"', '"+solicitudMantenimientoPreventivo.getAreasEmpresa().getCodAreaEmpresa()+"', " +
                    "  '"+sdf.format(new Date())+"'," +
                    "  '"+solicitudMantenimientoPreventivo.getObsSolicitudMantenimiento()+"', null,  '"+solicitudMantenimientoPreventivo.getMaquinaria().getCodMaquina()+"'," +
                    "  0, 0,'"+solicitudMantenimientoPreventivo.getAfectaraProduccion()+"', null,  null, '"+solicitudMantenimientoPreventivo.getAreasInstalaciones().getCodAreaInstalacion()+"'," +
                    "  '"+solicitudMantenimientoPreventivo.getModulosInstalaciones().getCodModuloInstalacion()+"', '"+solicitudMantenimientoPreventivo.getPartesMaquinaria().getCodParteMaquina()+"', '"+solicitudMantenimientoPreventivo.getTiposNivelSolicitudMantenimiento().getCodTipoNivelSolicitudMantenimiento()+"'); ";
            System.out.println("consulta "  + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void cargarTiposTarea() 
    {
        try {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder(" SELECT COD_TIPO_TAREA,NOMBRE_TIPO_TAREA, COD_ESTADO_REGISTRO ");
                                      consulta.append(" FROM TIPOS_TAREA ");
                                      consulta.append(" WHERE COD_ESTADO_REGISTRO = 1 ");
            LOGGER.debug("consulta cargar " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            tiposTareasList=new ArrayList<SelectItem>();
            while (res.next()) 
            {
                tiposTareasList.add(new SelectItem(res.getString("COD_TIPO_TAREA"), res.getString("NOMBRE_TIPO_TAREA")));
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
      public void cargarPersonal() {
        try {
            con = (Util.openConnection(con));
            String consulta = " select P.COD_PERSONAL,(P.NOMBRES_PERSONAL +' ' + P.AP_PATERNO_PERSONAL +' '+ P.AP_MATERNO_PERSONAL)  NOMBRES_PERSONAL " +
                    " from  personal P where P.cod_area_empresa=86 " +
                    " AND P.COD_ESTADO_PERSONA=1 ";

            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            personalList.clear();
            rs = st.executeQuery(consulta);
            while (rs.next()) {
                personalList.add(new SelectItem(rs.getString("COD_PERSONAL"), rs.getString("NOMBRES_PERSONAL")));
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

        public void cargarProovedor() {
        try {
            con = (Util.openConnection(con));
            String consulta = " SELECT PR.COD_PROVEEDOR,PR.NOMBRE_PROVEEDOR  from PROVEEDORES PR WHERE PR.COD_ESTADO_PROVEEDOR=1 AND PR.COD_ESTADO_REGISTRO=1 " +
                    " ORDER BY PR.NOMBRE_PROVEEDOR ASC ";


            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            proveedorList.clear();
            rs = st.executeQuery(consulta);
            while (rs.next()) {
                proveedorList.add(new SelectItem(rs.getString("COD_PROVEEDOR"), rs.getString("NOMBRE_PROVEEDOR")));
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
    public String verParteMaquinaria_action(){
        try {
             con = (Util.openConnection(con));
             solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();

             String consulta = "  select pm.cod_parte_maquina,  pm.cod_maquina,  pm.codigo,  pm.cod_tipo_equipo,  pm.nombre_parte_maquina," +
                     " pm.obs_parte_maquina,  te.NOMBRE_TIPO_EQUIPO " +
                     " from partes_maquinaria pm, TIPOS_EQUIPOS_MAQUINARIA te " +
                     " where cod_maquina = '"+solicitudMantenimientoItem.getMaquinaria().getCodMaquina()+"' " +
                     " and te.COD_TIPO_EQUIPO = pm.cod_tipo_equipo " +
                     " order by pm.nombre_parte_maquina ";

            System.out.println("consulta " + consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            partesMaquinariaList.clear();
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                PartesMaquinaria partesMaquinaria = new PartesMaquinaria();
                partesMaquinaria.setCodParteMaquina(rs.getInt("cod_parte_maquina"));
                partesMaquinaria.getMaquinaria().setCodMaquina(rs.getString("cod_maquina"));
                partesMaquinaria.setCodigo(rs.getString("codigo"));
                partesMaquinaria.getTiposEquiposMaquinaria().setCodTipoEquipo(rs.getString("cod_tipo_equipo"));
                partesMaquinaria.setNombreParteMaquina(rs.getString("nombre_parte_maquina"));
                partesMaquinaria.setObsParteMaquina(rs.getString("obs_parte_maquina"));
                partesMaquinaria.getTiposEquiposMaquinaria().setNombreTipoEquipo(rs.getString("NOMBRE_TIPO_EQUIPO"));
                partesMaquinariaList.add(partesMaquinaria);
            }
            PartesMaquinaria partesMaquinaria = new PartesMaquinaria();
            partesMaquinaria.setCodParteMaquina(0);
            partesMaquinaria.setCodigo("NINGUNO");
            partesMaquinaria.setNombreParteMaquina("NINGUNO");
            partesMaquinariaList.add(partesMaquinaria);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String seleccionarParteMaquinaria_action(){
        try {
             con = (Util.openConnection(con));

            PartesMaquinaria partesMaquinariaItem = (PartesMaquinaria)partesMaquinariaDataTable.getRowData();
            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO  " +
                    " SET COD_PARTE_MAQUINA = '"+partesMaquinariaItem.getCodParteMaquina()+"'  " +
                    " WHERE  COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoItem.getCodSolicitudMantenimiento()+"' ";
            System.out.println("consulta " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);
            st.close();
            

            solicitudMantenimientoList = this.cargarSeguimientoSolicitudesMantenimiento();

            //solicitudMantenimientoItem.setPartesMaquinaria(partesMaquinariaItem);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
      
   
     public String verInstalacionesModulos_action(){
         try {
             con = (Util.openConnection(con));
             solicitudMantenimientoItem = (SolicitudMantenimiento)solicitudMantenimientoDataTable.getRowData();
             String consulta = " SELECT AI.COD_AREA_INSTALACION,  AI.COD_MODULO_INSTALACION,   AI.CODIGO,  M.NOMBRE_MODULO_INSTALACION " +
                     " FROM AREAS_INSTALACIONES_MODULOS AI,      AREAS_INSTALACIONES A,      MODULOS_INSTALACIONES M " +
                     " WHERE AI.COD_AREA_INSTALACION = A.COD_AREA_INSTALACION AND M.COD_MODULO_INSTALACION = AI.COD_MODULO_INSTALACION " +
                     " AND AI.COD_AREA_INSTALACION = '"+solicitudMantenimientoItem.getAreasInstalaciones().getCodAreaInstalacion()+"'  order by M.NOMBRE_MODULO_INSTALACION  ";
             System.out.println("consulta " + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             ResultSet rs = st.executeQuery(consulta);
             areasInstalacionesModulosList.clear();
             while(rs.next()){
                 //AreasInstalacionesModulos areasInstalacionesModulos = new AreasInstalacionesModulos();
                 ModulosInstalaciones modulosInstalaciones = new ModulosInstalaciones();
                // modulosInstalaciones.getAreasInstalacionesModulos().getAreasInstalaciones().setCodAreaInstalacion(rs.getInt("COD_AREA_INSTALACION"));
                 modulosInstalaciones.setCodModuloInstalacion(rs.getInt("COD_MODULO_INSTALACION"));
                // modulosInstalaciones.getAreasInstalacionesModulos().getAreasInstalaciones().setCodigo(rs.getString("CODIGO"));
                 modulosInstalaciones.setNombreModuloInstalacion(rs.getString("NOMBRE_MODULO_INSTALACION"));
                 areasInstalacionesModulosList.add(modulosInstalaciones);
             }
             

         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }



     public String seleccionarAreaInstalacionModulo_action(){
        try {
             con = (Util.openConnection(con));
             //AreasInstalacionesModulos areasInstalacionesModulos = (AreasInstalacionesModulos)areasInstalacionesDataTable.getRowData();
             ModulosInstalaciones modulosInstalaciones = (ModulosInstalaciones)areasInstalacionesDataTable.getRowData();

            
            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO  " +
                    " SET COD_MODULO_INSTALACION = '"+modulosInstalaciones.getCodModuloInstalacion() +"'  " +
                    " WHERE  COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoItem.getCodSolicitudMantenimiento()+"' ";
            System.out.println("consulta " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);
            st.close();

            this.cargarSeguimientoSolicitudesMantenimiento();

            //solicitudMantenimientoItem.setPartesMaquinaria(partesMaquinariaItem);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     public String solicitudMantenimientoPreventivo_action(){
         //System.out.println("entro al action " + solicitudMantenimientoDetalleTareas.getConSolicitudMantenimientoPreventiva() );
//         if(solicitudMantenimientoDetalleTareas.getConSolicitudMantenimientoPreventiva().booleanValue()==false){
//             solicitudMantenimientoDetalleTareas.setConSolicitudMantenimientoPreventiva(true);
//         }else{
//             solicitudMantenimientoDetalleTareas.setConSolicitudMantenimientoPreventiva(false);
//         }
         return null;
     }
     public String describirEstado_action(){
         try {
             Iterator i = solicitudMantenimientoList.iterator();
             while(i.hasNext()){
                 solicitudMantenimientoItem = (SolicitudMantenimiento) i.next();
                 if(solicitudMantenimientoItem.getChecked().booleanValue()==true){
                     break;
                 }
                 
             }
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
     public String guardardescribirEstado_action(){
         try {
             ExternalContext ec = FacesContext.getCurrentInstance().getExternalContext();
             Map<String, String> parameterMap = (Map<String, String>) ec.getRequestParameterMap();
             String param = parameterMap.get("check_box");
             System.out.println("el valor recuperado" + param);
             Connection con = null;
             con = Util.openConnection(con);
             Statement st = con.createStatement();
             String consulta = " update solicitudes_mantenimiento set descripcion_estado = '"+solicitudMantenimientoItem.getDescripcionEstado()+"' " +
                     " where cod_solicitud_mantenimiento = '"+solicitudMantenimientoItem.getCodSolicitudMantenimiento()+"' ";
             System.out.println("consulta " + consulta );
             st.executeUpdate(consulta);
             st.close();
             con.close();
             if(enviarCorreoSolicitante==true){
                 this.enviarCorreoSolicitante(solicitudMantenimientoItem);
             }
             solicitudMantenimientoList = this.cargarSeguimientoSolicitudesMantenimiento();
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
     public String enviarCorreoSolicitante(SolicitudMantenimiento solicitudMantenimiento){
         try {
             ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
             String consulta = " select nombre_correopersonal from correo_personal c where c.cod_personal = '"+ solicitudMantenimiento.getPersonal_usuario().getCodPersonal() +"' ";
             System.out.println("consulta " + consulta);
             Connection con = null;
             con = Util.openConnection(con);
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(consulta);
             InternetAddress emails[] = new InternetAddress[1];
             if(rs.next()){
             emails[0]=new InternetAddress(rs.getString("nombre_correopersonal"));}
             Properties props = new Properties();
             props.put("mail.smtp.host", "mail.cofar.com.bo");
             props.put("mail.transport.protocol", "smtp");
             props.put("mail.smtp.auth", "false");
             props.setProperty("mail.user", "traspasos@cofar.com.bo");
             props.setProperty("mail.password", "n3td4t4");
             Session mailSession = Session.getInstance(props, null);
             Message msg = new MimeMessage(mailSession);
             msg.setSubject("Solicitud de Mantenimiento");
             msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", "Modulo de Mantenimiento"));
             msg.addRecipients(Message.RecipientType.TO, emails);
             String contenido = " <html> " +
                     " <head>  <title></title> " +
                     " <meta http-equiv='Content-Type' content='text/html; charset=windows-1252'> " +
                     " </head> " +
                     " <body> " +
                     " "+solicitudMantenimiento.getPersonal_usuario().getNombrePersonal()+": " +
                     " <br/>  su solicitud de Mantenimiento se actualizo con la siguiente informacion.<br/><br/> " +
                     " <table border='0' style='font-family: Arial'> " +
                     " <tbody> " +
                     " <tr> <td border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000><b> Solicitud de Mantenimiento: </b></td> <td>"+(solicitudMantenimiento.getObsSolicitudMantenimiento()!=null?solicitudMantenimiento.getObsSolicitudMantenimiento():"")+"</td> </tr>" +
                     " <tr> <td border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000><b>Nro Solicitud de Mantenimiento:</b></td> <td>"+(solicitudMantenimiento.getCodSolicitudMantenimiento()!=0?solicitudMantenimiento.getCodSolicitudMantenimiento():"")+"</td> </tr> " +
                     " <tr> <td border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000><b>Maquinaria:</b></td> <td>"+(solicitudMantenimiento.getMaquinaria().getNombreMaquina()!=null?solicitudMantenimiento.getMaquinaria().getNombreMaquina():"")+"</td> </tr> " +
                     " <tr> <td border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000><b>Instalacion:</b></td> <td>"+(solicitudMantenimiento.getAreasInstalaciones().getNombreAreaInstalacion()!=null?solicitudMantenimiento.getAreasInstalaciones().getNombreAreaInstalacion():"")+"</td> </tr> " +
                     " <tr> <td border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000><b>Comentario:</b></td> <td>"+(solicitudMantenimiento.getDescripcionEstado()!=null?solicitudMantenimiento.getDescripcionEstado():"")+"</td> </tr> " +
                     " </tbody></table> <br><br> Modulo de Mantenimiento - Atlas   " +
                     " </body> </html> " ;
            msg.setContent(contenido, "text/html");
            javax.mail.Transport.send(msg);
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
     
     private void cargarTiposSolicitudMantemiento()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ts.COD_TIPO_SOLICITUD,ts.NOMBRE_TIPO_SOLICITUD from TIPOS_SOLICITUD_MANTENIMIENTO ts order by ts.NOMBRE_TIPO_SOLICITUD";
            ResultSet res=st.executeQuery(consulta);
            tiposSolicitudMantenimientoList.clear();
            tiposSolicitudMantenimientoList.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                   tiposSolicitudMantenimientoList.add(new SelectItem(res.getString("COD_TIPO_SOLICITUD"),res.getString("NOMBRE_TIPO_SOLICITUD")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }

    public void cargarMaquinarias(String codigo, SolicitudMantenimiento bean,ManagedAccesoSistema bean1) {
        try {
            Connection con1=null;
            con1=Util.openConnection(con1);
            String sql = " select m.COD_MAQUINA,m.NOMBRE_MAQUINA,m.CODIGO from MAQUINARIAS m " +
                    " " +(!bean1.getCodAreaEmpresaGlobal().equals("")?" where m.cod_area_empresa = '"+ bean1.getCodAreaEmpresaGlobal()+"'":"") +
                    " order by m.NOMBRE_MAQUINA";
            System.out.println(" sql:" + sql);
            ResultSet rs = null;
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            if (!codigo.equals("")) {
            } else {
                getMaquinariasList().clear();
                rs = st.executeQuery(sql);
                while (rs.next()) {
                    if(getMaquinariasList().size()==0){getMaquinariasList().add(new SelectItem("0","-TODOS-"));}
                    getMaquinariasList().add(new SelectItem(rs.getString(1), rs.getString(2) + " " + rs.getString(3)));
                }
            }
           rs.close();
           st.close();
           con1.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public String buscarSolicitudMantenimiento_action()
    {
        begin=1;
        end=10;
        solicitudMantenimientoList =  this.cargarSeguimientoSolicitudesMantenimiento();
        return null;
    }
    public String guardarEdicionHorasSolicitudMantenimiento_action()
    {
        SimpleDateFormat fecha=new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat hora=new SimpleDateFormat("HH:mm");
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            String consulta="UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS "+
                            " SET DESCRIPCION = '"+solicitudTareasEditar.getDescripcion()+"',"+
                            " FECHA_INICIAL = '"+fecha.format(solicitudTareasEditar.getFechaInicial())+" "+hora.format(solicitudTareasEditar.getHoraInicial())+"',"+
                            " FECHA_FINAL = '"+fecha.format(solicitudTareasEditar.getFechaFinal())+" "+hora.format(solicitudTareasEditar.getHoraFinal())+"',"+
                            " HORAS_HOMBRE ='"+solicitudTareasEditar.getHorasHombre()+"'"+
                            " WHERE   COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoItem.getCodSolicitudMantenimiento()+"' and"+
                            " COD_TIPO_TAREA = '"+solicitudTareasEditar.getTiposTarea().getCodTipoTarea()+"' and"+
                            " COD_PERSONAL = '"+solicitudTareasEditar.getPersonal().getCodPersonal()+"'" +
                            " and FECHA_INICIAL = '"+fecha.format(solicitudTareasAgregar.getFechaInicial())+" "+hora.format(solicitudTareasAgregar.getHoraInicial())+"'"+
                            " and FECHA_FINAL = '"+fecha.format(solicitudTareasAgregar.getFechaFinal())+" "+hora.format(solicitudTareasAgregar.getHoraFinal())+"'";
            System.out.println("consulta update horas hombre "+consulta);
            PreparedStatement pst=con1.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo");
            pst.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        this.cargarSolicitudMantenimientoDetalleTareas();
        return null;
    }
    public void cargarPersonalTareas_action()
    {
        try
        {
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select  (CAST(t.COD_TIPO_TAREA as varchar)+' '+cast(s.COD_PERSONAL as varchar)+' '+cast(ISNULL(s.COD_PROVEEDOR,0) as varchar)) as  codigos,"+
                            " (p.NOMBRE_PILA+' '+p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL) as nombrePersonal,"+
                            " t.NOMBRE_TIPO_TAREA"+
                            " from SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS s inner join TIPOS_TAREA t on"+
                            " s.COD_TIPO_TAREA=t.COD_TIPO_TAREA inner join PERSONAL p on "+
                            " p.COD_PERSONAL=s.COD_PERSONAL"+
                            " where s.COD_SOLICITUD_MANTENIMIENTO='"+solicitudMantenimientoItem.getCodSolicitudMantenimiento()+"'"+
                            " group by t.COD_TIPO_TAREA,s.COD_PERSONAL,p.NOMBRE_PILA,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,t.NOMBRE_TIPO_TAREA,s.COD_PROVEEDOR"+
                            " order by p.NOMBRE_PILA,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,t.NOMBRE_TIPO_TAREA";
            System.out.println("consulta cargar personal"+consulta);
            ResultSet res=st.executeQuery(consulta);
            personalTareasList.clear();
            while(res.next())
            {
                personalTareasList.add(new SelectItem(res.getString("codigos"),res.getString("nombrePersonal")+" - "+res.getString("NOMBRE_TIPO_TAREA")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String agregarHorasSolicitudMantenimiento_action()
    {
        solicitudTareasAgregar=new SolicitudMantenimientoDetalleTareas();
        return null;
    }

    public String editarHorasSolicitudMantenimiento_action()
    {
        Iterator e=solicitudMantenimientoDetalleTareasList.iterator();
        while(e.hasNext())
        {
            SolicitudMantenimientoDetalleTareas bean=(SolicitudMantenimientoDetalleTareas)e.next();
            if(bean.getChecked())
            {
                solicitudTareasEditar=bean;
            }
        }
        solicitudTareasAgregar.setFechaInicial((Date)solicitudTareasEditar.getFechaInicial().clone());
        solicitudTareasAgregar.setHoraInicial((Date)solicitudTareasEditar.getFechaInicial().clone());
        solicitudTareasAgregar.setFechaFinal((Date)solicitudTareasEditar.getFechaFinal().clone());
        solicitudTareasAgregar.setHoraFinal((Date)solicitudTareasEditar.getFechaFinal().clone());
        return null;
    }
    public String guardarPersonalTareasSeguimiento_action()
     {
         try
         {
             SimpleDateFormat fecha=new SimpleDateFormat("yyyy/MM/dd");
             SimpleDateFormat hora=new SimpleDateFormat("HH:mm");
             Connection con1=null;
             con1=Util.openConnection(con1);
             System.out.println("cod person "+solicitudTareasAgregar.getPersonal().getCodPersonal());
             String consulta="INSERT INTO SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS(COD_SOLICITUD_MANTENIMIENTO"+
                             " , COD_TIPO_TAREA, DESCRIPCION, COD_PERSONAL, FECHA_INICIAL, FECHA_FINAL,"+
                             " COD_PROVEEDOR, HORAS_HOMBRE)"+
                             " VALUES ('"+solicitudMantenimientoItem.getCodSolicitudMantenimiento()+"'," +
                             "'"+solicitudTareasAgregar.getPersonal().getCodPersonal().split(" ")[0]+"', " +
                             "'"+solicitudTareasAgregar.getDescripcion()+"',"+
                             "'"+solicitudTareasAgregar.getPersonal().getCodPersonal().split(" ")[1]+"'," +
                             "'"+fecha.format(solicitudTareasAgregar.getFechaInicial())+" "+hora.format(solicitudTareasAgregar.getFechaInicial())+"'," +
                             "'"+fecha.format(solicitudTareasAgregar.getFechaFinal())+" "+hora.format(solicitudTareasAgregar.getFechaFinal())+"'," +
                             "'"+solicitudTareasAgregar.getPersonal().getCodPersonal().split(" ")[2]+"','"+solicitudTareasAgregar.getHorasHombre()+"')";
             System.out.println("consulta insert solicitudes mantenimiento "+consulta);
             PreparedStatement pst=con1.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se inserto en la base de datos");
             con1.close();
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }
         this.cargarSolicitudMantenimientoDetalleTareas();
         return null;
     }
    private void cargarAreasEmpresaBuscador()
    {
        try
        {
            ManagedAccesoSistema user=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            String consulta=(user.getCodAreaEmpresaGlobal().equals("86")?
                " select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA ae order by ae.NOMBRE_AREA_EMPRESA":
                " select ae.cod_area_empresa,ae.nombre_area_empresa from areas_empresa ae inner join USUARIOS_AREA_PRODUCCION u on ae.cod_area_empresa ="+
                " u.cod_area_empresa where u.cod_personal = '"+user.getUsuarioModuloBean().getCodUsuarioGlobal()+"' and u.cod_tipo_permiso = 1 order by ae.NOMBRE_AREA_EMPRESA");
            Connection con1=null;
            con1=Util.openConnection(con1);
            Statement st=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            areasEmpresaBuscadorList.clear();
            areasEmpresaBuscadorList.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                areasEmpresaBuscadorList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            res.close();
            st.close();
            con1.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }

    }
//  private boolean enviarSalida(String codIngresoVentasF, int codIngresoLiberado, String emailDestino, String emailDestino2, String emailDestino3, String emailDestino4, String asuntoAsistente) throws SQLException {
//        boolean verificar = true;
//        try {
//            String  sqlCorreos="select c.nombre_correopersonal from  correo_personal c where c.cod_tipo_envio=1";
//
//            Statement stCorreos=con.createStatement();
//            ResultSet rsCorreos=stCorreos.executeQuery(sqlCorreos);
//            List<String> data = new ArrayList<String>();
//
//            while (rsCorreos.next())
//                data.add(rsCorreos.getString(1));
//            rsCorreos.close();
//            stCorreos.close();
//
//            InternetAddress emails[] = new InternetAddress[data.size()];
//            int index = 0;
//            for (String d : data) {
//                InternetAddress e = new InternetAddress(d);
//                emails[index] = e;
//                index++;
//
//            }
//
//
//
//
//
//
//            emailDestino = emailDestino.equals("") ? email_traspasos : emailDestino;
//            String subject2 = "LIBERACION_" + codIngresoVentasF;
//            String subject = asuntoAsistente.equals("") ? subject2 : asuntoAsistente;
//
//            System.out.println("subject:" + subject);
//
//
//            Properties props = new Properties();
//            props.put("mail.smtp.host", "mail.cofar.com.bo");
//            props.put("mail.transport.protocol", "smtp");
//            props.put("mail.smtp.auth", "false");
//            props.setProperty("mail.user", "traspasos@cofar.com.bo");
//            props.setProperty("mail.password", "n3td4t4");
//            Session mailSession = Session.getInstance(props, null);
//            Message msg = new MimeMessage(mailSession);
//            msg.setSubject("Modulo de Mantenimiento");
//            msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", "LIBERACION DE MERCADERIA"));
//            msg.addRecipients(Message.RecipientType.TO, emails);
//            BodyPart adjunto = new MimeBodyPart();
//            String ingresoVentas = "";
//            String ingresoVentasLiberado = "";
//            String ingresoVentasLiberadoDetalle = "<br><table border='1'  cellpadding='1' cellspacing='1' style='border : solid #cccccc 1px;font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 11px;' >";
//            ingresoVentasLiberadoDetalle = ingresoVentasLiberadoDetalle + "<tr align='center'><td><b>Producto</b></td><td><b>N° Lote</b></td><td><b>Cant.</b></td><td><b>Cant. unit.</b></td></tr>";
//            try {
//                String sql_00 = "select i.NRO_INGRESOVENTAS,a.NOMBRE_ALMACEN_VENTA from INGRESOS_VENTAS i,ALMACENES_VENTAS a";
//                sql_00 += " where i.COD_ALMACEN_VENTA = a.COD_ALMACEN_VENTA and i.COD_INGRESOVENTAS = " + codIngresoVentasF;
//                Statement st_00 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//                ResultSet rs_00 = st_00.executeQuery(sql_00);
//                if (rs_00.next()) {
//                    ingresoVentas = "<b>" + rs_00.getString(1) + "</b> del Almacen <b>" + rs_00.getString(2) + "</b>";
//                }
//                String sql_01 = "select a.NOMBRE_ALMACEN_VENTA,i.NRO_INGRESOVENTAS from INGRESOS_VENTAS i,ALMACENES_VENTAS a";
//                sql_01 += " where i.COD_ALMACEN_VENTA = a.COD_ALMACEN_VENTA and i.COD_INGRESOVENTAS =" + codIngresoLiberado;
//                Statement st_01 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//                ResultSet rs_01 = st_01.executeQuery(sql_01);
//                if (rs_01.next()) {
//                    ingresoVentasLiberado = " a almac&eacute;n destino <b>" + rs_01.getString(1) + "</b> con nro. de ingreso <b>" + rs_01.getString(2) + "</b>";
//                }
//                String sql_02 = "select p.NOMBRE_PRODUCTO_PRESENTACION,i.COD_LOTE_PRODUCCION,i.CANTIDAD,i.CANTIDAD_UNITARIA";
//                sql_02 += " from INGRESOS_DETALLEVENTAS i,PRESENTACIONES_PRODUCTO p";
//                sql_02 += " where i.COD_PRESENTACION = p.cod_presentacion and i.COD_INGRESOVENTAS = " + codIngresoLiberado;
//                Statement st_02 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//                ResultSet rs_02 = st_02.executeQuery(sql_02);
//                while (rs_02.next()) {
//                    ingresoVentasLiberadoDetalle = ingresoVentasLiberadoDetalle + "<tr>";
//                    ingresoVentasLiberadoDetalle = ingresoVentasLiberadoDetalle + "<td>" + rs_02.getString(1) + "</td><td>" + rs_02.getString(2) + "</td><td align='right'>" + rs_02.getString(3) + "</td><td align='right'>" + rs_02.getString(4) + "</td>";
//                    ingresoVentasLiberadoDetalle = ingresoVentasLiberadoDetalle + "</tr>";
//                }
//                ingresoVentasLiberadoDetalle = ingresoVentasLiberadoDetalle + "</table>";
//            } catch (SQLException e) {
//                e.printStackTrace();
//            }
//            String html = "<html><head></head><body style='font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 11px;'>";
//            html = html + "Estimados se&#241;ores:<p> Se realizo la liberaci&oacute;n del nro. ingreso " + ingresoVentas + "" + ingresoVentasLiberado + "<br><p>Detalle:<br>" + ingresoVentasLiberadoDetalle + "</body></html>";
//            html = html + "<br><span style='color:#660099'><b>Sistema - Zeus</b></span><br><span style='color:#660099'>Laboratorios COFAR S.A.<br>C. Victor Eduardo Nro. 2293<br>La Paz-Bolivia</span>";
//            msg.setContent(html, "text/html");
//            javax.mail.Transport.send(msg);
//
//        } catch (MessagingException e) {
//            e.printStackTrace();
//        } catch (UnsupportedEncodingException e2) {
//            e2.printStackTrace();
//        }  catch (IOException i) {
//            i.printStackTrace();
//        }
//
//        return verificar;
//
//    }
//
}
