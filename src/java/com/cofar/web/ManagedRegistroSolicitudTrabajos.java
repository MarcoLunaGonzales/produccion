/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.TrabajosSolicitudMantenimiento;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import javax.servlet.http.HttpServletRequest;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author sistemas1
 */
public class ManagedRegistroSolicitudTrabajos {

    //para datos de trabajo de solicitud
    private List<TrabajosSolicitudMantenimiento> trabajosSolMantList = new ArrayList<TrabajosSolicitudMantenimiento>();
    private TrabajosSolicitudMantenimiento itemTrabajos = new TrabajosSolicitudMantenimiento();
    private TrabajosSolicitudMantenimiento adicionarItemTrabajo = new TrabajosSolicitudMantenimiento();
    private TrabajosSolicitudMantenimiento modificarItemTrabajo = new TrabajosSolicitudMantenimiento();
    private TrabajosSolicitudMantenimiento actualItemTrabajo = new TrabajosSolicitudMantenimiento();
    private TrabajosSolicitudMantenimiento borrarItemTrabajo = new TrabajosSolicitudMantenimiento();
    private TrabajosSolicitudMantenimiento asignarTiempoRealItemTrabajo = new TrabajosSolicitudMantenimiento();
    private HtmlDataTable trabajosDataTable;
    private List tiposTrabajosList = new ArrayList();
    private List personalList = new ArrayList();
    private List proovedorList = new ArrayList();
    private Connection con;
    private Date fechaInicio;
    private Date fechaFin;
    private int codSolicitudMantenimiento;
    private int codTipoTrabajo = 0;
    private int codPersonal = 0;
    private int codProveedor = 0;
    private String enteAsignado;


    //para datos de materiales de solicitud
    /** Creates a new instance of ManagedRegistroSolicitudTrabajos */
    public ManagedRegistroSolicitudTrabajos() {
    }

    public List<TrabajosSolicitudMantenimiento> getTrabajosSolMantList() {
        return trabajosSolMantList;
    }

    public void setTrabajosSolMantList(List<TrabajosSolicitudMantenimiento> trabajosSolMantList) {
        this.trabajosSolMantList = trabajosSolMantList;
    }

    public HtmlDataTable getTrabajosDataTable() {
        return trabajosDataTable;
    }

    public void setTrabajosDataTable(HtmlDataTable trabajosDataTable) {
        this.trabajosDataTable = trabajosDataTable;
    }

    public TrabajosSolicitudMantenimiento getAdicionarItemTrabajo() {
        return adicionarItemTrabajo;
    }

    public void setAdicionarItemTrabajo(TrabajosSolicitudMantenimiento adicionarItemTrabajo) {
        this.adicionarItemTrabajo = adicionarItemTrabajo;
    }

    public List getTiposTrabajosList() {
        return tiposTrabajosList;
    }

    public void setTiposTrabajosList(List tiposTrabajosList) {
        this.tiposTrabajosList = tiposTrabajosList;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public List getPersonalList() {
        return personalList;
    }

    public void setPersonalList(List personalList) {
        this.personalList = personalList;
    }

    public TrabajosSolicitudMantenimiento getModificarItemTrabajo() {
        return modificarItemTrabajo;
    }

    public void setModificarItemTrabajo(TrabajosSolicitudMantenimiento modificarItemTrabajo) {
        this.modificarItemTrabajo = modificarItemTrabajo;
    }

    public List getProovedorList() {
        return proovedorList;
    }

    public void setProovedorList(List proovedorList) {
        this.proovedorList = proovedorList;
    }

    public String getEnteAsignado() {
        return enteAsignado;
    }

    public void setEnteAsignado(String enteAsignado) {
        this.enteAsignado = enteAsignado;
    }

    public TrabajosSolicitudMantenimiento getAsignarTiempoRealItemTrabajo() {
        return asignarTiempoRealItemTrabajo;
    }

    public void setAsignarTiempoRealItemTrabajo(TrabajosSolicitudMantenimiento asignarTiempoRealItemTrabajo) {
        this.asignarTiempoRealItemTrabajo = asignarTiempoRealItemTrabajo;
    }

    public String getInit() {
        this.init();
        return "";
    }

    void init() {
        try {
            
            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("nroSolicitud") != null) {
                codSolicitudMantenimiento = Integer.parseInt(request.getParameter("nroSolicitud"));
            }



            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = "select SMT.COD_SOLICITUD_MANTENIMIENTO, TT.COD_TIPO_TRABAJO ,TT.NOMBRE_TIPO_TRABAJO,P.COD_PERSONAL,(P.NOMBRES_PERSONAL +' '+ P.AP_MATERNO_PERSONAL +' '+ P.AP_MATERNO_PERSONAL) AS NOMBRE_COMPLETO_PERSONAL,SMT.DESCRIPCION, " +
                    " SMT.FECHA_INICIO,SMT.FECHA_FIN,SMT.HORAS_TRABAJO, TT.COD_ " +
                    " FROM SOLICITUDES_MANTENIMIENTO_TRABAJOS SMT " +
                    " INNER JOIN TIPOS_TRABAJO TT ON SMT.COD_TIPO_TRABAJO=TT.COD_TIPO_TRABAJO " +
                    " INNER JOIN PERSONAL P ON P.COD_PERSONAL= SMT.COD_PERSONAL " +
                    " WHERE SMT.COD_SOLICITUD_MANTENIMIENTO =  " + codSolicitudMantenimiento;

            consulta = " select SMT.COD_SOLICITUD_MANTENIMIENTO, TT.COD_TIPO_TRABAJO ,TT.NOMBRE_TIPO_TRABAJO,P.COD_PERSONAL,(P.NOMBRES_PERSONAL +' '+ P.AP_MATERNO_PERSONAL +' '+ P.AP_MATERNO_PERSONAL) AS NOMBRE_COMPLETO_PERSONAL,SMT.DESCRIPCION, " +
                    " SMT.FECHA_INICIO,SMT.FECHA_FIN,SMT.HORAS_TRABAJO,PR.COD_PROVEEDOR, PR.NOMBRE_PROVEEDOR " +
                    " FROM SOLICITUDES_MANTENIMIENTO_TRABAJOS SMT " +
                    " INNER JOIN TIPOS_TRABAJO TT ON SMT.COD_TIPO_TRABAJO=TT.COD_TIPO_TRABAJO  " +
                    " LEFT JOIN PERSONAL P ON P.COD_PERSONAL= SMT.COD_PERSONAL " +
                    " LEFT JOIN PROVEEDORES PR ON PR.COD_PROVEEDOR=SMT.COD_PROVEEDOR " +
                    " WHERE SMT.COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "' ";
                    
            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            trabajosSolMantList.clear();
            for (int i = 0; i < filas; i++) {
                itemTrabajos = new TrabajosSolicitudMantenimiento();
                itemTrabajos.setCodSolicitudMantenimiento(rs.getString("COD_SOLICITUD_MANTENIMIENTO"));
                itemTrabajos.setCodTipoTrabajo(rs.getString("COD_TIPO_TRABAJO"));
                itemTrabajos.setNombreTipoTrabajo(rs.getString("NOMBRE_TIPO_TRABAJO"));
                itemTrabajos.setCodPersonal(rs.getString("COD_PERSONAL") == null ? "0" : rs.getString("COD_PERSONAL"));
                itemTrabajos.setNombrePersonal(rs.getString("NOMBRE_COMPLETO_PERSONAL"));
                itemTrabajos.setDescripcion(rs.getString("DESCRIPCION"));
                itemTrabajos.setFechaInicio(rs.getString("FECHA_INICIO"));
                itemTrabajos.setFechaFin(rs.getString("FECHA_FIN"));
                itemTrabajos.setHorasTrabajo(rs.getString("HORAS_TRABAJO"));
                itemTrabajos.setCodProveedor(rs.getString("COD_PROVEEDOR") == null ? "0" : rs.getString("COD_PROVEEDOR"));
                itemTrabajos.setNombreProovedor(rs.getString("NOMBRE_PROVEEDOR"));
                itemTrabajos.setConPersonal(rs.getString("COD_PERSONAL") == null ? "false" : "true");
                itemTrabajos.setConProveedor(rs.getString("COD_PROVEEDOR") == null ? "false" : "true");


                trabajosSolMantList.add(itemTrabajos);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String editar_action() {

        try {
            String DATE_FORMAT_NOW = "yyyy/MM/dd";

            Calendar cal = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);
            fechaInicio = cal.getTime();
            fechaFin = cal.getTime();

            this.cargarTiposTrabajos();
            this.cargarPersonal();
            this.cargarProovedor();

            modificarItemTrabajo = new TrabajosSolicitudMantenimiento();

            modificarItemTrabajo = (TrabajosSolicitudMantenimiento) trabajosDataTable.getRowData();
            codTipoTrabajo = Integer.parseInt(modificarItemTrabajo.getCodTipoTrabajo());
            codPersonal = Integer.parseInt(modificarItemTrabajo.getCodPersonal() == null ? "0" : modificarItemTrabajo.getCodPersonal());
            codProveedor = Integer.parseInt(modificarItemTrabajo.getCodProveedor() == null ? "0" : modificarItemTrabajo.getCodProveedor());

            if (modificarItemTrabajo.getConPersonal().equals("true")) {
                enteAsignado = "interno";
            }
            if (modificarItemTrabajo.getConProveedor().equals("true")) {
                enteAsignado = "externo";
            }


//            System.out.println("el codigo de trabajo" + modificarItemTrabajo.getCodTipoTrabajo());
//            System.out.println("el codigo de PERSONAL" + modificarItemTrabajo.getCodPersonal());
//          
//            System.out.println("el codigo de trabajo" + codTipoTrabajo);

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();

            ext.redirect("modificar_trabajo_solicitud_mantenimiento.jsf");

//
//            con = (Util.openConnection(con));
//            String consulta = " SELECT SMT.COD_SOLICITUD_MANTENIMIENTO, SMT.COD_PERSONAL,SMT.COD_TIPO_TRABAJO,SMT.DESCRIPCION,SMT.FECHA_INICIO, " +
//                              " SMT.FECHA_FIN, SMT.HORAS_TRABAJO FROM SOLICITUDES_MANTENIMIENTO_TRABAJOS SMT "+
//                              " WHERE SMT.COD_SOLICITUD_MANTENIMIENTO=4 AND SMT.COD_PERSONAL = 2 ";
//
//
//            ResultSet rs = null;
//
//            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//            tiposTrabajosList.clear();
//            rs = st.executeQuery(consulta);
//            while (rs.next()) {
//                tiposTrabajosList.add(new SelectItem(rs.getString(1), rs.getString(2)));
//            }
//
//            if (rs != null) {
//                rs.close();
//                st.close();
//                rs = null;
//                st = null;
//            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void cargarTiposTrabajos() {
        try {
            con = (Util.openConnection(con));
            String consulta = " SELECT TT.COD_TIPO_TRABAJO, TT.NOMBRE_TIPO_TRABAJO FROM TIPOS_TRABAJO TT " +
                    " ORDER BY TT.NOMBRE_TIPO_TRABAJO ASC";

            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            tiposTrabajosList.clear();
            rs = st.executeQuery(consulta);
            while (rs.next()) {
                tiposTrabajosList.add(new SelectItem(rs.getString(1), rs.getString(2)));
            }

            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
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
            proovedorList.clear();
            rs = st.executeQuery(consulta);
            while (rs.next()) {
                proovedorList.add(new SelectItem(rs.getString(1), rs.getString(2)));
            }

            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cargarPersonal() {
        try {
            con = (Util.openConnection(con));
            String consulta = " select P.COD_PERSONAL,(P.NOMBRES_PERSONAL +' ' + P.AP_PATERNO_PERSONAL +' '+ P.AP_MATERNO_PERSONAL)  " +
                    " from  personal P where P.cod_area_empresa=86 " +
                    " AND P.COD_ESTADO_PERSONA=1 ";

            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            personalList.clear();
            rs = st.executeQuery(consulta);
            while (rs.next()) {
                personalList.add(new SelectItem(rs.getString(1), rs.getString(2)));
            }

            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String adicionar_action() {
        try {

            String DATE_FORMAT_NOW = "yyyy/MM/dd";

            Calendar cal = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);
            fechaInicio = cal.getTime();
            fechaFin = cal.getTime();

            this.cargarTiposTrabajos();
            this.cargarPersonal();
            this.cargarProovedor();
            enteAsignado = "interno";

            adicionarItemTrabajo = new TrabajosSolicitudMantenimiento();


            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("agregar_trabajo_solicitud_mantenimiento.jsf");


        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String aceptarTrabajos_action() {
        try {
            //cambiar de estado a la solicitud de mantenimiento
            try {
                //6: ESTADO EN EJECUCION
                String consulta = "UPDATE SOLICITUDES_MANTENIMIENTO SET COD_ESTADO_SOLICITUD_MANTENIMIENTO = '6'" +
                        ", FECHA_CAMBIO_ESTADOSOLICITUD = GETDATE()  " +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";

                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                st.executeUpdate(consulta);

                st.close();
            } catch (Exception e) {
                e.printStackTrace();
            }



            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String retornar_action() {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String action_guardarTrabajo() {
        try {

            Format formatter = new SimpleDateFormat("yyyy/MM/dd");

            System.out.println("ENTRO AL EVENTO  DE GUARDAR EL CHECK enteAsignado" + enteAsignado);
            //preparar el objeto
            adicionarItemTrabajo.setFechaInicio(formatter.format(fechaInicio));
            adicionarItemTrabajo.setFechaFin(formatter.format(fechaFin));


            con = (Util.openConnection(con));

            String consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO_TRABAJOS " +
                    " VALUES('" + codSolicitudMantenimiento + "','" + adicionarItemTrabajo.getCodTipoTrabajo() + "','" + adicionarItemTrabajo.getDescripcion() + "','" +
                    adicionarItemTrabajo.getHorasTrabajo() + "','" + adicionarItemTrabajo.getCodPersonal() + "','" + adicionarItemTrabajo.getFechaInicio() + "','" + adicionarItemTrabajo.getFechaFin() + "'" +
                    ",NULL,NULL,NULL) ";

            if (enteAsignado.equals("interno")) {
                consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO_TRABAJOS " +
                        " VALUES('" + codSolicitudMantenimiento + "','" + adicionarItemTrabajo.getCodTipoTrabajo() + "','" + adicionarItemTrabajo.getDescripcion() + "','" +
                        adicionarItemTrabajo.getHorasTrabajo() + "','" + adicionarItemTrabajo.getCodPersonal() + "','" + adicionarItemTrabajo.getFechaInicio() + "','" + adicionarItemTrabajo.getFechaFin() + "','0'" +
                        ",NULL,NULL,NULL) ";
            } else {
                consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO_TRABAJOS " +
                        " VALUES('" + codSolicitudMantenimiento + "','" + adicionarItemTrabajo.getCodTipoTrabajo() + "','" + adicionarItemTrabajo.getDescripcion() + "','" +
                        adicionarItemTrabajo.getHorasTrabajo() + "',0,'" + adicionarItemTrabajo.getFechaInicio() + "','" + adicionarItemTrabajo.getFechaFin() + "','" + adicionarItemTrabajo.getCodProveedor() + "'" +
                        ",NULL,NULL,NULL) ";
            }


            System.out.println(consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.init();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_trabajos_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String action_guardarModificacionTrabajo() {
        try {
            Format formatter = new SimpleDateFormat("yyyy/MM/dd");

            System.out.println("ENTRO AL EVENTO  DE GUARDAR MODIFICACFION ");
            //preparar el objeto
            modificarItemTrabajo.setFechaInicio(formatter.format(fechaInicio));
            modificarItemTrabajo.setFechaFin(formatter.format(fechaFin));

            System.out.println("el cod proveedor antes de actualizar" + modificarItemTrabajo.getCodPersonal());

            con = (Util.openConnection(con));
            String consulta = "";
            if (enteAsignado.equals("interno")) {
                consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_TRABAJOS " +
                        " SET " +
                        " COD_TIPO_TRABAJO = '" + modificarItemTrabajo.getCodTipoTrabajo() + "', " +
                        " DESCRIPCION = '" + modificarItemTrabajo.getDescripcion() + "'," +
                        " HORAS_TRABAJO = '" + modificarItemTrabajo.getHorasTrabajo() + "', " +
                        " COD_PERSONAL = '" + modificarItemTrabajo.getCodPersonal() + "', " +
                        " FECHA_INICIO = '" + modificarItemTrabajo.getFechaInicio() + "', " +
                        " FECHA_FIN = '" + modificarItemTrabajo.getFechaFin() + "', " +
                        " COD_PROVEEDOR = 0  " +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + modificarItemTrabajo.getCodSolicitudMantenimiento() + "'" +
                        " AND COD_TIPO_TRABAJO= '" + codTipoTrabajo + "' " +
                        " AND COD_PERSONAL= '" + codPersonal + "'" +
                        " AND COD_PROVEEDOR = '" + codProveedor + "'";

            } else {
                consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_TRABAJOS " +
                        " SET " +
                        " COD_TIPO_TRABAJO = '" + modificarItemTrabajo.getCodTipoTrabajo() + "', " +
                        " DESCRIPCION = '" + modificarItemTrabajo.getDescripcion() + "'," +
                        " HORAS_TRABAJO = '" + modificarItemTrabajo.getHorasTrabajo() + "', " +
                        " COD_PERSONAL = 0, " +
                        " FECHA_INICIO = '" + modificarItemTrabajo.getFechaInicio() + "', " +
                        " FECHA_FIN = '" + modificarItemTrabajo.getFechaFin() + "', " +
                        " COD_PROVEEDOR = '" + modificarItemTrabajo.getCodProveedor() + "' " +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + modificarItemTrabajo.getCodSolicitudMantenimiento() + "'" +
                        " AND COD_TIPO_TRABAJO= '" + codTipoTrabajo + "' " +
                        " AND COD_PERSONAL= '" + codPersonal + "'" +
                        " AND COD_PROVEEDOR = '" + codProveedor + "'";

            }
            System.out.println(consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.init();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_trabajos_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String cancelar_action() {
        try {
            this.init();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_trabajos_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
        }
        return null;
    }


    public String borrar_action() {
        try {
            borrarItemTrabajo = (TrabajosSolicitudMantenimiento) trabajosDataTable.getRowData();
            /*
            trabajosDataTable
             */
            con = (Util.openConnection(con));
            String consulta = "";
            System.out.println("antes de borrar el cod personal" + borrarItemTrabajo.getCodPersonal() + borrarItemTrabajo.getCodProveedor());

            if (borrarItemTrabajo.getCodPersonal().equals("0") && !borrarItemTrabajo.getCodProveedor().equals("0")) {
                consulta = "  DELETE " +
                        " FROM SOLICITUDES_MANTENIMIENTO_TRABAJOS " +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + borrarItemTrabajo.getCodSolicitudMantenimiento() + "' " +
                        " AND COD_PERSONAL = '0' " +
                        " AND COD_PROVEEDOR = '" + borrarItemTrabajo.getCodProveedor() + "' " +
                        " AND COD_TIPO_TRABAJO = '" + borrarItemTrabajo.getCodTipoTrabajo() + "' ";
            }
            if (!borrarItemTrabajo.getCodPersonal().equals("0") && borrarItemTrabajo.getCodProveedor().equals("0")) {
                consulta = "  DELETE " +
                        " FROM SOLICITUDES_MANTENIMIENTO_TRABAJOS " +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + borrarItemTrabajo.getCodSolicitudMantenimiento() + "' " +
                        " AND COD_PERSONAL= '" + borrarItemTrabajo.getCodPersonal() + "'" +
                        " AND COD_PROVEEDOR = '0'  " +
                        " AND COD_TIPO_TRABAJO = '" + borrarItemTrabajo.getCodTipoTrabajo() + "' ";
            }


            System.out.println(consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.init();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_trabajos_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void asignado_change(ValueChangeEvent evt) {
        try {
            if (evt.getNewValue().equals("interno")) {
                modificarItemTrabajo.setConPersonal("true");
                modificarItemTrabajo.setConProveedor("false");
            } else {
                modificarItemTrabajo.setConPersonal("false");
                modificarItemTrabajo.setConProveedor("true");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getInitializeTrabajosTiemposReales() {
        this.initTrabajosTiemposReales();
        return null;
    }

    void initTrabajosTiemposReales() {
        try {

            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("nroSolicitud") != null) {
                codSolicitudMantenimiento = Integer.parseInt(request.getParameter("nroSolicitud"));
            }

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " select SMT.COD_SOLICITUD_MANTENIMIENTO, TT.COD_TIPO_TRABAJO ,TT.NOMBRE_TIPO_TRABAJO,P.COD_PERSONAL,(P.NOMBRES_PERSONAL +' '+ P.AP_MATERNO_PERSONAL +' '+ P.AP_MATERNO_PERSONAL) AS NOMBRE_COMPLETO_PERSONAL,SMT.DESCRIPCION, " +
                    " SMT.FECHA_INICIO,SMT.FECHA_FIN,SMT.HORAS_TRABAJO,PR.COD_PROVEEDOR, PR.NOMBRE_PROVEEDOR," +
                    " SMT.FECHA_INICIO_REAL, SMT.FECHA_FIN_REAL, SMT.HORAS_TRABAJO_REAL   " +
                    " FROM SOLICITUDES_MANTENIMIENTO_TRABAJOS SMT " +
                    " INNER JOIN TIPOS_TRABAJO TT ON SMT.COD_TIPO_TRABAJO=TT.COD_TIPO_TRABAJO  " +
                    " LEFT JOIN PERSONAL P ON P.COD_PERSONAL= SMT.COD_PERSONAL " +
                    " LEFT JOIN PROVEEDORES PR ON PR.COD_PROVEEDOR=SMT.COD_PROVEEDOR " +
                    " WHERE SMT.COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "' ";

            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            trabajosSolMantList.clear();
            for (int i = 0; i < filas; i++) {
                itemTrabajos = new TrabajosSolicitudMantenimiento();
                itemTrabajos.setCodSolicitudMantenimiento(rs.getString("COD_SOLICITUD_MANTENIMIENTO"));
                itemTrabajos.setCodTipoTrabajo(rs.getString("COD_TIPO_TRABAJO"));
                itemTrabajos.setNombreTipoTrabajo(rs.getString("NOMBRE_TIPO_TRABAJO"));
                itemTrabajos.setCodPersonal(rs.getString("COD_PERSONAL") == null ? "0" : rs.getString("COD_PERSONAL"));
                itemTrabajos.setNombrePersonal(rs.getString("NOMBRE_COMPLETO_PERSONAL"));
                itemTrabajos.setDescripcion(rs.getString("DESCRIPCION"));
                itemTrabajos.setFechaInicio(rs.getString("FECHA_INICIO"));
                itemTrabajos.setFechaFin(rs.getString("FECHA_FIN"));
                itemTrabajos.setHorasTrabajo(rs.getString("HORAS_TRABAJO"));
                itemTrabajos.setCodProveedor(rs.getString("COD_PROVEEDOR") == null ? "0" : rs.getString("COD_PROVEEDOR"));
                itemTrabajos.setNombreProovedor(rs.getString("NOMBRE_PROVEEDOR"));
                itemTrabajos.setConPersonal(rs.getString("COD_PERSONAL") == null ? "false" : "true");
                itemTrabajos.setConProveedor(rs.getString("COD_PROVEEDOR") == null ? "false" : "true");
                itemTrabajos.setFechaInicioReal(rs.getString("FECHA_INICIO_REAL"));
                itemTrabajos.setFechaFinReal(rs.getString("FECHA_FIN_REAL"));
                itemTrabajos.setHorasTrabajoReal(rs.getString("HORAS_TRABAJO_REAL"));

                trabajosSolMantList.add(itemTrabajos);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String asignarTiempoReal_action() {
        try {

            String DATE_FORMAT_NOW = "yyyy/MM/dd";
            Calendar cal = Calendar.getInstance();
            SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT_NOW);
            fechaInicio = cal.getTime();
            fechaFin = cal.getTime();

            

            asignarTiempoRealItemTrabajo = new TrabajosSolicitudMantenimiento();
            asignarTiempoRealItemTrabajo = (TrabajosSolicitudMantenimiento) trabajosDataTable.getRowData();


            codTipoTrabajo = Integer.parseInt(asignarTiempoRealItemTrabajo.getCodTipoTrabajo());
            codPersonal = Integer.parseInt(asignarTiempoRealItemTrabajo.getCodPersonal() == null ? "0" : asignarTiempoRealItemTrabajo.getCodPersonal());
            codProveedor = Integer.parseInt(asignarTiempoRealItemTrabajo.getCodProveedor() == null ? "0" : asignarTiempoRealItemTrabajo.getCodProveedor());
            fechaInicio = dateFormat.parse(!(asignarTiempoRealItemTrabajo.getFechaInicioReal()==null)?asignarTiempoRealItemTrabajo.getFechaInicioReal().replace("-", "/"):asignarTiempoRealItemTrabajo.getFechaInicio().replace("-", "/"));
            fechaFin = dateFormat.parse(!(asignarTiempoRealItemTrabajo.getFechaFinReal()==null)?asignarTiempoRealItemTrabajo.getFechaFinReal().replace("-", "/"):asignarTiempoRealItemTrabajo.getFechaFin().replace("-", "/"));
            asignarTiempoRealItemTrabajo.setHorasTrabajoReal(!(asignarTiempoRealItemTrabajo.getHorasTrabajoReal()==null)?asignarTiempoRealItemTrabajo.getHorasTrabajoReal():asignarTiempoRealItemTrabajo.getHorasTrabajo());
            
            
            
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("asignar_tiempo_real_trabajo_solicitud_mantenimiento.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String guardarAsignacionTiempoRealTrabajo_action() {
        try {

            Format formatter = new SimpleDateFormat("yyyy/MM/dd");
            //preparar el objeto
            asignarTiempoRealItemTrabajo.setFechaInicioReal(formatter.format(fechaInicio));
            asignarTiempoRealItemTrabajo.setFechaFinReal(formatter.format(fechaFin));


            con = (Util.openConnection(con));
            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_TRABAJOS " +
                    " SET " +
                    " HORAS_TRABAJO_REAL = '" + asignarTiempoRealItemTrabajo.getHorasTrabajoReal() + "', " +
                    " FECHA_INICIO_REAL = '" + asignarTiempoRealItemTrabajo.getFechaInicioReal() + "', " +
                    " FECHA_FIN_REAL = '" + asignarTiempoRealItemTrabajo.getFechaFinReal() + "' " +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + asignarTiempoRealItemTrabajo.getCodSolicitudMantenimiento() + "'" +
                    " AND COD_TIPO_TRABAJO= '" + codTipoTrabajo + "' " +
                    " AND COD_PERSONAL= '" + codPersonal + "'" +
                    " AND COD_PROVEEDOR = '" + codProveedor + "'";
                    
            System.out.println(consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.init();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_tiempo_real_trabajos_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String cancelarAsignacionTiempoReal_action() {
        try {
            this.init();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_tiempo_real_trabajos_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
        }
        return null;
    }
    public String aceptarAsignacionTiempoRealTrabajos_action() {
        try {
            //cambiar de estado a la solicitud de mantenimiento
            try {
                //7: CERRAR SOLICITUD DE MANTENIMIENTO
                String consulta = "UPDATE SOLICITUDES_MANTENIMIENTO SET COD_ESTADO_SOLICITUD_MANTENIMIENTO = '7'" +
                        ", FECHA_CAMBIO_ESTADOSOLICITUD = GETDATE()  " +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";

                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                st.executeUpdate(consulta);

                st.close();
            } catch (Exception e) {
                e.printStackTrace();
            }



            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
