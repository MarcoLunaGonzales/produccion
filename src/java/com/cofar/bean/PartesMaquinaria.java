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
 * @author rodrigo
 */
public class PartesMaquinaria extends  AbstractBean{
    
    /** Creates a new instance of LineaMKT */
    
    private int codParteMaquina=0;
    private Maquinaria maquinaria=new Maquinaria();
    private String codigo="";
    private String obsParteMaquina="";
    private String nombreParteMaquina="";
    private TiposEquiposMaquinaria tiposEquiposMaquinaria=new TiposEquiposMaquinaria();
    private Materiales materiales=new Materiales();

    public int getCodParteMaquina() {
        return codParteMaquina;
    }

    public void setCodParteMaquina(int codParteMaquina) {
        this.codParteMaquina = codParteMaquina;
    }

    

    public String getObsParteMaquina() {
        return obsParteMaquina;
    }

    public void setObsParteMaquina(String obsParteMaquina) {
        this.obsParteMaquina = obsParteMaquina;
    }

    public String getNombreParteMaquina() {
        return nombreParteMaquina;
    }

    public void setNombreParteMaquina(String nombreParteMaquina) {
        this.nombreParteMaquina = nombreParteMaquina;
    }

    public TiposEquiposMaquinaria getTiposEquiposMaquinaria() {
        return tiposEquiposMaquinaria;
    }

    public void setTiposEquiposMaquinaria(TiposEquiposMaquinaria tiposEquiposMaquinaria) {
        this.tiposEquiposMaquinaria = tiposEquiposMaquinaria;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }
    
    
   
   
}
