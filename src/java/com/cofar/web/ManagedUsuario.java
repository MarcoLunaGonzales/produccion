/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

/**
 *
 * @author sistemas1
 */
public class ManagedUsuario {

    private Connection con;
    private Personal personalModificar;
    private String mensajes;
    private int codUsuario;
    private int codModulo;

    public Personal getPersonalModificar() {
        return personalModificar;
    }

    public void setPersonalModificar(Personal personalModificar) {
        this.personalModificar = personalModificar;
    }

    /** Creates a new instance of ManagedUsuario */
    public ManagedUsuario() {
    }

    public String getMensajes() {
        return mensajes;
    }

    public void setMensajes(String mensajes) {
        this.mensajes = mensajes;
    }

    public class Personal {

        private String codPersonal = "";
        private String apPaternoPersonal = "";
        private String apMaternoPersonal = "";
        private String nombresPersonal = "";
        private String nombreUsuario = "";
        private String contrasenaUsuario = "";
        private String contrasenaUsuarioEscrito = "";
        private String nuevaContrasenaUsuario = "";
        private String reEscribirNuevaContrasenaUsuario = "";
        private String apellidosNombres = "";

        public String getApMaternoPersonal() {
            return apMaternoPersonal;
        }

        public void setApMaternoPersonal(String apMaternoPersonal) {
            this.apMaternoPersonal = apMaternoPersonal;
        }

        public String getApPaternoPersonal() {
            return apPaternoPersonal;
        }

        public void setApPaternoPersonal(String apPaternoPersonal) {
            this.apPaternoPersonal = apPaternoPersonal;
        }

        public String getCodPersonal() {
            return codPersonal;
        }

        public void setCodPersonal(String codPersonal) {
            this.codPersonal = codPersonal;
        }

        public String getContrasenaUsuario() {
            return contrasenaUsuario;
        }

        public void setContrasenaUsuario(String contrasenaUsuario) {
            this.contrasenaUsuario = contrasenaUsuario;
        }

        public String getNombreUsuario() {
            return nombreUsuario;
        }

        public void setNombreUsuario(String nombreUsuario) {
            this.nombreUsuario = nombreUsuario;
        }

        public String getNombresPersonal() {
            return nombresPersonal;
        }

        public void setNombresPersonal(String nombresPersonal) {
            this.nombresPersonal = nombresPersonal;
        }

        public String getNuevaContrasenaUsuario() {
            return nuevaContrasenaUsuario;
        }

        public void setNuevaContrasenaUsuario(String nuevaContrasenaUsuario) {
            this.nuevaContrasenaUsuario = nuevaContrasenaUsuario;
        }

        public String getReEscribirNuevaContrasenaUsuario() {
            return reEscribirNuevaContrasenaUsuario;
        }

        public void setReEscribirNuevaContrasenaUsuario(String reEscribirNuevaContrasenaUsuario) {
            this.reEscribirNuevaContrasenaUsuario = reEscribirNuevaContrasenaUsuario;
        }

        public String getContrasenaUsuarioEscrito() {
            return contrasenaUsuarioEscrito;
        }

        public void setContrasenaUsuarioEscrito(String contrasenaUsuarioEscrito) {
            this.contrasenaUsuarioEscrito = contrasenaUsuarioEscrito;
        }

        public String getApellidosNombres() {
            return apellidosNombres;
        }

        public void setApellidosNombres(String apellidosNombres) {
            this.apellidosNombres = apellidosNombres;
        }
    }

    public String getInitModificarUsuario() {
        try {
            ManagedAccesoSistema accesoSistema = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            codUsuario = Integer.valueOf(accesoSistema.getUsuarioModuloBean().getCodUsuarioGlobal());
            codModulo = Integer.valueOf(accesoSistema.getUsuarioModuloBean().getCod_modulo());
            personalModificar = new Personal();
            //System.out.println("Personal:"+paternoPersonal+maternoPersonal+nombrePersonal);
            String consulta = "select p.ap_paterno_personal,p.ap_materno_personal,p.nombres_personal," +
                    " um.nombre_usuario,um.contrasena_usuario" +
                    " from usuarios_modulos um,personal p" +
                    " where um.cod_personal=p.cod_personal and p.cod_personal='" + codUsuario + "'" +
                    " and um.cod_modulo='" + codModulo + "'";
                    
            con = Util.openConnection(con);
            System.out.println("consulta:..................." + consulta);
            Statement st_aux = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet resultado = st_aux.executeQuery(consulta);

            if (resultado.next()) {
                personalModificar.setApPaternoPersonal(resultado.getString("ap_paterno_personal"));
                personalModificar.setApMaternoPersonal(resultado.getString("ap_materno_personal"));
                personalModificar.setNombresPersonal(resultado.getString("nombres_personal"));
                personalModificar.setNombreUsuario(resultado.getString("nombre_usuario"));
                personalModificar.setContrasenaUsuario(resultado.getString("contrasena_usuario"));
                personalModificar.setApellidosNombres(resultado.getString("ap_paterno_personal") + " " + resultado.getString("ap_materno_personal") + " " + resultado.getString("nombres_personal"));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String aceptarCambioPassword_action() {
        try {
            mensajes = "";
            con = Util.openConnection(con);
            if (personalModificar.getContrasenaUsuarioEscrito().trim().equals("") || personalModificar.getNuevaContrasenaUsuario().trim().equals("") || personalModificar.getReEscribirNuevaContrasenaUsuario().trim().equals("")) {
                mensajes = "uno de los campos esta vacio";
                return null;
            }

            if (personalModificar.getNuevaContrasenaUsuario().trim().equals(personalModificar.getReEscribirNuevaContrasenaUsuario().trim())
                    && personalModificar.getContrasenaUsuario().trim().equals(personalModificar.getContrasenaUsuarioEscrito().trim())) {

                
                
                String consulta = " UPDATE USUARIOS_MODULOS SET " +
                        " CONTRASENA_USUARIO= '" + personalModificar.getNuevaContrasenaUsuario().trim() + "' " +
                        " WHERE " +
                        " COD_PERSONAL = '" + codUsuario + "' AND" +
                        " COD_MODULO = '" + codModulo + "'";
                
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                st.executeUpdate(consulta);
                mensajes = "Cambios realizados correctamente";

                //this.redireccionar("../cuerpo.jsf");
            } else {
                mensajes = "El password introducido actual no es el correcto o no coincide el nuevo password";
            }
            if (con != null) {
                con.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String cancelarCambioPassword_action() {
        try {
            this.redireccionar("../cuerpo.jsf");

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
