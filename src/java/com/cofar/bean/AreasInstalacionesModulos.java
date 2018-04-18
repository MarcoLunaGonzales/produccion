/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

public class AreasInstalacionesModulos {
    
    private AreasInstalaciones areasInstalaciones=new AreasInstalaciones();
    private ModulosInstalaciones modulosInstalaciones=new ModulosInstalaciones();
    private String codigo="";
    private Boolean checked=new Boolean(false);

    public AreasInstalaciones getAreasInstalaciones() {
        return areasInstalaciones;
    }

    public void setAreasInstalaciones(AreasInstalaciones areasInstalaciones) {
        this.areasInstalaciones = areasInstalaciones;
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

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

 
   
}
