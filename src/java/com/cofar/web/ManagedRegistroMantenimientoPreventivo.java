/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

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
import java.util.ListIterator;
import javax.annotation.PostConstruct;
import javax.faces.component.UIComponent;
import javax.faces.component.html.HtmlCommandLink;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author sistemas1
 */
public class ManagedRegistroMantenimientoPreventivo {

    /** Creates a new instance of ManagedRegistroMantenimientoPreventivo */
    public class MantenimientoPreventivo {

        private String codSolicitudMantenimientoPreventivo = "";
        private String fechaMantenimiento = "";
        private String tiempoEstimado = "";
        private String codMaquina = "";
        private String nombreMaquina = "";
        private String descripcion = "";
        private String codtipoMantenimientoPreventivo;
        private String nombretipoMantenimientoPreventivo;
        private String codEstadoSolicitudMantenimientoPreventivo;
        private String nombreEstadoSolicitudMantenimientoPreventivo;

        public String getCodMaquina() {
            return codMaquina;
        }

        public void setCodMaquina(String codMaquina) {
            this.codMaquina = codMaquina;
        }

        public String getCodSolicitudMantenimientoPreventivo() {
            return codSolicitudMantenimientoPreventivo;
        }

        public void setCodSolicitudMantenimientoPreventivo(String codSolicitudMantenimientoPreventivo) {
            this.codSolicitudMantenimientoPreventivo = codSolicitudMantenimientoPreventivo;
        }

        public String getFechaMantenimiento() {
            return fechaMantenimiento;
        }

        public void setFechaMantenimiento(String fechaMantenimiento) {
            this.fechaMantenimiento = fechaMantenimiento;
        }

        public String getTiempoEstimado() {
            return tiempoEstimado;
        }

        public void setTiempoEstimado(String tiempoEstimado) {
            this.tiempoEstimado = tiempoEstimado;
        }

        public String getNombreMaquina() {
            return nombreMaquina;
        }

        public void setNombreMaquina(String nombreMaquina) {
            this.nombreMaquina = nombreMaquina;
        }

        public String getDescripcion() {
            return descripcion;
        }

        public void setDescripcion(String descripcion) {
            this.descripcion = descripcion;
        }

        public String getCodtipoMantenimientoPreventivo() {
            return codtipoMantenimientoPreventivo;
        }

        public void setCodtipoMantenimientoPreventivo(String codtipoMantenimientoPreventivo) {
            this.codtipoMantenimientoPreventivo = codtipoMantenimientoPreventivo;
        }

        public String getNombretipoMantenimientoPreventivo() {
            return nombretipoMantenimientoPreventivo;
        }

        public void setNombretipoMantenimientoPreventivo(String nombretipoMantenimientoPreventivo) {
            this.nombretipoMantenimientoPreventivo = nombretipoMantenimientoPreventivo;
        }

        public String getCodEstadoSolicitudMantenimientoPreventivo() {
            return codEstadoSolicitudMantenimientoPreventivo;
        }

        public void setCodEstadoSolicitudMantenimientoPreventivo(String codEstadoSolicitudMantenimientoPreventivo) {
            this.codEstadoSolicitudMantenimientoPreventivo = codEstadoSolicitudMantenimientoPreventivo;
        }

        public String getNombreEstadoSolicitudMantenimientoPreventivo() {
            return nombreEstadoSolicitudMantenimientoPreventivo;
        }

        public void setNombreEstadoSolicitudMantenimientoPreventivo(String nombreEstadoSolicitudMantenimientoPreventivo) {
            this.nombreEstadoSolicitudMantenimientoPreventivo = nombreEstadoSolicitudMantenimientoPreventivo;
        }
    }

    public class calendarioMantenimiento {

        private String maquina = "";
        private String enero = "";
        private String febrero = "";
        private String marzo = "";
        private String abril = "";
        private String mayo = "";
        private String junio = "";
        private String julio = "";
        private String agosto = "";
        private String septiembre = "";
        private String octubre = "";
        private String noviembre = "";
        private String diciembre = "";

        public String getAbril() {
            return abril;
        }

        public void setAbril(String abril) {
            this.abril = abril;
        }

        public String getAgosto() {
            return agosto;
        }

        public void setAgosto(String agosto) {
            this.agosto = agosto;
        }

        public String getDiciembre() {
            return diciembre;
        }

        public void setDiciembre(String diciembre) {
            this.diciembre = diciembre;
        }

        public String getEnero() {
            return enero;
        }

        public void setEnero(String enero) {
            this.enero = enero;
        }

        public String getFebrero() {
            return febrero;
        }

        public void setFebrero(String febrero) {
            this.febrero = febrero;
        }

        public String getJulio() {
            return julio;
        }

        public void setJulio(String julio) {
            this.julio = julio;
        }

        public String getJunio() {
            return junio;
        }

        public void setJunio(String junio) {
            this.junio = junio;
        }

        public String getMarzo() {
            return marzo;
        }

        public void setMarzo(String marzo) {
            this.marzo = marzo;
        }

        public String getMayo() {
            return mayo;
        }

        public void setMayo(String mayo) {
            this.mayo = mayo;
        }

        public String getNoviembre() {
            return noviembre;
        }

        public void setNoviembre(String noviembre) {
            this.noviembre = noviembre;
        }

        public String getOctubre() {
            return octubre;
        }

        public void setOctubre(String octubre) {
            this.octubre = octubre;
        }

        public String getSeptiembre() {
            return septiembre;
        }

        public void setSeptiembre(String septiembre) {
            this.septiembre = septiembre;
        }

        public String getMaquina() {
            return maquina;
        }

        public void setMaquina(String maquina) {
            this.maquina = maquina;
        }
    }
    private Connection con;
    private List mantenimientoPreventivoList = new ArrayList();
    private List maquinaList = new ArrayList();
    private List tipoMantenimientoPreventivoList = new ArrayList();
    private MantenimientoPreventivo itemMantenimientoPreventivo;
    private HtmlDataTable mantenimientoPreventivoDataTable;
    private MantenimientoPreventivo adicionarMantenimientoPreventivo;
    private MantenimientoPreventivo borrarMantenimientoPreventivo;
    private Date fechaMantenimiento;
    private List<calendarioMantenimiento> calendarioManteniminientoList = new ArrayList<calendarioMantenimiento>();
    private String anoMantenimiento;
    private MantenimientoPreventivo modificarMantenimientoPreventivo;
    private int codMaquinaRef = 0;
    private int codTipoMantenimientoPreventivoRef = 0;
    private String fechaMantenimientoRef;
    private int codSolicitudMantenimientoPreventivo = 0;

    public ManagedRegistroMantenimientoPreventivo() {
    }

    public List getMantenimientoPreventivoList() {
        return mantenimientoPreventivoList;
    }

    public void setMantenimientoPreventivoList(List mantenimientoPreventivoList) {
        this.mantenimientoPreventivoList = mantenimientoPreventivoList;
    }

    public HtmlDataTable getMantenimientoPreventivoDataTable() {
        return mantenimientoPreventivoDataTable;
    }

    public void setMantenimientoPreventivoDataTable(HtmlDataTable mantenimientoPreventivoDataTable) {
        this.mantenimientoPreventivoDataTable = mantenimientoPreventivoDataTable;
    }

    public MantenimientoPreventivo getAdicionarMantenimientoPreventivo() {
        return adicionarMantenimientoPreventivo;
    }

    public void setAdicionarMantenimientoPreventivo(MantenimientoPreventivo adicionarMantenimientoPreventivo) {
        this.adicionarMantenimientoPreventivo = adicionarMantenimientoPreventivo;
    }

    public List getMaquinaList() {
        return maquinaList;
    }

    public void setMaquinaList(List maquinaList) {
        this.maquinaList = maquinaList;
    }

    public Date getFechaMantenimiento() {
        return fechaMantenimiento;
    }

    public void setFechaMantenimiento(Date fechaMantenimiento) {
        this.fechaMantenimiento = fechaMantenimiento;
    }

    public List<calendarioMantenimiento> getCalendarioManteniminientoList() {
        return calendarioManteniminientoList;
    }

    public void setCalendarioManteniminientoList(List<calendarioMantenimiento> calendarioManteniminientoList) {
        this.calendarioManteniminientoList = calendarioManteniminientoList;
    }

    public String getAnoMantenimiento() {
        return anoMantenimiento;
    }

    public void setAnoMantenimiento(String anoMantenimiento) {
        this.anoMantenimiento = anoMantenimiento;
    }

    public List getTipoMantenimientoPreventivoList() {
        return tipoMantenimientoPreventivoList;
    }

    public void setTipoMantenimientoPreventivoList(List tipoMantenimientoPreventivoList) {
        this.tipoMantenimientoPreventivoList = tipoMantenimientoPreventivoList;
    }

    public MantenimientoPreventivo getModificarMantenimientoPreventivo() {
        return modificarMantenimientoPreventivo;
    }

    public void setModificarMantenimientoPreventivo(MantenimientoPreventivo modificarMantenimientoPreventivo) {
        this.modificarMantenimientoPreventivo = modificarMantenimientoPreventivo;
    }

    @PostConstruct
    void init() {
    }

    public String getInitListadoMantenimientoPreventivo() {
        try {
            this.initListadoMantenimientoPreventivo();
            this.listadoCalendarioMantenimiento();
            this.resumeCalendarioMantenimiento();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void ano_changeEvent(ValueChangeEvent evt) {
        try {
            anoMantenimiento = evt.getNewValue().toString();
            this.listadoCalendarioMantenimiento();
            this.resumeCalendarioMantenimiento();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void cargaCalendarioMantenimiento(ResultSet rs) {
        try {
            calendarioMantenimiento itemCalendarioMantenimiento = new calendarioMantenimiento();
            //obtenemos el mes
            String mesArray[] = rs.getString("FECHA_MANTENIMIENTO").split("-");
            String mes = mesArray[1];
            System.out.println("el mes" + mes);
            itemCalendarioMantenimiento.setMaquina(rs.getString("NOMBRE_MAQUINA"));

            switch (Integer.parseInt(mes)) {

                case 1:
                    itemCalendarioMantenimiento.setEnero("X");
                    break;
                case 2:
                    itemCalendarioMantenimiento.setFebrero("X");
                    break;
                case 3:
                    itemCalendarioMantenimiento.setMarzo("X");
                    break;
                case 4:
                    itemCalendarioMantenimiento.setAbril("X");
                    break;
                case 5:
                    itemCalendarioMantenimiento.setMayo("X");
                    break;
                case 6:
                    itemCalendarioMantenimiento.setJunio("X");
                    break;
                case 7:
                    itemCalendarioMantenimiento.setJulio("X");
                    break;
                case 8:
                    itemCalendarioMantenimiento.setAgosto("X");
                    break;
                case 9:
                    itemCalendarioMantenimiento.setSeptiembre("X");
                    break;
                case 10:
                    itemCalendarioMantenimiento.setOctubre("X");
                    break;
                case 11:
                    itemCalendarioMantenimiento.setNoviembre("X");
                    break;
                case 12:
                    itemCalendarioMantenimiento.setDiciembre("X");
                    break;
            }
            calendarioManteniminientoList.add(itemCalendarioMantenimiento);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void listadoCalendarioMantenimiento() {
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT SMP.COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO, SMP.COD_MAQUINA,M.NOMBRE_MAQUINA,SMP.FECHA_MANTENIMIENTO,SMP.TIEMPO_ESTIMADO, " +
                    " SMP.DESCRIPCION " +
                    " FROM SOLICITUDES_MANTENIMIENTO_PREVENTIVO SMP " +
                    " INNER JOIN MAQUINARIAS M ON SMP.COD_MAQUINA = M.COD_MAQUINA " +
                    " WHERE YEAR(SMP.FECHA_MANTENIMIENTO)='" + anoMantenimiento + "'";

            // SMP.COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'" + " AND

            System.out.println("la consulta para calendario:" + consulta);
            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            calendarioManteniminientoList.clear();

            for (int i = 0; i < filas; i++) {
                this.cargaCalendarioMantenimiento(rs);
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

    public void resumeCalendarioMantenimiento() {
        try {
            ListIterator listIterator = calendarioManteniminientoList.listIterator();

            for (int i = 0; i < calendarioManteniminientoList.size(); i++) {
                calendarioMantenimiento itemCalendarioi = calendarioManteniminientoList.get(i);
                int j = i + 1;
                while (j < calendarioManteniminientoList.size()) {
                    calendarioMantenimiento itemCalendarioj = calendarioManteniminientoList.get(j);
                    if (itemCalendarioi.getMaquina().equals(itemCalendarioj.getMaquina())) {
                        System.out.println("items comparados: " + itemCalendarioi.getMaquina() + " " + itemCalendarioj.getMaquina());

                        itemCalendarioi.setEnero(!itemCalendarioj.getEnero().equals("") ? itemCalendarioj.getEnero() : itemCalendarioi.getEnero());
                        itemCalendarioi.setFebrero(!itemCalendarioj.getFebrero().equals("") ? itemCalendarioj.getFebrero() : itemCalendarioi.getFebrero());
                        itemCalendarioi.setMarzo(!itemCalendarioj.getMarzo().equals("") ? itemCalendarioj.getMarzo() : itemCalendarioi.getMarzo());
                        itemCalendarioi.setAbril(!itemCalendarioj.getAbril().equals("") ? itemCalendarioj.getAbril() : itemCalendarioi.getAbril());
                        itemCalendarioi.setMayo(!itemCalendarioj.getMayo().equals("") ? itemCalendarioj.getMayo() : itemCalendarioi.getMayo());
                        itemCalendarioi.setJunio(!itemCalendarioj.getJunio().equals("") ? itemCalendarioj.getJunio() : itemCalendarioi.getJunio());
                        itemCalendarioi.setJulio(!itemCalendarioj.getJulio().equals("") ? itemCalendarioj.getJulio() : itemCalendarioi.getJulio());
                        itemCalendarioi.setAgosto(!itemCalendarioj.getAgosto().equals("") ? itemCalendarioj.getAgosto() : itemCalendarioi.getAgosto());
                        itemCalendarioi.setSeptiembre(!itemCalendarioj.getSeptiembre().equals("") ? itemCalendarioj.getSeptiembre() : itemCalendarioi.getSeptiembre());
                        itemCalendarioi.setOctubre(!itemCalendarioj.getOctubre().equals("") ? itemCalendarioj.getOctubre() : itemCalendarioi.getOctubre());
                        itemCalendarioi.setNoviembre(!itemCalendarioj.getNoviembre().equals("") ? itemCalendarioj.getNoviembre() : itemCalendarioi.getNoviembre());
                        itemCalendarioi.setDiciembre(!itemCalendarioj.getDiciembre().equals("") ? itemCalendarioj.getDiciembre() : itemCalendarioi.getDiciembre());
                        calendarioManteniminientoList.remove(j);
                        j = i + 1;
                    } else {
                        j++;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void initListadoMantenimientoPreventivo() {
        try {

//            codSolicitudMantenimiento = 35;

            anoMantenimiento = "2010";
//
//            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
//            if (request.getParameter("nroSolicitud") != null) {
//                codSolicitudMantenimiento = Integer.parseInt(request.getParameter("nroSolicitud"));
//            }



            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT SMP.COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO,SMP.COD_MAQUINA,M.NOMBRE_MAQUINA,SMP.FECHA_MANTENIMIENTO,SMP.TIEMPO_ESTIMADO, " +
                    " SMP.DESCRIPCION,TSMP.PERIODO_MANTENIMIENTO_PREVENTIVO ,SMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO " +
                    " FROM SOLICITUDES_MANTENIMIENTO_PREVENTIVO SMP " +
                    " INNER JOIN MAQUINARIAS M ON SMP.COD_MAQUINA = M.COD_MAQUINA " +
                    " INNER JOIN TIPOS_MANTENIMIENTO_PREVENTIVO TSMP ON SMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO=TSMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO ";

            // WHERE SMP.COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'
            System.out.println(" entro en el init initListadoMantenimientoPreventivo  " + consulta);
            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            mantenimientoPreventivoList.clear();


            for (int i = 0; i < filas; i++) {

                itemMantenimientoPreventivo = new MantenimientoPreventivo();
                itemMantenimientoPreventivo.setCodSolicitudMantenimientoPreventivo(rs.getString("COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO"));
                itemMantenimientoPreventivo.setCodMaquina(rs.getString("COD_MAQUINA"));
                itemMantenimientoPreventivo.setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                itemMantenimientoPreventivo.setFechaMantenimiento(rs.getString("FECHA_MANTENIMIENTO"));
                itemMantenimientoPreventivo.setTiempoEstimado(rs.getString("TIEMPO_ESTIMADO"));
                itemMantenimientoPreventivo.setDescripcion(rs.getString("DESCRIPCION"));
                itemMantenimientoPreventivo.setCodtipoMantenimientoPreventivo(rs.getString("COD_TIPO_MANTENIMIENTO_PREVENTIVO"));
                itemMantenimientoPreventivo.setNombretipoMantenimientoPreventivo(rs.getString("PERIODO_MANTENIMIENTO_PREVENTIVO"));
                mantenimientoPreventivoList.add(itemMantenimientoPreventivo);
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
            SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT_NOW);
            fechaMantenimiento = cal.getTime();


            modificarMantenimientoPreventivo = new MantenimientoPreventivo();
            modificarMantenimientoPreventivo = (MantenimientoPreventivo) mantenimientoPreventivoDataTable.getRowData();

            this.cargarMaquinas();
            this.cargarTipoMantenimientoPreventivo();


            codMaquinaRef = Integer.parseInt(modificarMantenimientoPreventivo.getCodMaquina() == null ? "0" : modificarMantenimientoPreventivo.getCodMaquina());
            codTipoMantenimientoPreventivoRef = Integer.parseInt(modificarMantenimientoPreventivo.getCodtipoMantenimientoPreventivo() == null ? "0" : modificarMantenimientoPreventivo.getCodtipoMantenimientoPreventivo());
            fechaMantenimientoRef = modificarMantenimientoPreventivo.getFechaMantenimiento();
            fechaMantenimiento = dateFormat.parse(modificarMantenimientoPreventivo.getFechaMantenimiento().replace("-", "/"));
            codSolicitudMantenimientoPreventivo = Integer.parseInt(modificarMantenimientoPreventivo.getCodSolicitudMantenimientoPreventivo());


            this.redireccionar("modificar_mantenimiento_preventivo.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String borrar_action() {
        try {
            borrarMantenimientoPreventivo = (MantenimientoPreventivo) mantenimientoPreventivoDataTable.getRowData();
            /*
            trabajosDataTable
             */
            con = (Util.openConnection(con));
            String consulta = "";
            //System.out.println("antes de borrar el cod personal" + borrarItemTrabajo.getCodPersonal() + borrarItemTrabajo.getCodProveedor());


            consulta = " DELETE  FROM SOLICITUDES_MANTENIMIENTO_PREVENTIVO WHERE " +
                    " COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO='" + borrarMantenimientoPreventivo.getCodSolicitudMantenimientoPreventivo() + "' AND " +
                    " FECHA_MANTENIMIENTO='" + borrarMantenimientoPreventivo.getFechaMantenimiento() + "' AND " +
                    " TIEMPO_ESTIMADO='" + borrarMantenimientoPreventivo.getTiempoEstimado() + "' AND " +
                    " COD_MAQUINA='" + borrarMantenimientoPreventivo.getCodMaquina() + "' AND " +
                    " DESCRIPCION='" + borrarMantenimientoPreventivo.getDescripcion() + "' AND " +
                    " COD_TIPO_MANTENIMIENTO_PREVENTIVO='" + borrarMantenimientoPreventivo.getCodtipoMantenimientoPreventivo() + "' ";

            System.out.println(consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);
            this.init();
            this.redireccionar("listado_mantenimiento_preventivo.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarMaquinas() {
        try {
            con = (Util.openConnection(con));
            String consulta = " SELECT MAQ.COD_MAQUINA, MAQ.NOMBRE_MAQUINA FROM MAQUINARIAS MAQ " +
                    " ORDER BY MAQ.NOMBRE_MAQUINA ASC";

            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            maquinaList.clear();
            rs = st.executeQuery(consulta);
            while (rs.next()) {
                maquinaList.add(new SelectItem(rs.getString("COD_MAQUINA"), rs.getString("NOMBRE_MAQUINA")));
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

    public void cargarTipoMantenimientoPreventivo() {
        try {
            con = (Util.openConnection(con));
            String consulta = " SELECT TMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO,TMP.PERIODO_MANTENIMIENTO_PREVENTIVO " +
                    " FROM TIPOS_MANTENIMIENTO_PREVENTIVO TMP ";

            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            tipoMantenimientoPreventivoList.clear();
            rs = st.executeQuery(consulta);
            while (rs.next()) {
                tipoMantenimientoPreventivoList.add(new SelectItem(rs.getString("COD_TIPO_MANTENIMIENTO_PREVENTIVO"), rs.getString("PERIODO_MANTENIMIENTO_PREVENTIVO")));
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

    public String guardarMantenimientoPreventivo_action() {
        try {
            this.guardarMantenimientosPreventivo();
            this.initListadoMantenimientoPreventivo();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String cancelar_action() {
        try {
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String cancelarGuardarModificacionMantenimientoPreventivo_action() {
        try {
            this.redireccionar("listado_mantenimiento_preventivo.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String adicionarMantenimientoPreventivo_action() {
        try {
            String DATE_FORMAT_NOW = "yyyy/MM/dd";
            Calendar cal = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);

            fechaMantenimiento = cal.getTime();
            fechaMantenimiento.setDate(1);
            adicionarMantenimientoPreventivo = new MantenimientoPreventivo();


            this.cargarMaquinas();
            this.cargarTipoMantenimientoPreventivo();
            this.redireccionar("agregar_mantenimiento_preventivo.jsf");



        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String formatoFecha() {
        try {
            System.out.println("entro en formato de fecha" + fechaMantenimiento);
            fechaMantenimiento.setDate(1);
            System.out.println("entro en formato de fecha" + fechaMantenimiento);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public void guardarMantenimientosPreventivo() {
        try {

            Format formatter = new SimpleDateFormat("yyyy/MM/01");

            adicionarMantenimientoPreventivo.setFechaMantenimiento(formatter.format(fechaMantenimiento));

            con = (Util.openConnection(con));

            String consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO_PREVENTIVO( " +
                    " COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO,   FECHA_MANTENIMIENTO,   TIEMPO_ESTIMADO,   COD_MAQUINA,   DESCRIPCION, COD_TIPO_MANTENIMIENTO_PREVENTIVO) " +
                    " VALUES((SELECT MAX(COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO)+1 FROM SOLICITUDES_MANTENIMIENTO_PREVENTIVO)" +
                    ",'" + adicionarMantenimientoPreventivo.getFechaMantenimiento() + "'" +
                    ",'" + adicionarMantenimientoPreventivo.getTiempoEstimado() + "'" +
                    ",'" + adicionarMantenimientoPreventivo.getCodMaquina() + "'" +
                    ",'" + adicionarMantenimientoPreventivo.getDescripcion() + "'" +
                    ",'" + adicionarMantenimientoPreventivo.getCodtipoMantenimientoPreventivo() + "' ) ";

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
            ext.redirect("listado_mantenimiento_preventivo.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
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

    public String cancelarGuardarMantenimientoPreventivo_action() {
        this.redireccionar("listado_mantenimiento_preventivo.jsf");
        return null;
    }

    public String guardarModificacionMantenimientoPreventivo_action() {
        try {


            Format dateFormat = new SimpleDateFormat("yyyy/MM/dd");


            modificarMantenimientoPreventivo.setFechaMantenimiento(dateFormat.format(fechaMantenimiento));


            con = (Util.openConnection(con));
            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_PREVENTIVO " +
                    "  SET FECHA_MANTENIMIENTO = '" + modificarMantenimientoPreventivo.getFechaMantenimiento() + "', " +
                    "  TIEMPO_ESTIMADO = '" + modificarMantenimientoPreventivo.getTiempoEstimado() + "', " +
                    "  COD_MAQUINA = '" + modificarMantenimientoPreventivo.getCodMaquina() + "', " +
                    "  DESCRIPCION = '" + modificarMantenimientoPreventivo.getDescripcion() + "', " +
                    "  COD_TIPO_MANTENIMIENTO_PREVENTIVO = '" + modificarMantenimientoPreventivo.getCodtipoMantenimientoPreventivo() + "'" +
                    "  WHERE COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO = '" + codSolicitudMantenimientoPreventivo + "'" +
                    "  AND COD_MAQUINA='" + codMaquinaRef + "' " +
                    "  AND FECHA_MANTENIMIENTO='" + fechaMantenimientoRef + "' " +
                    "  AND COD_TIPO_MANTENIMIENTO_PREVENTIVO='" + codTipoMantenimientoPreventivoRef + "' ";


            System.out.println(" update mantenimiento preventivo" + consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.init();

            try {
                this.redireccionar("listado_mantenimiento_preventivo.jsf");
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    /*PARA ASIGNACION DE MANTENIMIENTO PREVENTIVO*/

    //para generacion de solicitud de mantenimiento
    public String getInitListadoMantenimientoPreventivoGeneraSolicitud() {
        try {
            this.initListadoMantenimientoPreventivoGeneraSolicitud();
            this.listadoCalendarioMantenimiento();
            this.resumeCalendarioMantenimiento();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void registraSolicitudMantenimiento() {
        try {

            ManagedAccesoSistema managedAccesoBean = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            String codUsuario = managedAccesoBean.getUsuarioModuloBean().getCodUsuarioGlobal();

            //Format formatter = new SimpleDateFormat("yyyy/MM/01");

            //adicionarMantenimientoPreventivo.setFechaMantenimiento(formatter.format(fechaMantenimiento));

            con = (Util.openConnection(con));

            String consulta = "  ";


            consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO(   COD_SOLICITUD_MANTENIMIENTO,   COD_GESTION,   COD_TIPO_SOLICITUD_MANTENIMIENTO, " +
                    " COD_RESPONSABLE,   COD_ESTADO_SOLICITUD_MANTENIMIENTO,   ESTADO_SISTEMA,   COD_PERSONAL,   COD_AREA_EMPRESA,  " +
                    " FECHA_SOLICITUD_MANTENIMIENTO,   OBS_SOLICITUD_MANTENIMIENTO,   FECHA_CAMBIO_ESTADOSOLICITUD,   COD_MAQUINARIA,   COD_FORM_SALIDA, " +
                    "  COD_SOLICITUD_COMPRA,   AFECTARA_PRODUCCION) " +
                    " VALUES((SELECT MAX(SM.COD_SOLICITUD_MANTENIMIENTO)+1 FROM SOLICITUDES_MANTENIMIENTO SM)," +
                    " (SELECT ISNULL(G.COD_GESTION,'0') FROM GESTIONES G WHERE G.GESTION_ESTADO=1) , " +
                    " '2'," +
                    " NULL, " +
                    " '1'," +
                    " '1', " +
                    " '" + codUsuario + "', " +
                    " (SELECT ISNULL(M.COD_AREA_EMPRESA,'0') FROM MAQUINARIAS M WHERE M.COD_MAQUINA='" + modificarMantenimientoPreventivo.getCodMaquina() + "')," +
                    " GETDATE()," +
                    " '" + modificarMantenimientoPreventivo.getDescripcion() + "', " +
                    "  NULL ," +
                    "  '" + modificarMantenimientoPreventivo.getCodMaquina() + "'," +
                    " 0, " +
                    " 0, NULL)";

            System.out.println("insercion de datos de solicitud de mantenimiento " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void initListadoMantenimientoPreventivoGeneraSolicitud() {
        try {

//            codSolicitudMantenimiento = 35;

            anoMantenimiento = "2010";
//
//            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
//            if (request.getParameter("nroSolicitud") != null) {
//                codSolicitudMantenimiento = Integer.parseInt(request.getParameter("nroSolicitud"));
//            }



            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT SMP.COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO,SMP.COD_MAQUINA,M.NOMBRE_MAQUINA,SMP.FECHA_MANTENIMIENTO,SMP.TIEMPO_ESTIMADO, " +
                    " SMP.DESCRIPCION,TSMP.PERIODO_MANTENIMIENTO_PREVENTIVO ,SMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO, ESM.COD_ESTADO_SOLICITUD, ESM.NOMBRE_ESTADO_SOLICITUD  " +
                    " FROM SOLICITUDES_MANTENIMIENTO_PREVENTIVO SMP " +
                    " INNER JOIN MAQUINARIAS M ON SMP.COD_MAQUINA = M.COD_MAQUINA " +
                    " INNER JOIN TIPOS_MANTENIMIENTO_PREVENTIVO TSMP ON SMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO=TSMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO " +
                    " INNER JOIN ESTADOS_SOLICITUD_MANTENIMIENTO ESM ON SMP.COD_ESTADO_SOLICITUD = ESM.COD_ESTADO_SOLICITUD " +
                    " WHERE SMP.COD_ESTADO_SOLICITUD=1"; //EN ESTADO EMITIDO

            //mantenimientos preventivos en el rango de aqui a una semana

            consulta = " SELECT SMP.COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO,SMP.COD_MAQUINA,M.NOMBRE_MAQUINA,SMP.FECHA_MANTENIMIENTO,SMP.TIEMPO_ESTIMADO, " +
                    " SMP.DESCRIPCION,TSMP.PERIODO_MANTENIMIENTO_PREVENTIVO ,SMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO, ESM.COD_ESTADO_SOLICITUD, ESM.NOMBRE_ESTADO_SOLICITUD, " +
                    " DATEADD(DD,7, GETDATE()) AS FECHA  FROM SOLICITUDES_MANTENIMIENTO_PREVENTIVO SMP " +
                    " INNER JOIN MAQUINARIAS M ON SMP.COD_MAQUINA = M.COD_MAQUINA " +
                    " INNER JOIN TIPOS_MANTENIMIENTO_PREVENTIVO TSMP ON SMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO=TSMP.COD_TIPO_MANTENIMIENTO_PREVENTIVO  " +
                    " INNER JOIN ESTADOS_SOLICITUD_MANTENIMIENTO ESM ON SMP.COD_ESTADO_SOLICITUD = ESM.COD_ESTADO_SOLICITUD " +
                    " WHERE SMP.COD_ESTADO_SOLICITUD=1 AND SMP.FECHA_MANTENIMIENTO BETWEEN GETDATE() AND DATEADD(DD,7, GETDATE()) "; //EN ESTADO EMITIDO

            // WHERE SMP.COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'
            System.out.println(" entro en el init initListadoMantenimientoPreventivoAsignar  " + consulta);
            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            mantenimientoPreventivoList.clear();


            for (int i = 0; i < filas; i++) {

                itemMantenimientoPreventivo = new MantenimientoPreventivo();
                itemMantenimientoPreventivo.setCodSolicitudMantenimientoPreventivo(rs.getString("COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO"));
                itemMantenimientoPreventivo.setCodMaquina(rs.getString("COD_MAQUINA"));
                itemMantenimientoPreventivo.setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                itemMantenimientoPreventivo.setFechaMantenimiento(rs.getString("FECHA_MANTENIMIENTO"));
                itemMantenimientoPreventivo.setTiempoEstimado(rs.getString("TIEMPO_ESTIMADO"));
                itemMantenimientoPreventivo.setDescripcion(rs.getString("DESCRIPCION"));
                itemMantenimientoPreventivo.setCodtipoMantenimientoPreventivo(rs.getString("COD_TIPO_MANTENIMIENTO_PREVENTIVO"));
                itemMantenimientoPreventivo.setNombretipoMantenimientoPreventivo(rs.getString("PERIODO_MANTENIMIENTO_PREVENTIVO"));
                itemMantenimientoPreventivo.setCodEstadoSolicitudMantenimientoPreventivo(rs.getString("COD_ESTADO_SOLICITUD"));
                itemMantenimientoPreventivo.setNombreEstadoSolicitudMantenimientoPreventivo(rs.getString("NOMBRE_ESTADO_SOLICITUD"));

                mantenimientoPreventivoList.add(itemMantenimientoPreventivo);

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

    
    public void generarSolicitud_action(ActionEvent evt) {
        try {


//            UIComponent myCommand = evt.getComponent();
//            System.out.println("quien lo genera??" + myCommand.getClass());
//            HtmlCommandLink html=(HtmlCommandLink)evt.getComponent();
//            System.out.println("html 1:"+html.getTitle());
//            System.out.println("html 2:"+html.getActionListeners());
//            System.out.println("html 2:"+html.getOnclick());


//            System.out.println("html 5:"+evt.getSource().toString());
//            System.out.println("html 6:"+evt);


            modificarMantenimientoPreventivo = new MantenimientoPreventivo();
            modificarMantenimientoPreventivo = (MantenimientoPreventivo) mantenimientoPreventivoDataTable.getRowData();

            //Format dateFormat = new SimpleDateFormat("yyyy/MM/dd");
            //modificarMantenimientoPreventivo.setFechaMantenimiento(dateFormat.format(fechaMantenimiento));


            con = (Util.openConnection(con));
            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_PREVENTIVO " +
                    "  SET COD_ESTADO_SOLICITUD = '8' " + //se lleva a estado asignado
                    "  WHERE COD_SOLICITUD_MANTENIMIENTO_PREVENTIVO = '" + modificarMantenimientoPreventivo.getCodSolicitudMantenimientoPreventivo() + "'" +
                    "  AND COD_MAQUINA='" + modificarMantenimientoPreventivo.getCodMaquina() + "' " +
                    "  AND FECHA_MANTENIMIENTO='" + modificarMantenimientoPreventivo.getFechaMantenimiento() + "' " +
                    "  AND COD_TIPO_MANTENIMIENTO_PREVENTIVO='" + modificarMantenimientoPreventivo.getCodtipoMantenimientoPreventivo() + "' ";

            System.out.println(" update asignar mantenimiento preventivo" + consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.registraSolicitudMantenimiento();
            this.getInitListadoMantenimientoPreventivoGeneraSolicitud();


        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
