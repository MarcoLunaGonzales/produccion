/*
 * Clientes.java
 * Created on 25 de febrero de 2008, 17:35
 */

package com.cofar.bean;

/**
 * @author Wilson
 * @company COFAR
 */
public class UsuariosModulos  extends AbstractBean{    
    /** Creates a new instance of Cliente */
    private String codUsuarioGlobal="";
    private String nombrePilaUsuarioGlobal="";
    private String apPaternoUsuarioGlobal="";
    private String apMaternoUsuarioGlobal="";
    private String cod_modulo="";
    private String nombreUsuario="";
    private String contraseniaUsuario="";
    private String session="";

    public UsuariosModulos() {
    }

    public String getCodUsuarioGlobal() {
        return codUsuarioGlobal;
    }

    public void setCodUsuarioGlobal(String codUsuarioGlobal) {
        this.codUsuarioGlobal = codUsuarioGlobal;
    }

    public String getNombrePilaUsuarioGlobal() {
        return nombrePilaUsuarioGlobal;
    }

    public void setNombrePilaUsuarioGlobal(String nombrePilaUsuarioGlobal) {
        this.nombrePilaUsuarioGlobal = nombrePilaUsuarioGlobal;
    }

    public String getApPaternoUsuarioGlobal() {
        return apPaternoUsuarioGlobal;
    }

    public void setApPaternoUsuarioGlobal(String apPaternoUsuarioGlobal) {
        this.apPaternoUsuarioGlobal = apPaternoUsuarioGlobal;
    }

    public String getApMaternoUsuarioGlobal() {
        return apMaternoUsuarioGlobal;
    }

    public void setApMaternoUsuarioGlobal(String apMaternoUsuarioGlobal) {
        this.apMaternoUsuarioGlobal = apMaternoUsuarioGlobal;
    }

    public String getCod_modulo() {
        return cod_modulo;
    }

    public void setCod_modulo(String cod_modulo) {
        this.cod_modulo = cod_modulo;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getContraseniaUsuario() {
        return contraseniaUsuario;
    }

    public void setContraseniaUsuario(String contraseniaUsuario) {
        this.contraseniaUsuario = contraseniaUsuario;
    }

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }
    
    
}
