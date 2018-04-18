/*
 * TiposMercaderia.java
 *
 * Created on 18 de marzo de 2008, 17:38
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class AreasInstalaciones {
    

    private int codAreaInstalacion=0;
    private String nombreAreaInstalacion="";
    private String codigo="";
    private AreasEmpresa areasEmpresa=new AreasEmpresa();
    private Boolean checked=new Boolean (false);
    private List<AreasInstalacionesDetalle> areasInstalacionesDetalleList=null;
    private List<AreasInstalacionesModulos> areasInstalacionesModuloList;

    public int getCodAreaInstalacion() {
        return codAreaInstalacion;
    }

    public void setCodAreaInstalacion(int codAreaInstalacion) {
        this.codAreaInstalacion = codAreaInstalacion;
    }
    
    
    public String getNombreAreaInstalacion() {
        return nombreAreaInstalacion;
    }

    public void setNombreAreaInstalacion(String nombreAreaInstalacion) {
        this.nombreAreaInstalacion = nombreAreaInstalacion;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public List getAreasInstalacionesDetalleList() {
        return areasInstalacionesDetalleList;
    }

    public void setAreasInstalacionesDetalleList(List areasInstalacionesDetalleList) {
        this.areasInstalacionesDetalleList = areasInstalacionesDetalleList;
    }

    public List<AreasInstalacionesModulos> getAreasInstalacionesModuloList() {
        return areasInstalacionesModuloList;
    }

    public void setAreasInstalacionesModuloList(List<AreasInstalacionesModulos> areasInstalacionesModuloList) {
        this.areasInstalacionesModuloList = areasInstalacionesModuloList;
    }

    public int getAreasInstalacionesModuloListSize()
    {
        return (this.areasInstalacionesModuloList!=null?areasInstalacionesModuloList.size():0);
    }
   
}
