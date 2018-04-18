/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;


import java.util.Date;

/**
 *
 * @author hvaldivia
 */
public class CuestionarioPersonalCargo {
    int codCuestionarioCargo = 0;
    String nombrecuestionarioCargo = "";
    int nroPreguntasDocumento =0;
    boolean aleatorio=false;
    Date fechaRegistro = new Date();
    Date fechaInicio = new Date();
    Date fechaFinal = new Date();
    private Date fechaAlternativa=new Date();
    private Date fechaAlternativaFinal=new Date();
    private Date fechaAlternativaInicio=new Date();
    private int nroPregutasArgumento=0;
    private boolean pregAleatorias = false;
    private Double tiempoCuestionario=0d;
    private String areasEmpresa="";
    private String tipoPregunta="";
    private String cargos="";
    private String componentesProd="";
    public boolean isAleatorio() {
        return aleatorio;
    }

    public void setAleatorio(boolean aleatorio) {
        this.aleatorio = aleatorio;
    }


    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }


    public int getCodCuestionarioCargo() {
        return codCuestionarioCargo;
    }

    public void setCodCuestionarioCargo(int codCuestionarioCargo) {
        this.codCuestionarioCargo = codCuestionarioCargo;
    }

  
    public String getNombrecuestionarioCargo() {
        return nombrecuestionarioCargo;
    }

    public void setNombrecuestionarioCargo(String nombrecuestionarioCargo) {
        this.nombrecuestionarioCargo = nombrecuestionarioCargo;
    }

    public Double getTiempoCuestionario() {
        return tiempoCuestionario;
    }

    public void setTiempoCuestionario(Double tiempoCuestionario) {
        this.tiempoCuestionario = tiempoCuestionario;
    }

    public Date getFechaAlternativa() {
        return fechaAlternativa;
    }

    public void setFechaAlternativa(Date fechaAlternativa) {
        this.fechaAlternativa = fechaAlternativa;
    }

    public Date getFechaAlternativaFinal() {
        return fechaAlternativaFinal;
    }

    public void setFechaAlternativaFinal(Date fechaAlternativaFinal) {
        this.fechaAlternativaFinal = fechaAlternativaFinal;
    }

    public Date getFechaAlternativaInicio() {
        return fechaAlternativaInicio;
    }

    public void setFechaAlternativaInicio(Date fechaAlternativaInicio) {
        this.fechaAlternativaInicio = fechaAlternativaInicio;
    }

    public int getNroPreguntasDocumento() {
        return nroPreguntasDocumento;
    }

    public void setNroPreguntasDocumento(int nroPreguntasDocumento) {
        this.nroPreguntasDocumento = nroPreguntasDocumento;
    }

    public int getNroPregutasArgumento() {
        return nroPregutasArgumento;
    }

    public void setNroPregutasArgumento(int nroPregutasArgumento) {
        this.nroPregutasArgumento = nroPregutasArgumento;
    }

    public boolean isPregAleatorias() {
        return pregAleatorias;
    }

    public void setPregAleatorias(boolean pregAleatorias) {
        this.pregAleatorias = pregAleatorias;
    }

    public String getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(String areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public String getCargos() {
        return cargos;
    }

    public void setCargos(String cargos) {
        this.cargos = cargos;
    }

    public String getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(String componentesProd) {
        this.componentesProd = componentesProd;
    }

    

    public String getTipoPregunta() {
        return tipoPregunta;
    }

    public void setTipoPregunta(String tipoPregunta) {
        this.tipoPregunta = tipoPregunta;
    }

    
    
}
