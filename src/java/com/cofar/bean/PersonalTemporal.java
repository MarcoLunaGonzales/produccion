/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class PersonalTemporal extends AbstractBean {
    private int codPersonal=0;
    private String nombreCompletoPersonal="";
    private String apellidoPaterno="";
    private String apellidoMaterno="";
    private String nombrePersonal="";
    private String nombre2personal="";
    private AreasEmpresa areasEmpresa=new AreasEmpresa();

    public PersonalTemporal() {
    }

    public String getApellidoMaterno() {
        return apellidoMaterno;
    }

    public void setApellidoMaterno(String apellidoMaterno) {
        this.apellidoMaterno = apellidoMaterno;
    }

    public String getApellidoPaterno() {
        return apellidoPaterno;
    }

    public void setApellidoPaterno(String apellidoPaterno) {
        this.apellidoPaterno = apellidoPaterno;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public int getCodPersonal() {
        return codPersonal;
    }

    public void setCodPersonal(int codPersonal) {
        this.codPersonal = codPersonal;
    }

    public String getNombre2personal() {
        return nombre2personal;
    }

    public void setNombre2personal(String nombre2personal) {
        this.nombre2personal = nombre2personal;
    }

    public String getNombreCompletoPersonal() {
        return nombreCompletoPersonal;
    }

    public void setNombreCompletoPersonal(String nombreCompletoPersonal) {
        this.nombreCompletoPersonal = nombreCompletoPersonal;
    }

    public String getNombrePersonal() {
        return nombrePersonal;
    }

    public void setNombrePersonal(String nombrePersonal) {
        this.nombrePersonal = nombrePersonal;
    }
    

}
