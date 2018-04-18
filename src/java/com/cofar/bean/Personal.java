/*
 * Personal.java
 *
 * Created on 4 de marzo de 2008, 04:17 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 *  @author Rene Ergueta Illanes
 *  @company COFAR
 */
public class Personal extends AbstractBean{
    
    /** Creates a new instance of Personal */
    private String codPersonal="";
    private String nombrePersonal="";
    private String nombre2Personal = "";
    private String apPaternoPersonal="";
    private String apMaternoPersonal="";
    private String nombreCorreoPersonal="";
    private AreasEmpresa areasEmpresa = new AreasEmpresa();
    Cargos cargos = new Cargos();
    //para areas empresa personal
    private List<PersonalAreaProduccion> personalAreaProduccionList;
    private UsuariosModulos usuariosModulos=new UsuariosModulos();
    public Personal() {
    }

    public String getCodPersonal() {
        return codPersonal;
    }

    public void setCodPersonal(String codPersonal) {
        this.codPersonal = codPersonal;
    }

    public String getNombrePersonal() {
        return nombrePersonal;
    }

    public void setNombrePersonal(String nombrePersonal) {
        this.nombrePersonal = nombrePersonal;
    }

    public String getApPaternoPersonal() {
        return apPaternoPersonal;
    }

    public void setApPaternoPersonal(String apPaternoPersonal) {
        this.apPaternoPersonal = apPaternoPersonal;
    }

    public String getApMaternoPersonal() {
        return apMaternoPersonal;
    }

    public void setApMaternoPersonal(String apMaternoPersonal) {
        this.apMaternoPersonal = apMaternoPersonal;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public Cargos getCargos() {
        return cargos;
    }

    public void setCargos(Cargos cargos) {
        this.cargos = cargos;
    }

    public String getNombreCorreoPersonal() {
        return nombreCorreoPersonal;
    }

    public void setNombreCorreoPersonal(String nombreCorreoPersonal) {
        this.nombreCorreoPersonal = nombreCorreoPersonal;
    }

    public List<PersonalAreaProduccion> getPersonalAreaProduccionList() {
        return personalAreaProduccionList;
    }
    public int getPersonalAreaProduccionListSize() {
        return (personalAreaProduccionList!=null?personalAreaProduccionList.size():0);
    }
    public void setPersonalAreaProduccionList(List<PersonalAreaProduccion> personalAreaProduccionList) {
        this.personalAreaProduccionList = personalAreaProduccionList;
    }

    public UsuariosModulos getUsuariosModulos() {
        return usuariosModulos;
    }

    public void setUsuariosModulos(UsuariosModulos usuariosModulos) {
        this.usuariosModulos = usuariosModulos;
    }

    public String getNombre2Personal() {
        return nombre2Personal;
    }

    public void setNombre2Personal(String nombre2Personal) {
        this.nombre2Personal = nombre2Personal;
    }
    
    public String getNombreCompletoPersonal(){
        return this.apPaternoPersonal + " "+this.apMaternoPersonal+" "+this.nombrePersonal+" "+this.nombre2Personal;
    }

}
