/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author WILSON CHOQUEHUANCA
 */
public class PartesModulosInstalacion {
    
    private String codParteModulo="";
    private ModulosInstalaciones modulosInstalaciones=new ModulosInstalaciones();
    private String codigo="";
    private String obsParteModulo="";
    private String nombreParteModulo="";
    private Boolean checked=new Boolean(false);

    public String getCodParteModulo() {
        return codParteModulo;
    }

    public void setCodParteModulo(String codParteModulo) {
        this.codParteModulo = codParteModulo;
    }

    public ModulosInstalaciones getModulosInstalaciones() {
        return modulosInstalaciones;
    }

    public void setModulosInstalaciones(ModulosInstalaciones modulosInstalaciones) {
        this.modulosInstalaciones = modulosInstalaciones;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getObsParteModulo() {
        return obsParteModulo;
    }

    public void setObsParteModulo(String obsParteModulo) {
        this.obsParteModulo = obsParteModulo;
    }

    public String getNombreParteModulo() {
        return nombreParteModulo;
    }

    public void setNombreParteModulo(String nombreParteModulo) {
        this.nombreParteModulo = nombreParteModulo;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

   
}
