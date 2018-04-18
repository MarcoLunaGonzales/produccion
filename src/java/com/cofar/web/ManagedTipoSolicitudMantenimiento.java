/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.util.Util;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author sistemas1
 */
public class ManagedTipoSolicitudMantenimiento {

    private Connection con;
    private List tiposSolicitudMantenimientoList = new ArrayList();
    private String codTipoSolMantenimiento;
    private String afectaraProduccion;
    private String nroSolicitud;

    /** Creates a new instance of ManagedTipoSolicitudMantenimiento */
    public ManagedTipoSolicitudMantenimiento() {
    }

    public List getTiposSolicitudMantenimientoList() {
        return tiposSolicitudMantenimientoList;
    }

    public void setTiposSolicitudMantenimientoList(List tiposSolicitudMantenimientoList) {
        this.tiposSolicitudMantenimientoList = tiposSolicitudMantenimientoList;
    }

    public String getCodTipoSolMantenimiento() {
        return codTipoSolMantenimiento;
    }

    public void setCodTipoSolMantenimiento(String codTipoSolMantenimiento) {
        this.codTipoSolMantenimiento = codTipoSolMantenimiento;
    }

    public String getAfectaProduccion() {
        return afectaraProduccion;
    }

    public void setAfectaProduccion(String afectaProduccion) {
        this.afectaraProduccion = afectaProduccion;
    }

    //@PostConstruct
    public String getInit() {
        try {
            System.out.println("entro al init");
            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            nroSolicitud = request.getParameter("nroSolicitud");
            this.cargaTiposSolicitud();
            this.colocaTiposolicitudMantenimiento();
            this.afectaraProduccion="SI";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public void cargaTiposSolicitud() {
        try {

            con = (Util.openConnection(con));
            String sql = " select t.COD_TIPO_SOLICITUD,t.NOMBRE_TIPO_SOLICITUD  from TIPOS_SOLICITUD_MANTENIMIENTO t order by t.NOMBRE_TIPO_SOLICITUD";
            ResultSet rs = null;
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            tiposSolicitudMantenimientoList.clear();
            rs = st.executeQuery(sql);
            tiposSolicitudMantenimientoList.add(new SelectItem("0", "Seleccione una opción"));
            while (rs.next()) {
                tiposSolicitudMantenimientoList.add(new SelectItem(rs.getString(1), rs.getString(2)));
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

    public void colocaTiposolicitudMantenimiento() {
        try {
            con = (Util.openConnection(con));
            String sql = " SELECT COD_SOLICITUD_MANTENIMIENTO, " +
                    " COD_TIPO_SOLICITUD_MANTENIMIENTO FROM SOLICITUDES_MANTENIMIENTO" +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + nroSolicitud + "'";

            ResultSet rs = null;
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            rs = st.executeQuery(sql);
            if (rs.next()) {
                codTipoSolMantenimiento = rs.getString("COD_TIPO_SOLICITUD_MANTENIMIENTO");
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

    public String guardarSolicitudMantenimiento() {

        try {
            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO SET COD_TIPO_SOLICITUD_MANTENIMIENTO = '" + codTipoSolMantenimiento + "', " +
                    " COD_ESTADO_SOLICITUD_MANTENIMIENTO = 2, " + // CAMBIA A ESTADO REVISADO
                    " FECHA_CAMBIO_ESTADOSOLICITUD = GETDATE(),  " +
                    " AFECTARA_PRODUCCION = '" + afectaraProduccion + "'" +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO= " + nroSolicitud;
            PreparedStatement st = con.prepareStatement(consulta);
            con = Util.openConnection(con);
            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public String cancelar() {
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
