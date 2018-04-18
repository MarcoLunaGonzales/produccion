/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class AreasInstalacionesDetalle extends AbstractBean{

    //private AreasInstalaciones areasInstalaciones=new AreasInstalaciones();
    private int codAreaInstalacionDetalle=0;
    private String nombreAreaInstalacionDetalle="";
    private String codigo="";
    private AreasEmpresa areaEmpresa= new AreasEmpresa();

    public AreasInstalacionesDetalle() {
    }

    

    public AreasEmpresa getAreaEmpresa() {
        return areaEmpresa;
    }

    public void setAreaEmpresa(AreasEmpresa areaEmpresa) {
        this.areaEmpresa = areaEmpresa;
    }
    public int getCodAreaInstalacionDetalle() {
        return codAreaInstalacionDetalle;
    }

    public void setCodAreaInstalacionDetalle(int codAreaInstalacionDetalle) {
        this.codAreaInstalacionDetalle = codAreaInstalacionDetalle;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombreAreaInstalacionDetalle() {
        return nombreAreaInstalacionDetalle;
    }

    public void setNombreAreaInstalacionDetalle(String nombreAreaInstalacionDetalle) {
        this.nombreAreaInstalacionDetalle = nombreAreaInstalacionDetalle;
    }


}
