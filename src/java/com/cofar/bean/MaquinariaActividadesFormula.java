/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Wilson Choquehuanca
 */
public class MaquinariaActividadesFormula {
    
    /** Creates a new instance of LineaMKT */
    
    private String codMaquinariaActividad="";
    private float horasMaquina=0;
    private float horasHombre=0;
    private Boolean checked=new Boolean(false);
    private Maquinaria maquinaria=new Maquinaria();
    private ActividadesFormulaMaestra actividadesFormulaMaestra=new ActividadesFormulaMaestra();
    private List estadoReferencialList = new ArrayList();
    private EstadoReferencial estadoReferencial = new EstadoReferencial();
    private double productividadStandar=0.0d;
    //horas para asignar horas general
    private double horasHombrePromedioPrograma=0d;
    private double horasMaquinaPromedioPrograma=0d;
    private boolean asignarHorasHombreStandar=true;
    private String formatoMaquina = "";
    TiposFormatoMaquinaria tiposFormatoMaquinaria = new TiposFormatoMaquinaria();
    public String getCodMaquinariaActividad() {
        return codMaquinariaActividad;
    }

    public void setCodMaquinariaActividad(String codMaquinariaActividad) {
        this.codMaquinariaActividad = codMaquinariaActividad;
    }

    public float getHorasHombre() {
        return horasHombre;
    }

    public void setHorasHombre(float horasHombre) {
        this.horasHombre = horasHombre;
    }

    public float getHorasMaquina() {
        return horasMaquina;
    }

    public void setHorasMaquina(float horasMaquina) {
        this.horasMaquina = horasMaquina;
    }

   


    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public ActividadesFormulaMaestra getActividadesFormulaMaestra() {
        return actividadesFormulaMaestra;
    }

    public void setActividadesFormulaMaestra(ActividadesFormulaMaestra actividadesFormulaMaestra) {
        this.actividadesFormulaMaestra = actividadesFormulaMaestra;
    }

    public List getEstadoReferencialList() {
        return estadoReferencialList;
    }

    public void setEstadoReferencialList(List estadoReferencialList) {
        this.estadoReferencialList = estadoReferencialList;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public double getProductividadStandar() {
        return productividadStandar;
    }

    public void setProductividadStandar(double productividadStandar) {
        this.productividadStandar = productividadStandar;
    }

    public double getHorasHombrePromedioPrograma() {
        return horasHombrePromedioPrograma;
    }

    public void setHorasHombrePromedioPrograma(double horasHombrePromedioPrograma) {
        this.horasHombrePromedioPrograma = horasHombrePromedioPrograma;
    }

    public double getHorasMaquinaPromedioPrograma() {
        return horasMaquinaPromedioPrograma;
    }

    public void setHorasMaquinaPromedioPrograma(double horasMaquinaPromedioPrograma) {
        this.horasMaquinaPromedioPrograma = horasMaquinaPromedioPrograma;
    }

    public boolean isAsignarHorasHombreStandar() {
        return asignarHorasHombreStandar;
    }

    public void setAsignarHorasHombreStandar(boolean asignarHorasHombreStandar) {
        this.asignarHorasHombreStandar = asignarHorasHombreStandar;
    }

    public String getFormatoMaquina() {
        return formatoMaquina;
    }

    public void setFormatoMaquina(String formatoMaquina) {
        this.formatoMaquina = formatoMaquina;
    }

    public TiposFormatoMaquinaria getTiposFormatoMaquinaria() {
        return tiposFormatoMaquinaria;
    }

    public void setTiposFormatoMaquinaria(TiposFormatoMaquinaria tiposFormatoMaquinaria) {
        this.tiposFormatoMaquinaria = tiposFormatoMaquinaria;
    }
    
    
}
